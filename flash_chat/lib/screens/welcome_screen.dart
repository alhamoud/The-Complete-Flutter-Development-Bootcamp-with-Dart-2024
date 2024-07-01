import 'package:flutter/material.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/components/rounded_button.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = "WelcomeScreen ";

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(seconds:3), vsync: this,
      //upperBound:100 ,
    );
    animation = ColorTween(begin: Colors.blueGrey, end:Colors.white).animate(controller);
 /*  animation = CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut); //after use curves upperbound can not be bigger than one cause curves always between 0 & 1
    controller.forward();*/
   /* animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse(from: 1.0);
      } else if (status == AnimationStatus.dismissed) {
      }
    });*/

    controller.forward();


    controller.addListener(() {
      setState(() {});
   //   print(animation.value);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: SizedBox(
                    height: 60.0,
                    child: Image.asset('images/logo.png')//animation.value*100,
                  ),
                ),
                DefaultTextStyle(
                  style:  TextStyle(
                    fontSize: 50.0,
                    fontWeight: FontWeight.w900,
                    //fontFamily: 'Agne',//'Canterbury'
                  ),
                  child: AnimatedTextKit(
                    animatedTexts: [
                  //   ScaleAnimatedText('Flash Chat'),
                    TypewriterAnimatedText('Flash Chat'),
                     // WavyAnimatedText('Flash Chat'),
                    ],
                   // isRepeatingAnimation: true, // Ensure it repeats to avoid out of range error {it might give this error RangeError (index): Index out of range: index should be less than 1: 9}
                    repeatForever: true,
                    onTap: () {
                      print("  WavyAnimatedText('Flash Chat') Tap Event");
                    },
                  ),
                ),
              /*
              *   Text(
              *   'Flash Chat',
                  style: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                * */
              ],
            ),
             SizedBox(
              height: 48.0,
            ),
            RoundedButton(color: Colors.blueAccent,title :'Log In',onPressed: () {
              Navigator.pushNamed(context, LoginScreen.id);
              //Go to registration screen.
            },),
            RoundedButton(color: Colors.lightBlueAccent,title :'Register',onPressed: () {
              Navigator.pushNamed(context, RegistrationScreen.id);
              //Go to registration screen.
            },),

          ],
        ),
      ),
    );
  }
}

