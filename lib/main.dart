import 'package:flutter/material.dart';
import 'package:fitoterapica/data/database.dart';
import 'package:fitoterapica/screens/about.dart';
import 'package:fitoterapica/screens/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final plantDatabase = PlantDatabase();
  await plantDatabase.initDatabase();

  runApp(MyApp(plantDatabase: plantDatabase));
}

class MyApp extends StatelessWidget {
  final PlantDatabase plantDatabase;

  const MyApp({Key? key, required this.plantDatabase}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Fitoterápica",
      initialRoute: "/",
      routes: {
        "/": (context) => Home(plantDatabase: plantDatabase),
        "/about": (context) => const AboutPage(),
      },
    );
  }
}
