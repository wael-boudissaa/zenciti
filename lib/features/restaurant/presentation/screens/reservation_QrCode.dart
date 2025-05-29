import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:zenciti/features/home/presentation/widgets/appbar_pages.dart';

class ReservationQrCode extends StatelessWidget {
  final String idReservation;
  const ReservationQrCode({super.key, required this.idReservation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarPages(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Your reservation is complete!",
              style: TextStyle(
                color: Colors.green.shade600,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            QrImageView(
              data: idReservation,
              version: QrVersions.auto,
              size: 200.0,
              backgroundColor: Colors.white,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

