import 'package:flutter/material.dart';
import 'package:flutter_hylid_bridge/hylid_bridge.dart';

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
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const DemoPage(),
    );
  }
}

class DemoPage extends StatefulWidget {
  const DemoPage({super.key});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  String _lastResult = 'No operations performed yet';
  bool _isLoading = false;

  void _setLoading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }

  void _setResult(String result) {
    setState(() {
      _lastResult = result;
      _isLoading = false;
    });
  }

  Future<void> _testAlert() async {
    _setLoading(true);
    try {
      await alert(
        title: 'Demo Alert',
        content: 'This is a Hylid Bridge alert dialog!',
        buttonText: 'Got it',
        success: () {
          _setResult('Alert: User clicked the button');
        },
        fail: () {
          _setResult('Alert: Failed to display');
        },
      );
    } catch (e) {
      _setResult('Alert Error: $e');
    }
  }

  Future<void> _testAuth() async {
    _setLoading(true);
    try {
      await getAuthCode(
        scopes: ['auth_user', 'auth_profile'],
        success: (AuthCodeResult result) {
          _setResult('Auth Success: Received auth code');
        },
        fail: () {
          _setResult('Auth: User denied or failed');
        },
        complete: () {
          // Flow completed
        },
      );
    } catch (e) {
      _setResult('Auth Error: $e');
    }
  }

  Future<void> _testPayment() async {
    _setLoading(true);
    try {
      // Note: You'll need a valid payment URL from your backend
      // This is just a demo - replace with actual payment URL
      await tradePay(
        paymentUrl: 'https://example.com/payment-url',
        success: (TradePayResult result) {
          _setResult('Payment Success');
        },
        fail: (TradePayResult result) {
          _setResult('Payment Failed');
        },
        complete: (TradePayResult result) {
          // Flow completed
        },
      );
    } catch (e) {
      _setResult('Payment Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hylid Bridge Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Last Result:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _lastResult,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Test Hylid Bridge APIs:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _testAlert,
              icon: const Icon(Icons.info),
              label: const Text('Test Alert'),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _testAuth,
              icon: const Icon(Icons.login),
              label: const Text('Test Authentication'),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _testPayment,
              icon: const Icon(Icons.payment),
              label: const Text('Test Payment'),
            ),
            const SizedBox(height: 24),
            if (_isLoading)
              const Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 8),
                    Text('Processing...'),
                  ],
                ),
              ),
            const Spacer(),
            Card(
              color: Colors.blue[50],
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Note:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'This demo runs on web. The Hylid Bridge script is automatically loaded when you use any API.',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
