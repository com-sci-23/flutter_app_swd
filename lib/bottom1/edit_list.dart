import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_swd/model/todo_model.dart';
import 'package:flutter_app_swd/screen/home.dart';
import 'package:flutter_app_swd/use_class/my_address.dart';
import 'package:flutter_app_swd/use_class/my_style.dart';


class EditList extends StatefulWidget {
  final TodoModel todoModel;

  EditList({Key key, this.todoModel}) : super(key: key);

  @override
  _EditListState createState() => _EditListState();
}

class _EditListState extends State<EditList> {
  List<TodoModel> todoModels = List();
  TodoModel todoModel;
  String  t_list;
  String t_id;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    todoModel = widget.todoModel;
    t_id = todoModel.tId;
    t_list = todoModel.tList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แก้ไขรายการ'),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      floatingActionButton: uploadButton1(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 100,
            ),
            listForm(),
            SizedBox(
              height: 20,
            ),
            deleteButton(),
          ],
        ),
      ),
    );
  }


  //--------------------------------------------

  Future<Null> insertList() async {
    String t_id = todoModel.tId;

    String url = '${MyAddress().domain}/swd/editList.php?t_id=$t_id&t_list=$t_list';
    await Dio().get(url).then((value) {
      MaterialPageRoute route = MaterialPageRoute(
        builder: (context) => Home(),
      );
      Navigator.push(context, route)
          .then((value) => Home());
    }

    );
  }

  Future<Null> conFirmEdit() async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('คุณต้องการเปลี่ยนแปลงข้อมูล',),
        children: <Widget>[
          Row(
            children: <Widget>[
              FlatButton.icon(
                onPressed: () {
                  //Navigator.pop(context);
                  insertList();
                },
                icon: Icon(
                  Icons.check,
                  color: Colors.green,
                ),
                label: Text('เปลี่ยนแปลง',),
              ),
              FlatButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.clear,
                  color: Colors.red,
                ),
                label: Text('ยกเลิก',),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<Null> deleteList(TodoModel todoModel) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('คุณต้องการลบ ?'),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              FlatButton(
                onPressed: () async {
                  String url =
                      '${MyAddress().domain}/swd/deleteList.php?t_id=$t_id';
                  await Dio().get(url).then((value) {
                    MaterialPageRoute route = MaterialPageRoute(
                      builder: (context) => Home(),
                    );
                    Navigator.push(context, route)
                        .then((value) => Home());
                  });
                },
                child: Text('ยืนยัน'),
              ),
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text('ยกเลิก'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //--------------------------------------------

  Widget listForm() => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Container(
        padding: EdgeInsets.only(left: 50, right: 50, top: 20),
        width: MediaQuery.of(context).size.width,
        child: TextFormField(
          onChanged: (value) => t_list = value.trim(),
          initialValue: t_list,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.assignment,
              color: MyStyle().primaryColor,
            ),
            labelStyle: TextStyle(color: MyStyle().primaryColor),
            labelText: 'Note :',
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: MyStyle().primaryColor)),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: MyStyle().primaryColor)),
          ),
        ),
      ),
    ],
  );

  Widget deleteButton() => Container(
    padding: EdgeInsets.only(
      left: 50,
      right: 50,
      top: 20,
      bottom: 50,
    ),
    width: MediaQuery.of(context).size.width,
    child: RaisedButton(
      color: MyStyle().primaryColor,
      onPressed: () {
        deleteList(todoModel);
      },
      child: Text(
        'ลบรายการ',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    ),
  );

  FloatingActionButton uploadButton1() {
    return FloatingActionButton(
      onPressed: () {
        if (todoModel.tId != null) {
          conFirmEdit();
        } else {

        }
      },
      child: Icon(Icons.save),
      backgroundColor: Colors.red,
    );
  }

}
