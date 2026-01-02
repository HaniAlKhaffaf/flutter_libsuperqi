import 'package:flutter/material.dart';
import 'package:hylid_bridge/hylid_bridge.dart' show alert, getAuthCode;
import 'dart:js_interop';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hylid Bridge Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  void _showHelloWorld(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hello World'),
          content: const Text('hello world'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showHylidAlert(BuildContext context) {
    try {
      alert(
        title: 'Alert Title',
        content: 'This is the content of the alert.',
        buttonText: 'Confirm',
        success: () {
          if (context.mounted) {
            _showDialog(context, 'Alert Success', 'Alert was confirmed!');
          }
        },
      );
    } catch (e) {
      _showDialog(context, 'Error', 'Failed to show alert: $e');
    }
  }

  void _getAuthCode(BuildContext context) {
    try {
      print('[Flutter] Requesting auth code from wallet...');
      
      getAuthCode(
        scopes: ['auth_base'],
        success: (res) {
          print('[Flutter] SUCCESS: Auth code retrieved');
          // res has authCode property (JSString?)
          final authCode = res.authCode?.toDart;
          print('[Flutter] Auth code: $authCode');
          
          if (context.mounted) {
            _showDialog(
              context,
              'Auth Success',
              'Authorization Code:\n${authCode ?? 'No auth code received'}',
            );
          }
        },
        fail: () {
          print('[Flutter] ERROR: Auth code retrieval failed');
          
          if (context.mounted) {
            _showDialog(context, 'Auth Failed', 'Authorization failed.');
          }
        },
      );
    } catch (e, stackTrace) {
      _showDialog(context, 'Error', 'Failed to call getAuthCode:\n$e\n\nStack trace:\n$stackTrace');
    }
  }

  void _showDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Hylid Bridge Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _showHelloWorld(context),
              child: const Text('Show Hello World (Dart)'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _showHylidAlert(context),
              child: const Text('Show Hylid Alert'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _getAuthCode(context),
              child: const Text('Get Auth Code'),
            ),
          ],
        ),
      ),
    );
  }
}
