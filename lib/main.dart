import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/providers/db_provider.dart';
import 'package:todo/ui/screens/main_screen.dart';

void main() {
  runApp(Todo());
}

class Todo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DBProvider>(
      create: (BuildContext context) {
        return DBProvider();
      },
      child: MaterialApp(
        title: 'Todo App',
        home: MainScreen(),
      ),
    );
  }
}
