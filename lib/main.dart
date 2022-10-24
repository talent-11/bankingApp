import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fotoc/providers/account_provider.dart';
import 'package:fotoc/routes.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<CurrentAccount>(create: (_) => CurrentAccount()),
      ],
      child: const MyApp()
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FOTOC',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // brightness: Brightness.dark,
        primaryColor: const Color(0xff5d10f6),
        fontFamily: 'Roboto',
        // primarySwatch: Colors.blue,
        textTheme: const TextTheme(
          headline1: TextStyle(
            fontSize: 20.0,
            color: Color(0xff252631),
            fontWeight: FontWeight.w400
          ),
          headline4: TextStyle(
            fontSize: 14.0, 
            color: Colors.white, 
            fontWeight: FontWeight.w500
          ),
          headline5: TextStyle(
            fontSize: 15.0,
            height: 1.4,
            color: Color(0xff252631),
            fontWeight: FontWeight.w400
          ),
          headline6: TextStyle(
            fontSize: 14.0,
            color: Color(0xff252631),
            fontWeight: FontWeight.w500
          ),
          bodyText1: TextStyle(fontSize: 14.0, color: Color(0xff98a9bc), height: 1.4),
          bodyText2: TextStyle(fontSize: 12.0, color: Color(0xff98a9bc), height: 1.2),
        ),
        textSelectionTheme: const TextSelectionThemeData(cursorColor: Color(0xff5d10f6)),
      ),
      // home: const SignupPage(),
      routes: routes,
    );
  }
}
