import 'package:flutter/material.dart';
import 'driver_home.dart';

class SelectBusScreen extends StatefulWidget {
  @override
  State<SelectBusScreen> createState() => _SelectBusScreenState();
}

class _SelectBusScreenState extends State<SelectBusScreen> {
  final List<Map<String, String>> busList = [
    {"id": "101", "name": "City Express"},
    {"id": "202", "name": "Metro Rider"},
    {"id": "303", "name": "Downtown Shuttle"},
    {"id": "404", "name": "School Bus"},
    {"id": "505", "name": "Airport Link"},
    {"id": "606", "name": "Night Rider"},
    {"id": "707", "name": "Eco Bus"},
    {"id": "808", "name": "Rapid Transit"},
    {"id": "909", "name": "Highway Star"},
  ];

  String searchText = "";
  Map<String, String>? selectedBus;

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF1976D2);

    List<Map<String, String>> filteredBusList = busList
        .where((bus) =>
            bus["id"]!.toLowerCase().contains(searchText.toLowerCase()) ||
            bus["name"]!.toLowerCase().contains(searchText.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Select Your Bus"),
        backgroundColor: primaryBlue,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 🔍 Search Bar
            TextField(
              decoration: InputDecoration(
                labelText: "Search Bus",
                prefixIcon: Icon(Icons.search, color: primaryBlue),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                setState(() => searchText = value);
              },
            ),
            SizedBox(height: 20),

            // 📋 Bus List
            Expanded(
              child: ListView.builder(
                itemCount: filteredBusList.length,
                itemBuilder: (context, index) {
                  final bus = filteredBusList[index];
                  final isSelected = selectedBus == bus;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedBus = bus;
                      });
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: isSelected
                            ? BorderSide(color: primaryBlue, width: 2)
                            : BorderSide.none,
                      ),
                      elevation: 3,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        leading: CircleAvatar(
                          radius: 24,
                          backgroundColor: primaryBlue.withOpacity(0.15),
                          child: Icon(Icons.directions_bus,
                              color: primaryBlue, size: 28),
                        ),
                        title: Text(
                          "Bus ${bus["id"]}",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: primaryBlue,
                          ),
                        ),
                        subtitle: Text(
                          bus["name"]!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                        trailing: isSelected
                            ? Icon(Icons.check_circle, color: Colors.green)
                            : null,
                      ),
                    ),
                  );
                },
              ),
            ),

            // 🚀 Continue Button
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      selectedBus != null ? primaryBlue : Colors.grey,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: selectedBus == null
                    ? null
                    : () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DriverHome(
                              busId: selectedBus!["id"]!,
                              busName: selectedBus!["name"]!,
                            ),
                          ),
                        );
                      },
                child: Text(
                  "Continue",
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
