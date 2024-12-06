// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/app/providers/task_provider.dart';

import '../model/task.dart';
import 'widgets/bottom_buttons.dart';
import 'widgets/build_text_field_and_date_time_picker.dart';
import 'widgets/my_app_bar.dart';
import 'widgets/top_text_widget.dart';

class TaskView extends StatefulWidget {
  final Task? task;
  const TaskView({super.key, required this.task});

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      Future.microtask(() {
        Provider.of<TaskProvider>(context, listen: false)
            .initializeTask(widget.task!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: const MyAppBar(),
            body: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TopTextWidget(task: widget.task),
                      const BuildTextFieldAndDateTimePicker(),
                      bottomButtons(
                        context,
                        widget.task,
                        taskProvider.titleController!,
                        taskProvider.subtitleController!,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
