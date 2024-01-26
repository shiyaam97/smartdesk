import 'dart:io';

import 'package:flutter/material.dart';
import 'package:smartdesk/splash.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:window_manager/window_manager.dart';


// main class
Future main() async {
  if (Platform.isWindows || Platform.isLinux) {

    // Initialize FFI
    sqfliteFfiInit();
    // Change the default factory
    databaseFactory = databaseFactoryFfi;
  }
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = const WindowOptions(
      size: Size(850, 600),
       title: 'Split Flap',
      center: true
  );
  windowManager.waitUntilReadyToShow(
      windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
    await windowManager.isResizable();
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Color color = const Color.fromARGB(255, 237, 248, 255);
    return MaterialApp(
      restorationScopeId: "Test",
      title: 'Smart Desk',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: color
      ),
      // splach screen
      home: Splash(),
    );
  }
}

