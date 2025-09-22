import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'driver_bus_details.dart';

class DriverSignup extends StatefulWidget {
  @override
  _DriverSignupState createState() => _DriverSignupState();
}

class _DriverSignupState extends State<DriverSignup> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();
  final TextEditingController licenseCtrl = TextEditingController();

  bool _obscurePassword = true;
  String? _licenseDoc;   // Driver license file
  String? _permitDoc;    // Bus permit file

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    passCtrl.dispose();
    licenseCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDocument(bool isLicense) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        if (isLicense) {
          _licenseDoc = result.files.single.path!;
        } else {
          _permitDoc = result.files.single.path!;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF1976D2);
    const accentBlue = Color(0xFF1565C0);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 24),
            padding: EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 16,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.assignment_ind, size: 64, color: primaryBlue),
                  SizedBox(height: 16),
                  Text(
                    "Register as Driver",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: primaryBlue,
                    ),
                  ),
                  SizedBox(height: 32),

                  // Full Name
                  TextFormField(
                    controller: nameCtrl,
                    decoration: InputDecoration(
                      labelText: "Full Name",
                      prefixIcon: Icon(Icons.person, color: accentBlue),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? "Enter your name" : null,
                  ),
                  SizedBox(height: 20),

                  // Email
                  TextFormField(
                    controller: emailCtrl,
                    decoration: InputDecoration(
                      labelText: "Email",
                      prefixIcon: Icon(Icons.email, color: accentBlue),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return "Enter your email";
                      if (!value.contains('@')) return "Enter a valid email";
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 20),

                  // Password
                  TextFormField(
                    controller: passCtrl,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon: Icon(Icons.lock, color: accentBlue),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility : Icons.visibility_off,
                          color: accentBlue,
                        ),
                        onPressed: () {
                          setState(() => _obscurePassword = !_obscurePassword);
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                    validator: (value) =>
                        value == null || value.length < 6
                            ? "Password must be at least 6 chars"
                            : null,
                  ),
                  SizedBox(height: 20),

                  // License Number
                  TextFormField(
                    controller: licenseCtrl,
                    decoration: InputDecoration(
                      labelText: "License Number",
                      prefixIcon: Icon(Icons.badge, color: accentBlue),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? "Enter your license number" : null,
                  ),
                  SizedBox(height: 20),

                  // Driver License Document Upload
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Upload Driver License",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: accentBlue,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  OutlinedButton.icon(
                    icon: Icon(Icons.upload_file, color: primaryBlue),
                    label: Text(
                      _licenseDoc == null
                          ? "Choose File"
                          : "Selected: ${_licenseDoc!.split('/').last}",
                      overflow: TextOverflow.ellipsis,
                    ),
                    onPressed: () => _pickDocument(true),
                  ),
                  SizedBox(height: 20),

                  // Bus Permit Document Upload
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Upload Bus Permit Document",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: accentBlue,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  OutlinedButton.icon(
                    icon: Icon(Icons.upload_file, color: primaryBlue),
                    label: Text(
                      _permitDoc == null
                          ? "Choose File"
                          : "Selected: ${_permitDoc!.split('/').last}",
                      overflow: TextOverflow.ellipsis,
                    ),
                    onPressed: () => _pickDocument(false),
                  ),
                  SizedBox(height: 28),

                  // Register button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBlue,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate() &&
                            _licenseDoc != null &&
                            _permitDoc != null) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SelectBusScreen(),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  "Please upload both Driver License and Bus Permit documents"),
                            ),
                          );
                        }
                      },
                      child: Text(
                        "Register",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 12),

                  // Back to login
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // back to login
                    },
                    child: Text(
                      "Already have an account? Login",
                      style: TextStyle(color: accentBlue),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
