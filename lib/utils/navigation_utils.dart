import 'package:flutter/material.dart';

/// Pushes a route and returns the result.
/// Returns null if the user pops without a result.
Future<T?> pushAndAwaitResult<T>(
  BuildContext context,
  Widget destination,
) {
  return Navigator.push<T>(
    context,
    MaterialPageRoute(builder: (_) => destination),
  );
}

/// Pops the current route with an optional result.
void popWithResult<T>(BuildContext context, [T? result]) {
  Navigator.pop(context, result);
}

/// Shows a SnackBar with a given message.
void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}