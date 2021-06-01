import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_swd/screen/home.dart';
import 'package:flutter_app_swd/use_class/my_address.dart';
import 'package:flutter_app_swd/use_class/my_style.dart';
import 'package:flutter_app_swd/use_class/normal_dialog.dart';
import 'package:image_picker/image_picker.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String u_fname, u_lname, u_address, u_email, u_phone, u_urlpictrue;

  File file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.red,
        title: Text(
          'สมัคสมาชิก',
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
              groupImage(),
              fNameForm(),
              lNameForm(),
              emailForm(),
              phoneForm(),
              addressForm(),
              registerButton(),
            ],
          ),
        ),
      ),
    );
  }

  //--------------------------------------------

  //อัพโหลดข้อมูลขึ้น server
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
        String u_urlpictrue = '/swd/User/$nameFile';

        String urlInsertData = '${MyAddress().domain}/swd/register.php?u_fname=$u_fname&u_lname=$u_lname&u_urlpictrue=$u_urlpictrue&u_address=$u_address&u_email=$u_email&u_phone=$u_phone';
        await Dio().get(urlInsertData).then((value) {
          MaterialPageRoute route = MaterialPageRoute(
            builder: (context) => Home(),
          );
          Navigator.pushReplacement(context, route).then((value) => Home());
        });
      });
    } catch (e) {}
  }


  //--------------------------------------------

  //เพิ่มรูปภาพ
  Column groupImage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 200.0,
          //ตรวจเช็คมีรูปหรือไม่
          child: file == null ? Image.asset('assets/images/person_up.png') : Image.file(file),
        ),
        SizedBox(
          height: 10.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.add_a_photo,
                size: 36.0,
              ),
              onPressed: () => chooseImage(ImageSource.camera),
            ),
            IconButton(
              icon: Icon(
                Icons.add_photo_alternate_outlined,
                size: 36.0,
              ),
              onPressed: () => chooseImage(ImageSource.gallery),
            ),
            SizedBox(
              width: 50.0,
            ),
          ],
        ),
      ],
    );
  }


  //เงื่อนไขรูปภาพ
  Future<Null> chooseImage(ImageSource imageSource) async {
    try {
      var object = await ImagePicker.pickImage(
        //กำหนดความละเอียดของรูปไม่เกิน 800 pic
        source: imageSource,
        maxHeight: 400.0,
        maxWidth: 400.0,
      );
      setState(() {
        file = object;
      });
    } catch (e) {}
  }

  //--------------------------------------------

  Widget fNameForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 50, right: 50, top: 20),
            width: MediaQuery.of(context).size.width,
            child: TextField(
              onChanged: (value) => u_fname = value.trim(),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.face,
                  color: MyStyle().primaryColor,
                ),
                labelStyle: TextStyle(color: MyStyle().primaryColor),
                labelText: 'First Name :',
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: MyStyle().primaryColor)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: MyStyle().primaryColor)),
              ),
            ),
          ),
        ],
      );

  Widget lNameForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 50, right: 50, top: 20),
            width: MediaQuery.of(context).size.width,
            child: TextField(
              onChanged: (value) => u_lname = value.trim(),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.face,
                  color: MyStyle().primaryColor,
                ),
                labelStyle: TextStyle(color: MyStyle().primaryColor),
                labelText: 'Last Name :',
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: MyStyle().primaryColor)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: MyStyle().primaryColor)),
              ),
            ),
          ),
        ],
      );

  Widget addressForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 50, right: 50, top: 20),
            width: MediaQuery.of(context).size.width,
            child: TextField(
              maxLines: 5,
              onChanged: (value) => u_address = value.trim(),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.home,
                  color: MyStyle().primaryColor,
                ),
                labelStyle: TextStyle(color: MyStyle().primaryColor),
                labelText: 'Address :',
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: MyStyle().primaryColor)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: MyStyle().primaryColor)),
              ),
            ),
          ),
        ],
      );

  Widget phoneForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 50, right: 50, top: 20),
            width: MediaQuery.of(context).size.width,
            child: TextField(
              onChanged: (value) => u_phone = value.trim(),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.phone,
                  color: MyStyle().primaryColor,
                ),
                labelStyle: TextStyle(color: MyStyle().primaryColor),
                labelText: 'Phone :',
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: MyStyle().primaryColor)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: MyStyle().primaryColor)),
              ),
            ),
          ),
        ],
      );

  Widget emailForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 50, right: 50, top: 20),
            width: MediaQuery.of(context).size.width,
            child: TextField(
              onChanged: (value) => u_email = value.trim(),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.email,
                  color: MyStyle().primaryColor,
                ),
                labelStyle: TextStyle(color: MyStyle().primaryColor),
                labelText: 'Email :',
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: MyStyle().primaryColor)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: MyStyle().primaryColor)),
              ),
            ),
          ),
        ],
      );

  Widget registerButton() => Container(
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
            if (u_fname == null || u_fname.isEmpty) {
              normalDialog(
                context,
                'กรุณากรอกข้อมูล First Name ด้วยครับ',
              );
            } else if (u_lname == null || u_lname.isEmpty) {
              normalDialog(
                context,
                'กรุณากรอกข้อมูล Last Name ด้วยครับ',
              );

            } else if (u_email == null || u_email.isEmpty) {
              normalDialog(
                context,
                'กรุณากรอกข้อมูล Email ด้วยครับ',
              );
            } else if (u_phone == null || u_phone.isEmpty) {
              normalDialog(
                context,
                'กรุณากรอกข้อมูล Phone ด้วยครับ',
              );
            } else if (u_address == null || u_address.isEmpty) {
              normalDialog(
                context,
                'กรุณากรอกข้อมูล Address ด้วยครับ',
              );
            } else if (file == null) {
              normalDialog(
                context,
                'กรุณากรอกข้อมูล รูป ด้วยครับ',
              );
            } else {
              uploadAndInsertData();
            }
          },
          child: Text(
            'register',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      );

//--------------------------------------------
}
