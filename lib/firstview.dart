// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'newview.dart';
import 'state.dart';
import 'todo.dart';
import 'delete.dart';

class Homepage extends StatelessWidget {
  const Homepage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Att-Göra Lista'),
        actions: [
          Consumer<MyState>(
            builder: (context, state, child) => Row(
              children: [
                PopupMenuButton(
                  tooltip: 'Meny',
                  onSelected: (value) =>
                      Provider.of<MyState>(context, listen: false)
                          .setFilterBy(value as String),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                        value: 'Samtliga', child: Text("Samtliga")),
                    const PopupMenuItem(
                        value: 'Avklarade', child: Text("Avklarade")),
                    const PopupMenuItem(
                        value: 'Ej avklarade', child: Text("Ej avklarade")),
                  ],
                )
              ],
            ),
          )
        ],
      ),
      body: Consumer<MyState>(builder: (context, state, child) {
        return TodoList(_filterList(state.list, state.filterBy));
      }),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Lägg till anteckning',
        backgroundColor: Colors.yellow,
        foregroundColor: Colors.black,
        child: const Icon(Icons.add),
        onPressed: () async {
          var newtodo = await Navigator.push(context,
              MaterialPageRoute(builder: (context) => const NewView()));
          if (newtodo != null && newtodo.todo != "") {
            Provider.of<MyState>(context, listen: false).addToDo(newtodo);
          }
        },
      ),
    );
  }
}

class TodoList extends StatelessWidget {
  final List<Todo> list;
  const TodoList(this.list, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      children: list.map((item) => todoItems(context, item)).toList(),
    );
  }

  Widget todoItems(context, item) {
    return Column(
      children: [
        ListTile(
            leading: checkBox(context, item),
            title: text(context, item),
            trailing: delete(context, item)),
        const Divider(height: 5, thickness: 2),
      ],
    );
  }
}

Widget text(context, item) {
  return Text(
    item.todo,
    style: item.checked
        ? const TextStyle(
            decoration: TextDecoration.lineThrough, color: Colors.grey)
        : const TextStyle(),
  );
}

Widget checkBox(context, item) {
  return Checkbox(
      value: item.checked,
      fillColor: MaterialStateProperty.all(Colors.yellow),
      checkColor: Colors.black,
      onChanged: (value) {
        Provider.of<MyState>(context, listen: false).setIsDone(item);
      });
}

List<Todo> _filterList(list, filter) {
  if (filter == 'Samtliga') {
    return list;
  } else if (filter == 'Avklarade') {
    return list.where((item) => item.checked == true).toList();
  } else if (filter == 'Ej avklarade') {
    return list.where((item) => item.checked == false).toList();
  }
  return list;
}
