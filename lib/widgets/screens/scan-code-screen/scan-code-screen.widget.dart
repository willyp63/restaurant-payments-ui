import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fast_qr_reader_view/fast_qr_reader_view.dart';

import 'package:restaurant_payments_ui/services/index.dart';
import 'package:restaurant_payments_ui/utils/index.dart';
import 'package:restaurant_payments_ui/theme/colors.dart';

class MMSScanCodeScreen extends StatefulWidget {
  @override
  _MMSScanCodeScreenState createState() => new _MMSScanCodeScreenState();
}

class _MMSScanCodeScreenState extends State<MMSScanCodeScreen>
    with SingleTickerProviderStateMixin {
  QRReaderController controller;
  final double boxSize = 300.0;
  final double boxBorderWidth = 4.0;
  final double boxCornerRatio = 1 / 4;
  final Color boxColor = MMSColors.violet;

  @override
  initState() {
    super.initState();

    CameraService.getFirstAvailableCamera().then(onNewCamera);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MMSColors.black,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: _cameraPreviewWidget(context),
              ),
            ),
            Center(
              child: _boxWidget(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _boxWidget() {
    return Container(
      height: boxSize,
      width: boxSize,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              width: boxSize * boxCornerRatio,
              height: boxSize * boxCornerRatio,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                      color: boxColor, width: boxBorderWidth),
                  left: BorderSide(
                      color: boxColor, width: boxBorderWidth),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: boxSize * boxCornerRatio,
              height: boxSize * boxCornerRatio,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                      color: boxColor, width: boxBorderWidth),
                  right: BorderSide(
                      color: boxColor, width: boxBorderWidth),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              width: boxSize * boxCornerRatio,
              height: boxSize * boxCornerRatio,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      color: boxColor, width: boxBorderWidth),
                  left: BorderSide(
                      color: boxColor, width: boxBorderWidth),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: boxSize * boxCornerRatio,
              height: boxSize * boxCornerRatio,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      color: boxColor, width: boxBorderWidth),
                  right: BorderSide(
                      color: boxColor, width: boxBorderWidth),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Display the preview from the camera (or a message if the preview is not available).
  Widget _cameraPreviewWidget(BuildContext context) {
    if (controller == null || !controller.value.isInitialized) {
      return Text(
        'No camera selected',
        style: TextStyle(
          color: MMSColors.white,
          fontSize: Theme.of(context).textTheme.headline.fontSize,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      return AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: QRReaderPreview(controller),
      );
    }
  }

  void onNewCamera(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }
    controller = new QRReaderController(cameraDescription, ResolutionPreset.low,
        [CodeFormat.qr, CodeFormat.pdf417], onCodeRead);

    // If the controller is updated then update the UI.
    controller.addListener(() {
      if (mounted) setState(() {});
      if (controller.value.hasError) {
        logError(null, controller.value.errorDescription);
      }
    });

    try {
      await controller.initialize();
    } on QRReaderException catch (e) {
      logError(e.code, e.description);
    }

    if (mounted) {
      setState(() {});
      controller.startScanning();
    }
  }

  void onCodeRead(String tableId) {
    UserService.addUserToTable(tableId);

    // TODO: test that user was added successfully before navigating

    // TODO: navigate to table screen
  }
}
