import 'package:flutter/material.dart';
import 'package:foode_waste_app_1/services/auth/login_or_register.dart';  // pastikan ini import yang benar
import 'package:foode_waste_app_1/models/restaurant.dart';
import 'package:foode_waste_app_1/themes/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:foode_waste_app_1/pages/splash_screen_page.dart';
import 'package:foode_waste_app_1/pages/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => Restaurant()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Foode Waste App',
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: const SplashScreen(),
      routes: {
        '/login': (context) => const LoginOrRegister(),  // <== diubah dari LoginOrRegisterPage ke LoginOrRegister
        '/home': (context) => const HomePage(),
        // Tambahkan route lain kalau perlu
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
