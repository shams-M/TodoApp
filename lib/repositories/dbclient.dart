import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DBClient{
  DBClient._();
  static final DBClient dbClient=DBClient._();
  Database database;
  final String taskTableName='tasks';
  final String taskIdColm='task_id';
  final String taskTitleColm='task_title';
  final String taskDescColm='task_description';
  final String taskIsComppleteColm='task_iscomplete';
  final String taskDateColm='task_date';    // deadline of task

  Future<Database> initDB()async{
    if(database==null) {
      database=await connectDB();
      return database;
    }
      else{
        return database;
    }
  }
  Future<Database> connectDB()async{
    Directory dir=await getApplicationDocumentsDirectory();
    String dp_path=join(dir.path,'tasks.db');
    Database db=await openDatabase(dp_path,version: 1,onCreate:(db,ver){
      db.execute('''CREATE TABLE $taskTableName(
          $taskIdColm INTEGER PRIMARY KEY AUTOINCREMENT,
          $taskTitleColm TEXT NOT NULL,
          $taskDescColm TEXT NOT NULL,
          $taskIsComppleteColm INTEGER NOT NULL,
          $taskDateColm TEXT NOT NULL
        )''');
    } );
    return db;
  }

  Future<int> insertNewTask(Map<String,dynamic> map)async {
    try{
      database=await initDB();
      int rowIndex=await database.insert(taskTableName, map);
      return rowIndex;
    }catch(e){
      throw 'Database error $e';
    }
  }

  Future<List<Map<String, dynamic>>> getAllTasks()async{
    try{
      database=await initDB();
      Future<List<Map<String, dynamic>>> allTasks=database.query(taskTableName);
      return allTasks;
    }catch(e){
      throw 'Database error $e';
    }
  }

  Future<List<Map<String, dynamic>>> getCompleteTasks()async{
    try{
      database=await initDB();
      Future<List<Map<String, dynamic>>> allTasks=database.query(taskTableName,where: '$taskIsComppleteColm = ?',whereArgs: [1]);
      return allTasks;
    }catch(e){
      throw 'Database error $e';
    }
  }

  Future<List<Map<String, dynamic>>> getInCompleteTasks()async{
    try{
      database=await initDB();
      Future<List<Map<String, dynamic>>> allTasks=database.query(taskTableName,where: '$taskIsComppleteColm = ?',whereArgs: [0]);
      return allTasks;
    }catch(e){
      throw 'Database error $e';
    }
  }
  Future<int> updateTask(Map<String,dynamic> map,int id) async {
    try{
      database=await initDB();
      int updatedRows=await database.update(taskTableName, map,where: '$taskIdColm = ?',whereArgs: [id]);
      return updatedRows;
    }
    catch(e){
      throw 'Database error $e';
    }
  }
  Future<int> deleteTask(int id)async{
    try{
      database=await initDB();
      int deletedRows=await database.delete(taskTableName,where: '$taskIdColm = ?',whereArgs: [id]);
      return deletedRows;
    }catch(e){
      throw 'Database error $e';
    }
  }

  Future<int> deleteAllTasks()async{
    try{
      database=await initDB();
      int deletedRows=await database.delete(taskTableName);
      return deletedRows;
    }catch(e){
      throw 'Database error $e';
    }
  }


}

