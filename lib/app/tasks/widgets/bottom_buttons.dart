import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/colors.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/strings.dart';
import '../../model/task.dart';
import '../../providers/task_provider.dart';

Widget bottomButtons(
  BuildContext context,
  Task? task,
  TextEditingController taskTitleController,
  TextEditingController taskDescriptionController,
) {
  final taskProvider = Provider.of<TaskProvider>(context);

  return Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: Row(
      mainAxisAlignment: task != null
          ? MainAxisAlignment.spaceEvenly
          : MainAxisAlignment.center,
      children: [
        task != null
            ? Container(
                width: 150,
                height: 55,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: MyColors.primaryColor,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  minWidth: 150,
                  height: 55,
                  onPressed: () async {
                    taskProvider.deleteTask(task);
                    taskDeleted(context);
                    Navigator.pop(context);
                  },
                  color: Colors.white,
                  child: const Row(
                    children: [
                      Icon(
                        Icons.close,
                        color: MyColors.primaryColor,
                      ),
                      SizedBox(width: 5),
                      Text(
                        MyString.deleteTask,
                        style: TextStyle(
                          color: MyColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Container(),
        MaterialButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          minWidth: 150,
          height: 55,
          onPressed: () async {
            bool fieldsAreEmpty = taskTitleController.text.isEmpty ||
                taskDescriptionController.text.isEmpty;

            if (task == null) {
              if (fieldsAreEmpty) {
                emptyFieldsWarning(context);
              } else {
                taskProvider.addTask(context);
                taskAdded(context);
              }
            } else {
              if (taskProvider.hasTaskChanged(task)) {
                taskProvider.updateTask(context, task);
                taskUpdated(context);
              } else {
                nothingEnterOnUpdateTaskMode(context);
              }
            }
          },
          color: MyColors.primaryColor,
          child: Text(
            task == null ? MyString.addTaskString : MyString.updateTaskString,
            style: TextStyle(
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
          ),
        ),
      ],
    ),
  );
}
