import 'package:flutter/material.dart';
import 'pages/heatmap_calendar_example.dart';
import 'pages/heatmap_example.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recuerdos',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(),
        '/fotos': (context) => const HeatMapCalendarExample(),
        '/carta': (context) => const HeatMapExample(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recuerdos')),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: const Text('Fotos'),
              onTap: () => Navigator.of(context).pushNamed('/fotos'),
            ),
            ListTile(
              title: const Text('Cartas'),
              onTap: () => Navigator.of(context).pushNamed('/carta'),
            ),
          ],
        ),
      ),
    );
  }
}
