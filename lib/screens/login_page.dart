import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ritchat/screens/signup_page.dart';

import '../cubit/login_cubit/login_cubit.dart';
import 'home_page.dart';

class LoginPage extends StatelessWidget {
  var emailController=TextEditingController();
  var passController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Account"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(11.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text("Enter your Email "),
                ],
              ),
              TextField(
                controller: emailController,
                autofocus: true,
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
                autofocus: true,
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
              BlocConsumer<LoginCubit,LoginState>(builder: (context,state){
                if(state is LoginLoadingState){
                  return ElevatedButton(onPressed: (){},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          ),
                          SizedBox(width: 11,),
                          Text("is Logining..."),
                        ],
                      ));
                }
                return ElevatedButton(onPressed: (){
                  if(emailController.text!=null &&passController.text!=null){
                    BlocProvider.of<LoginCubit>(context).loginUser(email: emailController.text,password:passController.text);
                  }
                }, child: Text("Login"));
              }, listener:(_,state){
                if(state is LoginFailedState){
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.deepOrange,
                  content:Text(state.errormsg,style: TextStyle(fontSize: 18),)));
                }else if (state is LoginSucessState){
                  Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>MyHomePage()));
                }

                }


    ),
              SizedBox(height: 15,),
              Row(
                children: [
                  Text("Don`t have acct"),
                  TextButton(onPressed: (){
                    Navigator.push(context,MaterialPageRoute(builder: (context)=>SignupPage()));
                  }, child:Text("Create account ?",style: TextStyle(fontWeight: FontWeight.bold),))
                ],
              )



            ],
          ),
        ),
      ),
    );
  }
}
