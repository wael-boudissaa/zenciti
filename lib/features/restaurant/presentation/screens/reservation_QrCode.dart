import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:zenciti/features/home/presentation/widgets/appbar_pages.dart';
import 'package:go_router/go_router.dart';

class ReservationQrCode extends StatelessWidget {
  final String idReservation;
  const ReservationQrCode({super.key, required this.idReservation});

  @override
  Widget build(BuildContext context) {
    final primary = const Color(0xFF00614B);
    final accent = const Color(0xFF8EEDC7);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarPages(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_rounded,
                color: primary,
                size: 64,
              ),
              const SizedBox(height: 18),
              Text(
                "Reservation Confirmed!",
                style: TextStyle(
                  color: primary,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Poppins",
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Show this QR code upon arrival to check in.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Poppins",
                ),
              ),
              const SizedBox(height: 32),
              Container(
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.16),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: accent.withOpacity(0.14),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    )
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: QrImageView(
                  data: idReservation,
                  version: QrVersions.auto,
                  size: 200.0,
                  backgroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.home_rounded, size: 22),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      fontFamily: "Poppins",
                    ),
                  ),
                  onPressed: () => context.go('/home'),
                  label: const Text('Back to Home'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
