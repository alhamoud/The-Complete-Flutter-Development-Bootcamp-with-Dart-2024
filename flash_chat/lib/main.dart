import 'package:flutter/material.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyB8PRuaD8cLbrSXDWrcwe7qRaZeQ-eBUfI",
      projectId: "flash-chat-3c1e8",
      messagingSenderId: "61390688795",
      appId: "1:61390688795:android:fb02460c7514dc843f5ebe",
    ),
  );
  runApp(FlashChat());
}


class FlashChat extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // theme: ThemeData.dark().copyWith(
      //   textTheme: TextTheme(
      //     bodyLarge: TextStyle(color: Colors.black54),
      //   ),
      // ),
      //to enable some  decoration attributes we need to delete themeData and that causes to go back to black color for text for the button so we edit manually from
      //When using initialRoute, don't define a home property.
      //  home: WelcomeScreen(),
            //
            initialRoute: WelcomeScreen.id,
            routes:{
            WelcomeScreen.id : (context) => WelcomeScreen(),
            ChatScreen.id: (context) => ChatScreen(),
            RegistrationScreen.id: (context) =>  RegistrationScreen(),
            LoginScreen.id : (context) => LoginScreen(),

            },


    );
  }
}
