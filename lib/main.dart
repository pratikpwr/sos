import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sos_app/src/app.dart';
import 'package:sos_app/src/core/injector/injection_container.dart' as di;
import 'package:sos_app/src/notification_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await di.initDI();
  await Firebase.initializeApp();
  await NotificationConfig.init();
  runApp(const MyApp());
}
