import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'state.dart';

Widget delete(context, item) {
  return IconButton(
    icon: const Icon(Icons.close, color: Colors.white),
    tooltip: 'Ta bort',
    onPressed: () {
      Provider.of<MyState>(context, listen: false).removeToDo(item);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          duration: Duration(seconds: 1),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          content: Text('Anteckning borttagen',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontFamily: "Roboto"))));
    },
  );
}
