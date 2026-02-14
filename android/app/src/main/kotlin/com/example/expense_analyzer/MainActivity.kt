package com.example.expense_analyzer

import android.database.Cursor
import android.net.Uri
import android.provider.Telephony
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "sms_channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->

                if (call.method == "getSms") {
                    result.success(readSms())
                } else {
                    result.notImplemented()
                }
            }
    }

    private fun readSms(): List<Map<String, Any>> {

        val smsList = mutableListOf<Map<String, Any>>()

        val uri: Uri = Telephony.Sms.CONTENT_URI

        val projection = arrayOf(
            Telephony.Sms._ID,   // ✅ ADD THIS (IMPORTANT)
            Telephony.Sms.BODY,
            Telephony.Sms.DATE
        )

        val cursor: Cursor? = contentResolver.query(
            uri,
            projection,
            null,
            null,
            Telephony.Sms.DATE + " DESC"
        )

        cursor?.use {

            val idIndex = it.getColumnIndexOrThrow(Telephony.Sms._ID)
            val bodyIndex = it.getColumnIndexOrThrow(Telephony.Sms.BODY)
            val dateIndex = it.getColumnIndexOrThrow(Telephony.Sms.DATE)

            while (it.moveToNext()) {

                val id = it.getString(idIndex)        // ✅ REAL SMS ID
                val body = it.getString(bodyIndex)
                val date = it.getLong(dateIndex)      // use Long instead of String

                val sms = mapOf(
                    "id" to id,
                    "body" to body,
                    "date" to date
                )

                smsList.add(sms)
            }
        }

        return smsList
    }
}
