import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodeGeneratorPage extends StatefulWidget {
  @override
  _QRCodeGeneratorPageState createState() => _QRCodeGeneratorPageState();
}

class _QRCodeGeneratorPageState extends State<QRCodeGeneratorPage> {
  String? qrData; // QR kod ma'lumotlarini saqlash uchun o'zgaruvchi
  bool isLoading = false; // Yuklanish jarayoni belgisi

  Future<void> _generateQRCode() async {
    setState(() {
      isLoading = true; // Tugmani bosganda yuklanish belgisi ko'rinadi
    });

    // GET so'rov yuborish
    final response = await http.get(
      Uri.parse('https://nz-dashboard.onrender.com/v1/nis/api'), // API manzili
      headers: {
        'Authorization':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3Mjg0MTM2NDUsImlhdCI6MTcyNzUzNTI0NSwiaWQiOiJhOTY2MDdiYy03YTRlLTQ2ZjgtOTkyOC02NjFhM2UzNDM3MzgiLCJyb2xlIjoic3VwZXIifQ.x7xZKHVaCprsP1Ku8BLRXiD1o7h8m97hXHi84AvbuWo',
        // Token bilan autentifikatsiya qilish
      },
    );

    if (response.statusCode == 200) {
      // So'rov muvaffaqiyatli bo'lsa, ma'lumotlarni dekod qilish
      final responseData = jsonDecode(response.body);
      setState(() {
        qrData = responseData['data']; // Ma'lumotni saqlash
        isLoading = false; // Yuklanish tugadi
      });
    } else {
      setState(() {
        isLoading = false; // Yuklanish tugadi
      });
      // So'rov xato bo'lsa, xatolikni ko'rsatish
      throw Exception('QR kodni yaratishda xatolik yuz berdi');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR kod yaratish'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Agar yuklanayotgan bo'lsa, progress indikatorini ko'rsatish
            isLoading
                ? CircularProgressIndicator()
                : qrData != null
                    // QR kod yaratilgan bo'lsa, uni UI'da ko'rsatish
                    ? QrImageView(
                        data: qrData!,
                        version: QrVersions.auto,
                        size: 200.0,
                      )
                    : Text('QR kod yaratish uchun tugmani bosing'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _generateQRCode, // QR kod yaratish uchun tugma
              child: Text('QR kod yaratish'),
            ),
          ],
        ),
      ),
    );
  }
}
