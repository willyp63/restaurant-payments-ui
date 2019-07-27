import 'dart:async';

import 'package:fast_qr_reader_view/fast_qr_reader_view.dart';

import 'package:mimos/utils/logging.utils.dart';

class CameraService {
  static List<CameraDescription> _cameras;

  static Future<CameraDescription> getFirstAvailableCamera() async {
    // TODO: may want to ask the user multiple times if they allow it
    if (_cameras == null) {
      try {
        _cameras = await availableCameras();
      } on QRReaderException catch (e) {
        logError(e.code, e.description);
      }
    }

    return _cameras[0];
  }
}
