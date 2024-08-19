import 'package:flutter/material.dart';

class QRScannerOverlay extends StatelessWidget {
  final Color overLayColor;

  const QRScannerOverlay({Key? key, required this.overLayColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double overlaySize = constraints.maxWidth * 0.5; // 70% of screen width
        return Stack(
          children: [
            // Top overlay with transparent background

            // Center transparent area with modern border and corners
            Positioned(
              top: (constraints.maxHeight - overlaySize) / 2,
              left: (constraints.maxWidth - overlaySize) / 2,
              width: overlaySize,
              height: overlaySize,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 4.0),
                  borderRadius: BorderRadius.circular(16.0),
                  color: Colors.transparent,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 10.0,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Stack(
                    children: [
                      // Center text
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Align QR code within the frame',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              shadows: [
                                Shadow(
                                  blurRadius: 4.0,
                                  color: Colors.black.withOpacity(0.5),
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
