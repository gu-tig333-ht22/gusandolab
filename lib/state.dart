// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'todo.dart';

class MyState extends ChangeNotifier {
  final List<Todo> _list = [];
  String _filterBy = 'Samtliga';

  List<Todo> get list => _list;
  String get filterBy => _filterBy;

  String homepage = "https://todoapp-api.apps.k8s.gu.se/todos";
  String key = "?key=52ba5e9b-bd5e-4af6-a070-0875aff960b6";

  MyState() {
    getupdateApiList();
  }

  void getupdateApiList() async {
    http.Response answer = await http.get(Uri.parse('$homepage$key'));
    List itemlist = jsonDecode(answer.body);
    updateApiList(itemlist);
  }

  void updateApiList(itemlist) {
    _list.clear();
    itemlist.forEach((object) {
      _list.add(Todo(
          todo: object["title"], checked: object["done"], id: object["id"]));
    });
    notifyListeners();
  }

  void addToDo(Todo item) async {
    http.Response answer = await http.post(Uri.parse('$homepage$key'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"title": item.todo, "done": item.checked}));
    List itemlist = jsonDecode(answer.body);
    updateApiList(itemlist);
    notifyListeners();
  }

  void removeToDo(Todo item) async {
    String id = item.id;
    http.Response answer = await http.delete(Uri.parse('$homepage/$id$key'));
    List itemlist = jsonDecode(answer.body);
    updateApiList(itemlist);
    notifyListeners();
  }

  void setFilterBy(String filterBy) {
    _filterBy = filterBy;
    notifyListeners();
  }

  void setIsDone(Todo item) async {
    String id = item.id;
    http.Response answer = await http.put(Uri.parse('$homepage/$id$key'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"title": item.todo, "done": !item.checked}));
    List itemlist = jsonDecode(answer.body);
    updateApiList(itemlist);
    notifyListeners();
  }
}
