import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/colors.dart';
import '../../providers/task_provider.dart';

Widget datePickerWidget(BuildContext context) {
  return Container(
    height: 270,
    color: Theme.of(context).scaffoldBackgroundColor,
    child: Column(
      children: [
        SizedBox(
          height: 200,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: Provider.of<TaskProvider>(context).date ?? DateTime.now().add(
              const Duration(minutes: 30),
            ),
            minimumDate: DateTime.now(),
            maximumDate: DateTime(2030, 12, 31),
            onDateTimeChanged: (DateTime newDate) {
              Provider.of<TaskProvider>(context, listen: false).setDate(newDate);
            },
          ),
        ),
        CupertinoButton(
          borderRadius: BorderRadius.circular(50),
          child: const Text(
            'Done',
            style: TextStyle(
              color: MyColors.primaryColor,
              fontSize: 20,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop(Provider.of<TaskProvider>(context, listen: false).date);
          },
        )
      ],
    ),
  );
}
