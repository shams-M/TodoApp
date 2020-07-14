import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:todo/models/task.dart';
import 'package:todo/providers/db_provider.dart';
import 'package:todo/ui/widgets/item_task.dart';

class InCompleteTasksTab extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Consumer<DBProvider>(builder: (context,value,child){
      List<Task> allTask=value.inCompletTasks;
      return ListView.builder(itemCount: allTask.length,itemBuilder: (context,index){
        return ItemTask(allTask[index]);
      });
    });
  }

}