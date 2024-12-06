import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/colors.dart';
import '../../providers/task_provider.dart';

Widget timePickerWidget(BuildContext context) {
  return Container(
    height: 300,
    color: Theme.of(context).scaffoldBackgroundColor,
    child: Column(
      children: [
        SizedBox(
          height: 200,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.time,
            initialDateTime: Provider.of<TaskProvider>(context).time ?? DateTime.now(),
            onDateTimeChanged: (DateTime value) {
              Provider.of<TaskProvider>(context, listen: false).setTime(value);
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
            Navigator.of(context).pop();
            FocusManager.instance.primaryFocus?.unfocus();
          },
        )
      ],
    ),
  );
}
