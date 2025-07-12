import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SimulatePaymentScreen extends StatefulWidget {
  const SimulatePaymentScreen({super.key});

  @override
  State<SimulatePaymentScreen> createState() => _SimulatePaymentScreenState();
}

class _SimulatePaymentScreenState extends State<SimulatePaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final storage = FlutterSecureStorage();

  final TextEditingController _amount = TextEditingController();
  final TextEditingController _receiver = TextEditingController();
  String _method = 'UPI';
  String _status = 'success';

  Future<void> submitPayment() async {
    final token = await storage.read(key: 'jwt');
    final url = Uri.parse('http://localhost:3000/payments');

    final body = {
      "amount": double.tryParse(_amount.text.trim()) ?? 0,
      "method": _method,
      "receiver": _receiver.text.trim(),
      "status": _status,
    };

    try {
      final res = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(body),
      );

      if (res.statusCode == 201 || res.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Payment simulated successfully")),
        );
        _formKey.currentState?.reset();
      } else {
        throw Exception("Failed to create payment");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Something went wrong")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Simulate Payment")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _amount,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Amount"),
                validator: (val) => val == null || val.isEmpty ? "Enter amount" : null,
              ),
              TextFormField(
                controller: _receiver,
                decoration: const InputDecoration(labelText: "Receiver"),
                validator: (val) => val == null || val.isEmpty ? "Enter receiver" : null,
              ),
              DropdownButtonFormField(
                value: _method,
                items: ['UPI', 'Card', 'NetBanking'].map((method) {
                  return DropdownMenuItem(value: method, child: Text(method));
                }).toList(),
                onChanged: (val) => setState(() => _method = val.toString()),
                decoration: const InputDecoration(labelText: "Payment Method"),
              ),
              DropdownButtonFormField(
                value: _status,
                items: ['success', 'failed', 'pending'].map((status) {
                  return DropdownMenuItem(value: status, child: Text(status));
                }).toList(),
                onChanged: (val) => setState(() => _status = val.toString()),
                decoration: const InputDecoration(labelText: "Status"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    submitPayment();
                  }
                },
                child: const Text("Submit Payment"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
