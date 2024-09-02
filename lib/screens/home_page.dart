import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ritchat/modal/user_modal.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../firebase/firebase.dart';
import 'Chat_page.dart';
import 'Contacts_page.dart';
import 'login_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var fromid="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFromid();
  }

  Future<void> getFromid() async {
    fromid=(await Firebaseintialize.getFromid())!;
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Re-chat"),
        actions: [
          PopupMenuButton(child: Icon(Icons.more_vert),
              itemBuilder: (contexxt){
            return [
              PopupMenuItem(onTap: () async {
                //logout_session
                var prefs=await SharedPreferences.getInstance();
                prefs.setString(Firebaseintialize.Prefs_Set_UID,"");
                Navigator.push(context,MaterialPageRoute(builder: (context)=>LoginPage()));},
                  child: Text("Logout")),];
          }),



        ],
      ),
      body:StreamBuilder<QuerySnapshot>(
        stream:Firebaseintialize.getHomeChatContactStream(fromid: fromid),
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }else if(snapshot.hasError){
            return Center(child: Text("error${snapshot.error}"));
          }else if(snapshot.hasData){
    var listUserID=List.generate(snapshot.data!.docs.length,(index){
    var mdata=snapshot.data!.docs[index].get("ids") as List<dynamic>;
    mdata.removeWhere((element)=> element==fromid);
    return mdata[0];
    });
    print(" userformdd${listUserID.toString()}");
    return ListView.builder(itemCount:listUserID.length,
    itemBuilder: (context,index){
    return FutureBuilder(future:Firebaseintialize.getHomeChatContactStreamUserID(UserId: listUserID[index]),
    builder: (context,usersnap){
    var currentModal=UserModal.fromMap(usersnap.data!.data()!);
    return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Card(
    child: Padding(
    padding: const EdgeInsets.all(8.0),
    child: ListTile(
    onTap: (){
    Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(userID: currentModal)));
    },
    leading: CircleAvatar(
    radius: 25,
    backgroundImage: currentModal.profilePic != null ? NetworkImage(currentModal.profilePic!):AssetImage("assets/images/avtors.png"),

    ),
    title: Text(currentModal.name!),
    subtitle: Text(currentModal.email!),),)),);
    });
    });
    }return Container();},),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>ContactsPage()));
      },child: Icon(Icons.add),),
    );
  }
}
