import 'dart:io';
import '../local/database_helper.dart';
import '../models/transaction_model.dart';

class ImportResult {
  final int imported;
  final int duplicates;
  final int skipped;
  final List<String> errors;

  const ImportResult({
    required this.imported,
    required this.duplicates,
    required this.skipped,
    required this.errors,
  });
}

class TransactionImportService {
  final _db = DatabaseHelper.instance;

  static const _categoryKeywords = <String, List<String>>{
    'Food':          ['swiggy','zomato','uber eats','mcdonalds','kfc','pizza','burger','restaurant','cafe','starbucks','coffee','sushi','food','eat'],
    'Groceries':     ['grocer','supermarket','bigbasket','blinkit','zepto','fresh','mart','costco','trader','whole foods','dmart'],
    'Transport':     ['uber','ola','lyft','rapido','bus','metro','petrol','fuel','gas station','irctc','train','flight','airline','taxi','cab'],
    'Shopping':      ['amazon','flipkart','myntra','meesho','zara','nike','adidas','mall','store','shop','retail','h&m','ajio'],
    'Bills':         ['rent','electricity','water','gas','broadband','wifi','internet','bill','recharge','dth','mobile','postpaid','prepaid','insurance','emi'],
    'Health':        ['pharmacy','apollo','medplus','hospital','clinic','doctor','dentist','gym','fitness','health','medicine','diagnostic'],
    'Entertainment': ['netflix','hotstar','prime','spotify','youtube','movie','cinema','pvr','inox','game','concert','event'],
    'Income':        ['salary','freelance','payment received','credit','income','bonus','dividend','refund','cashback'],
  };

  Future<ImportResult> importFromCSV(String filePath) async {
    int imported   = 0;
    int duplicates = 0;
    int skipped    = 0;
    final errors   = <String>[];

    try {
      final file  = File(filePath);
      final lines = await file.readAsLines();

      if (lines.isEmpty) {
        return ImportResult(imported: 0, duplicates: 0, skipped: 0,
            errors: ['File is empty']);
      }

      // Detect header column indices
      final header    = _splitCsv(lines.first);
      final dateIdx   = _findCol(header, ['date', 'txn date', 'transaction date', 'value date', 'posting date']);
      final amtIdx    = _findCol(header, ['amount', 'transaction amount', 'txn amount']);
      final debitIdx  = _findCol(header, ['debit', 'dr', 'debit amount', 'withdrawal']);
      final creditIdx = _findCol(header, ['credit', 'cr', 'credit amount', 'deposit']);
      final descIdx   = _findCol(header, ['description', 'narration', 'remarks', 'particulars', 'merchant', 'details']);

      if (dateIdx == -1 || descIdx == -1) {
        return ImportResult(imported: 0, duplicates: 0, skipped: 0,
            errors: ['Could not detect required columns (Date, Description)']);
      }

      // Build duplicate-detection set from existing transactions.
      // TransactionModel.timestamp is a String (ISO8601).
      final existing     = await _db.getAllTransactions();
      final existingKeys = existing
          .map((t) => '${t.timestamp.substring(0, 10)}_${t.amount}_${t.merchant}')
          .toSet();

      // Process each data row
      for (int i = 1; i < lines.length; i++) {
        final rawLine = lines[i].trim();
        if (rawLine.isEmpty) { skipped++; continue; }

        try {
          final cols = _splitCsv(rawLine);
          if (cols.length <= descIdx || cols.length <= dateIdx) {
            skipped++; continue;
          }

          // Parse date → ISO8601 String for storage
          final dateStr      = cols[dateIdx].trim();
          final date         = _parseDate(dateStr);
          if (date == null)  { skipped++; continue; }
          final timestampStr = date.toIso8601String();

          // Parse amount
          double amount;
          String type;

          if (debitIdx != -1 && creditIdx != -1) {
            // Two-column format (debit / credit)
            final dStr = debitIdx  < cols.length ? _cleanAmount(cols[debitIdx])  : '';
            final cStr = creditIdx < cols.length ? _cleanAmount(cols[creditIdx]) : '';
            final debit  = double.tryParse(dStr) ?? 0;
            final credit = double.tryParse(cStr) ?? 0;
            if (credit > 0) {
              amount = credit; type = 'income';
            } else if (debit > 0) {
              amount = -debit; type = 'expense';
            } else {
              skipped++; continue;
            }
          } else if (amtIdx != -1) {
            // Single amount column
            final cleaned = _cleanAmount(amtIdx < cols.length ? cols[amtIdx] : '');
            final val     = double.tryParse(cleaned) ?? 0;
            if (val == 0)  { skipped++; continue; }
            amount = val;
            type   = val > 0 ? 'income' : 'expense';
          } else {
            skipped++; continue;
          }

          final desc     = cols[descIdx].trim();
          final category = _categorize(desc, type);

          // Deduplicate
          final key = '${timestampStr.substring(0, 10)}_${amount}_$desc';
          if (existingKeys.contains(key)) { duplicates++; continue; }

          final tx = TransactionModel(
            amount:    amount,
            merchant:  desc.isNotEmpty ? desc : 'Unknown',
            category:  category,
            type:      type,
            timestamp: timestampStr, // String, matches TransactionModel
            note:      '',
          );

          await _db.insertTransaction(tx);
          existingKeys.add(key);
          imported++;

        } catch (e) {
          errors.add('Row ${i + 1}: $e');
          skipped++;
        }
      }
    } catch (e) {
      errors.add('Failed to read file: $e');
    }

    return ImportResult(
      imported:   imported,
      duplicates: duplicates,
      skipped:    skipped,
      errors:     errors,
    );
  }

