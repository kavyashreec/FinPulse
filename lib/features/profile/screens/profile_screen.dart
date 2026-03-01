import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../../data/local/database_helper.dart';
import '../../../data/models/user_profile_model.dart';
import '../../../data/services/score_service.dart';
import '../../../data/services/transaction_import_service.dart';
import '../../notifications/notification_screen.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin {
  final _db = DatabaseHelper.instance;
  final _scoreService = ScoreService();

  // ── palette ──────────────────────────────────
  static const _bg    = Color(0xFF040B16);
  static const _card  = Color(0xFF0B1628);
  static const _cardB = Color(0xFF081020);
  static const _bord  = Color(0xFF1A2C42);
  static const _blue  = Color(0xFF3B82F6);
  static const _sub   = Color(0xFF64748B);
  static const _muted = Color(0xFF334155);

  UserProfileModel? _profile;
  bool _loading = true;
  int _txCount = 0;
  double _totalIncome = 0;
  double _totalExpense = 0;
  double _score = 0;
  String _scoreLabel = 'FAIR';
  Color _scoreColor = const Color(0xFFF59E0B);
  int _goalCount = 0;
  String _memberSince = 'Mar 2026';

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  Future<void> _loadAll() async {
    setState(() => _loading = true);
    try {
      final profile = await _db.getUserProfile();
      final now     = DateTime.now();
      final start   = DateTime(2000);
      final end     = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

      final results = await Future.wait([
        _db.getTransactionCount(),
        _db.getIncomeExpense(start, end),
        _scoreService.calculateScore(),
        _db.getAllGoals(),
      ]);

      final txCount = results[0] as int;
      final ie      = results[1] as Map<String, double>;
      final score   = results[2] as double;
      final goals   = results[3] as List;

      if (!mounted) return;
      setState(() {
        _profile      = profile ?? UserProfileModel(
          name: 'FinPulse User', email: '', age: '', handle: '',
        );
        _txCount      = txCount;
        _totalIncome  = ie['income']  ?? 0;
        _totalExpense = ie['expense'] ?? 0;
        _score        = score;
        _scoreLabel   = ScoreService.getScoreLabel(score);
        _scoreColor   = Color(ScoreService.getScoreLabelColor(score));
        _goalCount    = goals.length;
        _loading      = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _profile = UserProfileModel(
            name: 'FinPulse User', email: '', age: '', handle: '');
        _loading = false;
      });
    }
  }

  // ═══════════════════════════════════════════
  //  BUILD
  // ═══════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    super.build(context);

    final name     = _profile?.name ?? 'User';
    final email    = _profile?.email ?? '';
    final initials = name.trim().isNotEmpty
        ? name.trim().split(' ').map((p) => p[0]).take(2).join().toUpperCase()
        : 'U';

    return Scaffold(
      backgroundColor: _bg,
      // ── App Bar ─────────────────────────────
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined,
                color: Colors.white, size: 26),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NotificationScreen()),
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: _blue))
          : RefreshIndicator(
              onRefresh: _loadAll,
              color: _blue,
              backgroundColor: _card,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    // ── Avatar Card ──────────────────────────
                    _avatarCard(name, email, initials),
                    const SizedBox(height: 16),

                    // ── Stat Row 1 ───────────────────────────
                    Row(children: [
                      Expanded(child: _statTile(
                        'Financial Score',
                        _score.toStringAsFixed(0),
                        _scoreLabel,
                        _scoreColor,
                      )),
                      const SizedBox(width: 12),
                      Expanded(child: _statTile(
                        'Transactions',
                        '$_txCount',
                        'All time',
                        _blue,
                      )),
                    ]),
                    const SizedBox(height: 12),

                    // ── Stat Row 2 ───────────────────────────
                    Row(children: [
                      Expanded(child: _statTile(
                        'Total Income',
                        '₹${_fmt(_totalIncome)}',
                        'Lifetime',
                        const Color(0xFF22C55E),
                      )),
                      const SizedBox(width: 12),
                      Expanded(child: _statTile(
                        'Total Expense',
                        '₹${_fmt(_totalExpense)}',
                        'Lifetime',
                        const Color(0xFFEF4444),
                      )),
                    ]),
                    const SizedBox(height: 12),

                    // ── Active Goals (half-width left) ───────
                    SizedBox(
                      width: (MediaQuery.of(context).size.width - 52) / 2,
                      child: _statTile(
                        'Active Goals',
                        '$_goalCount',
                        'Savings goals tracked',
                        const Color(0xFF8B5CF6),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ── Account Section ──────────────────────
                    _sectionLabel('Account'),
                    const SizedBox(height: 12),
                    _menuCard([
                      _tile(
                        icon: Icons.person_outline_rounded,
                        iconColor: _blue,
                        label: 'Edit Profile',
                        subtitle: 'Update your display name',
                        onTap: _showEditProfile,
                      ),
                      _divider(),
                      _tile(
                        icon: Icons.lock_outline_rounded,
                        iconColor: const Color(0xFF8B5CF6),
                        label: 'Change Password',
                        subtitle: 'Send a password reset email',
                        onTap: _showChangePassword,
                      ),
                      _divider(),
                      _tile(
                        icon: Icons.upload_file_outlined,
                        iconColor: const Color(0xFF06B6D4),
                        label: 'Import Transactions',
                        subtitle: 'Upload CSV / bank statement',
                        onTap: _importTransactions,
                      ),
                      _divider(),
                      _tile(
                        icon: Icons.settings_outlined,
                        iconColor: const Color(0xFF22C55E),
                        label: 'Settings',
                        subtitle: 'Preferences, data & security',
                        onTap: () async {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const SettingsScreen()));
                          _loadAll();
                        },
                      ),
                    ]),

                    const SizedBox(height: 20),

                    // ── Account Actions Section ──────────────
                    _sectionLabel('Account Actions'),
                    const SizedBox(height: 12),
                    _menuCard([
                      _tile(
                        icon: Icons.logout_rounded,
                        iconColor: const Color(0xFFFF8A34),
                        label: 'Logout',
                        subtitle: 'Sign out of your account',
                        onTap: _confirmLogout,
                      ),
                      _divider(),
                      _tile(
                        icon: Icons.delete_outline_rounded,
                        iconColor: Colors.redAccent,
                        label: 'Delete Account',
                        subtitle: 'Permanently remove everything',
                        showArrow: false,
                        onTap: _confirmDelete,
                      ),
                    ]),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
    );
  }

  // ═══════════════════════════════════════════
  //  AVATAR CARD
  // ═══════════════════════════════════════════
  Widget _avatarCard(String name, String email, String initials) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(colors: [_card, _cardB]),
        border: Border.all(color: _bord),
      ),
      child: Row(
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                  colors: [_blue, Color(0xFF1D4ED8)]),
            ),
            child: Center(
              child: Text(initials,
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.white)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
                const SizedBox(height: 3),
                Text(email.isNotEmpty ? email : '—',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, color: _sub)),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E40AF).withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text('Premium Member',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF60A5FA))),
                    ),
                    const SizedBox(width: 10),
                    Text('Since $_memberSince',
                        style: const TextStyle(fontSize: 12, color: _muted)),
                  ]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════
  //  STAT TILE
  // ═══════════════════════════════════════════
  Widget _statTile(String label, String value, String sub, Color color) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(colors: [_card, _cardB]),
        border: Border.all(color: _bord),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: _sub)),
          const SizedBox(height: 6),
          Text(value,
              style: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.w700, color: color)),
          const SizedBox(height: 2),
          Text(sub, style: const TextStyle(fontSize: 12, color: _muted)),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════
  //  UI HELPERS
  // ═══════════════════════════════════════════
  Widget _sectionLabel(String t) => Text(t,
      style: const TextStyle(
          fontSize: 14, fontWeight: FontWeight.w500, color: _sub));

  Widget _menuCard(List<Widget> children) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: const LinearGradient(colors: [_card, _cardB]),
          border: Border.all(color: _bord),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Column(children: children),
        ),
      );

  Widget _tile({
    required IconData icon,
    required Color iconColor,
    required String label,
    required VoidCallback onTap,
    String? subtitle,
    bool showArrow = true,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: iconColor.withValues(alpha: 0.08),
        highlightColor: Colors.white.withValues(alpha: 0.03),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(subtitle,
                        style: const TextStyle(fontSize: 12, color: _sub)),
                  ],
                ],
              ),
            ),
            if (showArrow)
              const Icon(Icons.chevron_right, color: _muted, size: 22),
          ]),
        ),
      ),
    );
  }

  Widget _divider() => Container(
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      color: _bord.withValues(alpha: 0.5));

  String _fmt(double v) {
    if (v >= 100000) return '${(v / 100000).toStringAsFixed(1)}L';
    if (v >= 1000)   return '${(v / 1000).toStringAsFixed(1)}K';
    return v.toStringAsFixed(0);
  }

  void _snack(String msg, {Color bg = const Color(0xFF1E293B)}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: bg,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ));
  }

  // ═══════════════════════════════════════════
  //  EDIT PROFILE
  // ═══════════════════════════════════════════
  void _showEditProfile() {
    final nameC  = TextEditingController(text: _profile?.name ?? '');
    final emailC = TextEditingController(text: _profile?.email ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: _card,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(
            24, 16, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(2))),
            ),
            const SizedBox(height: 20),
            const Text('Edit Profile',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white)),
            const SizedBox(height: 4),
            const Text('Update your display name & email.',
                style: TextStyle(fontSize: 13, color: _sub)),
            const SizedBox(height: 20),
            _field('NAME', nameC, TextCapitalization.words),
            const SizedBox(height: 12),
            _field('EMAIL', emailC, TextCapitalization.none,
                keyboard: TextInputType.emailAddress),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () async {
                  final updated = UserProfileModel(
                    name: nameC.text.trim(),
                    email: emailC.text.trim(),
                    age: _profile?.age ?? '',
                    handle: _profile?.handle ?? '',
                  );
                  await _db.updateUserProfile(updated);
                  if (!mounted) return;
                  Navigator.pop(ctx);
                  await _loadAll();
                  _snack('Profile updated!', bg: const Color(0xFF1E3A8A));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Save Changes',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController c, TextCapitalization cap,
      {TextInputType keyboard = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: _sub,
                letterSpacing: 1.2)),
        const SizedBox(height: 6),
        TextField(
          controller: c,
          keyboardType: keyboard,
          textCapitalization: cap,
          style: const TextStyle(color: Colors.white, fontSize: 15),
          decoration: InputDecoration(
            filled: true,
            fillColor: _cardB,
            hintStyle: const TextStyle(color: _muted),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: _bord)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: _blue)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════
  //  CHANGE PASSWORD
  // ═══════════════════════════════════════════
  void _showChangePassword() {
    final email = _profile?.email ?? '';
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: _card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Change Password',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        content: Text(
          email.isNotEmpty
              ? 'A password reset link will be sent to:\n\n$email'
              : 'No email address is set on this account.',
          style: const TextStyle(color: Color(0xFF94A3B8), height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: _sub)),
          ),
          if (email.isNotEmpty)
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _snack('Password reset email sent!',
                    bg: const Color(0xFF22C55E));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E3A8A),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Send Email',
                  style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════
  //  IMPORT TRANSACTIONS
  // ═══════════════════════════════════════════
  Future<void> _importTransactions() async {
    final proceed = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: _card,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(children: [
              Icon(Icons.upload_file, color: Color(0xFF06B6D4), size: 28),
              SizedBox(width: 12),
              Text('Import Transactions',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white)),
            ]),
            const SizedBox(height: 14),
            const Text(
              'Upload a CSV from your bank to import transactions. '
              'We auto-detect columns and categorize each entry.',
              style: TextStyle(
                  fontSize: 14, color: Color(0xFF94A3B8), height: 1.5),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                  color: _cardB,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: _bord)),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('✓  Supports most Indian bank formats',
                      style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8))),
                  SizedBox(height: 6),
                  Text('✓  Auto-detects Date, Amount, Description',
                      style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8))),
                  SizedBox(height: 6),
                  Text('✓  Smart categorization (Food, Transport…)',
                      style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8))),
                  SizedBox(height: 6),
                  Text('✓  Skips duplicate transactions',
                      style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8))),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(ctx, true),
                icon: const Icon(Icons.folder_open, color: Colors.white),
                label: const Text('Choose CSV File',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF06B6D4),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    if (proceed != true || !mounted) return;

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', 'CSV'],
    );
    if (result == null ||
        result.files.isEmpty ||
        result.files.single.path == null) return;
    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AlertDialog(
        backgroundColor: _card,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        content: Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            CircularProgressIndicator(color: Color(0xFF06B6D4)),
            SizedBox(height: 16),
            Text('Importing transactions…',
                style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14)),
          ]),
        ),
      ),
    );

    final importResult =
        await TransactionImportService().importFromCSV(result.files.single.path!);

    if (!mounted) return;
    Navigator.pop(context);

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: _card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(children: [
          Icon(
            importResult.imported > 0 ? Icons.check_circle : Icons.info_outline,
            color: importResult.imported > 0
                ? const Color(0xFF22C55E)
                : const Color(0xFFFF8A34),
            size: 24,
          ),
          const SizedBox(width: 10),
          const Text('Import Complete',
              style: TextStyle(color: Colors.white, fontSize: 18)),
        ]),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _resultRow('Imported', '${importResult.imported}',
                const Color(0xFF22C55E)),
            if (importResult.duplicates > 0)
              _resultRow('Duplicates skipped', '${importResult.duplicates}',
                  const Color(0xFFFF8A34)),
            if (importResult.skipped > 0)
              _resultRow('Rows skipped', '${importResult.skipped}', _sub),
            if (importResult.errors.isNotEmpty) ...[
              const SizedBox(height: 8),
              const Text('Errors:',
                  style: TextStyle(color: Color(0xFFEF4444), fontSize: 13)),
              ...importResult.errors.take(3).map((e) => Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(e,
                        style: const TextStyle(
                            color: Color(0xFF94A3B8), fontSize: 12)),
                  )),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Done', style: TextStyle(color: _blue)),
          ),
        ],
      ),
    );

    if (importResult.imported > 0) _loadAll();
  }

  Widget _resultRow(String label, String val, Color c) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: const TextStyle(
                    color: Color(0xFF94A3B8), fontSize: 14)),
            Text(val,
                style: TextStyle(
                    color: c, fontSize: 16, fontWeight: FontWeight.w600)),
          ]),
    );
  }

  // ═══════════════════════════════════════════
  //  LOGOUT
  // ═══════════════════════════════════════════
  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: _card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Logout',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        content: const Text('Are you sure you want to sign out?',
            style: TextStyle(color: Color(0xFF94A3B8))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: _sub)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamedAndRemoveUntil('/', (r) => false);
            },
            child: const Text('Logout',
                style: TextStyle(
                    color: Color(0xFFFF8A34), fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════
  //  DELETE ACCOUNT
  // ═══════════════════════════════════════════
  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: _card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete Account',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        content: const Text(
          'This will permanently delete all your transactions, goals, '
          'and profile data.\n\nThis cannot be undone.',
          style: TextStyle(color: Color(0xFF94A3B8), height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: _sub)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _db.clearAll();
              if (!mounted) return;
              _snack('All data deleted.', bg: Colors.redAccent);
              Navigator.of(context).pushNamedAndRemoveUntil('/', (r) => false);
            },
            child: const Text('Delete',
                style: TextStyle(
                    color: Colors.redAccent, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}