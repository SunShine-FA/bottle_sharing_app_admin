import 'package:bottle_sharing_app_admin/model/app_data.dart';
import 'package:bottle_sharing_app_admin/model/user_model.dart';
import 'package:bottle_sharing_app_admin/view/items/confirm_dialog.dart';
import 'package:bottle_sharing_app_admin/view/screens/screen_user_posts.dart';
import 'package:flutter/material.dart' hide BackButton;
import 'package:bottle_sharing_app_admin/view/items/back_button.dart';

class ScreenUserDetails extends StatefulWidget {
  final UserModel? user;

  const ScreenUserDetails({super.key, this.user});

  @override
  State<ScreenUserDetails> createState() => _ScreenUserDetailsState();
}

class _ScreenUserDetailsState extends State<ScreenUserDetails> {
  late UserModel user;

  @override
  void initState() {
    super.initState();
    user = widget.user ??
        UserModel(
          id: "u1",
          name: "Jacob Jones",
          phone: "+1-3456789",
          email: "jacob.jones@example.com",
          avatar: "assets/images/JacobJones.png",
          dateOfBirth: "16 Jan, 2002",
          followers: "196",
          following: "17",
          totalPosts: "23",
        );
  }

  void _toggleBlockStatus() async {
    final willBlock = !user.isBlocked;
    final confirmed = await ConfirmDialog.show(
      context: context,
      title: willBlock ? "Block User" : "Unblock User",
      message: willBlock
          ? "Are you sure you want to block ${user.name}? They will lose access to the bottle sharing features."
          : "Are you sure you want to unblock ${user.name}? Their access will be fully restored.",
      confirmText: willBlock ? "Block User" : "Unblock",
      confirmColor: willBlock ? Colors.red : Colors.black,
      icon: willBlock ? Icons.block : Icons.check_circle_outline,
    );

    if (confirmed && mounted) {
      if (willBlock) {
        AppData.instance.blockUser(user.id);
      } else {
        AppData.instance.unblockUser(user.id);
      }

      setState(() {
        user.isBlocked = willBlock;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            willBlock
                ? "${user.name} has been blocked."
                : "${user.name} has been unblocked.",
          ),
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
          'User Details',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                // Profile Avatar & Status Badge
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 52,
                        backgroundColor: Colors.grey.shade200,
                        backgroundImage: AssetImage(user.avatar),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: user.isBlocked
                                ? Colors.red
                                : Colors.green.shade600,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: Text(
                            user.isBlocked ? "Blocked" : "Active",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  user.email,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 24),

                // Stats Row
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatColumn('Followers', user.followers),
                      Container(
                        height: 36,
                        width: 1,
                        color: Colors.grey.shade300,
                      ),
                      _buildStatColumn('Following', user.following),
                      Container(
                        height: 36,
                        width: 1,
                        color: Colors.grey.shade300,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ScreenUserPosts(user: user),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Total Posts',
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(width: 2),
                                  const Icon(Icons.chevron_right,
                                      size: 14, color: Colors.black54),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                user.totalPosts,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Info Rows
                _buildInfoRow('Full Name', user.name),
                _buildInfoRow('Phone Number', user.phone),
                _buildInfoRow('Email Address', user.email),
                _buildInfoRow(
                  'Date of Birth',
                  user.dateOfBirth,
                  showBottomBorder: true,
                ),

                const SizedBox(height: 40),

                // Block / Unblock Action Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton(
                      onPressed: _toggleBlockStatus,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: user.isBlocked ? Colors.black : Colors.red,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: Text(
                        user.isBlocked ? 'Unblock User' : 'Block User',
                        style: TextStyle(
                          color: user.isBlocked ? Colors.black : Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatColumn(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.grey.shade700,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(
    String title,
    String value, {
    bool showBottomBorder = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey.shade200),
          bottom: showBottomBorder
              ? BorderSide(color: Colors.grey.shade200)
              : BorderSide.none,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
