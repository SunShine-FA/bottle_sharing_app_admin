import 'package:bottle_sharing_app_admin/model/app_data.dart';
import 'package:bottle_sharing_app_admin/model/subadmin_model.dart';
import 'package:flutter/material.dart' hide BackButton;
import 'package:bottle_sharing_app_admin/view/items/back_button.dart';

class ScreenAddSubadmin extends StatefulWidget {
  const ScreenAddSubadmin({super.key});

  @override
  State<ScreenAddSubadmin> createState() => _ScreenAddSubadminState();
}

class _ScreenAddSubadminState extends State<ScreenAddSubadmin> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool obscurePassword = true;
  bool isCreating = false;

  final SubadminPermissions permissions = SubadminPermissions(
    shareStory: true,
    seeUser: true,
    sendNotification: false,
    blockUser: false,
    deleteUserPost: true,
  );

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _handleAddSubadmin() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (name.isEmpty) {
      _showError("Please enter the subadmin's full name.");
      return;
    }
    if (email.isEmpty || !email.contains('@')) {
      _showError("Please enter a valid email address.");
      return;
    }
    if (password.length < 6) {
      _showError("Password must be at least 6 characters.");
      return;
    }

    setState(() {
      isCreating = true;
    });

    final newSubadmin = SubadminModel(
      id: "sa_${DateTime.now().millisecondsSinceEpoch}",
      name: name,
      email: email,
      permissions: permissions,
    );

    AppData.instance.addSubadmin(newSubadmin);

    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;

    setState(() {
      isCreating = false;
    });

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  size: 40,
                  color: Colors.green.shade700,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                "SubAdmin Added!",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "$name has been granted administrative access.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                  },
                  child: const Text("Done"),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (mounted) {
      Navigator.pop(context);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
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
          'Add Sub Admin',
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

              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F4FA),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade300, width: 1.5),
                  ),
                  child: const Icon(
                    Icons.person_add_alt_1_rounded,
                    size: 38,
                    color: Colors.black87,
                  ),
                ),
              ),

              const SizedBox(height: 28),

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
                  hintText: "e.g. Sarah Jenkins",
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
                  hintText: "sarah.jenkins@sharebottle.com",
                  prefixIcon: Icon(Icons.email_outlined, size: 20),
                ),
              ),

              const SizedBox(height: 18),

              const Text(
                "Temporary Password",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: passwordController,
                obscureText: obscurePassword,
                decoration: InputDecoration(
                  hintText: "Minimum 6 characters",
                  prefixIcon: const Icon(Icons.lock_outline, size: 20),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 28),

              const Text(
                "Initial Permissions",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),

              _buildCheckboxTile("Share Story", permissions.shareStory, (v) {
                setState(() => permissions.shareStory = v ?? false);
              }),
              _buildCheckboxTile("See Users", permissions.seeUser, (v) {
                setState(() => permissions.seeUser = v ?? false);
              }),
              _buildCheckboxTile(
                  "Send Notification", permissions.sendNotification, (v) {
                setState(() => permissions.sendNotification = v ?? false);
              }),
              _buildCheckboxTile("Block User", permissions.blockUser, (v) {
                setState(() => permissions.blockUser = v ?? false);
              }),
              _buildCheckboxTile(
                  "Delete User Post", permissions.deleteUserPost, (v) {
                setState(() => permissions.deleteUserPost = v ?? false);
              }),

              const SizedBox(height: 36),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: isCreating ? null : _handleAddSubadmin,
                  child: isCreating
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          "Add SubAdmin",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
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

  Widget _buildCheckboxTile(
      String title, bool value, ValueChanged<bool?> onChanged) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Checkbox(
              value: value,
              activeColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              onChanged: onChanged,
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
