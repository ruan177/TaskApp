import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskapp/UI/screens/login.dart';

import 'data/database.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<MyDatabase>(
          create: (_) => MyDatabase(),
        ),
        // Outros providers, se houver
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Login(),

    );
  }
}

