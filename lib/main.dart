import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ritchat/screens/splash.dart';

import 'cubit/login_cubit/login_cubit.dart';
import 'cubit/register_cubit/register_cubit.dart';
import 'firebase/firebase.dart';
import 'firebase_options.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => RegisterCubit(firebaseintialize: Firebaseintialize())),
        BlocProvider(create: (context) => LoginCubit(firebaseintialize: Firebaseintialize())),

      ],
      child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashPage(),
    );
  }
}
