import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:provider/provider.dart';
import 'package:todo/models/task.dart';
import 'package:todo/providers/db_provider.dart';
import 'package:todo/ui/widgets/item_task.dart';

class AllTasksTab extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Consumer<DBProvider>(builder: (context, value, child) {
      List<Task> allTask = value.allTasks;
      return ListView.builder(
          itemCount: allTask.length,
          itemBuilder: (context, index) {
            return  ItemTask(allTask[index]);

          });
    });
  }
}
