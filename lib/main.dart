import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo_app_firebase/models/loading.dart';
import 'package:todo_app_firebase/widgets/todo_app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context,snapshot){
        if(snapshot.hasError){
          return Scaffold(
            body: Center(
              child: Text(snapshot.error.toString()),
            ),
          );
        }

        if(snapshot.connectionState == ConnectionState.waiting){
          return const Loading();
        }

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'ToDo App',
          theme: ThemeData(
            primarySwatch: Colors.pink,
            scaffoldBackgroundColor: Colors.grey[900],
          ),
          home: const ToDoList(),
        );
      },
    );
  }
}
