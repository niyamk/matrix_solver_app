import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matrix_solver/calcy_screen.dart';
import 'package:ml_linalg/linalg.dart';
import 'package:scidart/numdart.dart';
import 'package:sizer/sizer.dart';
import 'package:scidart/numdart.dart' as matr;

class Testing extends StatefulWidget {
  const Testing({super.key});

  @override
  State<Testing> createState() => _TestingState();
}

class _TestingState extends State<Testing> {
  int initialRowCount = 3;
  int initialColumnCount = 3;
  String matrixMenu = '3x3';
  String resultSelectionMenu = 'inverse';
  List<DropdownMenuItem<String>> matrixMenuItemList = const [
    DropdownMenuItem(value: '2x2', child: Text('2x2')),
    // DropdownMenuItem(value: '2x3', child: Text('2x3')),
    // DropdownMenuItem(value: '2x4', child: Text('2x4')),
    // DropdownMenuItem(value: '3x2', child: Text('3x2')),
    DropdownMenuItem(value: '3x3', child: Text('3x3')),
    // DropdownMenuItem(value: '3x4', child: Text('3x4')),
    // DropdownMenuItem(value: '4x2', child: Text('4x2')),
    // DropdownMenuItem(value: '4x3', child: Text('4x3')),
    DropdownMenuItem(value: '4x4', child: Text('4x4')),
  ];
  List<DropdownMenuItem<String>> resultSelectionMenuList = const [
    DropdownMenuItem(value: 'inverse', child: Text('Inverse')),
    DropdownMenuItem(value: 'lt', child: Text('Lower Triangle')),
    DropdownMenuItem(value: 'ut', child: Text('Upper Triangle')),
    DropdownMenuItem(value: 'det', child: Text('Determinant')),
    DropdownMenuItem(value: 'xyz', child: Text('x y z / u v w')),
  ];

  Map<String, TextEditingController> netControllers = {};
  Map<String, TextEditingController> netControllers2 = {};
  var textFields = <TextField>[];
  var textFields2 = <TextField>[];
  List testingList = [];
  List testingList2 = [];
  var outputData;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void setIndexMap(row, column) {
    testingList.clear();
    testingList2.clear();

    // textFields.clear();
    // textFields2.clear();

    for (int i = 0; i < row; i++) {
      for (int j = 0; j < column; j++) {
        testingList.add('${i + 1}${j + 1}');
      }
      testingList2.add('${i + 1}1');
    }
    for (var element in testingList) {
      var controller = TextEditingController(text: '');
      netControllers.putIfAbsent(element.toString(), () => controller);
      continue;
    }
    for (var element in testingList2) {
      var controller = TextEditingController(text: '');
      netControllers2.putIfAbsent(element.toString(), () => controller);
      continue;
    }
  }

