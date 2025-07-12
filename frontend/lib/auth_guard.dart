import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthGuard extends StatefulWidget {
  final Widget child;
  const AuthGuard({required this.child, super.key});

  @override
  State<AuthGuard> createState() => _AuthGuardState();
}

class _AuthGuardState extends State<AuthGuard> {
  final storage = const FlutterSecureStorage();
  bool? isAuthenticated;

  @override
  void initState() {
    super.initState();
    checkAuth();
  }

  Future<void> checkAuth() async {
    final jwt = await storage.read(key: 'jwt');
    if (mounted) {
      setState(() {
        isAuthenticated = jwt != null;
      });

      // Navigate to login if not authenticated
      if (jwt == null && mounted) {
        Navigator.pushReplacementNamed(context, '/');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isAuthenticated == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return widget.child;
  }
}
