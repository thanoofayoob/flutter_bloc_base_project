// library tie_picker;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_base_project/src/shared/plugins/lib/src/calendar_overlay/calendar_overlay.dart';
import 'package:flutter_bloc_base_project/src/shared/plugins/lib/src/calendar_overlay/calendar_overlay_controller.dart';

abstract class ModalPicker {
  static bool _isModalOpen = false;

  static Future<DateTime?> datePicker({
    required BuildContext context,
    required DateTime? date,
    CalendarMode mode = CalendarMode.day,
  }) async =>
      await showCupertinoModalPopup(
        context: context,
        builder: (ctx) => CalendarOverlay(
          date: date,
          mode: mode,
        ),
        useRootNavigator: true,
      ) ??
      date;
}