  @override
  void initState() {
    setIndexMap(initialRowCount, initialColumnCount);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              _scaffoldKey.currentState!.openDrawer();
              setState(() {});
            },
          onDoubleTap: () {
            Navigator.push(context, CupertinoPageRoute(builder: (context) => CalcyScreen()));
          },
          child: Container(
            child: Icon(Icons.menu, color: Colors.black),
          ),
        ),
        backgroundColor: Colors.white,
        actions: [
          DropdownButton(
            value: matrixMenu,
            items: matrixMenuItemList,
            onChanged: (value) {
              setState(() {
                initialRowCount = int.parse(value!.split('x')[0]);
                initialColumnCount = int.parse(value.split('x')[1]);
                matrixMenu = value;
                setIndexMap(initialRowCount, initialColumnCount);
                outputData = null;
              });
            },
          ),
          SizedBox(width: 3.w),
          /* DropdownButton(
            value: resultSelectionMenu,
            items: resultSelectionMenuList,
            onChanged: (value) {
              setState(() {
                resultSelectionMenu = value!;

              });
            },
          ),*/
        ],
      ),
      drawer: myDrawer(),
      body: SafeArea(
        minimum: const EdgeInsets.only(top: 10),
        child: Column(
          children: [
            SizedBox(height: 1.h),
            Center(
              child: dynamicInputMatrix(
                  rowCount: initialRowCount, columnCount: initialColumnCount),
              /*  child: dynamicMatrixSquare(
                  rowCount: initialRowCount,
                  columnCount: initialColumnCount,
                  isTextField: true,
                  datatype: 'Float32Matrix'),*/
            ),
            SizedBox(height: 1.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                OutlinedButton(
                  onPressed: () {
                    if (initialRowCount == initialColumnCount) {
                      outputData = Matrix.fromList(rawDataToArray()[1])
                          .decompose()
                          .toList()[0];
                      setState(() {});
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Matrix should be Square to get Lower Triangle!'),
                        ),
                      );
                    }
                  },
                  child: const Text("Lower Triangle"),
                ),
                OutlinedButton(
                  onPressed: () {
                    outputData = rawDataToArray();
                    if (initialRowCount == initialColumnCount) {
                      outputData = Matrix.fromList(rawDataToArray()[1])
                          .decompose()
                          .toList()[1];
                      setState(() {});
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                            'Matrix should be Square to get Upper Triangle!'),
                        duration: Duration(milliseconds: 1500),
                      ));
                    }
                  },
                  child: const Text("Upper Triangle"),
                ),
                OutlinedButton(
                  onPressed: () {
                    outputData = rawDataToArray();
                    if (initialRowCount == initialColumnCount) {
                      outputData = matrixInverse(Array2d(rawDataToArray()[0]));
                      setState(() {});
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content:
                              Text('Matrix should be Square to get Inverse!')));
                    }
                  },
                  child: const Text('Inverse'),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Spacer(flex: 4),
                OutlinedButton(
                    onPressed: () {
                      if (initialRowCount == initialColumnCount) {
                        outputData = LU(Array2d(rawDataToArray()[0]))
                            .det()
                            .toStringAsFixed(2);
                        setState(() {});
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Not Square Matrix!!!')));
                      }
                    },
                    child: const Text('Determinant')),
                const Spacer(flex: 1),
                OutlinedButton(
                  onPressed: () {
                    try {
                      // var x =  matrixInverse(Array2d(rawDataToArray()[0])) * Array2d(rawDataToArray2()[0]);
                      outputData = (Matrix.fromList(
                                  matrixInverse(Array2d(rawDataToArray()[0]))
                                      .toList()) *
                              Matrix.fromList(rawDataToArray2()[1]))
                          .toList();
                      String x = '';
                      for (var i = 0; i < outputData.length; i++) {
                        x += "\n" +
                            'x${i + 1} = ' +
                            outputData[i][0].toString() +
                            '\n';
                      }
                      outputData = x;
                      print(x);
                      setState(() {});
                    } catch (e) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(e.toString())));
                    }
                  },
                  child: const Text('x y z / u v w'),
                ),
                const Spacer(flex: 4),
              ],
            ),
            SizedBox(height: 1.h),
            if (outputData != null)
              Center(
                child: dynamicOutputMatrix(
                  rowCount: initialRowCount,
                  columnCount: initialColumnCount,
                  data: outputData,
                ),
              ),
            SizedBox(height: 1.h),
          ],
        ),
      ),
    );
  }

  Widget dynamicOutputMatrix(
      {required rowCount, required columnCount, required data}) {
    return ['Float32Matrix', 'Array2d'].contains(data.runtimeType.toString())
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                /*width: 70.w,
                    height: 70.w,*/
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(.08),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: List.generate(
                    rowCount,
                    (indexRow) => Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(
                        columnCount,
                        (indexColumn) => Container(
                          margin: EdgeInsets.all(
                              ((columnCount + rowCount) / 2) * 3),
                          width: 80.w / (columnCount + 2),
                          height: 95.w / (columnCount + 5),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(double.parse(
                                    '${outputData[indexRow][indexColumn]}')
                                .toStringAsFixed(2)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        : Container(
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text('$data'),
            ),
          );
  }

  Widget dynamicInputMatrix({required rowCount, required columnCount}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          /*width: 70.w,
                    height: 70.w,*/
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(.08),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: List.generate(
              rowCount,
              (indexRow) => Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(
                  columnCount,
                  (indexColumn) => Container(
                      margin:
                          EdgeInsets.all(((columnCount + rowCount) / 2) * 3),
                      width: 80.w / (columnCount + 2),
                      height: 95.w / (columnCount + 5),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextField(
                        controller:
                            netControllers['${indexRow + 1}${indexColumn + 1}'],
                        onTap: () {
                          if (netControllers[
                                  '${indexRow + 1}${indexColumn + 1}']!
                              .text
                              .isNotEmpty) {
                            netControllers['${indexRow + 1}${indexColumn + 1}']!
                                    .selection =
                                TextSelection(
                                    baseOffset: 0,
                                    extentOffset: netControllers[
                                            '${indexRow + 1}${indexColumn + 1}']!
                                        .value
                                        .text
                                        .length);
                          }
                        },
                        decoration: const InputDecoration(
                          hintText: '0',
                        ),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                      )),
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
              margin: EdgeInsets.only(top: 1.h),
              height: ((95.w / (columnCount + 5)) +
                      (((columnCount + rowCount) / 2) * 2) * 2) *
                  columnCount,
              child: VerticalDivider(color: Colors.black38)),
        ),
        Column(
          children: [
            ...List.generate(
              rowCount,
              (index) => Container(
                margin: EdgeInsets.all(((columnCount + rowCount) / 2) * 3),
                width: 80.w / (columnCount + 2),
                height: 95.w / (columnCount + 5),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  decoration: const InputDecoration(hintText: '0'),
                  controller: netControllers2['${index + 1}1'],
                  onTap: () {
                    netControllers2['${index + 1}1']!.selection = TextSelection(
                        baseOffset: 0,
                        extentOffset: netControllers2['${index + 1}1']!
                            .value
                            .text
                            .length);
                  },
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                ),
              ),
            ),
            const Text(
              'x y z / u v w',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }

  List rawDataToArray() {
    try {
      List<List<double>> rowList = [];
      List<Array> d1List = [];
      List<double> columnList = [];

      for (int row = 0; row < initialRowCount; row++) {
        for (int column = 0; column < initialColumnCount; column++) {
          columnList.add(double.parse(
              netControllers['${row + 1}${column + 1}']!.text != ''
                  ? netControllers['${row + 1}${column + 1}']!.text
                  : '0'));
          // columnList.add('${row + 1}${column + 1}');
        }
        d1List.add(Array(columnList));
        rowList.add([...columnList]);
        columnList.clear();
      }

      return [d1List, rowList];
    } catch (e) {
      // print(e);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Check the Entered Data Again!')));
    }
    return [];
  }

  List rawDataToArray2() {
    try {
      List<List<double>> rowList = [];
      List<Array> d1List = [];
      List<double> columnList = [];
      for (int row = 0; row < initialRowCount; row++) {
        columnList.add(double.parse(netControllers2['${row + 1}1']!.text != ''
            ? netControllers2['${row + 1}1']!.text
            : '0'));
        d1List.add(Array(columnList));
        rowList.add([...columnList]);
        columnList.clear();
      }

      return [d1List, rowList];
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Check the Entered Data Again!')));
    }
    return [];
  }

  myDrawer() {
    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // SizedBox(height: 1.h),
              ListTile(
                tileColor: Colors.lightBlueAccent.shade100,
                title: Text('Matrix Solver',style: TextStyle(color: Colors.white),),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30))),
              ),
              ListTile(
                onTap: (){
                  Navigator.push(context, CupertinoPageRoute(builder: (context) => CalcyScreen(),));
                  _scaffoldKey.currentState!.closeDrawer();
                },
                trailing: Icon(Icons.calculate_outlined),
                title: Text('Calcy',style:  TextStyle(color: Colors.black),),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* Container(
              color: Colors.grey.withOpacity(.2),
              width: 70.w,
              height: 60.w,
              child: GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                children: List.generate(
                  9,
                  (index) => Container(
                    color: Colors.red,
                    margin: EdgeInsets.all(5),
                  ),
                ),
              ),
            ),*/
