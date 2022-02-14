import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo.dart';
import 'dart:convert';

const todoListKey = 'todolist';

class TodoRepository {
  late SharedPreferences sharedPreferences;
  Future<List<Todo>> getTodoList() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final String jsonString = sharedPreferences.getString(todoListKey) ?? '[]';
    final List jsonDecoded = json.decode(jsonString) as List;
    return jsonDecoded.map((e) => Todo.fromJson(e)).toList();
  }

  void saveTodoList(List<Todo> todos) {
    final String jsonString = json.encode(todos);
    sharedPreferences.setString('todoListKey', jsonString);
  }
}
