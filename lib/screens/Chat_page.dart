import 'package:flutter/material.dart';
import '../modal/message_modal.dart';
import '../modal/user_modal.dart';

class ChatPage extends StatefulWidget {
 UserModal? userID;
   ChatPage({required UserModal userID});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<MessageModal> listMsg=[];
  var queryController=TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userID!.name!),
      ),
      body: Column(
        children: [],
      ),
    );
  }
}
