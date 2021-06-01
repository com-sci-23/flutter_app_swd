import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_swd/buttom3/edit_person.dart';
import 'file:///C:/Users/s6052/AndroidStudioProjects/flutter_app_swd/lib/buttom3/singup.dart';
import 'package:flutter_app_swd/model/member_model.dart';
import 'package:flutter_app_swd/use_class/my_address.dart';

class DataPerson extends StatefulWidget {
  @override
  _DataPersonState createState() => _DataPersonState();
}

class _DataPersonState extends State<DataPerson> {
  List<MemberModel> memberModels = List();
  List<Widget> Cards = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readMember();
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
                  'ข้อมูลส่วนบุคคล',
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
                  'ข้อมูลส่วนบุคคล',
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
  Future<Null> readMember() async {
    if (memberModels.length != 0) {
      setState(() {
        Cards.clear();
        memberModels.clear();
      });
    }

    String url = '${MyAddress().domain}/swd/getMember.php';

    await Dio().get(url).then((value) {
      var result = json.decode(value.data);

      int index = 0;

      for (var map in result) {
        print('data $result');
        MemberModel model = MemberModel.fromJson(map);
        setState(() {
          memberModels.add(model);
          Cards.add(createCard(model, index));
          index++;
        });
      }
    });
  }

  Widget createCard(MemberModel memberModel, int index) {
    return GestureDetector(
      onTap: () {
        print('you click index $index');
        MaterialPageRoute route = MaterialPageRoute(
          builder: (context) => EditPerson(
            memberModel: memberModels[index],
          ),
        );
        Navigator.push(context, route);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10.0),
            padding: EdgeInsets.all(10.0),
            width: MediaQuery.of(context).size.width,
            height: 200.0,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10.0), boxShadow: [
              BoxShadow(blurRadius: 5.0, offset: Offset(0, 0.5), color: Colors.black38),
            ]),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Container(
                      margin: EdgeInsets.only(right: 10.0),
                      width: 140.0,
                      height: 170.0,
                      child: Image.network(
                        '${MyAddress().domain}${memberModel.uUrlpictrue}',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 5.0,
                          ),
                          child: Row(
                            children: [
                              Text(
                                'ชื่อ : ',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                memberModel.uFname,
                                style: TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                memberModel.uLname,
                                style: TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Text(
                              'Email : ',
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(memberModel.uEmail),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Text(
                              'เบอร์โทร : ',
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(memberModel.uPhone),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Text(
                              'ที่อยู่ : ',
                              style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(memberModel.uAddress),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  FloatingActionButton create() {
    return FloatingActionButton(
      onPressed: () {
        MaterialPageRoute route = MaterialPageRoute(
          builder: (context) => SignUp(),
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
