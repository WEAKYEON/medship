import 'package:flutter/material.dart';
import 'package:medship/service/shared_pref.dart';
import 'package:medship/service/database.dart';
import 'chat.dart';

class ChatSelectionPage extends StatefulWidget {
  const ChatSelectionPage({super.key});

  @override
  State<ChatSelectionPage> createState() => _ChatSelectionPageState();
}

class _ChatSelectionPageState extends State<ChatSelectionPage> {
  String myUserName = "";

  @override
  void initState() {
    super.initState();
    getMyUsername();
  }

  void getMyUsername() async {
    myUserName = (await SharedPreferenceHelper().getUserName()) ?? "";
    setState(() {});
  }

  void startChatWith(String doctorName) async {
    String chatRoomId = getChatRoomId(myUserName, doctorName);

    Map<String, dynamic> chatRoomInfoMap = {
      "users": [myUserName, doctorName],
      "chatRoomId": chatRoomId,
      "lastMessage": "",
      "timestamp": DateTime.now(),
    };

    await DatabaseMethods().createChatRoom(chatRoomId, chatRoomInfoMap);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) =>
                ChatPage(chatRoomId: chatRoomId, recipientName: doctorName),
      ),
    );
  }

  String getChatRoomId(String user1, String user2) {
    if (user1.compareTo(user2) < 0) {
      return "$user1\_$user2";
    } else {
      return "$user2\_$user1";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "แชทกับหมอ",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () => startChatWith("Dr.A"),
              child: Text("แชทกับหมอ A"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => startChatWith("Dr.B"),
              child: Text("แชทกับหมอ B"),
            ),
          ],
        ),
      ),
    );
  }
}
