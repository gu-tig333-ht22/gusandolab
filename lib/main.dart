// ignore_for_file: unnecessary_new, prefer_typing_uninitialized_variables, library_private_types_in_public_api, prefer_final_fields, unused_field, curly_braces_in_flow_control_structures, unused_import, unnecessary_null_comparison

import 'dart:async';
import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Att-Göra ista',
      theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.yellow,
          unselectedWidgetColor: Colors.yellow),
      home: const TodoList(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Todo {
  Todo({required this.id, required this.name, required this.checked});

  int id;
  String name;
  bool checked;
}

class TodoList extends StatefulWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  _TodoListState createState() => new _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final TextEditingController _textFieldController = TextEditingController();
  List<Todo> _todos = [];
  List<Todo> _filterd = [];

  String initialText = "";
  bool isChecked = false;
  int listState = 0;

  StreamController<bool> nameStreamController = StreamController.broadcast();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Att-Göra'),
        actions: [
          PopupMenuButton(itemBuilder: (context) {
            return [
              const PopupMenuItem<int>(
                value: 0,
                child: Text("Samtliga"),
              ),
              const PopupMenuItem<int>(
                value: 1,
                child: Text("Avklarade"),
              ),
              const PopupMenuItem<int>(
                value: 2,
                child: Text("Ej avklarade"),
              ),
            ];
          }, onSelected: (value) {
            if (value == 0) {
              _todos.clear();
              _todos.addAll(_filterd);
              if (mounted) {
                setState(() {});
              }
            } else if (value == 1) {
              _todos.clear();
              for (var todo in _filterd) {
                if (todo.checked) {
                  _todos.add(todo);
                }
              }
              if (mounted) {
                setState(() {});
              }
            } else if (value == 2) {
              _todos.clear();
              for (var todo in _filterd) {
                if (!todo.checked) {
                  _todos.add(todo);
                }
              }
              if (mounted) {
                setState(() {});
              }
            }
          }),
        ],
      ),
      body: ListView.builder(
          itemCount: _todos.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Checkbox(
                checkColor: Colors.black,
                activeColor: Colors.yellow,
                value: _todos[index].checked,
                onChanged: (bool? value) {
                  setState(() {
                    _todos[index].checked = value!;
                    Todo? filteredTodo = (_filterd
                        .singleWhere((it) => it.id == _todos[index].id));
                    if (filteredTodo != null) {
                      filteredTodo.checked = value;
                    }
                  });
                },
              ),
              title: Text(
                _todos[index].name,
                style: TextStyle(
                    decoration: _todos[index].checked
                        ? TextDecoration.lineThrough
                        : TextDecoration.none),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        Todo? filteredTodo = (_filterd
                            .singleWhere((it) => it.id == _todos[index].id));
                        if (filteredTodo != null) {
                          _filterd.remove(filteredTodo);
                        }
                        _todos.removeAt(index);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                          'Anteckning borttagen',
                          textAlign: TextAlign.center,
                        ),
                      ));
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _displayDialog(),
        tooltip: 'Ny uppgift',
        backgroundColor: Colors.yellow,
        foregroundColor: Colors.black,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addTodoItem(String name) {
    setState(() {
      int id = _filterd.length + 1;
      _filterd.add(Todo(id: id, name: name, checked: false));
      _todos.clear();
      _todos.addAll(_filterd);
    });
    _textFieldController.clear();
  }

  Future<void> _displayDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ny uppgift'),
          content: TextField(
            onSubmitted: (newValue) {
              initialText = newValue;
            },
            controller: _textFieldController,
            decoration: const InputDecoration(hintText: 'Skriv här..'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Lägg till'),
              onPressed: () {
                Navigator.of(context).pop();
                _addTodoItem(_textFieldController.text);
                _textFieldController.clear();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text(
                    'Anteckning sparad!',
                    textAlign: TextAlign.center,
                  ),
                ));
              },
            ),
          ],
        );
      },
    );
  }
}
