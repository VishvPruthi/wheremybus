import 'package:flutter/material.dart';
import 'passenger_bus_list.dart';

class PassengerHome extends StatefulWidget {
  @override
  _PassengerHomeState createState() => _PassengerHomeState();
}

class _PassengerHomeState extends State<PassengerHome> {
  final TextEditingController fromCtrl = TextEditingController();
  final TextEditingController toCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF1976D2);

    return Scaffold(
      appBar: AppBar(
        title: Text("Where is my Bus"),
        backgroundColor: primaryBlue,
      ),

      // 👇 Drawer added
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: primaryBlue),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Home"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Settings"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text("About"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // From stop
            TextField(
              controller: fromCtrl,
              decoration: InputDecoration(
                labelText: "From Stop",
                prefixIcon: Icon(Icons.directions_bus, color: primaryBlue),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            SizedBox(height: 16),

            // To stop
            TextField(
              controller: toCtrl,
              decoration: InputDecoration(
                labelText: "To Stop",
                prefixIcon: Icon(Icons.location_on, color: primaryBlue),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey[100],
              ),
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
                    borderRadius: BorderRadius.circular(12),
                  ),
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
                label: Text(
                  "Find Buses",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}
