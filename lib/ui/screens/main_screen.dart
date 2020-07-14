import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/models/task.dart';
import 'package:todo/providers/db_provider.dart';
import 'package:todo/ui/screens/tabs_screens/all_task_tab.dart';
import 'package:todo/ui/screens/tabs_screens/complete_tasks_tab.dart';
import 'package:todo/ui/screens/tabs_screens/incomplete_tasks_tab.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class MainScreen extends StatelessWidget {

  GlobalKey<FormState> formKey1 = GlobalKey();
  String title;
  String desc; //task description
  String taskDate ="${DateTime.now().year.toString()}-${DateTime.now().month.toString().padLeft(2,'0')}-${DateTime.now().day.toString().padLeft(2,'0')}";


  setTitle(String val) {
    this.title = val;
  }
  setDesc(String val) {
    this.desc = val;
  }

  setDate(String val) {
    this.taskDate = val;
  }

  submitData(BuildContext context) {
    if (formKey1.currentState.validate()) {
      formKey1.currentState.save();
      try {
        Provider.of<DBProvider>(context, listen: false).insertNewTask(
            Task(title: this.title, desc: this.desc, date: this.taskDate));
        Navigator.pop(context);
      } catch (e) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text(e.toString()),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Ok')),
                ],
              );
            });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(backgroundColor: Colors.pink[700],
          title: Text('Todo'),
          bottom: TabBar(indicatorColor: Colors.white,tabs: [
            Tab(
              icon: Icon(FontAwesomeIcons.tasks,),
              text: 'All Tasks',
            ),
            Tab(
              icon: Icon(Icons.star,),
              text: 'Complete',
            ),
            Tab(
              icon:Icon(Icons.star_border,),
              text: 'InComplete',
            )
          ]),
        ),
        body: FutureBuilder<List<Task>>(
            future: Provider.of<DBProvider>(context).setLists(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return TabBarView(children: [
                  AllTasksTab(),
                  CompleteTasksTab(),
                  InCompleteTasksTab()
                ]);
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
        floatingActionButton: FloatingActionButton(backgroundColor: Colors.pink[600],
          child: Icon(Icons.add),
          onPressed: () {
            showModalBottomSheet(isScrollControlled: true,
                backgroundColor: Colors.grey[300],
                context: context,
                builder: (BuildContext context) {
                  return  Padding(
                      padding: MediaQuery.of(context).viewInsets,
                      child: Form(
                        key: formKey1,
                        child: CupertinoActionSheet(title: Text('New Task',style: TextStyle(color: Colors.pink[600],fontSize: 20),),
                          actions: <Widget>[
                            CupertinoActionSheetAction(
                                onPressed: () {},
                                child: Card(
                                  color: Colors.transparent,
                                  elevation: 0.0,
                                  child: TextFormField(
                                    validator: (value) {
                                      return value == null || value == ''
                                          ? 'Title is required'
                                          : null;
                                    },
                                    onSaved: (value) {
                                      setTitle(value);
                                    },
                                    decoration: InputDecoration(
                                        labelText: 'Title',
                                        border: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.circular(20)),
                                        fillColor: Colors.transparent,
                                        filled: true),
                                  ),
                                )),
                            CupertinoActionSheetAction(
                                onPressed: () {},
                                child: Card(
                                  color: Colors.transparent,
                                  elevation: 0.0,
                                  child: TextFormField(
                                    minLines: 3,
                                    maxLines: 4,
                                    validator: (value) {
                                      return value == null || value == ''
                                          ? 'Description is required'
                                          : null;
                                    },
                                    onSaved: (value) {
                                      setDesc(value);
                                    },
                                    decoration: InputDecoration(
                                        labelText: 'Description',
                                        border: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.circular(20)),
                                        fillColor: Colors.transparent,
                                        filled: true),
                                  ),
                                )),
                            CupertinoActionSheetAction(
                              onPressed: () {},
                              child: Card(
                                child: CupertinoButton(
                                    child: Text('Task Deadline :',style: TextStyle(color: Colors.grey[700]),),
                                    onPressed: () {
                                      DatePicker.showDatePicker(context,
                                          theme: DatePickerTheme(containerHeight: 300,titleHeight: 50,
                                            headerColor: Colors.pink[600],
                                            itemHeight: 40,
                                            itemStyle: TextStyle(
                                                color: Colors.pink[500], fontWeight: FontWeight.bold, fontSize: 18),
                                            doneStyle: TextStyle(color: Colors.white, fontSize: 16),
                                          ),
                                          currentTime: DateTime.now(),
                                          locale: LocaleType.en,
                                          minTime: DateTime(2020, 1, 1),
                                          onConfirm: (date) {
                                            String dateformate ="${date.year.toString()}-${date.month.toString().padLeft(2,'0')}-${date.day.toString().padLeft(2,'0')}";
                                            setDate(dateformate);
                                          });
                                    }),
                              ),
                            )
                          ],
                          cancelButton: CupertinoActionSheetAction(
                            child: Text('Save',style: TextStyle(color: Colors.purple[700],fontWeight:FontWeight.bold,),),
                            onPressed: () {
                              submitData(context);
                            },
                          ),
                        ),
                      ),
                    );
                });
          },
        ),
      ),
    );
  }
}
