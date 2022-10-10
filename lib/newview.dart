import 'package:flutter/material.dart';
import 'todo.dart';

class NewView extends StatefulWidget {
  const NewView({super.key});

  @override
  State<NewView> createState() {
    return NewViewState();
  }
}

class NewViewState extends State<NewView> {
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.yellow),
          tooltip: 'Tillbaka',
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: const Text('Att-Göra Lista'),
      ),
      body: Column(
        children: [
          _tips(),
          _input(),
          Container(height: 20),
          _addButton(),
        ],
      ),
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Notera"),
          content: const Text("Anteckningen är tom"),
          actions: <Widget>[
            ElevatedButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _tips() {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: const [
      SizedBox(height: 40),
      Icon(Icons.lightbulb_outline, size: 50, color: Colors.yellow),
      SizedBox(height: 15),
      Text(
        'Tips: Köpa mjölk, städa rummet, gå ut med hunden',
        style: TextStyle(fontSize: 15),
      ),
    ]);
  }

  Widget _input() {
    return Container(
      margin: const EdgeInsets.only(left: 45, right: 45, top: 100),
      child: TextField(
          controller: textController,
          decoration: const InputDecoration(
            hintText: 'Skriv här..',
          )),
    );
  }

  Widget _addButton() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      TextButton(
          onPressed: () {
            if (textController.text.isEmpty) {
              _showDialog(context);
            } else {
              Navigator.pop(context,
                  Todo(todo: textController.text, checked: false, id: ''));
            }
          },
          child: const Text(
            "Lägg till anteckning",
            style: TextStyle(fontSize: 20, color: Colors.yellow),
          )),
    ]);
  }
}
