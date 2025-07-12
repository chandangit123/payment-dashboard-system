import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/simulate_payment_screen.dart';
import 'screens/transactions_screen.dart';
import 'auth_guard.dart'; // You need to create this file below
import 'screens/users_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Payment Dashboard',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/dashboard': (context) => const AuthGuard(child: DashboardScreen()),
        '/simulate': (context) => const AuthGuard(child: SimulatePaymentScreen()),
        '/transactions': (context) => const AuthGuard(child: TransactionsScreen()),
        '/users': (context) => const AuthGuard(child: UsersScreen()),

      },
    );
  }
}
