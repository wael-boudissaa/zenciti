import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ReservationPage extends StatefulWidget {
  const ReservationPage({super.key});

  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  String reservationId = "abc123456"; // received from backend
  @override
  Widget build(BuildContext context) {
    return QrImageView(
      data: reservationId,
      version: QrVersions.auto,
      size: 200.0,
      gapless: false,
      errorCorrectionLevel: QrErrorCorrectLevel.M, // L, M, Q, H
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
    );
  }
}
