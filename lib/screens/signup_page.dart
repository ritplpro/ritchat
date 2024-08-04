import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/register_cubit/register_cubit.dart';
import '../cubit/register_cubit/register_state.dart';
import '../modal/user_modal.dart';

class SignupPage extends StatelessWidget {
  var nameController=TextEditingController();
  var emailController=TextEditingController();
  var passController=TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Account"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(11.0),
        child: Center(
          child: Column(
            children: [
              Row(
                children: [
                  Text("Enter your name "),
                ],
              ),
              TextField(
                controller: nameController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(21)
                  )
                ),
              ),
              SizedBox(height: 10,),
              Row(
                children: [
                  Text("Enter your Email "),
                ],
              ),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(21)
                    )
                ),
              ),
              SizedBox(height: 10,),
              Row(
                children: [
                  Text("Enter your Password "),
                ],
              ),
              TextField(
                controller: passController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.password_sharp),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(21)
                    )
                ),
              ),
              SizedBox(height: 30,),
              BlocConsumer<RegisterCubit,RegisterState>(builder: (context,state){
                if (state is RegisterLoadingState){
                  return ElevatedButton(
                      onPressed: (){},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          ),
                          SizedBox(width: 11,),
                          Text("Creating account ..."),
                        ],
                      ));
                }
                return ElevatedButton(onPressed: (){
                  var password=passController.text;

                  if(nameController.text!=null && passController.text!=null && emailController.text!=null){
                    var newmodal=UserModal(
                      name: nameController.text,
                      email: emailController.text,
                      createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
                    );

                    BlocProvider.of<RegisterCubit>(context).registerUser(newmodal,password);









                  }
                }, child: Text("Cretae"));
              }, listener: (_,state){
                if(state is RegisterFailedState){
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.deepOrange,
                      content:Text(state.errormsg,style: TextStyle(fontSize: 18),)));
                }else if (state is RegisterScucessState){
                  Navigator.pop(context);

                }
              })



            ],
          ),
        ),
      ),
    );
  }
}
