import 'package:flutter/material.dart';
import 'package:notif/screens/home_screen.dart';
import 'package:notif/screens/second_screen.dart';
import 'package:notif/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().initializeNotification();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notification Demo',
      routes: {
        'home': (context) => const HomeScreen(),
        'second': (context) => const SecondScreen(),
      },
      initialRoute: 'home',
      navigatorKey: navigatorKey,
    );
  }
}
