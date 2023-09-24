import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:sizer/sizer.dart';

class CalcyScreen extends StatefulWidget {
  const CalcyScreen({super.key});

  @override
  State<CalcyScreen> createState() => _CalcyScreenState();
}

String text = '';

class _CalcyScreenState extends State<CalcyScreen> {
  Parser p = Parser();
  Expression exp = Parser().parse(text.isEmpty ? '0' : text);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
      ),
      body: Container(
        width: 100.w,
        height: 100.h,
        alignment: Alignment.bottomCenter,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Align(
                  alignment: const Alignment(1, 0),
                  child: Text(
                    text,
                    style:
                        TextStyle(fontSize: 23.sp, fontWeight: FontWeight.w400),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: SizedBox(
                  height: 10.h,
                  width: 100.w,
                  child: Align(
                      alignment: const Alignment(1, 0),
                      child: Text(exp
                          .evaluate(EvaluationType.REAL, ContextModel())
                          .toString())),
                ),
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      digitButton('AC', spacing: 100.w / 2.1),
                      // digitButton('()'),
                      digitButton('%'),
                      digitButton('/'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      digitButton('7'),
                      digitButton('8'),
                      digitButton('9'),
                      digitButton('X'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      digitButton('4'),
                      digitButton('5'),
                      digitButton('6'),
                      digitButton('-'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      digitButton('1'),
                      digitButton('2'),
                      digitButton('3'),
                      digitButton('+'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      digitButton('0'),
                      digitButton('.'),
                      digitButton(Icons.backspace_outlined),
                      digitButton('='),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  digitButton(digit, {spacing = 1}) {
    return InkWell(
      onTap: () {
        setState(() {
          if (digit == Icons.backspace_outlined && text.isNotEmpty) {
            text = text.substring(0, text.length - 1);
          }
          if (['/', 'X', '%', '-', '+', '.'].contains(digit)) {
            if (digit == 'X') {
              text += '*';
            } else {
              text += digit;
            }
          }
          if (digit == 'AC') {
            text = '';
          }
          if (int.parse(digit.toString().runes.toList()[0].toString()) <= 57 &&
              int.parse(digit.toString().runes.toList()[0].toString()) >= 48) {
            text += digit;
          }
          try {
            exp = Parser().parse(text.isEmpty ? '0' : text);
          } catch (e) {}
        });
        // } else if(int.parse(digit.toString().runes.toString())){ }
      },
      child: Padding(
        padding: EdgeInsets.all(1.w),
        child: Container(
          width: spacing == 1 ? 100.w / 4.4 : spacing,
          height: 12.h,
          color: Colors.grey.shade200,
          child: digit.runtimeType == String
              ? Center(
                  child: Text(
                  digit,
                  style: TextStyle(fontSize: 15.sp),
                ))
              : Icon(digit),
        ),
      ),
    );
  }
  /* iconButton(icon){
    return InkWell(
      onTap: () {
        },
      child: Padding(
        padding: EdgeInsets.all(1.w),
        child: Container(
          child: Icon,
        ),
      ),
    );
  }*/
}
