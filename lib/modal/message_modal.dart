class MessageModal{
  String? msgId;
  String? msg;
  String? sentAt;
  String? readAt;
  String? fromId;
  String? toId;
  int? msgType;
  String? imgUrl;

  MessageModal({
     this.msgId,
     this.msg,
     this.sentAt,
     this.fromId,
     this.imgUrl="",
     this.msgType=0,
     this.readAt="",
     this.toId,
  });


  factory MessageModal.fromDoc(Map<String,dynamic>doc){
    return MessageModal(
        msgId: doc['msgId'],
        msg: doc['msg'],
        sentAt: doc["sentAt"],
        fromId: doc['fromId'],
        imgUrl: doc["imgUrl"],
        msgType: doc["msgType"],
        readAt: doc["readAt"],
        toId: doc["toId"]);
  }


  Map<String,dynamic>toDoc(){
    return{
    "msgId": msgId,
    'msg': msg,
    "sentAt": sentAt,
    "fromId": fromId,
    "imgUrl": imgUrl,
    "msgType": msgType,
    "readAt": readAt,
    "toId": toId,

    };
  }



}