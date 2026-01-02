import 'package:flutter/material.dart';
import 'hylid_bridge/hylid_bridge.dart' show getAuthCode, tradePay;
import 'dart:js_interop';
import 'dart:convert';
import 'package:http/http.dart' as http;

const String baseUrl = 'http://172.20.10.2:1999';

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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // App state (similar to the JS state object)
  String authCode = '';
  String token = '';
  String paymentUrl = '';
  String paymentId = '';
  double paymentAmount = 0;

  // Console log output
  List<String> logs = [];

  void _log(String message) {
    setState(() {
      logs.add(message);
    });
    print(message);
  }

  void _getAuthCode() {
    _log('=================================================================');
    _log('[Flutter] Requesting auth code from wallet...');
    _log('=================================================================');

    try {
      getAuthCode(
        scopes: ['auth_base', 'USER_ID'],
        success: (res) {
          _log('[Flutter] SUCCESS: Auth code retrieved');
          final code = res.authCode?.toDart ?? '';
          _log('[Flutter] Auth code: $code');

          setState(() {
            authCode = code;
          });

          _log('[Flutter] Auth code saved to state');
          _log('[Flutter] Next step: Click "Apply Token" button');
          _log('=================================================================\n');

          if (mounted) {
            _showDialog('Auth Success', 'Authorization code retrieved!\n\nClick "Apply Token" to continue.');
          }
        },
        fail: () {
          _log('[Flutter] ERROR: Auth code retrieval failed');
          _log('=================================================================\n');

          if (mounted) {
            _showDialog('Auth Failed', 'Failed to retrieve authorization code.');
          }
        },
      );
    } catch (e, stackTrace) {
      _log('[Flutter] ERROR: Exception during getAuthCode');
      _log('[Flutter] Error: $e');
      _log('[Flutter] Stack trace: $stackTrace');
      _log('=================================================================\n');

      if (mounted) {
        _showDialog('Error', 'Failed to call getAuthCode:\n$e');
      }
    }
  }

  Future<void> _applyToken() async {
    if (authCode.isEmpty) {
      _log('[Flutter] ERROR: Auth code not available - click "Get Auth Code" first');
      _showDialog('Error', 'Please click "Get Auth Code" button first.');
      return;
    }

    _log('=================================================================');
    _log('[Flutter] STARTING TOKEN EXCHANGE');
    _log('=================================================================');
    _log('[Flutter] Sending auth code to backend...');
    _log('[Flutter] Request body: {auth_code: $authCode}');

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/apply-token'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'auth_code': authCode,
        }),
      );

      _log('[Flutter] Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _log('[Flutter] SUCCESS: Response received from backend');
        _log('[Flutter] Response data: $data');

        setState(() {
          token = data['token'] ?? '';
        });

        _log('[Flutter] Token saved to state');
        _log('[Flutter] Authentication complete - ready to create payment');
        _log('[Flutter] Click "Pay" button to create payment');
        _log('=================================================================\n');

        if (mounted) {
          _showDialog('Token Applied', 'Authentication successful!\n\nToken received from backend.\nReady for payment.');
        }
      } else {
        final errorText = response.body;
        _log('[Flutter] ERROR: Server returned status ${response.statusCode}');
        _log('[Flutter] Response: $errorText');
        _log('=================================================================\n');

        if (mounted) {
          _showDialog('Error', 'Failed to apply token.\nStatus: ${response.statusCode}');
        }
      }
    } catch (error) {
      _log('[Flutter] ERROR: Failed during token exchange');
      _log('[Flutter] Error details: $error');
      _log('=================================================================\n');

      if (mounted) {
        _showDialog('Error', 'Network error during token exchange:\n$error');
      }
    }
  }

  Future<void> _createPayment() async {
    if (token.isEmpty) {
      _log('[Flutter] ERROR: Token not available');
      _showDialog('Error', 'Please click "Apply Token" button first to authenticate.');
      return;
    }

    _log('=================================================================');
    _log('[Flutter] CREATING PAYMENT');
    _log('=================================================================');
    _log('[Flutter] Sending token to backend for payment creation...');

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/payment/create'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'token': token,
        }),
      );

      _log('[Flutter] Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _log('[Flutter] SUCCESS: Payment response received');
        _log('[Flutter] Response data: $data');

        if (data['paymentUrl'] != null) {
          setState(() {
            paymentUrl = data['paymentUrl'] ?? '';
            paymentId = data['paymentId'] ?? '';
            paymentAmount = (data['amount'] ?? 0).toDouble();
          });

          _log('[Flutter] Payment URL received: $paymentUrl');
          _log('[Flutter] Payment ID: $paymentId');
          _log('[Flutter] Payment Amount: $paymentAmount');
          _log('[Flutter] Payment created successfully');
          _log('[Flutter] Automatically opening payment cashier...');
          _log('=================================================================\n');

          // Automatically redirect to payment
          _goToPayment();
        } else {
          _log('[Flutter] ERROR: No payment URL in response');
          _log('=================================================================\n');
          if (mounted) {
            _showDialog('Error', 'No payment URL received from backend.');
          }
        }
      } else {
        final errorText = response.body;
        _log('[Flutter] ERROR: Server returned status ${response.statusCode}');
        _log('[Flutter] Response: $errorText');
        _log('=================================================================\n');

        if (mounted) {
          _showDialog('Error', 'Failed to create payment.\nStatus: ${response.statusCode}');
        }
      }
    } catch (error) {
      _log('[Flutter] ERROR: Failed to create payment');
      _log('[Flutter] Error details: $error');
      _log('=================================================================\n');

      if (mounted) {
        _showDialog('Error', 'Network error during payment creation:\n$error');
      }
    }
  }

  void _goToPayment() {
    if (paymentUrl.isEmpty) {
      _log('[Flutter] ERROR: Payment URL not available');
      return;
    }

    _log('=================================================================');
    _log('[Flutter] STARTING PAYMENT FLOW');
    _log('=================================================================');
    _log('[Flutter] Payment URL: $paymentUrl');
    _log('[Flutter] Payment ID: $paymentId');
    _log('[Flutter] Calling my.tradePay() JSAPI...');

    try {
      tradePay(
        paymentUrl: paymentUrl,
        success: (res) {
          _log('=================================================================');
          _log('[Flutter] PAYMENT SUCCESS CALLBACK');
          _log('=================================================================');
          final resultCode = res.resultCode?.toDart ?? '';
          _log('[Flutter] Success response: ${res.resultCode?.toDart}');
          _log('[Flutter] Result code: $resultCode');

          if (resultCode == '9000') {
            _log('[Flutter] Payment SUCCESSFUL (code: 9000)');
          } else if (resultCode == '8000') {
            _log('[Flutter] Trade PROCESSING (code: 8000)');
          } else if (resultCode == '6004') {
            _log('[Flutter] Unknown result, may be success (code: 6004)');
          } else {
            _log('[Flutter] Other result code: $resultCode');
          }
          _log('=================================================================\n');

          if (mounted) {
            _showDialog('Payment Success', 'Payment result code: $resultCode');
          }
        },
        fail: (res) {
          _log('=================================================================');
          _log('[Flutter] PAYMENT FAIL CALLBACK');
          _log('=================================================================');
          final resultCode = res.resultCode?.toDart ?? '';
          _log('[Flutter] Fail response: ${res.resultCode?.toDart}');
          _log('[Flutter] Result code: $resultCode');

          if (resultCode == '4000') {
            _log('[Flutter] Payment FAILED (code: 4000)');
          } else if (resultCode == '6001') {
            _log('[Flutter] User CANCELLED payment (code: 6001)');
          } else if (resultCode == '6002') {
            _log('[Flutter] Network EXCEPTION (code: 6002)');
          } else {
            _log('[Flutter] Other error code: $resultCode');
          }
          _log('=================================================================\n');

          if (mounted) {
            _showDialog('Payment Failed', 'Payment result code: $resultCode');
          }
        },
        complete: (res) {
          _log('=================================================================');
          _log('[Flutter] PAYMENT COMPLETE CALLBACK');
          _log('=================================================================');
          _log('[Flutter] Complete response: ${res.resultCode?.toDart}');
          _log('[Flutter] NOTE: This callback executes after success OR fail');
          _log('[Flutter] Next step: Backend should receive webhook notification');
          _log('[Flutter] Check backend logs for webhook callback from wallet');
          _log('=================================================================\n');
        },
      );

      _log('[Flutter] Waiting for user action in wallet cashier page...');
    } catch (e, stackTrace) {
      _log('[Flutter] ERROR: Exception during tradePay');
      _log('[Flutter] Error: $e');
      _log('[Flutter] Stack trace: $stackTrace');
      _log('=================================================================\n');

      if (mounted) {
        _showDialog('Error', 'Failed to call tradePay:\n$e');
      }
    }
  }

  Future<void> _requestRefund() async {
    if (paymentId.isEmpty) {
      _log('[Flutter] ERROR: Payment ID not available');
      _showDialog('Error', 'No payment to refund. Please create a payment first.');
      return;
    }

    if (paymentAmount == 0) {
      _log('[Flutter] ERROR: Payment amount not available');
      _showDialog('Error', 'Payment amount is unknown. Cannot process refund.');
      return;
    }

    _log('=================================================================');
    _log('[Flutter] REQUESTING REFUND');
    _log('=================================================================');
    _log('[Flutter] Payment ID to refund: $paymentId');
    _log('[Flutter] Refund amount (IQD): $paymentAmount');
    _log('[Flutter] Sending refund request to backend...');

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/payment/refund'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'paymentId': paymentId,
          'amount': paymentAmount,
        }),
      );

      _log('[Flutter] Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _log('[Flutter] SUCCESS: Refund response received');
        _log('[Flutter] Response data: $data');

        final status = data['status'];
        final resultStatus = data['resultStatus'];

        if (status == 'SUCCESS' || resultStatus == 'S') {
          _log('[Flutter] Refund processed successfully!');
          _log('[Flutter] Refund ID: ${data['refundId']}');
          _log('=================================================================\n');

          if (mounted) {
            _showDialog(
              'Refund Successful',
              'Your refund has been processed successfully.',
            );
          }
        } else if (status == 'PENDING' || resultStatus == 'U') {
          _log('[Flutter] Refund is pending/unknown');
          _log('[Flutter] Backend will poll for status');
          _log('=================================================================\n');

          if (mounted) {
            _showDialog(
              'Refund Pending',
              'Your refund is being processed. Please check back later.',
            );
          }
        } else if (status == 'FAILED' || resultStatus == 'F') {
          _log('[Flutter] Refund failed');
          _log('[Flutter] Error: ${data['errorCode'] ?? data['resultMessage']}');
          _log('=================================================================\n');

          if (mounted) {
            _showDialog(
              'Refund Failed',
              data['resultMessage'] ?? 'Refund request failed. Please try again.',
            );
          }
        } else {
          _log('[Flutter] Unknown refund status: $data');
          _log('=================================================================\n');

          if (mounted) {
            _showDialog(
              'Refund Status Unknown',
              'Received unknown status from backend.',
            );
          }
        }
      } else {
        final errorText = response.body;
        _log('[Flutter] ERROR: Server returned status ${response.statusCode}');
        _log('[Flutter] Response: $errorText');
        _log('=================================================================\n');

        if (mounted) {
          _showDialog(
            'Error',
            'Failed to process refund request.\nStatus: ${response.statusCode}',
          );
        }
      }
    } catch (error) {
      _log('[Flutter] ERROR: Failed to request refund');
      _log('[Flutter] Error details: $error');
      _log('=================================================================\n');

      if (mounted) {
        _showDialog(
          'Error',
          'Failed to process refund request. Please try again.',
        );
      }
    }
  }

  void _showDialog(String title, String content) {
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
      body: Column(
        children: [
          // Buttons Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Get Auth Code Button (Yellow)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  onPressed: _getAuthCode,
                  child: const Text('Get Auth Code'),
                ),
                const SizedBox(height: 12),

                // Apply Token Button (Red)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[400],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  onPressed: _applyToken,
                  child: const Text('Apply Token'),
                ),
                const SizedBox(height: 12),

                // Pay Button (Purple)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple[300],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  onPressed: _createPayment,
                  child: const Text('Pay'),
                ),
                const SizedBox(height: 12),

                // Refund Button (Orange)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange[500],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  onPressed: _requestRefund,
                  child: const Text('Refund'),
                ),
              ],
            ),
          ),

          // Console/Log Section
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListView.builder(
                itemCount: logs.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text(
                      logs[index],
                      style: const TextStyle(
                        color: Colors.greenAccent,
                        fontFamily: 'monospace',
                        fontSize: 12,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
