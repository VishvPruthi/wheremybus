import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PassengerBusList extends StatefulWidget {
  final String from;
  final String to;

  PassengerBusList({required this.from, required this.to});

  @override
  _PassengerBusListState createState() => _PassengerBusListState();
}

class _PassengerBusListState extends State<PassengerBusList> {
  List<dynamic> buses = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBuses();
  }

  Future<void> fetchBuses() async {
    try {
      final response = await http.get(Uri.parse(
          "http://10.0.2.2:5000/searchBuses?from=${widget.from}&to=${widget.to}"));
          // 10.0.2.2 = localhost for Android Emulator
          // If testing on real device, replace with your PC IP (e.g., 192.168.x.x)

      if (response.statusCode == 200) {
        setState(() {
          buses = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching buses: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF1976D2);

    return Scaffold(
      appBar: AppBar(
        title: Text("Available Buses"),
        backgroundColor: primaryBlue,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : buses.isEmpty
              ? Center(child: Text("No buses found for this route"))
              : ListView.builder(
                  itemCount: buses.length,
                  itemBuilder: (context, index) {
                    final bus = buses[index];
                    return Card(
                      margin: EdgeInsets.all(12),
                      child: ListTile(
                        leading: Icon(Icons.directions_bus, color: primaryBlue),
                        title: Text("Bus ${bus['busId']}"),
                        subtitle: Text(
                          "Route: ${bus['route']}\nTime: ${bus['time']}",
                        ),
                        onTap: () {
                          // TODO: Navigate to bus live tracking page
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
