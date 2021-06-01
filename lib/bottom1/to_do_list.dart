import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_swd/bottom1/create_list.dart';
import 'package:flutter_app_swd/bottom1/edit_list.dart';
import 'package:flutter_app_swd/model/todo_model.dart';
import 'package:flutter_app_swd/use_class/my_address.dart';

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List<TodoModel> todoModels = List();
  List<Widget> Cards = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: create(),
      body: Cards.length == 0
          ? Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.red,
                centerTitle: true,
                title: Text(
                  'TodoList',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              body: Center(child: Text('ยังไม่มีรายการ')),
            )
          : Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.red,
                centerTitle: true,
                title: Text(
                  'TodoList',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 1),
                        child: Column(
                          children: Cards,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  //api
  Future<Null> readTodo() async {
    if (todoModels.length != 0) {
      setState(() {
        Cards.clear();
        todoModels.clear();
      });
    }

    String url = '${MyAddress().domain}/swd/getMessage.php';

    await Dio().get(url).then((value) {
      var result = json.decode(value.data);

      int index = 0;

      for (var map in result) {
        print('data $result');
        TodoModel model = TodoModel.fromJson(map);
        setState(() {
          todoModels.add(model);
          Cards.add(createCard(model, index));
          index++;
        });
      }
    });
  }

  Widget createCard(TodoModel todoModel, int index) {
    return GestureDetector(
      onTap: () {
        print('you click index $index');
        MaterialPageRoute route = MaterialPageRoute(
          builder: (context) => EditList(
            todoModel: todoModels[index],
          ),
        );
        Navigator.push(context, route).then((value) => EditList());
      },
      child: Card(
        elevation: 3,
        color: Colors.grey[200],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
            ),
            SingleChildScrollView(
              child: ListTile(
                title: Text(
                  '${todoModel.tList}',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  FloatingActionButton create() {
    return FloatingActionButton(
      onPressed: () {
        MaterialPageRoute route = MaterialPageRoute(
          builder: (context) => CreateList(),
        );
        Navigator.push(context, route);
      },
      child: Icon(
        Icons.add_comment,
        color: Colors.white,
      ),
      backgroundColor: Colors.red,
    );
  }
}
