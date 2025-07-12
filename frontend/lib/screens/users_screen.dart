import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final storage = FlutterSecureStorage();
  List users = [];
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String _role = 'viewer';
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    setState(() => loading = true);
    final token = await storage.read(key: 'jwt');

    final url = Uri.parse('http://localhost:3000/users');
    final res = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });

    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      setState(() {
        users = data;
        loading = false;
      });
    }
  }

  Future<void> createUser() async {
    final token = await storage.read(key: 'jwt');
    final url = Uri.parse('http://localhost:3000/users');

    final res = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          "username": _usernameController.text.trim(),
          "password": _passwordController.text.trim(),
          "role": _role
        }));

    if (res.statusCode == 201 || res.statusCode == 200) {
      _usernameController.clear();
      _passwordController.clear();
      setState(() => _role = 'viewer');
      fetchUsers();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("User created")));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Error creating user")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manage Users")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text("Create New User", style: TextStyle(fontSize: 18)),
                  TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(labelText: "Username"),
                  ),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: "Password"),
                  ),
                  DropdownButton<String>(
                    value: _role,
                    onChanged: (val) => setState(() => _role = val!),
                    items: ['admin', 'viewer']
                        .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                        .toList(),
                  ),
                  ElevatedButton(
                    onPressed: createUser,
                    child: const Text("Create User"),
                  ),
                  const SizedBox(height: 30),
                  const Text("User List", style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        return ListTile(
                          title: Text(user['username']),
                          subtitle: Text("Role: ${user['role']}"),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
