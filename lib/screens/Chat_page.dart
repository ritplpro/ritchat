

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
    setState(() {

    });
/*


    listMsg.add(MessageModal(msg:widget.userID!.userid,msgType: 0,sentAt: DateTime.now().millisecondsSinceEpoch.toString(),));
    listMsg.add(MessageModal(msg:widget.userID!.userid,msgType: 1,sentAt: DateTime.now().millisecondsSinceEpoch.toString(),));
*/

  }

  intializechatRoom() async {
    var formid=await Firebaseintialize.getFromid();
    Firebaseintialize.getChatStream(fromid: formid!, toID:widget.userID!.userid!);

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
      body:Column(
        children: [
          Expanded(
            child: FutureBuilder<Stream<QuerySnapshot<Map<String, dynamic>>>>(
              future: Firebaseintialize.getChatStream(fromid: fromid, toID: widget.userID!.userid!),
              builder: (context, futureSnapshot) {
                if (!futureSnapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
            
                return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: futureSnapshot.data!,
                  builder: (context, streamSnapshot) {
                    if (!streamSnapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
            
                    var docs = streamSnapshot.data!.docs;
                    listMsg = docs.map((doc) => MessageModal.fromDoc(doc.data())).toList();
            
                    return ListView.builder(
                      itemCount: listMsg.length,
                      shrinkWrap: true,
                      reverse: true,
                      itemBuilder: (context, index) {
                        // return Text('hii');
                        return listMsg[index].fromId == fromid
                            ? rightMessageBubble(listMsg[index])
                            : leftChatBox(listMsg[index]);
                      },
                    );
                  },
                );
              },
            ),
          ),
          SizedBox(height: 15,),
          // body: Column(
          //   children: [
          //     /*Expanded(
          //         child:StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(
          //             stream: Firebaseintialize.getChatStream(fromid: fromid, toID: widget.userID!.userid!) as Stream<QuerySnapshot<Map<String, dynamic>>>,
          //             builder:(context,snapshot){
          //               // print(snapshot.data!.docs);
          //           if(snapshot.connectionState==ConnectionState.waiting){
          //             return Center(child: CircularProgressIndicator());
          //           }
          //
          //           listMsg = List.generate(snapshot.data!.docs.length,(index)=> MessageModal.fromDoc(snapshot.data!.docs[index].data()));
          //
          //          // print('this is message model ${MessageModal.fromDoc(snapshot.data!.docs[1].data())}');
          //           print('list of msg ${listMsg.length}');
          //
          //           return ListView.builder(itemCount: listMsg.length,
          //               shrinkWrap: true,
          //               reverse: true,
          //               itemBuilder: (context,index){
          //             return listMsg[index].fromId == fromid ?  rightMessageBubble(listMsg[index]): leftChatBox(listMsg[index]);
          //           });
          //         })),*/
          //
          //
          //
          //
          //
          //
          //   ],
          // ),
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

          ),
          


        ],
      )
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

  Widget rightMessageBubble(MessageModal msgmodal){

    var sentTime = TimeOfDay.fromDateTime(
        DateTime.fromMillisecondsSinceEpoch(int.parse(msgmodal.sentAt!)));

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(sentTime.format(context)),
        ),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                margin: EdgeInsets.all(11),
                padding: EdgeInsets.all(11),
                decoration: BoxDecoration(
                    color: Colors.amber.shade100,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(21),
                        topRight: Radius.circular(21),
                        bottomLeft: Radius.circular(21))),
                child: msgmodal.msgType == 0 ? Text(msgmodal.msg!) : Image.network(msgmodal.imgUrl!),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Visibility(visible: msgmodal.readAt!="",
                      child: Text(msgmodal.readAt=="" ? "" : TimeOfDay.fromDateTime(
                          DateTime.fromMillisecondsSinceEpoch(int.parse(msgmodal.readAt!))).format(context).toString())),
                  SizedBox(
                    width: 7,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(Icons.done_all_outlined,
                      color: msgmodal.readAt!= "" ? Colors.blue : Colors.grey,),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
/*

  Widget leftMessageBubble(MessageModal msgmodal){

    if(msgmodal.readAt==""){
      Firebaseintialize.updateReadStatus(fromId: widget.currUserId, toId: widget.eachUserId, mid: msg.mid!);
    }

    var sentTime = TimeOfDay.fromDateTime(
        DateTime.fromMillisecondsSinceEpoch(int.parse(msg.sentAt!)));

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.all(11),
                padding: EdgeInsets.all(11),
                decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(21),
                        topRight: Radius.circular(21),
                        bottomLeft: Radius.circular(21))),
                child: msg.msgType == 0 ? Text(msg.txtMsg) : Image.network(msg.imgUrl!),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(sentTime.format(context)),
        ),

      ],
    );
  }

*/

}
