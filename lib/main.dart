import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:notes_app_firebase/logic/login_bloc/login_bloc.dart';
import 'package:notes_app_firebase/presentation/screens/create_note.dart';
import 'package:notes_app_firebase/presentation/screens/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app_firebase/presentation/screens/notes_display.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // You may set the permission requests to "provisional" which allows the user to choose what type
  // of notifications they would like to receive once the user receives a notification.
  final notificationSettings = await FirebaseMessaging.instance
      .requestPermission();
  // For apple platforms, ensure the APNS token is available before making any FCM plugin API calls
  // final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
  final token = await FirebaseMessaging.instance.getToken();
  print("------------------- FCM Token: $token --------------------------");
  // if (apnsToken != null) {
  //   // APNS token is available, make FCM plugin API requests...
  // }
  FirebaseMessaging.onMessage.listen((RemoteMessage message){
    print(message.messageId);
    print("Title:${message.notification?.title}");
    print("Body:${message.notification?.body}");
    print("data:${message.data}");

  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(FirebaseAuth.instance),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: LoginPage(),
      ),
    );
  }
}
