# flutter_hylid_bridge

A Flutter wrapper for the Hylid-Bridge JavaScript SDK.

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_hylid_bridge: ^0.0.1
```

Then run:

```bash
flutter pub get
```

## Usage

### Basic Setup

No setup required! Just import and use:

```dart
import 'package:flutter_hylid_bridge/hylid_bridge.dart';
```

The Hylid Bridge JavaScript library will be automatically loaded when you use any API method on web platforms.

### my.tradePay

Process a payment using the `tradePay` function:

```dart
import 'package:flutter_hylid_bridge/hylid_bridge.dart';

await tradePay(
  paymentUrl: 'https://your-payment-url.com/pay?params=...',
  success: (TradePayResult result) {
    print('Payment successful: ${result.resultCode?.toDart}');
  },
  fail: (TradePayResult result) {
    print('Payment failed: ${result.resultCode?.toDart}');
  },
  complete: (TradePayResult result) {
    print('Payment completed');
  },
);
```

### my.getAuthCode

Get an authorization code:

```dart
import 'package:flutter_hylid_bridge/hylid_bridge.dart';

await getAuthCode(
  scopes: ['auth_user', 'auth_profile'],
  success: (AuthCodeResult result) {
    final authCode = result.authCode?.toDart;
    print('Auth code: $authCode');
  },
  fail: () {
    print('Authentication failed');
  },
  complete: () {
    print('Authentication flow completed');
  },
);
```

### my.alert

Display a native-style alert:

```dart
import 'package:flutter_hylid_bridge/hylid_bridge.dart';

await alert(
  title: 'Success',
  content: 'Your operation was successful!',
  buttonText: 'OK',
  success: () {
    print('User clicked OK');
  },
);
```

### Organized Imports

You can import specific categories instead of everything:

```dart
// Import only payment APIs
import 'package:flutter_hylid_bridge/payment.dart';

// Import only authentication APIs
import 'package:flutter_hylid_bridge/auth.dart';

// Import only UI APIs
import 'package:flutter_hylid_bridge/ui.dart';
```

## Platform Support

| Platform | Support |
|----------|---------|
| Web      | ✓       |
| Android  | -       |
| iOS      | -       |
| macOS    | -       |
| Windows  | -       |
| Linux    | -       |

The package is designed for web platforms where the Hylid Bridge JavaScript SDK operates. On non-web platforms, all methods will execute without errors but won't perform any actions.

## How It Works

### Automatic Script Injection

When you use any API method on web, the package will automatically checks if the Hylid Bridge script is loaded. If not loaded, it injects the script tag into the DOM

## API Reference

### Payment

#### `tradePay`

```dart
Future<void> tradePay({
  String? paymentUrl,
  void Function(TradePayResult result)? success,
  void Function(TradePayResult result)? fail,
  void Function(TradePayResult result)? complete,
})
```

Process a payment transaction.

**Parameters:**
- `paymentUrl`: The payment URL provided by your backend
- `success`: Called when payment succeeds
- `fail`: Called when payment fails
- `complete`: Called when payment flow completes (success or fail)

### Authentication

#### `getAuthCode`

```dart
Future<void> getAuthCode({
  required List<String> scopes,
  void Function(AuthCodeResult result)? success,
  void Function()? fail,
  void Function()? complete,
})
```

Request an authorization code with specified scopes.

**Parameters:**
- `scopes`: List of authorization scopes to request
- `success`: Called with the auth code on success
- `fail`: Called when authorization fails
- `complete`: Called when authorization flow completes

### UI

#### `alert`

```dart
Future<void> alert({
  String? title,
  String? content,
  String? buttonText,
  void Function()? success,
  void Function()? fail,
  void Function()? complete,
})
```

Display a native-style alert dialog.

**Parameters:**
- `title`: Alert title
- `content`: Alert message
- `buttonText`: Text for the button (default: "OK")
- `success`: Called when user dismisses the alert
- `fail`: Called if alert fails to display
- `complete`: Called when alert flow completes

## Example

See the [example](example) directory for a complete sample app demonstrating all features.

## Important Notes

- All API methods are asynchronous and return `Future<void>`
- Make sure to `await` the calls or handle the Future properly
- On web, the Hylid Bridge script is loaded from: `https://cdn.marmot-cloud.com/npm/hylid-bridge/2.10.0/index.js`
- Callbacks receive JavaScript interop types - use `.toDart` to convert to Dart types

## License

MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome through PRs!