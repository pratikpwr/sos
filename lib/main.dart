import 'package:flutter/material.dart';
import 'package:sos_app/src/app.dart';
import 'package:sos_app/src/core/injector/injection_container.dart' as di;

void main() {
  di.initDI();
  runApp(const MyApp());
}
