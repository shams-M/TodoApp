import 'package:todo/models/task.dart';
import 'package:todo/repositories/dbclient.dart';

class DBRepository{
  DBRepository._();
  static final DBRepository dbRepository=DBRepository._();

  Future<int> insertNewTask(Task task)async{
    int rowIndex=await DBClient.dbClient.insertNewTask(task.toJson());
    return rowIndex;
  }
  Future<List<Task>> getAllTasks()async{
    List<Map<String,dynamic>> result= await DBClient.dbClient.getAllTasks();
    List<Task> tasks=result.map((e) => Task.fromJson(e)).toList();
    return tasks;
  }
  Future<List<Task>> getCompleteTasks()async{
    List<Map<String,dynamic>> result=await DBClient.dbClient.getCompleteTasks();
    List<Task> tasks=result.map((e) => Task.fromJson(e)).toList();
    return tasks;
  }
  Future<List<Task>> getInCompleteTasks()async{
    List<Map<String,dynamic>> result=await DBClient.dbClient.getInCompleteTasks();
    List<Task> tasks=result.map((e) => Task.fromJson(e)).toList();
    return tasks;
  }

  Future<int> toggleTask(Task task) async{
    task.toggleTask();
    int updatedrows=await DBClient.dbClient.updateTask(task.toJson(), task.id);
    return updatedrows;
  }
  Future<int> updateTask(Task task) async{
    int updatedrows=await DBClient.dbClient.updateTask(task.toJson(), task.id);
    return updatedrows;
  }
  Future<int> deleteTask(Task task)async{
    int deletedRows=await DBClient.dbClient.deleteTask(task.id);
    return deletedRows;
  }
  deleteAll()async{
    await DBClient.dbClient.deleteAllTasks();
  }

}