import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app_firebase/models/todo_model.dart';

class DataBaseService {
  CollectionReference todoCollection =
      FirebaseFirestore.instance.collection("Todos");

  var n;

  //adding new task into fire store
  Future createNewToDo(String title) async {
    return await todoCollection.add({
      "title": title,
      "isComplete": false,
    });
  }

  //update task is done.
  Future completeTask(uid) async {
    await todoCollection.doc(uid).update({"isComplete": true});
  }

  Future removeTodo(uid) async{
    await todoCollection.doc(uid).delete();
  }

  List<Todo> todoFromFireStore(QuerySnapshot snapshot) {
    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.map((e) {
        return Todo(
          title: (e.data() as dynamic)["title"],
          isComplete: (e.data() as dynamic)["isComplete"],
          uid: e.id,
        );
      }).toList();
    } else{
      return n;
    }
  }

  Stream<List<Todo>> listTodos(){
    return todoCollection.snapshots().map((todoFromFireStore));
  }
}
