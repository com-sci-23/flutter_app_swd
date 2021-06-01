import 'package:flutter/material.dart';
import 'file:///C:/Users/s6052/AndroidStudioProjects/flutter_app_swd/lib/buttom2/calculate.dart';
import 'file:///C:/Users/s6052/AndroidStudioProjects/flutter_app_swd/lib/buttom3/data_person.dart';
import 'package:flutter_app_swd/bottom1/to_do_list.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentTabIndex = 0;
  Widget currentPage;

  //pages
  TodoList todoList;
  Calculator calcuLator;
  DataPerson dataPerson;

  List<Widget> pages;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    todoList = TodoList();
    calcuLator = Calculator();
    dataPerson = DataPerson();

    pages = [
      todoList,
      calcuLator,
      dataPerson,

    ];
    currentPage = todoList;
  }


  void routeToService(Widget myWidget) {
    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => myWidget,
    );
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentPage,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.red,
        fixedColor: Colors.white,
        onTap: (int index) {
          setState(() {
            currentTabIndex = index;
            currentPage = pages[index];
          });
        },
        currentIndex: currentTabIndex,
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.list), title: Text("TodoList")),
          BottomNavigationBarItem(icon: Icon(Icons.calculate), title: Text("Calculate")),
          BottomNavigationBarItem(icon: Icon(Icons.person), title: Text("ข้อมูลส่วนบุคคล")),

        ],
      ),
    );
  }



}
