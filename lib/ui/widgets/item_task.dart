import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:provider/provider.dart';
import 'package:todo/models/task.dart';
import 'package:todo/providers/db_provider.dart';

class ItemTask extends StatelessWidget {
  Task task;
  ItemTask(this.task);
  GlobalKey<FormState> formKey2=GlobalKey();

  setTitle(String val) {
    task.title = val;
  }
  setDesc(String val) {
    task.desc = val;
  }
  setTDate(String val) {
    task.date = val;
  }
  submitData(BuildContext context) {
    if (formKey2.currentState.validate()) {
      formKey2.currentState.save();
      try {
        Provider.of<DBProvider>(context, listen: false).updateTask(
            task);
            print(task.desc);
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
    return Card(margin: EdgeInsets.fromLTRB(7, 7, 7, 0),
          child: ListTile(
            title: Text(task.title),
            subtitle: Text('${task.date}'),
            trailing:
                Row(mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(icon: Icon(Icons.delete), onPressed: (){
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(title: Text('Delete This Task ?'),
                              actions: <Widget>[
                                FlatButton(
                                    onPressed: () {
                                      Provider.of<DBProvider>(context, listen: false).deleteTask(task);
                                      Navigator.pop(context);
                                    },
                                    child: Text('Yes',style: TextStyle(color: Colors.pink[600]),)),
                                FlatButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('No',style: TextStyle(color: Colors.grey[500]))),
                              ],
                            );
                          });
                  }),
                    IconButton(icon: Icon(Icons.edit), onPressed: () {
                      showModalBottomSheet(isScrollControlled: true,
                          backgroundColor: Colors.grey[300],
                          context: context,
                          builder: (BuildContext context) {
                            return Padding(
                              padding: MediaQuery.of(context).viewInsets,
                              child: Form(
                                key: formKey2,
                                child: CupertinoActionSheet(title: Text('Update Task',style: TextStyle(color: Colors.pink[600],fontSize: 20),),
                                  actions: <Widget>[
                                    CupertinoActionSheetAction(
                                        onPressed: () {},
                                        child: Card(
                                            color: Colors.transparent,
                                            elevation: 0.0,
                                            child: TextFormField(
                                              initialValue: task.title,
                                              validator: (value) {
                                                return value == null || value == ''
                                                    ? 'Title is required'
                                                    : null;
                                              },
                                              onChanged: (value){
                                                setTitle(value);
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
                                            ))),
                                    CupertinoActionSheetAction(
                                        onPressed: () {},
                                        child: Card(
                                            color: Colors.transparent,
                                            elevation: 0.0,
                                            child: TextFormField(
                                              initialValue: task.desc,
                                              minLines: 3,
                                              maxLines: 4,
                                              validator: (value) {
                                                return value == null || value == ''
                                                    ? 'Description is required'
                                                    : null;
                                              },
                                              onChanged: (value) {
                                                setDesc(value);
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
                                            ))),
                                    CupertinoActionSheetAction(
                                      onPressed: () {},
                                      child: Card(
                                        child: CupertinoButton(
                                            child: Text('Task Deadline :',style: TextStyle(color: Colors.grey[700]),),
                                            onPressed: () {
                                              DatePicker.showDatePicker(context,
                                                  theme: DatePickerTheme(
                                                    headerColor: Colors.pink[600],
                                                    itemStyle: TextStyle(
                                                        color: Colors.pink[500], fontWeight: FontWeight.bold, fontSize: 18),
                                                    doneStyle: TextStyle(color: Colors.white, fontSize: 16),
                                                  ),
                                                  currentTime: DateTime.parse(task.date),
                                                  locale: LocaleType.en,
                                                  minTime: DateTime(2020, 1, 1),
                                                  onConfirm: (date) {
                                                    String dateformate ="${date.year.toString()}-${date.month.toString().padLeft(2,'0')}-${date.day.toString().padLeft(2,'0')}";
                                                    setTDate(dateformate);
                                                  });
                                            }),
                                      ),
                                    )
                                  ],
                                  cancelButton: CupertinoActionSheetAction(
                                    child: Text('Update',style: TextStyle(color: Colors.purple[700],fontWeight:FontWeight.bold),),
                                    onPressed: () {
                                      submitData(context);
                                    },
                                  ),
                                ),
                              ),
                            );
                          });
                    })
                  ],
                ),

            leading: Checkbox(activeColor: Colors.pink[500],
                value: task.isCompleted,
                onChanged: (value) {
                  Provider.of<DBProvider>(context, listen: false)
                      .toggleTask(task);
                }),
          ),
        );
  }

}

