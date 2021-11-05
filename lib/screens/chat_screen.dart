import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';

final _firestore = FirebaseFirestore.instance;
User loggedInUser;

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  String msgText;
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final User user = _auth.currentUser;
      final uid = user.uid;
      if (user != null) {
        setState(() {
          loggedInUser = user;
        });
        print(loggedInUser.email);
        print(uid);
      }
    } catch (e) {
      print(e);
    }
  }

  // void getMessages() async {
  //   final messages = await _firestore.collection('messages').get();
  //   for (var message in messages.docs) {
  //     print(message.data);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff303030),
      appBar: AppBar(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
        automaticallyImplyLeading: false,
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.power_settings_new,
                color: Colors.black,
              ),
              onPressed: () {
                //Implement logout functionality
                _auth.signOut();
                Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
                Fluttertoast.showToast(
                  msg: "Thank You for using Flash Chat 😃",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.tealAccent.shade400,
                  textColor: Colors.black,
                  fontSize: 16.0,
                );
              }),
        ],
        title: Text(
          '⚡️Chat',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Color(0xff00EDB3),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        textCapitalization: TextCapitalization.sentences,
                        controller: messageTextController,
                        onChanged: (value) {
                          //Do something with the user input.
                          msgText = value;
                        },
                        decoration: kMessageTextFieldDecoration,
                      ),
                    ),
                    Material(
                      color: Colors.tealAccent.shade400,
                      borderRadius: BorderRadius.circular(50.0),
                      child: IconButton(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onPressed: () {
                          messageTextController.clear();
                          var now = DateTime.now();
                          String date =
                              '${now.day.toString()}/${now.month.toString}';
                          String time =
                              '${DateFormat.jm().format(now).toString()}';
                          //Implement send functionality.
                          _firestore.collection('messages').add({
                            'text': msgText,
                            'sender': loggedInUser.email,
                            'date': date,
                            'time': time,
                            'Timestamp': FieldValue.serverTimestamp(),
                          });
                        },
                        // child: Text(
                        //   'Send',
                        //   style: kSendButtonTextStyle,
                        icon: Icon(
                          Icons.send,
                          // color: Color(0xff00EDB3),
                        ),
                      ),
                    ),
                  ],
                ),
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
    return StreamBuilder<QuerySnapshot>(
        stream:
            _firestore.collection('messages').orderBy('Timestamp').snapshots(),
        builder: (context, snapshot) {
          // if (!snapshot.hasData) {
          //   return Center(
          //     child: CircularProgressIndicator(
          //       backgroundColor:Color(0xff00EDB3),
          //     ),
          //   );
          // }
          if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
            return Align(
              alignment: Alignment.bottomCenter,
              child: Text('No messages here!!'),
            );
          }
          final messages = snapshot.data.docs.reversed;
          List<MessageBubble> messageBubbles = [];
          for (var message in messages) {
            // final messageData = message.data();
            final data = Map<String, dynamic>.from(message.data());
            final messageText = data['text'];
            final messageSender = data['sender'];
            final date = data['date'];
            final time = data['time'];
            final currentUser = loggedInUser.email;
            // if (currentUser == loggedInUser.email) {}
            final messageBubble = MessageBubble(
              sender: messageSender,
              text: messageText,
              isMe: currentUser == messageSender,
              date: date,
              time: time,
            );
            messageBubbles.add(messageBubble);
          }
          return Expanded(
            child: ListView(
              reverse: true,
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              children: messageBubbles,
            ),
          );
        });
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({this.sender, this.text, this.isMe, this.date, this.time});
  final String sender;
  final String text;
  final bool isMe;
  final String date;
  final String time;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: TextStyle(fontSize: 12.0, color: Colors.white30),
          ),
          // Text(
          //   date,
          //   style: TextStyle(fontSize: 12, color: Colors.white30),
          // ),
          Material(
            elevation: 8.0,
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30))
                : BorderRadius.only(
                    bottomRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
            color: isMe
                ? Colors.lightBlueAccent.shade700
                : Colors.tealAccent.shade700,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 13.0, horizontal: 20),
              child: Text(
                '$text',
                style: TextStyle(
                    color: isMe ? Colors.white : Colors.black, fontSize: 18.0),
              ),
            ),
          ),
          Text(
            '$time',
            style: TextStyle(fontSize: 12, color: Colors.white30),
          ),
        ],
      ),
    );
  }
}
