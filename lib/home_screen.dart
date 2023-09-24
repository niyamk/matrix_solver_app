import 'package:flutter/material.dart';
import 'package:ml_linalg/matrix.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final a11 = TextEditingController();
  final a12 = TextEditingController();
  final a13 = TextEditingController();
  final a21 = TextEditingController();
  final a22 = TextEditingController();
  final a23 = TextEditingController();
  final a31 = TextEditingController();
  final a32 = TextEditingController();
  final a33 = TextEditingController();

  final b11 = TextEditingController();
  final b21 = TextEditingController();
  final b31 = TextEditingController();
  var mat1 = Matrix.identity(3);
  var mat2 = Matrix.identity(1);

  // ignore: prefer_typing_uninitialized_variables
  var mat = Matrix.identity(3);

  var lowerMatrix = Matrix.identity(3);
  var upperMatrix = Matrix.identity(3);

  var menu = 'inverse';
  // ignore: prefer_typing_uninitialized_variables
  var u, v, w, determinant = '';

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var uiOfInput = ['uvw'].contains(menu);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'credits : Jash , Phoenix',
          style: TextStyle(color: Colors.black38),
        ),
        actions: [
          DropdownButton(
            value: menu,
            items: const [
              DropdownMenuItem(
                value: 'inverse',
                child: Text('Inverse'),
              ),
              DropdownMenuItem(
                value: 'uvw',
                child: Text('u v w'),
              ),
              DropdownMenuItem(
                value: 'L',
                child: Text('Lower Triangle'),
              ),
              DropdownMenuItem(
                value: 'U',
                child: Text('Upper Triangle'),
              ),
              DropdownMenuItem(
                value: 'det',
                child: Text('Determinant'),
              ),
            ],
            onChanged: (value) {
              if (value!.isNotEmpty) setState(() => menu = value);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Form(
              key: _formKey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 50.w,
                    height: 50.w,
                    // color: Colors.red,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MaterixTextField(controller: a11),
                            MaterixTextField(controller: a12),
                            MaterixTextField(controller: a13),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MaterixTextField(controller: a21),
                            MaterixTextField(controller: a22),
                            MaterixTextField(controller: a23),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MaterixTextField(controller: a31),
                            MaterixTextField(controller: a32),
                            MaterixTextField(controller: a33),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (uiOfInput)
                    Row(
                      children: [
                        SizedBox(
                          height: 48.w,
                          child: const VerticalDivider(
                            color: Colors.black45,
                          ),
                        ),
                        SizedBox(
                          width: 20.w,
                          height: 50.w,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              MaterixTextField(controller: b11),
                              SizedBox(height: 1.h),
                              MaterixTextField(controller: b21),
                              SizedBox(height: 1.h),
                              MaterixTextField(controller: b31),
                            ],
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      mat1 = Matrix.fromList([
                        [
                          double.parse(a11.text),
                          double.parse(a12.text),
                          double.parse(a13.text),
                        ],
                        [
                          double.parse(a21.text),
                          double.parse(a22.text),
                          double.parse(a23.text),
                        ],
                        [
                          double.parse(a31.text),
                          double.parse(a32.text),
                          double.parse(a33.text),
                        ],
                      ]);
                      if (uiOfInput) {
                        mat2 = Matrix.fromList([
                          [
                            double.parse(b11.text),
                          ],
                          [
                            double.parse(b21.text),
                          ],
                          [
                            double.parse(b31.text),
                          ]
                        ]);
                      }
                      setState(() {
                        var a11 = mat1[0][0];
                        var a12 = mat1[0][1];
                        var a13 = mat1[0][2];
                        var a21 = mat1[1][0];
                        var a22 = mat1[1][1];
                        var a23 = mat1[1][2];
                        var a31 = mat1[2][0];
                        var a32 = mat1[2][1];
                        var a33 = mat1[2][2];

                        var m11 = a22 * a33 - a23 * a32;
                        var m12 = a21 * a33 - a31 * a23;
                        var m13 = a21 * a32 - a22 * a31;
                        var m21 = a12 * a33 - a13 * a32;
                        var m22 = a11 * a33 - a13 * a31;
                        var m23 = a11 * a32 - a12 * a31;
                        var m31 = a12 * a23 - a22 * a13;
                        var m32 = a11 * a23 - a21 * a13;
                        var m33 = a11 * a22 - a21 * a12;

                        var cofactor = Matrix.fromList([
                          [m11, -m12, m13],
                          [-m21, m22, -m23],
                          [m31, -m32, m33],
                        ]);

                        var det = a11 * (a22 * a33 - a23 * a32) -
                            a12 * (a21 * a33 - a31 * a23) +
                            a13 * (a21 * a32 - a22 * a31);

                        determinant = det.toString();

                        mat = cofactor.transpose() / det;

                        if (uiOfInput) {
                          var x = mat * mat2;
                          u = x[0][0].toStringAsFixed(3);
                          v = x[1][0].toStringAsFixed(3);
                          w = x[2][0].toStringAsFixed(3);
                        }

                        lowerMatrix = mat1.decompose().toList()[0];

                        upperMatrix = mat1.decompose().toList()[1];

                        if (menu == 'inverse') {
                          // mat = cofactor.transpose() / det;
                        } else if (menu == 'uvw') {
                          // var x = (cofactor.transpose() / det) * mat2;
                          // u = x[0][0].toStringAsFixed(3);
                          // v = x[1][0].toStringAsFixed(3);
                          // w = x[2][0].toStringAsFixed(3);
                        } else if (menu == 'L') {
                          // print(mat1.decompose().toList()[0].toString());
                        } else if (menu == 'U') {
                          // mat = mat1.decompose().toList()[1];
                        } else if (menu == 'det') {
                          // determinant = det.toString();
                        }
                      });
                    }
                  },
                  child: const Text('Matrix'),
                ),
                SizedBox(width: 1.w),
                ElevatedButton(
                  onPressed: () {
                    a11.clear();
                    a12.clear();
                    a13.clear();
                    a21.clear();
                    a22.clear();
                    a23.clear();
                    a31.clear();
                    a32.clear();
                    a33.clear();

                    b11.clear();
                    b21.clear();
                    b31.clear();

                    u = v = w = '';



                    setState(() {});
                  },
                  child: const Text('Clear'),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            if (menu == 'inverse') Matrix3x3Representation(mat),
            if (menu == 'uvw')
              Column(
                children: [
                  Text('u --> ${u ?? ''}', style: TextStyle(fontSize: 14.sp)),
                  Text('v --> ${v ?? ''}', style: TextStyle(fontSize: 14.sp)),
                  Text('w --> ${w ?? ''}', style: TextStyle(fontSize: 14.sp)),
                ],
              ),
            if (menu == 'L') Matrix3x3Representation(lowerMatrix),
            if (menu == 'U') Matrix3x3Representation(upperMatrix),
            if (menu == 'det') Text('Determinant --> $determinant'),
          ],
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  MaterixTextField({required controller}) {
    return Container(
      height: 14.w,
      width: 14.w,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(.1),
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Center(
        child: TextFormField(
          validator: (value) {
            if (value!.isEmpty) {
              return '';
            }
          },
          decoration: InputDecoration(
            errorStyle: TextStyle(fontSize: 0.01),
          ),
          controller: controller,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.number,
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Matrix3x3Representation(materix) {
    return Container(
      height: 22.h,
      width: 22.h,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        children: List.generate(
          3,
          (index) => Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: List.generate(
                3,
                (index2) => Container(
                  height: 14.w,
                  width: 14.w,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(.2),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Center(
                    child: Text(
                      materix[index][index2].toStringAsPrecision(3),
                      style: TextStyle(
                          fontSize: 10.sp, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
