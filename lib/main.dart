import 'package:dio/dio.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(
        title: 'Flutter Demo Home Page',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? token;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () async {
                token = await FirebaseAppCheck.instance.getToken();
                setState(() {});
              },
              child: const Text('Get AppCheck token'),
            ),
            if (token != null) ...[
              const SizedBox(width: 8),
              Text('AppCheck token: $token'),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () async {
                  // Set the API endpoint URL
                  const apiUrl = 'http://localhost/check-token';

                  // Set the headers
                  Map<String, String> headers = {
                    'X-Firebase-AppCheck': token!,
                  };
                  print('X-Firebase-AppCheck: $token');

                  // Create a Dio instance
                  Dio dio = Dio();

                  // Make the HTTP request
                  final response = await dio.get(
                    apiUrl,
                    options: Options(
                      headers: headers,
                    ),
                  );

                  // Print the response
                  print(response.data);
                },
                child: const Text('Check AppCheck token'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
