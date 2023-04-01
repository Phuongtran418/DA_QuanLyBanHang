import 'package:flutter/material.dart';

import 'package:opc_app_main/login_screen.dart';




Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(app_opc());

}

class app_opc extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OPC App',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      initialRoute: 'welcome',
      routes: {
        'welcome': (context) => LoginScreen(),  
      },
    );
  }
}
