// ignore_for_file: unnecessary_new, prefer_typing_uninitialized_variables, library_private_types_in_public_api, prefer_final_fields, unused_field, curly_braces_in_flow_control_structures

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
          unselectedWidgetColor: Colors.yellow),
      home: const TodoList(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Todo {
  Todo({required this.name, required this.checked});
  String name;
  bool checked;
}

class TodoItem extends StatelessWidget {
  TodoItem({
    required this.todo,
    required this.onTodoChanged,
  }) : super(key: ObjectKey(todo));

  final Todo todo;
  final onTodoChanged;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(todo.name),
      controlAffinity: ListTileControlAffinity.leading,
      secondary: const Icon(Icons.close),
      activeColor: Colors.yellow,
      checkColor: Colors.black,
      value: todo.checked,
      onChanged: (bool? value) {
        onTodoChanged(todo);
      },
    );
  }
}

class TodoList extends StatefulWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  _TodoListState createState() => new _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final TextEditingController _textFieldController = TextEditingController();
  final List<Todo> _todos = [];
  String initialText = "";

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text('Att-Göra Lista'),
      ),
      body: ListView.builder(
          itemCount: _todos.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(_todos[index].name),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      showDialog<void>(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Uppdatera uppgift'),
                            content: TextField(
                              onChanged: (value) {
                                setState(() {
                                  initialText = value;
                                });
                              },
                              controller: _textFieldController,
                              decoration: const InputDecoration(
                                  hintText: 'Skriv här..'),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('Uppdatera'),
                                onPressed: () {
                                  setState(() {
                                    _todos[index].name = initialText;
                                  });
                                  Navigator.of(context).pop();
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text("Uppdaterat"),
                                  ));
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _todos.removeAt(index);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Anteckning borttagen"),
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
      // ListView(
      //   padding: const EdgeInsets.symmetric(vertical: 8.0),
      //   children: _todos.map((Todo todo) {
      //     return TodoItem(
      //       todo: todo,
      //       onTodoChanged: _handleTodoChange,
      //     );
      //   }).toList(),
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _displayDialog(),
        tooltip: 'Ny uppgift',
        backgroundColor: Colors.yellow,
        foregroundColor: Colors.black,
        child: const Icon(Icons.add),
      ),
    );
  }

  //final void Function()? delete;

/*  void _handleTodoChange(Todo todo) {
    setState(() {
      todo.checked = !todo.checked;
    });
    _displayDialog();
  }
  */

  void _addTodoItem(String name) {
    setState(() {
      _todos.add(Todo(name: name, checked: false));
    });
    _textFieldController.clear();
  }

  Future<void> _displayDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
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
              },
            ),
          ],
        );
      },
    );
  }

  // ignore: unused_element
  Future<void> _displayDialog2() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ny uppgift'),
          content: TextField(
            controller: _textFieldController,
            decoration: const InputDecoration(hintText: 'Skriv här..'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Uppdatera'),
              onPressed: () {
                Navigator.of(context).pop();
                _textFieldController.clear();
              },
            ),
          ],
        );
      },
    );
  }
}
