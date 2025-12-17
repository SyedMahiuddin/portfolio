import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../presentation/pages/admin/admin_page.dart';

class KeyboardService extends GetxService {
  final _ctrlPressed = false.obs;
  final _metaPressed = false.obs;

  @override
  void onInit() {
    super.onInit();
    _setupKeyboardListener();
  }

  void _setupKeyboardListener() {
    RawKeyboard.instance.addListener(_handleKeyEvent);
  }

  void _handleKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      if (event.isControlPressed) {
        _ctrlPressed.value = true;
      }
      if (event.isMetaPressed) {
        _metaPressed.value = true;
      }

      final isMac = defaultTargetPlatform == TargetPlatform.macOS;

      if (isMac) {
        if (_metaPressed.value && event.logicalKey == LogicalKeyboardKey.keyA) {
          _showAdminDialog();
        }
      } else {
        if (_ctrlPressed.value && event.logicalKey == LogicalKeyboardKey.keyH) {
          _showAdminDialog();
        }
      }
    } else if (event is RawKeyUpEvent) {
      if (!event.isControlPressed) {
        _ctrlPressed.value = false;
      }
      if (!event.isMetaPressed) {
        _metaPressed.value = false;
      }
    }
  }

  void _showAdminDialog() {
    Get.dialog(
      AdminLoginDialog(),
      barrierDismissible: true,
    );
  }

  @override
  void onClose() {
    RawKeyboard.instance.removeListener(_handleKeyEvent);
    super.onClose();
  }
}