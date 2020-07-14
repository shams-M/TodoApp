import 'package:flutter/material.dart';
import 'package:todo/models/task.dart';
import 'package:todo/repositories/db_repository.dart';

class DBProvider extends ChangeNotifier{
  List<Task> allTasks=[];
  List<Task> completTasks=[];
  List<Task> inCompletTasks=[];

  Future<List<Task>> setLists()async{
    List<Task> tasks=await DBRepository.dbRepository.getAllTasks();
    this.allTasks=tasks;
    this.completTasks=await DBRepository.dbRepository.getCompleteTasks();
    this.inCompletTasks=await DBRepository.dbRepository.getInCompleteTasks();
    notifyListeners();
    return tasks;

  }
  
  insertNewTask(Task task) async {
    await DBRepository.dbRepository.insertNewTask(task);
    setLists();
  }

  toggleTask(Task task) async {
    await DBRepository.dbRepository.toggleTask(task);
    setLists();
  }

  updateTask(Task task) async {
    await DBRepository.dbRepository.updateTask(task);
    setLists();
  }
  deleteTask(Task task) async {
    await DBRepository.dbRepository.deleteTask(task);
    setLists();
  }
  deleteAllTasks() async {
    await DBRepository.dbRepository.deleteAll();
    setLists();
  }

}