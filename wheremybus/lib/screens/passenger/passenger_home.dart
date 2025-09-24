import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'passenger_bus_list.dart';

class PassengerHome extends StatefulWidget {
  @override
  _PassengerHomeState createState() => _PassengerHomeState();
}

class _PassengerHomeState extends State<PassengerHome> {
  final TextEditingController fromCtrl = TextEditingController();
  final TextEditingController toCtrl = TextEditingController();

  // Example bus stops (later you can fetch from backend)
  final List<String> busStops = [
    "Delhi",
    "Gurgaon",
    "Rohtak",
    "Jhajjar",
    "Chandigarh",
    "Hisar",
    "Panipat",
    "Haridwar",
    "Sonipat",
    "Bahadurgarh",
    "Sampla",
    "Dighal",
    "Dujana",
  ];

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF1976D2);

    return Scaffold(
      appBar: AppBar(
        title: Text("Where is my Bus", style: TextStyle(color: Colors.white)),
        backgroundColor: primaryBlue,
        iconTheme: IconThemeData(color: Colors.white),
        actionsIconTheme: IconThemeData(color: Colors.white),
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: primaryBlue),
              child: Text('Menu',
                  style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Home"),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Settings"),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text("About"),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // From stop with styled suggestions
            TypeAheadField<String>(
              builder: (context, controller, focusNode) {
                return TextField(
                  controller: fromCtrl,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    labelText: "From Stop",
                    prefixIcon: Icon(Icons.directions_bus, color: primaryBlue),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                );
              },
              suggestionsCallback: (pattern) async {
                return busStops
                    .where((stop) =>
                        stop.toLowerCase().contains(pattern.toLowerCase()))
                    .toList();
              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                  leading: Icon(Icons.location_city, color: primaryBlue),
                  title: Text(
                    suggestion,
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text("Bus stop"),
                );
              },
              onSelected: (suggestion) {
                fromCtrl.text = suggestion;
              },
            ),

            SizedBox(height: 16),

            // To stop with styled suggestions
            TypeAheadField<String>(
              builder: (context, controller, focusNode) {
                return TextField(
                  controller: toCtrl,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    labelText: "To Stop",
                    prefixIcon: Icon(Icons.location_on, color: primaryBlue),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                );
              },
              suggestionsCallback: (pattern) async {
                return busStops
                    .where((stop) =>
                        stop.toLowerCase().contains(pattern.toLowerCase()))
                    .toList();
              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                  leading: Icon(Icons.place, color: Colors.green),
                  title: Text(
                    suggestion,
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text("Destination stop"),
                );
              },
              onSelected: (suggestion) {
                toCtrl.text = suggestion;
              },
            ),

            SizedBox(height: 24),

            // Find buses button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PassengerBusList(
                        from: fromCtrl.text,
                        to: toCtrl.text,
                      ),
                    ),
                  );
                },
                icon: Icon(Icons.search, color: Colors.white),
                label: Text("Find Buses",
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
