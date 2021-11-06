import 'package:flutter/material.dart';
import 'package:todo_app_firebase/models/loading.dart';
import 'package:todo_app_firebase/models/todo_model.dart';
import 'package:todo_app_firebase/services/database_services.dart';
import 'package:async/async.dart';

class ToDoList extends StatefulWidget {
  const ToDoList({Key? key}) : super(key: key);

  @override
  State<ToDoList> createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  bool isComplete = false;
  TextEditingController todoListController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<List<Todo>>(
          stream: DataBaseService().listTodos(),
          builder:(context, snapshot){
            List<Todo>? todo = snapshot.data;
            return Padding(
              padding: const EdgeInsets.all(25),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "All ToDo",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Divider(
                      color: Colors.grey[600],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ListView.separated(
                      separatorBuilder: (context, index) => Divider(
                        color: Colors.grey[800],
                      ),
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemCount: snapshot.hasData ? todo!.length : 0,
                      itemBuilder: (context, index) {
                        return Dismissible(
                          key: Key(index.toString(),),
                          background: Container(
                            padding: const EdgeInsets.only(left: 20),
                            alignment: Alignment.centerLeft,
                            child: const Icon(Icons.delete),
                            color: Colors.red,
                          ),
                          onDismissed: (direction) async{
                            await DataBaseService().removeTodo(todo![index].uid);
                          },
                          child: ListTile(
                            onTap: () {
                              DataBaseService().completeTask(todo![index].uid);
                            },
                            leading: Container(
                              padding: const EdgeInsets.all(2),
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  shape: BoxShape.circle),
                              child: todo![index].isComplete
                                  ? const Icon(
                                Icons.check,
                                color: Colors.white70,
                              )
                                  : Container(),
                            ),
                            title: Text(
                              todo[index].title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white70,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          }
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return SimpleDialog(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 20,
                  ),
                  backgroundColor: Colors.grey[800],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  title: Row(
                    children: [
                      const Text(
                        "Add Task",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.cancel,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  children: [
                    const Divider(),
                    TextFormField(
                      controller: todoListController,
                      autofocus: true,
                      style: const TextStyle(
                        fontSize: 18,
                        height: 1.5,
                        color: Colors.white,
                      ),
                      decoration: const InputDecoration(
                        hintText: "eg. exercise",
                        hintStyle: TextStyle(
                          color: Colors.white,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        onPressed: () async{
                          if(todoListController.text.isNotEmpty) {
                            await DataBaseService().createNewToDo(todoListController.text.trim());
                            Navigator.pop(context);
                          }
                        },
                        child: const Text(
                          "Add",
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                        ),
                      ),
                    ),
                  ],
                );
              });
        },
      ),
    );
  }
}
