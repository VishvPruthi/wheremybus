import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async'; // for Timer
import 'passenger_bus_tracking.dart';

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
  Timer? refreshTimer;

  @override
  void initState() {
    super.initState();
    fetchBuses();

    // Auto-refresh every 10 seconds
    refreshTimer = Timer.periodic(Duration(seconds: 10), (timer) {
      fetchBuses();
    });
  }

  @override
  void dispose() {
    refreshTimer?.cancel(); // stop timer when leaving page
    super.dispose();
  }

  Future<void> fetchBuses() async {
    try {
      final url =
          "http://10.0.2.2:5000/api/buses/search?source=${widget.from}&destination=${widget.to}";
      final response = await http.get(Uri.parse(url));

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

  Widget buildBusCard(bus) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BusDetailsPage(bus: bus),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row: BusId + Time + Runs Daily
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Bus ID badge
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue[700],
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      bus['busId'].toString(),
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(width: 12),
                  // Time
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87),
                        children: [
                          TextSpan(text: bus['departureTime']),
                          TextSpan(
                            text: " ➝ ",
                            style: TextStyle(
                                color: Colors.blue[700],
                                fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: bus['arrivalTime']),
                        ],
                      ),
                    ),
                  ),
                  // Runs Daily badge
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green[600],
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      "Runs Daily",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 6),

              // Bus Name
              Text(
                bus['busName'],
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF1976D2);

    return Scaffold(
      appBar: AppBar(
        title: Text("Available Buses", style: TextStyle(color: Colors.white)),
        backgroundColor: primaryBlue,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : buses.isEmpty
              ? Center(child: Text("No buses found for this route"))
              : RefreshIndicator( // manual pull to refresh
                  onRefresh: fetchBuses,
                  child: ListView.builder(
                    itemCount: buses.length,
                    itemBuilder: (context, index) {
                      return buildBusCard(buses[index]);
                    },
                  ),
                ),
    );
  }
}
