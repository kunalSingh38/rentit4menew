// ignore_for_file: prefer_const_constructors

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rentit4me_new/blocs/network_bloc/network_bloc.dart';
import 'package:rentit4me_new/views/personal_detail_screen.dart';
import 'package:rentit4me_new/views/splash_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// const AndroidNotificationChannel channel = AndroidNotificationChannel(
//     'high_importance_channel', // id
//     'High Importance Notifications', // title
//     importance: Importance.high,
//     playSound: true);

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print('A bg message just showed up :  ${message.messageId}');
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // await flutterLocalNotificationsPlugin
  //     .resolvePlatformSpecificImplementation<
  //         AndroidFlutterLocalNotificationsPlugin>()
  //     ?.createNotificationChannel(channel);

  // await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
  //   alert: true,
  //   badge: true,
  //   sound: true,
  // );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InternetBloc(),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          //theme: lightThemeData(context),
          //darkTheme: darkThemeData(context),
          title: 'Rentit4me',
          theme: ThemeData(
            primarySwatch: Colors.indigo,
          ),
          home: SplashScreen()
          // home: PersonalDetailScreen(),
          //home: SignupConsumerScreen(),
          //home: SignupScreen(),
          //home: const CurrentUserLocationScreen(),
          ),
    );
  }
}
