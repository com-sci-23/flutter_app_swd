import 'dart:io';
import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_swd/model/member_model.dart';
import 'package:flutter_app_swd/model/todo_model.dart';
import 'package:flutter_app_swd/screen/home.dart';
import 'package:flutter_app_swd/use_class/my_address.dart';
import 'package:flutter_app_swd/use_class/my_style.dart';
import 'package:flutter_app_swd/use_class/normal_dialog.dart';
import 'package:image_picker/image_picker.dart';

class EditPerson extends StatefulWidget {
  final MemberModel memberModel;

  EditPerson({Key key, this.memberModel}) : super(key: key);

  @override
  _EditPersonState createState() => _EditPersonState();
}

class _EditPersonState extends State<EditPerson> {
  List<TodoModel> todoModels = List();
  MemberModel memberModel;
  String u_phone, u_fname, u_lname, u_email, u_urlpictrue, u_address;

  String u_id;

  File file;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    memberModel = widget.memberModel;
    u_id = memberModel.uId;
    u_phone = memberModel.uPhone;
    u_fname = memberModel.uFname;
    u_lname = memberModel.uLname;
    u_email = memberModel.uEmail;
    u_address = memberModel.uAddress;
    u_urlpictrue = memberModel.uUrlpictrue;
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
              height: 20,
            ),
            showImage(),
            fNameForm(),
            lNameForm(),
            emailForm(),
            phoneForm(),
            addressForm(),
            deleteButton(),
          ],
        ),
      ),
    );
  }

  //--------------------------------------------


  Future<Null> uploadAndInsertData() async {
    String urlUpload = '${MyAddress().domain}/swd/savePictrue.php';

    Random random = Random();
    int i = random.nextInt(1000000);
    String nameFile = 'user$i.jpg';

    try {
      Map<String, dynamic> map = Map();
      map['file'] = await MultipartFile.fromFile(file.path, filename: nameFile);
      FormData formData = FormData.fromMap(map);

      await Dio().post(urlUpload, data: formData).then((value) async {
        String uUrlpictrue = '/swd/User/$nameFile';

        String u_id = memberModel.uId;

        String urlInsertData = '${MyAddress().domain}/swd/editUser.php?u_id=$u_id&u_fname=$u_fname&u_lname=$u_lname&u_urlpictrue=$uUrlpictrue&u_address=$u_address&u_email=$u_email&u_phone=$u_phone';
        await Dio().get(urlInsertData).then((value) {
          MaterialPageRoute route = MaterialPageRoute(
            builder: (context) => Home(),
          );
          Navigator.push(context, route).then((value) => Home());
        });
      });
    } catch (e) {}
  }

  Future<Null> conFirmEdit() async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(
          'คุณต้องการเปลี่ยนแปลงข้อมูล',
        ),
        children: <Widget>[
          Row(
            children: <Widget>[
              FlatButton.icon(
                onPressed: () {
                  //Navigator.pop(context);
                  uploadAndInsertData();
                },
                icon: Icon(
                  Icons.check,
                  color: Colors.green,
                ),
                label: Text(
                  'เปลี่ยนแปลง',
                ),
              ),
              FlatButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.clear,
                  color: Colors.red,
                ),
                label: Text(
                  'ยกเลิก',
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<Null> deleteList(MemberModel memberModel) async {
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
                  String url = '${MyAddress().domain}/swd/deleteMember.php?u_id=$u_id';
                  await Dio().get(url).then((value) {
                    MaterialPageRoute route = MaterialPageRoute(
                      builder: (context) => Home(),
                    );
                    Navigator.push(context, route).then((value) => Home());
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

  Future<Null> choseImage(ImageSource source) async {
    try {
      var object = await ImagePicker().getImage(source: source, maxWidth: 800.0, maxHeight: 800.0);

      setState(() {
        file = File(object.path);
      });
    } catch (e) {}
  }

  Widget deleteButton() => Container(
        width: 250.0,

        child: RaisedButton(
          color: MyStyle().primaryColor,
          onPressed: () {
            deleteList(memberModel);
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
        if (memberModel.uId != null) {
          conFirmEdit();
        } else {}
      },
      child: Icon(Icons.save),
      backgroundColor: Colors.red,
    );
  }

  Widget showImage() => Container(
      margin: EdgeInsets.only(top: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.add_a_photo),
            onPressed: () => choseImage(ImageSource.camera),
          ),
          Container(
            width: 250.0,
            height: 250.0,
            child: file == null ? Image.network('${MyAddress().domain}${memberModel.uUrlpictrue}') : Image.file(file),
          ),
          IconButton(
            icon: Icon(Icons.add_photo_alternate_outlined),
            onPressed: () => choseImage(ImageSource.gallery),
          ),
        ],
      ));

  Widget fNameForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 250.0,
            child: TextFormField(
              onChanged: (value) => u_fname = value,
              initialValue: u_fname, //เอาค่ามาใช้งาน
              decoration: InputDecoration(
                labelText: 'First Name :',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );

  Widget lNameForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 250.0,
            child: TextFormField(
              onChanged: (value) => u_lname = value,
              initialValue: u_lname, //เอาค่ามาใช้งาน
              decoration: InputDecoration(
                labelText: 'Last Name :',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );

  Widget emailForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 250.0,
            child: TextFormField(
              onChanged: (value) => u_email = value,
              initialValue: u_email, //เอาค่ามาใช้งาน
              decoration: InputDecoration(
                labelText: 'Email :',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );

  Widget phoneForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 250.0,
            child: TextFormField(
              onChanged: (value) => u_phone = value,
              initialValue: u_phone, //เอาค่ามาใช้งาน
              decoration: InputDecoration(
                labelText: 'Phone :',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );

  Widget addressForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 16.0),
            width: 250.0,
            child: TextFormField(
              onChanged: (value) => u_address = value,
              initialValue: u_address, //เอาค่ามาใช้งาน
              decoration: InputDecoration(
                labelText: 'Address :',
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );


}
