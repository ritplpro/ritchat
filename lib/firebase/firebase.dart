


import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ritchat/modal/message_modal.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../modal/user_modal.dart';

class Firebaseintialize{

  static final FirebaseAuth firebaseAuth=FirebaseAuth.instance;

  static final FirebaseFirestore firestore=FirebaseFirestore.instance;
  
   static const Collection_User="user";
  static const Collection_ChatRoom="ChatRoom";
  static const Collection_Messages="messages";
  static const Prefs_Set_UID="userId";


  createUser({required UserModal user, required String password}) async {
    try{

    var usercred= await  firebaseAuth.createUserWithEmailAndPassword(email: user.email!, password: password);
     if(usercred.user !=null){
       user.userid=usercred.user!.uid;//add userid firestore userid
       firestore.collection(Collection_User).doc(usercred.user!.uid).set(user.toMap()).catchError((error){
         throw(Exception("Error:$error"));
       });
     }


    } on FirebaseException catch(e){
      throw (Exception("Error:$e"));

    }catch(e){
      throw(Exception("Error:$e"));
      
    }
  }


  LoginUser({required String email, required String password}) async {
    try{
      var usercred= await  firebaseAuth.signInWithEmailAndPassword(email: email, password: password);

      if(usercred.user !=null){

        var prefs=await SharedPreferences.getInstance();
        prefs.setString(Prefs_Set_UID,usercred.user!.uid);


        }
    } on FirebaseException catch(e){
      throw (Exception("Error:$e"));

    }catch(e){
      throw(Exception("Error:$e"));

    }
  }



 static Future<QuerySnapshot<Map<String,dynamic>>>getAllContacts(){
    return firestore.collection(Collection_User).get();
  }
//// send msg function
  static   getFromid() async {
    var prefs=await SharedPreferences.getInstance();
     return prefs.getString(Prefs_Set_UID);

  }

  static  getSendid({required String fromID,required String toid}) async {
   if(fromID.hashCode <= toid.hashCode){
     return "${fromID}_$toid";
   }else{
     return "${toid}_$fromID";
   }

  }

  static Future<void>  sendTextMessages({required String toid,required String msg}) async {
   var fromID=await  getFromid();
   var currtime=DateTime.now().millisecondsSinceEpoch.toString();
   var chatID=await getSendid(fromID: fromID, toid: toid);
   var messageModal=MessageModal(
       msgId:currtime,
       msg: msg,
       sentAt: currtime,
     fromId: fromID,
     toId: toid);

   firestore.collection(Collection_ChatRoom).doc(chatID)
       .collection(Collection_Messages).doc(currtime).set(messageModal.toDoc());
   
   
   
  }


  static  sendImageMessages({required String toid,String imgmsg="",String msg="" }) async {
    var fromID=await  getFromid();
    var currtime=DateTime.now().millisecondsSinceEpoch.toString();
    var chatID=await getSendid(fromID: fromID, toid: toid);
    var messageModal=MessageModal(
        msgId:currtime,
        msg:msg,
        sentAt: currtime,
        msgType: 1,
        imgUrl: imgmsg,
        fromId: fromID,
        toId: toid);

    firestore.collection(Collection_ChatRoom).doc(chatID)
        .collection(Collection_Messages).doc(currtime).set(messageModal.toDoc());



  }


  static Stream<QuerySnapshot<Map<String, dynamic>>> getChatStream({required String fromid,required String toID}){

    var chatid = getSendid(fromID: fromid, toid: toID);
    return firestore.collection(Collection_ChatRoom).doc(chatid.toString()).collection(Collection_Messages).snapshots();

  }




}