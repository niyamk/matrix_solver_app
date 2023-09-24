import 'package:flutter/material.dart';
import 'package:matrix_solver/home_screen.dart';
import 'package:matrix_solver/testing.dart';
import 'package:sizer/sizer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (BuildContext context, Orientation orientation, DeviceType deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor:Colors.lightBlueAccent.shade100,
            appBarTheme: AppBarTheme(color: Colors.lightBlueAccent.shade100),
            inputDecorationTheme: const InputDecorationTheme(
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
            ),
          ),
          // home: HomeScreen(),
          home: Testing(),
        );
      },
    );
  }
}
