import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'package:fast_qr_reader_view/fast_qr_reader_view.dart';
import 'package:mimos/constants/app-routes.constants.dart';

import 'package:mimos/constants/colors.constants.dart';
import 'package:mimos/services/index.dart';
import 'package:mimos/utils/index.dart';

import 'package:mimos/widgets/screens/table-screen/table-screen.widget.dart';

class MMSScanCodeScreen extends StatefulWidget {
  @override
  _MMSScanCodeScreenState createState() => new _MMSScanCodeScreenState();
}

class _MMSScanCodeScreenState extends State<MMSScanCodeScreen>
    with SingleTickerProviderStateMixin {
  QRReaderController controller;
  final double boxSize = 300.0;
  final double boxBorderWidth = 3.0;
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
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  _boxWidget(),
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 8),
                    child: Text(
                      'Scan the code on your receipt',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .headline
                          .merge(TextStyle(color: MMSColors.white)),
                    ),
                  )
                ],
              ),
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
                  top: BorderSide(color: boxColor, width: boxBorderWidth),
                  left: BorderSide(color: boxColor, width: boxBorderWidth),
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
                  top: BorderSide(color: boxColor, width: boxBorderWidth),
                  right: BorderSide(color: boxColor, width: boxBorderWidth),
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
                  bottom: BorderSide(color: boxColor, width: boxBorderWidth),
                  left: BorderSide(color: boxColor, width: boxBorderWidth),
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
                  bottom: BorderSide(color: boxColor, width: boxBorderWidth),
                  right: BorderSide(color: boxColor, width: boxBorderWidth),
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
      return Container(color: MMSColors.black);
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

    Navigator.of(context).pushReplacementNamed(AppRoutes.table,
        arguments: MMSTableScreenArguments(tableId: tableId));
  }
}
