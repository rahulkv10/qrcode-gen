import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:qrcode/data/data.dart';
import 'package:qrcode/data/dataModel.dart';
import 'package:qrcode/otpScan.dart';

import 'dataBase/dataBaseHelper.dart';

class GeneratePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => GeneratePageState();
}

class GeneratePageState extends State<GeneratePage> {
  DatabaseHelper _databaseHelper = DatabaseHelper();
  String qrName;
  String qrId;
  int selectedIndex;

  List<StudentData> studentList = [];
  StudentData _dataList;
  // already generated qr code when the page opens
  @override
  void initState() {
    // readDataFromDb();

    initApiCalls();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('QR Code Generator', style: TextStyle(color: Colors.white)),
        actions: <Widget>[],
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            qrName == null
                ? Container(child:Text("Please Select any student name to display their qr code"))
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      QrImage(
                        // padding: EdgeInsets.all(50),
                        data: "$qrId $qrName",
                        version: QrVersions.auto,
                        size: 200,
                        // size: 1.0,
                      ),
                      qrName == null
                          ? Container()
                          : Text(
                              "$qrName",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal),
                            ),
                    ],
                  ),
            SizedBox(
              height: 20.0,
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: studentList.length,
                  itemBuilder: (ctx, i) {
                    return Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: GestureDetector(
                        child: Container(
                          decoration: BoxDecoration(
                            color:
                                selectedIndex == i ? Colors.grey : Colors.white,
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Name:${studentList[i].name}"),
                                Text("Age :${studentList[i].age}"),
                              ],
                            ),
                          ),
                        ),
                        onTap: () {
                          selectedIndex = i;
                          qrName = "${studentList[i].name}";
                          qrId = "${studentList[i].id}";
                          setState(() {});
                        },
                      ),
                    );
                  }),
            ),
            SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ScanPage(),
            ),
          );
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // Thi
    );
  }

  addStudentDataToDb() async {
    for (int i = 0; i < Items.studentsList.length; i++) {
      _dataList = StudentData(Items.studentsList[i]['name'],
          Items.studentsList[i]['id'], Items.studentsList[i]['age']);
      var atimer =
          await _databaseHelper.insertDb(_dataList.toMap(), 'registerTable');
      print('Timer value in db                             $atimer');
    }

    await readDataFromDb();
    setState(() {});
  }

  readDataFromDb() async {
    List names = await _databaseHelper.readDb(
      'SELECT * FROM ${DatabaseHelper.registerTable}',
    );

    print('names List ${names.length}');

    for (int i = 0; i < names.length; i++) {
      studentList.add(StudentData.fromMapObject(names[i]));
      print("kkkkkkkkkkkkkkkkkkkkkkkkkkkkkk ${studentList[i].name}");
    }

    setState(() {});
  }

  final qrdataFeed = TextEditingController();

  initApiCalls() async {
    await readDataFromDb();
    if (studentList.length == 0) {
      addStudentDataToDb();
    } 
    setState(() {});
  }
}
