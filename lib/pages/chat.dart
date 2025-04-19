import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medship/service/database.dart';
import 'package:medship/service/shared_pref.dart';
import 'package:medship/widget/widget_support.dart';

class ChatPage extends StatefulWidget {
  final String chatRoomId;
  final String recipientName; // ชื่อปลายทาง เช่น โรงพยาบาล

  const ChatPage({
    super.key,
    required this.chatRoomId,
    required this.recipientName,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Stream<QuerySnapshot>? chatStream;
  TextEditingController messageController = TextEditingController();
  String myUserName = "";

  @override
  void initState() {
    super.initState();
    getUserInfoAndMessages();
  }

  getUserInfoAndMessages() async {
    myUserName = (await SharedPreferenceHelper().getUserName()) ?? "Guest";
    chatStream = DatabaseMethods().getChatMessages(widget.chatRoomId);
    setState(() {});
  }

  sendMessage() {
    if (messageController.text.trim().isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": messageController.text.trim(),
        "sendBy": myUserName,
        "timestamp": FieldValue.serverTimestamp(),
      };

      DatabaseMethods().addMessage(widget.chatRoomId, messageMap);

      messageController.clear();
    }
  }

  Widget chatMessageList() {
    return StreamBuilder(
      stream: chatStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        return ListView.builder(
          reverse: true,
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data.docs[index];
            bool isMe = ds["sendBy"] == myUserName;

            return Align(
              alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isMe ? Colors.blueAccent : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  ds["message"],
                  style: TextStyle(color: isMe ? Colors.white : Colors.black),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "แชทกับ ${widget.recipientName}",
          style: AppWidget.boldTextFieldStyle().copyWith(color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(child: chatMessageList()),
          Divider(height: 1),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: "พิมพ์ข้อความ...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  onPressed: sendMessage,
                  icon: Icon(Icons.send),
                  color: Colors.blue,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
