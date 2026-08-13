name: lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/driver_custody_provider.dart';
import 'screens/driver_custody_screen.dart';

void main() {
  runApp(const DriverCustodyApp());
}

class DriverCustodyApp extends StatelessWidget {
  const DriverCustodyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DriverCustodyProvider()..load(),
      child: MaterialApp(
        title: 'Driver Financial Custody',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          useMaterial3: true,
        ),
        home: const DashboardScreen(),
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: DriverCustodyScreen(),
      ),
    );
  }
}
