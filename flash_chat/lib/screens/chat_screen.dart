import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;
late User loggedinUser;

class ChatScreen extends StatefulWidget {
  static String id = "ChatScreen";

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  late String messageText;

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedinUser = user;
        print(loggedinUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  // void messagesStream() async {
  //   await for (var snaphot in _firestore.collection("Messages").snapshots()) {
  //     for (var message in snaphot.docs) {
  //       print(message.data());
  //     }
  //   }
  // }

  //  void getMessages()async{
  //    try {
  // final messages = await _firestore.collection('Messages').get();
  // for(var meesage in messages.docs){
  //  // print(meesage.id);
  //   print(meesage.data());
  // }
  //    } catch (e) {
  //      print("Error getting documents: $e");
  //    }
  //  }

  @override
  void initState() {
    getCurrentUser();
  }

  //  final _auth= FirebaseAuth.instance;
  // late User loggedInUser;
  //  void getcurrentUser(){
  //   try {
  //     final user =  _auth.currentUser;
  //     if (user != null) {
  //       loggedInUser=user;
  //       print(loggedInUser.email);
  //     }
  //   }catch(e){ print(e); }
  //  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {

                _auth.signOut();
                Navigator.pop(context);
                print("signOut");
                //Implement logout functionality
              }),
        ],
        title: Center(
          child: Text('⚡️ Chat'),
        ),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                        //Do something with the user input.
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      messageTextController.clear();
                      _firestore.collection("Messages").add({
                        "sender": loggedinUser.email,
                        "text": messageText,
                        "timestamp": FieldValue.serverTimestamp(),
                      });
                      //Implement send functionality.
                    },
                    child: const Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class MessageStream extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return  StreamBuilder<QuerySnapshot>(// we need yo fix null problem neither in CircularProgressIndicator or else and return erreo messages
      stream: _firestore.collection("Messages").orderBy('timestamp',descending: false).snapshots(),//.orderBy('timestamp',descending: false)
      builder: (context, snapshot) {
        // Handle waiting state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        // Handle error state
        else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } // Handle data state
        else if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.blue,
            ),
          );
        }
        final messages = snapshot.data!.docs.reversed;
        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          final data = message.data() as Map<String, dynamic>;
          final messageText = data['text'] ?? 'No text';
          final messageSender = data['sender'] ?? 'No sender';

          final currenuser=loggedinUser.email;
          if(currenuser== messageSender){
            //this Message from the loggedin USer
          }

          final messageBubble =MessageBubble(messageText,messageSender,currenuser== messageSender);
          messageBubbles.add(messageBubble);
        }
        //another way to handle it with map
        //messages.map((e) => null);
        // List<MessageWidget> messageWidgets = messages.map((doc) {
        //   final data = doc.data() as Map<String, dynamic>;
        //   final messageText = data['text'] ?? 'No text';
        //   final messageSender = data['sender'] ?? 'No sender';
        //
        //   return MessageWidget(
        //     sender: messageSender,
        //     text: messageText,
        //   );
        // }).toList();
        return Expanded(
          child: ListView(//without Expanded widget will take all the space and maney not showen any things.
           reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10.0 ,vertical: 10.0),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble(this.messageText,this.messageSender,this.isMe);
  final bool isMe;
   final String messageText;
  final String messageSender;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe?CrossAxisAlignment.end:CrossAxisAlignment.start,
        children: [
          Text(messageSender,
          style: TextStyle(
            fontSize: 12.0,
            color: Colors.black54,
            fontWeight:FontWeight.bold,
          ),),
          Material(
          elevation: 5.0,
            color: isMe?Colors.lightBlueAccent : Colors.white,
            borderRadius: isMe? BorderRadius.only(topLeft:Radius.circular(30.0),bottomLeft:Radius.circular(30.0),bottomRight:Radius.circular(30.0)) :
            BorderRadius.only(topRight:Radius.circular(30.0),bottomLeft:Radius.circular(30.0),bottomRight:Radius.circular(30.0)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
              child: Text(
                messageText,
                style: TextStyle(
                  color: isMe? Colors.white: Colors.black,
                  fontSize: 15,
                ),),
            ),
          ),
        ],
      ),
    );
  }
}
