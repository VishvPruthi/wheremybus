import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class BusDetailsPage extends StatefulWidget {
  final Map<String, dynamic> bus;

  BusDetailsPage({required this.bus});

  @override
  _BusDetailsPageState createState() => _BusDetailsPageState();
}

class _BusDetailsPageState extends State<BusDetailsPage> {
  List<dynamic> routeStops = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRouteDetails();
  }

  Future<void> fetchRouteDetails() async {
    try {
      final url =
          "http://10.0.2.2:5000/api/buses/${widget.bus['busId']}/route";
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          routeStops = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching route details: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget buildStopTile(Map<String, dynamic> stop, bool isFirst, bool isLast) {
    final bool isCurrent = stop['isCurrent'] ?? false;

    // Colors for stop type
    final Color stopColor = isCurrent
        ? Colors.red
        : (isFirst ? Colors.green : Colors.blue);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline column
        Column(
          children: [
            if (!isFirst)
              Container(height: 20, width: 2, color: Colors.grey[400]),
            CircleAvatar(
              radius: 10,
              backgroundColor: stopColor,
              child: Icon(
                Icons.directions_bus,
                size: 14,
                color: Colors.white,
              ),
            ),
            if (!isLast)
              Container(height: 40, width: 2, color: Colors.grey[400]),
          ],
        ),
        SizedBox(width: 12),

        // Stop card
        Expanded(
          child: Card(
            elevation: isCurrent ? 4 : 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: isCurrent ? Colors.white : Colors.grey[100],
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stop name
                  Text(
                    stop['stopName'],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                          isCurrent ? FontWeight.bold : FontWeight.w600,
                      color: isCurrent ? Colors.red[700] : Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),

                  // Two-column row
                  Row(
                    children: [
                      // Distance
                      Expanded(
                        child: Text(
                          "Distance: ${stop['distance']}",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),

                      // Time + ETA stacked
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Time: ${stop['time']}",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "ETA: ${stop['eta'] ?? '--'}",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: isCurrent
                                    ? Colors.red
                                    : Colors.green[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bus = widget.bus;
    const primaryBlue = Color(0xFF1976D2);

    return Scaffold(
      appBar: AppBar(
        title: Text(bus['busName'], style: TextStyle(color: Colors.white)),
        backgroundColor: primaryBlue,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : routeStops.isEmpty
              ? Center(child: Text("No route details available"))
              : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: routeStops.length,
                  itemBuilder: (context, index) {
                    return buildStopTile(
                      routeStops[index],
                      index == 0,
                      index == routeStops.length - 1,
                    );
                  },
                ),
    );
  }
}
