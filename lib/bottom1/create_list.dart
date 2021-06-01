import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_swd/screen/home.dart';
import 'package:flutter_app_swd/use_class/my_address.dart';
import 'package:flutter_app_swd/use_class/my_style.dart';
import 'package:flutter_app_swd/use_class/normal_dialog.dart';


class CreateList extends StatefulWidget {
  @override
  _CreateListState createState() => _CreateListState();
}

class _CreateListState extends State<CreateList> {
  String  t_list;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.red,
        title: Text(
          'รายการที่ต้องทำ',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              listForm(),
              uploadButton(),
            ],
          ),
        ),
      ),
    );
  }

  //--------------------------------------------

  Future<Null> insertList() async {
    String url = '${MyAddress().domain}/swd/insertMessage.php?t_list=$t_list';
    await Dio().get(url).then((value) {
      if (value.toString() == 'true') {
        //Navigator.pop(context);
      } else {
        normalDialog(context, 'สำเร็จ');
        //Navigator.pop(context);
      }
      MaterialPageRoute route = MaterialPageRoute(
        builder: (context) => Home(),
      );
      Navigator.push(context, route).then((value) => Home());
    });
  }

  //--------------------------------------------

  Widget listForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 50, right: 50, top: 20),
            width: MediaQuery.of(context).size.width,
            child: TextField(
              onChanged: (value) => t_list = value.trim(),
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

  Widget uploadButton() => Container(
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
            if (t_list == null || t_list.isEmpty) {
              normalDialog(
                context,
                'กรุณากรอกข้อมูล Note ด้วยครับ',
              );

            } else {
              insertList();
            }
          },
          child: Text(
            'บันทึก',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      );

  //--------------------------------------------
}
