


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
  final msgController=TextEditingController();


  @override
  void initState() {
    super.initState();
    intializechatRoom();

  }

  Future<void> intializechatRoom() async {
     fromid=(await Firebaseintialize.getFromid())!;
    setState((){   });


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Row(
          children: [
            CircleAvatar(
              //child: Image.network(widget.userID!.profilePic!),
            ),
            SizedBox(width: 5,),
            Column(
              children: [
                Text(widget.userID!.name.toString()),
                widget.userID!.isOnline == false ? Text("Offline..",style: TextStyle(fontSize: 10),) :Text("Online..",style: TextStyle(fontSize: 10),)
              ],
            )
          ],
        ),


      ),
      body:Column(
             children: [
               Expanded(
                 child: StreamBuilder<QuerySnapshot>(
                   stream:Firebaseintialize.getChatStream(
                     fromid: fromid,
                     toID: widget.userID!.userid ?? '',
                   ),
                   builder: (context, snapshot) {
                     if (snapshot.connectionState == ConnectionState.waiting) {
                       return const Center(child: CircularProgressIndicator());
                     }
                     if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                       return const Center(child: Text("No messages yet"));
                     }

                     listMsg = snapshot.data!.docs
                         .map((doc) => MessageModal.fromDoc(
                         doc.data() as Map<String, dynamic>))
                         .toList();

                     // Sort messages by timestamp in descending order
                     listMsg.sort((a, b) => int.parse(b.sentAt ?? '0')
                         .compareTo(int.parse(a.sentAt ?? '0')));

                     return ListView.builder(
                       itemCount: listMsg.length,
                       reverse: true,
                       itemBuilder: (context, index) {
                         return listMsg[index].fromId == fromid
                             ? rightMessageBubble(listMsg[index])
                             : leftMessageBubble(listMsg[index]);
                       },
                     );
                   },
                 ),
               ),

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
           ),
      );

  }


  Widget rightMessageBubble(MessageModal msgmodal){

    var sentTime = TimeOfDay.fromDateTime(
        DateTime.fromMillisecondsSinceEpoch(int.parse(msgmodal.sentAt!)));

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
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
                    child: msgmodal.msgType == 0 ? Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(msgmodal.msg!,style: TextStyle(fontSize: 18),),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(sentTime.format(context),),
                        )
                      ],
                    ) : Column(
                      children: [
                        Image.network(msgmodal.imgUrl!),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(sentTime.format(context)),
                        )
                      ],
                    ),
                  ),

                ],
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


  Widget leftMessageBubble(MessageModal msgmodal){
/*

    if(msgmodal.readAt==""){
      Firebaseintialize.updateReadStatus(fromId: widget.currUserId, toId: widget.eachUserId, mid: msg.mid!);
    }
*/

    var sentTime = TimeOfDay.fromDateTime(
        DateTime.fromMillisecondsSinceEpoch(int.parse(msgmodal.sentAt!)));

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
                        topRight: Radius.circular(21),
                        topLeft: Radius.circular(21),
                        bottomRight: Radius.circular(21))),
                child: msgmodal.msgType == 0 ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(msgmodal.msg!),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(sentTime.format(context)),
                    )
                  ],
                ) : Column(
                  children: [
                    Image.network(msgmodal.imgUrl!),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(sentTime.format(context)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),


      ],
    );
  }


}
