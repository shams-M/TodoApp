import 'package:todo/repositories/dbclient.dart';

class Task{
  int id;
  String title;
  String desc;    // task description
  bool isCompleted;
  String date;
  Task({this.title,this.desc,this.isCompleted=false,this.date});
  Task.fromJson(Map<String,dynamic> map){
    this.id=map[DBClient.dbClient.taskIdColm];
    this.title=map[DBClient.dbClient.taskTitleColm];
    this.desc=map[DBClient.dbClient.taskDescColm];
    this.isCompleted=map[DBClient.dbClient.taskIsComppleteColm] ==1 ? true:false;
    this.date=map[DBClient.dbClient.taskDateColm];
  }
  toJson(){
    return {
      DBClient.dbClient.taskTitleColm:this.title,
      DBClient.dbClient.taskDescColm:this.desc,
      DBClient.dbClient.taskIsComppleteColm:this.isCompleted? 1:0,
      DBClient.dbClient.taskDateColm:this.date
    };
  }
  toggleTask(){
    this.isCompleted=!this.isCompleted;
  }
}