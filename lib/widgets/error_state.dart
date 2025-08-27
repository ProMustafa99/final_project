import 'package:flutter/material.dart';

Widget buildErrorState(Function() onRetry) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: onRetry,
        icon: const Icon(Icons.refresh),
        label: const Text("Retry"),
      ),
    );
  }