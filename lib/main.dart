// ignore_for_file: unnecessary_new, prefer_typing_uninitialized_variables, library_private_types_in_public_api
// ^ Får mindre OCD över notiser och väljer att ignorera
// behöver addera exception handling för att hantera en tom input

import 'package:flutter/material.dart';

void main() => runApp(const Todoapp());

class Todoapp extends StatelessWidget {
  const Todoapp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Att-göra lista',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.yellow,
        unselectedWidgetColor: Colors.yellow,
      ),
      home: const TodoList(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Todo {
  Todo({required this.name, required this.checked});
  final String name;
  bool checked;
}

class TodoItem extends StatelessWidget {
  TodoItem({
    required this.todo,
    required this.onTodoChanged,
  }) : super(key: ObjectKey(todo));

  final Todo todo;
  final onTodoChanged;

  TextStyle? _getTextStyle(bool checked) {
    if (!checked) return null;
    return const TextStyle(
      color: Colors.grey,
      decoration: TextDecoration
          .lineThrough, // Ändra till bold för att förtydliga att raden blivit vald (vid byte mot checkbox)
    );
  }

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
        controlAffinity: ListTileControlAffinity.leading,
        secondary: const Icon(Icons.close),
        title: Text(todo.name, style: _getTextStyle(todo.checked)),
        value: false,
        onChanged: (bool? newValue) {
          //setState(() {
          // = newValue;   Behöver ta vidare onchanged till att ändra värde
        });
  }
}

class TodoList extends StatefulWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  _TodoListState createState() => new _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final TextEditingController _textFieldController = TextEditingController();
  final List<Todo> _todos = <Todo>[];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text('Att-Göra lista'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        children: _todos.map((Todo todo) {
          return TodoItem(
            todo: todo,
            onTodoChanged: _handleTodoChange,
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _displayDialog(),
        tooltip: 'Ny uppgift',
        backgroundColor: Colors.yellow,
        foregroundColor: Colors.black,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _handleTodoChange(Todo todo) {
    setState(() {
      todo.checked = !todo.checked;
    });
  }

  void _addTodoItem(String name) {
    setState(() {
      _todos.add(Todo(name: name, checked: false));
    });
    _textFieldController.clear();
  }

  Future<void> _displayDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // användare behöver trycka på knappen
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ny uppgift'),
          content: TextField(
            controller: _textFieldController,
            decoration: const InputDecoration(hintText: 'Skriv här..'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Lägg till'),
              onPressed: () {
                Navigator.of(context).pop();
                _addTodoItem(_textFieldController.text);
              },
            ),
          ],
        );
      },
    );
  }
}
