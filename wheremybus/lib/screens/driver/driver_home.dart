import 'package:flutter/material.dart';

class DriverHome extends StatefulWidget {
  final String busId;
  final String busName; // 👈 Added bus name
  DriverHome({required this.busId, required this.busName});

  @override
  State<DriverHome> createState() => _DriverHomeState();
}

class _DriverHomeState extends State<DriverHome> {
  bool isSharing = false;

  void startSharing() {
    setState(() => isSharing = true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Started sharing location..."),
        backgroundColor: Colors.green,
      ),
    );
  }

  void stopSharing() {
    setState(() => isSharing = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Arrived at last stop. Location sharing stopped."),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF1976D2);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: primaryBlue,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Driver Dashboard",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          // 🚍 Header with gradient background
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(24),
            margin: EdgeInsets.only(top: 12), // gap below AppBar
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryBlue, primaryBlue.withOpacity(0.85)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.directions_bus, size: 72, color: Colors.white),
                SizedBox(height: 16),

                // 🆔 Bus Info card with curved corners
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  margin: EdgeInsets.only(top: 4, bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24), // 👈 more curved corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Bus ID: ${widget.busId}",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: primaryBlue,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Bus Name: ${widget.busName}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),

                // Status pill
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSharing ? Colors.green : Colors.redAccent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isSharing
                        ? "Active - Sharing Live Location"
                        : "Inactive - Ride not started",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 40),

          // 🚦 Action buttons
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  // Start Bus Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.play_arrow, color: Colors.white),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isSharing ? Colors.grey : primaryBlue,
                        padding: EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                      ),
                      onPressed: isSharing ? null : startSharing,
                      label: Text(
                        "Start Bus",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // End Ride Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.stop, color: Colors.white),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isSharing ? Colors.redAccent : Colors.grey,
                        padding: EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                      ),
                      onPressed: isSharing ? stopSharing : null,
                      label: Text(
                        "End Ride",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),

                  // Status text
                  AnimatedOpacity(
                    opacity: isSharing ? 1.0 : 0.6,
                    duration: Duration(milliseconds: 300),
                    child: Text(
                      isSharing
                          ? "✅ Live location sharing is ACTIVE."
                          : "⚠️ Start ride to begin sharing location.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: isSharing ? Colors.green[700] : Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
