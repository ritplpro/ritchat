

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ritchat/firebase/firebase.dart';
import '../modal/message_modal.dart';
import '../modal/user_modal.dart';

class ChatPage extends StatefulWidget {
  UserModal? userID;
   ChatPage({required this.userID});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<MessageModal> listMsg=[];
  DateFormat dtetime=DateFormat.Hm();
  var fromid="";
  var msgController=TextEditingController();
  @override
  void initState() {
    super.initState();
    intializechatRoom();

/*

    listMsg.add(MessageModal(msg:widget.userID!.userid,msgType: 0,sentAt: DateTime.now().millisecondsSinceEpoch.toString(),));
    listMsg.add(MessageModal(msg:widget.userID!.userid,msgType: 1,sentAt: DateTime.now().millisecondsSinceEpoch.toString(),));
*/

  }

  intializechatRoom() async {
    var formid=await Firebaseintialize.getFromid();
    Firebaseintialize.getChatStream(fromid: formid, toID:widget.userID!.userid!);

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Row(
          children: [
            CircleAvatar(),
            SizedBox(width: 5,),
            Text(widget.userID!.name.toString())
          ],
        ),

      ),
      body: Column(
        children: [
          Container(),
          Expanded(
              child:StreamBuilder(stream:Firebaseintialize.getChatStream(fromid: fromid, toID: widget.userID!.userid!),
                  builder:(context,snapshot){
                if(snapshot.connectionState==ConnectionState.waiting){
                  return Center(child: CircularProgressIndicator());
                }

                listMsg = List.generate(snapshot.data!.docs.length,(index)=>MessageModal.fromDoc(snapshot.data!.docs[index].data()));

                return ListView.builder(itemCount: listMsg.length,
                    reverse: true,
                    itemBuilder: (context,index){

                  log(msgs.toString());
                  return listMsg[index].fromId==fromid ?  rightChatBox(listMsg[index]): leftChatBox(listMsg[index]);
                });
              })),
          TextField(
            autofocus: true,
            enableSuggestions: true,
            controller: msgController,
            decoration: InputDecoration(
              prefixIcon: IconButton(onPressed: (){},icon: Icon(Icons.mic,),),
              suffixIcon:  IconButton(onPressed: (){
                Firebaseintialize.sendTextMessages(toid:widget.userID!.userid!, msg:msgController.text);

                msgController.clear();

              },icon: Icon(Icons.send),),
              fillColor:Theme.of(context).colorScheme.onPrimary,
              filled: true,
              hintText: "message...",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15)
              )
            ),

          )



        ],
      ),
    );
  }

  Widget leftChatBox(MessageModal msgModal){
  var  dtime=dtetime.format(DateTime.fromMillisecondsSinceEpoch(int.parse(msgModal.sentAt!)));
    return Container(
      padding: EdgeInsets.all(11.0),
      margin: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(11),
            bottomRight: Radius.circular(11),
            topLeft: Radius.circular(11)),
      ),
      child: Column(
        children: [
          Text("${msgModal.msg}",style: TextStyle(fontSize: 20),),
          Text("${msgModal.sentAt}"),
        ],
      ),
    );
  }

  Widget rightChatBox(MessageModal msgModal){
    return Container(
      padding: EdgeInsets.all(11.0),
      margin: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color:Theme.of(context).colorScheme.inversePrimary,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(11)),
      ),
      child: Column(
        children: [
          Text("${msgModal.msg}",style: TextStyle(fontSize: 20)),
          Text(msgModal.sentAt!),
        ],
      ),
    );
  }


}
