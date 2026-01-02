import 'package:flutter/material.dart';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

// JS Interop declarations - these bind to JavaScript functions
@JS('jsGreet')
external JSString jsGreet(JSString name);

@JS('jsShowAlert')
external void jsShowAlert(JSString message);

@JS('jsGetData')
external JSObject jsGetData();

@JS('jsCallWithCallback')
external void jsCallWithCallback(JSFunction callback);

@JS('jsBridge')
external JSObject get jsBridge;

// Helper function to convert JSString to Dart String
String jsStringToDart(JSString jsStr) => jsStr.toDart;

// Helper function to convert Dart String to JSString
JSString dartStringToJS(String str) => str.toJS;

// Helper function to get a string property from a JSObject
String? getJSStringProperty(JSObject obj, String key) {
  final value = obj.getProperty(key.toJS);
  if (value case JSString str) {
    return str.toDart;
  }
  return null;
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JS Interop Demo',
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

  void _callJSGreet(BuildContext context) {
    try {
      final result = jsGreet(dartStringToJS('Flutter'));
      final message = jsStringToDart(result);
      _showDialog(context, 'JS Greet Result', message);
    } catch (e) {
      _showDialog(context, 'Error', 'Failed to call JS: $e');
    }
  }

  void _callJSAlert(BuildContext context) {
    try {
      jsShowAlert(dartStringToJS('This alert is from JavaScript!'));
    } catch (e) {
      _showDialog(context, 'Error', 'Failed to call JS: $e');
    }
  }

  void _callJSGetData(BuildContext context) {
    try {
      final data = jsGetData();
      final message = getJSStringProperty(data, 'message') ?? 'No message';
      final timestamp = getJSStringProperty(data, 'timestamp') ?? 'No timestamp';
      _showDialog(context, 'JS Data', 'Message: $message\nTimestamp: $timestamp');
    } catch (e) {
      _showDialog(context, 'Error', 'Failed to call JS: $e');
    }
  }

  void _callJSCallback(BuildContext context) {
    try {
      // Create a JS function from a Dart function
      final callback = ((JSString message) {
        final msg = message.toDart;
        if (context.mounted) {
          _showDialog(context, 'JS Callback', msg);
        }
      }).toJS;
      
      jsCallWithCallback(callback);
      _showDialog(context, 'Callback Set', 'Callback registered. Result will appear in 1 second.');
    } catch (e) {
      _showDialog(context, 'Error', 'Failed to call JS: $e');
    }
  }

  void _getJSBridgeInfo(BuildContext context) {
    try {
      final bridge = jsBridge;
      final getInfo = bridge.getProperty('getInfo'.toJS) as JSFunction;
      final info = getInfo.callAsFunction() as JSObject;
      final platform = getJSStringProperty(info, 'platform') ?? 'Unknown';
      final userAgent = getJSStringProperty(info, 'userAgent') ?? 'Unknown';
      _showDialog(context, 'JS Bridge Info', 'Platform: $platform\n\nUser Agent: $userAgent');
    } catch (e) {
      _showDialog(context, 'Error', 'Failed to get bridge info: $e');
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
        title: const Text('JS Interop Demo'),
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
              onPressed: () => _callJSGreet(context),
              child: const Text('Call JS Greet Function'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _callJSAlert(context),
              child: const Text('Call JS Alert'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _callJSGetData(context),
              child: const Text('Get Data from JS'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _callJSCallback(context),
              child: const Text('JS Callback Example'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _getJSBridgeInfo(context),
              child: const Text('Get JS Bridge Info'),
            ),
          ],
        ),
      ),
    );
  }
}
