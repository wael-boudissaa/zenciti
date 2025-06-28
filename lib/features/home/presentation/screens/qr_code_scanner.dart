import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:zenciti/features/activity/presentation/blocs/activity_bloc.dart';
import 'package:zenciti/features/activity/presentation/blocs/activity_event.dart';
import 'package:zenciti/features/activity/presentation/blocs/activity_type_bloc.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({Key? key}) : super(key: key);

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool flashOn = false;
  bool frontCamera = false;
  bool cameraActive = true;

  @override
  void reassemble() {
    super.reassemble();
    if (controller != null) {
      if (Theme.of(context).platform == TargetPlatform.android) {
        controller!.pauseCamera();
      }
      controller!.resumeCamera();
    }
  }

  Future<void> _onQRViewCreated(QRViewController ctrl) async {
    controller = ctrl;
    await controller?.resumeCamera();
    controller?.scannedDataStream.listen((scanData) async {
      if (scanData.code != null && cameraActive) {
        setState(() {
          cameraActive = false;
        });
        controller?.pauseCamera();

        // Trigger the CompleteActivity event with the scanned QR code as idClientActivity
        context.read<ActivityBloc>().add(
              CompleteActivity(scanData.code!),
            );
      }
    });
  }

  Future<void> _toggleFlash() async {
    await controller?.toggleFlash();
    final status = await controller?.getFlashStatus();
    setState(() {
      flashOn = status ?? false;
    });
  }

  Future<void> _switchCamera() async {
    await controller?.flipCamera();
    final cam = await controller?.getCameraInfo();
    setState(() {
      frontCamera = cam == CameraFacing.front;
    });
  }

  Future<void> _requestCameraPermission() async {
    await Permission.camera.request();
  }

  @override
  void initState() {
    super.initState();
    _requestCameraPermission();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Widget _buildCameraViewfinder(BuildContext context) {
    return Stack(
      children: [
        QRView(
          key: qrKey,
          overlay: QrScannerOverlayShape(
            borderColor: const Color(0xFF00674B),
            borderRadius: 16,
            borderLength: 40,
            borderWidth: 7,
            cutOutSize: MediaQuery.of(context).size.width * 0.65,
          ),
          onQRViewCreated: _onQRViewCreated,
        ),
        // Camera indicator
        Positioned(
          top: 14,
          right: 14,
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                margin: const EdgeInsets.only(right: 6),
              ),
              const Text("Camera active",
                  style: TextStyle(fontSize: 12, color: Colors.black87)),
            ],
          ),
        ),
        // Flash toggle
        Positioned(
          bottom: 18,
          right: 18,
          child: GestureDetector(
            onTap: _toggleFlash,
            child: Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                    )
                  ]),
              child: Icon(
                Icons.bolt,
                color: flashOn ? const Color(0xFF00674B) : Colors.grey[700],
                size: 26,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showSuccessToast(BuildContext context, String message) {
    MotionToast.success(
      description:
          Text(message, style: const TextStyle(fontWeight: FontWeight.w500)),
      animationDuration: const Duration(milliseconds: 500),
      position: MotionToastPosition.top,
    ).show(context);
  }

  void _showErrorToast(BuildContext context, String error) {
    MotionToast.error(
      description:
          Text(error, style: const TextStyle(fontWeight: FontWeight.w500)),
      animationDuration: const Duration(milliseconds: 500),
      position: MotionToastPosition.top,
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    final Color primary = const Color(0xFF00674B);
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<ActivityBloc, ActivityState>(
        listener: (context, state) {
          if (state is ActivityCompleted) {
            _showSuccessToast(context, 'Activity completed: ${state.message}');
            // Optional: add navigation or reset scan here
          } else if (state is ActivityFailure) {
            _showErrorToast(context, 'Error: ${state.error}');
            setState(() {
              cameraActive = true; // allow rescan after error
            });
            controller?.resumeCamera();
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: cameraActive
                    ? _buildCameraViewfinder(context)
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.qr_code_2,
                                size: 60, color: Color(0xFF00674B)),
                            const SizedBox(height: 18),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  cameraActive = true;
                                });
                                controller?.resumeCamera();
                              },
                              child: const Text("Scan Again"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
              const SizedBox(height: 12),
              const Text(
                "Position the QR code within the frame to scan",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 15),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _switchCamera,
                      icon: const Icon(Icons.cameraswitch, color: Colors.white),
                      label: const Text("Switch Camera"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
