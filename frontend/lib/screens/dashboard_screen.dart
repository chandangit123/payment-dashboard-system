import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final storage = FlutterSecureStorage();
  double revenueToday = 0;
  int failedTxns = 0;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchStats();
  }

  Future<void> fetchStats() async {
    final token = await storage.read(key: 'jwt');
    final url = Uri.parse('http://localhost:3000/payments/stats');

    try {
      final res = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
      });

      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        setState(() {
          revenueToday = data['todayRevenue'].toDouble();
          failedTxns = data['failedTransactions'];
          loading = false;
        });
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  List<FlSpot> mockChartData() {
    return [
      FlSpot(1, 100),
      FlSpot(2, 250),
      FlSpot(3, 300),
      FlSpot(4, 150),
      FlSpot(5, 400),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await storage.delete(key: 'jwt');
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Today's Revenue: ₹$revenueToday",
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Failed Transactions: $failedTxns",
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 30),
                  const Text("Revenue Trend", style: TextStyle(fontSize: 20)),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 200,
                    child: LineChart(
                      LineChartData(
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: true),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: true),
                          ),
                        ),
                        borderData: FlBorderData(show: true),
                        lineBarsData: [
                          LineChartBarData(
                            isCurved: true,
                            spots: mockChartData(),
                            barWidth: 3,
                            dotData: FlDotData(show: true),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/simulate'),
                    child: const Text("Simulate Payment"),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/transactions'),
                    child: const Text("View Transactions"),
                  ),
                  ElevatedButton(
  onPressed: () => Navigator.pushNamed(context, '/users'),
  child: const Text("Manage Users"),
),

                ],
              ),
            ),
    );
  }
}
