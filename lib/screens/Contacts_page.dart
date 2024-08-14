import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../firebase/firebase.dart';
import '../modal/user_modal.dart';
import 'Chat_page.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All contacts"),
      ),
      body:StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(stream:Firebaseintialize.getAllContacts().asStream(),
          builder: (context,snapshot){
        if(snapshot.connectionState==ConnectionState.waiting){
          return Center(child: CircularProgressIndicator());
        }else if(snapshot.hasError){
          return Center(child: Text(snapshot.error.toString()));
        }else if(snapshot.hasData){
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
              itemBuilder: (context,index){
              var currentModal=UserModal.fromMap(snapshot.data!.docs[index].data());
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)  => ChatPage(userID: currentModal)));
                      },
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundImage: currentModal.profilePic != null ? NetworkImage(currentModal.profilePic!):AssetImage("assets/images/avtors.png"),

                      ),
                      title: Text(currentModal.name!),
                      subtitle: Text(currentModal.email!),
                    ),
                  )),
            );
          });
        }
        return Container();
          }),
    );
  }
}
