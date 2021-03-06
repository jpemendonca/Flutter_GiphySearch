import 'package:flutter/material.dart';
import 'ui/home_page.dart ';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      theme: ThemeData(
          appBarTheme: AppBarTheme(backgroundColor: Colors.black),
          hintColor: Colors.white,
          scaffoldBackgroundColor: Colors.black,
          primaryColor: Colors.white,
          inputDecorationTheme: const InputDecorationTheme(
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              hintStyle: TextStyle(color: Colors.white),
              labelStyle: TextStyle(color: Colors.white))),
    ),
  );
}
