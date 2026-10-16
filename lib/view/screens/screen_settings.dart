import 'package:bottle_sharing_app_admin/model/app_data.dart';
import 'package:bottle_sharing_app_admin/view/items/confirm_dialog.dart';
import 'package:bottle_sharing_app_admin/view/screens/screen_login.dart';
import 'package:flutter/material.dart' hide BackButton;
import 'package:bottle_sharing_app_admin/view/items/back_button.dart';

class ScreenSettings extends StatefulWidget {
  const ScreenSettings({super.key});

  @override
  State<ScreenSettings> createState() => _ScreenSettingsState();
}

class _ScreenSettingsState extends State<ScreenSettings> {
  final AppData appData = AppData.instance;

  late TextEditingController nameController;
  late TextEditingController emailController;
  final TextEditingController currentPasswordController =
      TextEditingController(text: "admin123");
  final TextEditingController newPasswordController = TextEditingController();

  bool obscureCurrent = true;
  bool obscureNew = true;
  bool notifyNewUsers = true;
  bool notifyStoryReports = true;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: appData.adminName);
    emailController = TextEditingController(text: appData.adminEmail);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    super.dispose();
  }

  void _saveSettings() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();

    if (name.isEmpty) {
      _showSnack("Please enter your name.", isError: true);
      return;
    }

    if (email.isEmpty || !email.contains('@')) {
      _showSnack("Please enter a valid email address.", isError: true);
      return;
    }

    setState(() => isSaving = true);
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;

    appData.updateAdminProfile(name, email);

    setState(() => isSaving = false);
    _showSnack("Settings saved successfully.");
  }

  void _confirmSignOut() async {
    final confirmed = await ConfirmDialog.show(
      context: context,
      title: "Sign Out",
      message: "Are you sure you want to log out of the admin console?",
      confirmText: "Sign Out",
      confirmColor: Colors.black,
      icon: Icons.logout_rounded,
    );

    if (confirmed && mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const ScreenLogin()),
        (route) => false,
      );
    }
  }

  void _showSnack(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.black87,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const BackButton(
        titleWidget: Text(
          'Settings',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(height: 1, color: Colors.grey.shade200),
              const SizedBox(height: 24),

              // Admin Profile Card
              Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage("assets/images/profile.jpg"),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              appData.adminName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                "Super Admin",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          appData.adminEmail,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              const Text(
                "Profile Information",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                "Full Name",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person_outline, size: 20),
                ),
              ),

              const SizedBox(height: 18),

              const Text(
                "Email Address",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email_outlined, size: 20),
                ),
              ),

              const SizedBox(height: 28),

              const Text(
                "Security & Password",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                "Current Password",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: currentPasswordController,
                obscureText: obscureCurrent,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock_outline, size: 20),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureCurrent
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() => obscureCurrent = !obscureCurrent);
                    },
                  ),
                ),
              ),

              const SizedBox(height: 18),

              const Text(
                "New Password",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: newPasswordController,
                obscureText: obscureNew,
                decoration: InputDecoration(
                  hintText: "Leave blank to keep current password",
                  prefixIcon: const Icon(Icons.lock_reset, size: 20),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureNew
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() => obscureNew = !obscureNew);
                    },
                  ),
                ),
              ),

              const SizedBox(height: 28),

              const Text(
                "Admin Notification Preferences",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),

              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text("New User Registrations",
                    style: TextStyle(fontSize: 14)),
                subtitle: Text("Receive alerts when new members sign up",
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                value: notifyNewUsers,
                activeTrackColor: Colors.black,
                activeThumbColor: Colors.white,
                onChanged: (val) => setState(() => notifyNewUsers = val),
              ),

              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text("Post Moderation Reports",
                    style: TextStyle(fontSize: 14)),
                subtitle: Text("Get notified when posts or stories are reported",
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                value: notifyStoryReports,
                activeTrackColor: Colors.black,
                activeThumbColor: Colors.white,
                onChanged: (val) => setState(() => notifyStoryReports = val),
              ),

              const SizedBox(height: 36),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: isSaving ? null : _saveSettings,
                  child: isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          "Save Changes",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 16),

              // Sign Out Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: _confirmSignOut,
                  icon: const Icon(Icons.logout, color: Colors.red, size: 18),
                  label: const Text(
                    "Sign Out",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
