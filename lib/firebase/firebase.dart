import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../modal/user_modal.dart';

class Firebaseintialize{

  static final FirebaseAuth firebaseAuth=FirebaseAuth.instance;

  static final FirebaseFirestore firestore=FirebaseFirestore.instance;
  
   static const Collection_User="user";
  static const Collection_ChatRoom="ChatRoom";
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





}