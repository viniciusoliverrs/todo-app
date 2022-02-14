import 'package:flutter/material.dart';
import 'package:todo_list/models/todo.dart';

import '../repositories/todo_repository.dart';
import '../widgets/todo_list_item.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  _TodoListPageState createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  List<Todo> todos = [];
  final TextEditingController todo = TextEditingController();
  final TodoRepository todoRepository = TodoRepository();
  @override
  void initState() {
    super.initState();
    todoRepository.getTodoList().then((value) => {
          setState(() {
            todos = value;
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Adicionar uma tarefa.",
                          hintText: "Ex: Estudar, Ler",
                        ),
                        controller: todo,
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (todo.text.isEmpty) return;
                        Todo model = new Todo(
                          title: todo.text,
                          dateTime: DateTime.now(),
                        );
                        setState(() {
                          todos.add(model);
                        });
                        todo.clear();
                        todoRepository.saveTodoList(todos);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xff00d7f3),
                        padding: EdgeInsets.all(14),
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                SizedBox(
                  height: 150,
                  child: ListView(
                    children: [
                      for (var todo in todos)
                        TodoListItem(
                          todo: todo,
                          onDelete: onDelete,
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text("${todos.length} tarefas"),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ElevatedButton(
                      onPressed: () => showDeleteTodosConfirmationDialog(),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xff00d7f3),
                        padding: EdgeInsets.all(14),
                      ),
                      child: const Text("Limpar"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showDeleteTodosConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete all tasks"),
        content: const Text("Are you sure you want to delete all tasks?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              deleteAllTodos();
            },
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }

  void deleteAllTodos() {
    setState(() {
      todos.clear();
    });
    todoRepository.saveTodoList(todos);
  }

  void onDelete(Todo todo) {
    var index = todos.indexOf(todo);
    setState(() {
      todos.remove(todo);
    });
    todoRepository.saveTodoList(todos);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "${todo.title} Task deleted!",
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.red,
            fontSize: 12,
          ),
        ),
        backgroundColor: Colors.white,
        action: SnackBarAction(
          label: "Undo",
          onPressed: () => setState(() {
            todos.insert(index, todo);
          }),
        ),
        duration: const Duration(
          seconds: 5,
        ),
      ),
    );
  }
}
