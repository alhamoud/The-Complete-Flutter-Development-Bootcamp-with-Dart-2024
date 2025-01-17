import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  return runApp(
    MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.red,
        appBar: AppBar(
          title: Text('Dicee'),
          backgroundColor: Colors.red,
        ),
        body: DicePage(),
      ),
    ),
  );
}

class DicePage extends StatefulWidget {
  const DicePage({super.key});
  @override
  State<DicePage> createState() => _DicePageState();
}

class _DicePageState extends State<DicePage> {
  int leftdicenumber = 1;
  int rightdicenumber = 1;

  void changeDiceFace(){
    setState(() {
      leftdicenumber = Random().nextInt(6) + 1;
      rightdicenumber= Random().nextInt(6) + 1;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        children: [
          Expanded(
            //flex:3,
            child: TextButton(
              onPressed: () {
                 changeDiceFace();
              },
              child: Image(
                image: NetworkImage("images/dice$leftdicenumber.png"),
              ),
            ),
          ),
          Expanded(
            //flex:1,
            child: TextButton(
              onPressed: () {
                 changeDiceFace();
              },
              child: Image(
                image: NetworkImage("images/dice$rightdicenumber.png"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
