import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Pagination + Filters
int currentPage = 0;
final int pageSize = 10;
bool hasMore = true;
String statusFilter = 'all';
String methodFilter = 'all';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final storage = FlutterSecureStorage();
  List<dynamic> transactions = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    setState(() => loading = true);

    final token = await storage.read(key: 'jwt');

    final filters = {
      'limit': pageSize.toString(),
      'offset': (currentPage * pageSize).toString(),
      if (statusFilter != 'all') 'status': statusFilter,
      if (methodFilter != 'all') 'method': methodFilter,
    };

    final url = Uri.parse('http://localhost:3000/payments')
        .replace(queryParameters: filters);

    try {
      final res = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
      });

      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        setState(() {
          transactions = data;
          hasMore = data.length == pageSize;
          loading = false;
        });
      }
    } catch (e) {
      print("Fetch error: $e");
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Transactions")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // 🔽 Filter Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DropdownButton<String>(
                        value: statusFilter,
                        items: ['all', 'success', 'failed', 'pending']
                            .map((value) => DropdownMenuItem(
                                value: value, child: Text(value)))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            statusFilter = val!;
                            currentPage = 0;
                          });
                          fetchTransactions();
                        },
                      ),
                      DropdownButton<String>(
                        value: methodFilter,
                        items: ['all', 'UPI', 'Card', 'NetBanking']
                            .map((value) => DropdownMenuItem(
                                value: value, child: Text(value)))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            methodFilter = val!;
                            currentPage = 0;
                          });
                          fetchTransactions();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // 🔽 Transaction List
                  Expanded(
                    child: ListView.builder(
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        final txn = transactions[index];
                        return ListTile(
                          title: Text("${txn['receiver']} - ₹${txn['amount']}"),
                          subtitle:
                              Text("${txn['method']} | ${txn['status']}"),
                          trailing: Text(
                            DateTime.parse(txn['timestamp'])
                                .toLocal()
                                .toString()
                                .split(".")[0],
                            style: const TextStyle(fontSize: 12),
                          ),
                        );
                      },
                    ),
                  ),

                  // 🔽 Pagination Buttons
                  if (transactions.isNotEmpty)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: currentPage > 0
                              ? () {
                                  setState(() => currentPage--);
                                  fetchTransactions();
                                }
                              : null,
                          child: const Text("Previous"),
                        ),
                        Text("Page ${currentPage + 1}"),
                        ElevatedButton(
                          onPressed: hasMore
                              ? () {
                                  setState(() => currentPage++);
                                  fetchTransactions();
                                }
                              : null,
                          child: const Text("Next"),
                        ),
                      ],
                    ),
                ],
              ),
            ),
    );
  }
}