  // ── Private helpers ───────────────────────────────────────

  int _findCol(List<String> header, List<String> candidates) {
    for (int i = 0; i < header.length; i++) {
      final h = header[i].toLowerCase().trim();
      if (candidates.any((c) => h.contains(c))) return i;
    }
    return -1;
  }

  List<String> _splitCsv(String line) {
    final result  = <String>[];
    final buffer  = StringBuffer();
    bool inQuotes = false;
    for (int i = 0; i < line.length; i++) {
      final ch = line[i];
      if (ch == '"') {
        inQuotes = !inQuotes;
      } else if (ch == ',' && !inQuotes) {
        result.add(buffer.toString());
        buffer.clear();
      } else {
        buffer.write(ch);
      }
    }
    result.add(buffer.toString());
    return result;
  }

  String _cleanAmount(String s) =>
      s.replaceAll(RegExp(r'[₹\$,\s]'), '')
       .replaceAll('(', '-')
       .replaceAll(')', '');

  DateTime? _parseDate(String s) {
    final t = s.trim();

    // dd/mm/yyyy or dd-mm-yyyy
    final dmy = RegExp(r'^(\d{1,2})[\/\-](\d{1,2})[\/\-](\d{4})$');
    var m = dmy.firstMatch(t);
    if (m != null) {
      try { return DateTime(int.parse(m.group(3)!), int.parse(m.group(2)!), int.parse(m.group(1)!)); }
      catch (_) {}
    }

    // yyyy-mm-dd or yyyy/mm/dd
    final ymd = RegExp(r'^(\d{4})[\/\-](\d{1,2})[\/\-](\d{1,2})$');
    m = ymd.firstMatch(t);
    if (m != null) {
      try { return DateTime(int.parse(m.group(1)!), int.parse(m.group(2)!), int.parse(m.group(3)!)); }
      catch (_) {}
    }

    // dd/mm/yy
    final dmyShort = RegExp(r'^(\d{1,2})[\/\-](\d{1,2})[\/\-](\d{2})$');
    m = dmyShort.firstMatch(t);
    if (m != null) {
      try {
        var yr = int.parse(m.group(3)!);
        yr += yr >= 50 ? 1900 : 2000;
        return DateTime(yr, int.parse(m.group(2)!), int.parse(m.group(1)!));
      } catch (_) {}
    }

    // dd MMM yyyy  e.g. "01 Mar 2025" or "01-Mar-2025"
    final mmm = RegExp(r'^(\d{1,2})[\s\-\/]([A-Za-z]{3})[\s\-\/](\d{2,4})$');
    m = mmm.firstMatch(t);
    if (m != null) {
      final day = int.tryParse(m.group(1)!) ?? 0;
      final mon = _monthFromAbbr(m.group(2)!);
      var   yr  = int.tryParse(m.group(3)!) ?? 0;
      if (yr < 100) yr += yr >= 50 ? 1900 : 2000;
      if (mon > 0) {
        try { return DateTime(yr, mon, day); } catch (_) {}
      }
    }

    // ISO fallback
    try { return DateTime.parse(t); } catch (_) {}
    return null;
  }

  int _monthFromAbbr(String abbr) {
    const months = ['jan','feb','mar','apr','may','jun',
                    'jul','aug','sep','oct','nov','dec'];
    final idx = months.indexOf(abbr.toLowerCase());
    return idx == -1 ? 0 : idx + 1;
  }

  String _categorize(String description, String type) {
    if (type == 'income') return 'Income';
    final lower = description.toLowerCase();
    for (final entry in _categoryKeywords.entries) {
      for (final kw in entry.value) {
        if (lower.contains(kw)) return entry.key;
      }
    }
    return 'Shopping';
  }
}
