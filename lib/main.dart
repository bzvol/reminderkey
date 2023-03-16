import 'package:flutter/material.dart';

import 'pages/home.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.indigo,
            backgroundColor: const Color(0xFF181433),
            brightness: Brightness.dark,
          ),
          scaffoldBackgroundColor: const Color(0xFF181433),
          useMaterial3: true,
          textTheme: const TextTheme(
            bodyLarge: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
            bodyMedium: TextStyle(
              fontSize: 18.0,
              color: Colors.white,
            ),
          )
        ),
        home: const HomePage());
  }
}
