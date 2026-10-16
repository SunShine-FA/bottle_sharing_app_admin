import 'package:bottle_sharing_app_admin/model/app_data.dart';
import 'package:bottle_sharing_app_admin/model/subadmin_model.dart';
import 'package:bottle_sharing_app_admin/view/items/confirm_dialog.dart';
import 'package:flutter/material.dart' hide BackButton;
import 'package:bottle_sharing_app_admin/view/items/back_button.dart';

class ScreenSubadminDetails extends StatefulWidget {
  final SubadminModel? subadmin;

  const ScreenSubadminDetails({super.key, this.subadmin});

  @override
  State<ScreenSubadminDetails> createState() => _ScreenSubadminDetailsState();
}

class _ScreenSubadminDetailsState extends State<ScreenSubadminDetails> {
  late SubadminModel subadmin;
  late SubadminPermissions permissions;
  bool hasChanges = false;

  @override
  void initState() {
    super.initState();
    subadmin = widget.subadmin ??
        SubadminModel(
          id: "sa1",
          name: "Jacob Jones",
          email: "jacob.admin@sharebottle.com",
          permissions: SubadminPermissions(
            shareStory: true,
            seeUser: true,
            sendNotification: true,
            blockUser: true,
            deleteUserPost: true,
          ),
        );
    permissions = subadmin.permissions.copyWith();
  }

  void _savePermissions() {
    AppData.instance.updateSubadminPermissions(subadmin.id, permissions);
    setState(() {
      hasChanges = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Permissions updated successfully."),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _confirmRemove() async {
    final confirmed = await ConfirmDialog.show(
      context: context,
      title: "Remove SubAdmin",
      message:
          "Are you sure you want to remove ${subadmin.name} as a SubAdmin? They will immediately lose all administrative rights.",
      confirmText: "Remove",
      confirmColor: Colors.red,
      icon: Icons.person_remove_outlined,
    );

    if (confirmed && mounted) {
      AppData.instance.removeSubadmin(subadmin.id);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${subadmin.name} removed from SubAdmins."),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BackButton(
        titleWidget: const Text(
          'SubAdmin Details',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 1, color: Colors.grey.shade200),

            // Profile Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.black,
                    child: Text(
                      subadmin.name.isNotEmpty
                          ? subadmin.name[0].toUpperCase()
                          : "A",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          subadmin.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subadmin.email,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Permissions Section Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              color: const Color(0xFFF7F8FA),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Role & Permissions",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  if (hasChanges)
                    GestureDetector(
                      onTap: _savePermissions,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          "Save Changes",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            _buildPermissionSwitch(
              title: "Share Story",
              subtitle: "Can publish new venue stories and club announcements",
              value: permissions.shareStory,
              onChanged: (val) {
                setState(() {
                  permissions.shareStory = val;
                  hasChanges = true;
                });
              },
            ),
            _buildPermissionSwitch(
              title: "See Users",
              subtitle: "Can view user directories, posts, and details",
              value: permissions.seeUser,
              onChanged: (val) {
                setState(() {
                  permissions.seeUser = val;
                  hasChanges = true;
                });
              },
            ),
            _buildPermissionSwitch(
              title: "Send Notification",
              subtitle: "Can dispatch broadcast push notifications",
              value: permissions.sendNotification,
              onChanged: (val) {
                setState(() {
                  permissions.sendNotification = val;
                  hasChanges = true;
                });
              },
            ),
            _buildPermissionSwitch(
              title: "Block User",
              subtitle: "Can suspend and block violating accounts",
              value: permissions.blockUser,
              onChanged: (val) {
                setState(() {
                  permissions.blockUser = val;
                  hasChanges = true;
                });
              },
            ),
            _buildPermissionSwitch(
              title: "Delete User Post",
              subtitle: "Can moderate and remove flagged bottle posts",
              value: permissions.deleteUserPost,
              onChanged: (val) {
                setState(() {
                  permissions.deleteUserPost = val;
                  hasChanges = true;
                });
              },
            ),

            const SizedBox(height: 40),

            // Remove SubAdmin Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: _confirmRemove,
                  child: const Text(
                    "Remove SubAdmin",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionSwitch({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.white,
            activeTrackColor: Colors.black,
            inactiveTrackColor: Colors.grey.shade200,
          ),
        ],
      ),
    );
  }
}
