import 'package:flutter/cupertino.dart';

import 'date_picker.dart';

class ScheduleDatePicker extends StatelessWidget {
  final DatePickerController controller;
  final Function(DateTime) onDateSelected;

  const ScheduleDatePicker({
    super.key,
    required this.controller,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDatePicker(
      controller: controller,
      onDateSelected: onDateSelected,
    );
  }
}