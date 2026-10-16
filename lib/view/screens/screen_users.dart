import 'package:bottle_sharing_app_admin/model/app_data.dart';
import 'package:bottle_sharing_app_admin/model/user_model.dart';
import 'package:bottle_sharing_app_admin/view/items/confirm_dialog.dart';
import 'package:bottle_sharing_app_admin/view/screens/screen_user_details.dart';
import 'package:flutter/material.dart' hide BackButton;
import 'package:bottle_sharing_app_admin/view/items/back_button.dart';

class ScreenUsers extends StatefulWidget {
  const ScreenUsers({super.key});

  @override
  State<ScreenUsers> createState() => _ScreenUsersState();
}

class _ScreenUsersState extends State<ScreenUsers> {
  final AppData appData = AppData.instance;
  final TextEditingController searchController = TextEditingController();
  bool isSearching = false;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    appData.addListener(_onAppDataChanged);
  }

  @override
  void dispose() {
    appData.removeListener(_onAppDataChanged);
    searchController.dispose();
    super.dispose();
  }

  void _onAppDataChanged() {
    if (mounted) setState(() {});
  }

  void _confirmBlockUser(UserModel user) async {
    final confirmed = await ConfirmDialog.show(
      context: context,
      title: "Block User",
      message:
          "Are you sure you want to block ${user.name}? They will lose access to the bottle sharing community.",
      confirmText: "Block",
      confirmColor: Colors.red,
      icon: Icons.block,
    );

    if (confirmed && mounted) {
      appData.blockUser(user.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${user.name} has been blocked."),
          action: SnackBarAction(
            label: "Undo",
            textColor: Colors.amberAccent,
            onPressed: () {
              appData.unblockUser(user.id);
            },
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeUsers = appData.activeUsers;
    final filteredUsers = searchQuery.isEmpty
        ? activeUsers
        : activeUsers.where((u) {
            final q = searchQuery.toLowerCase();
            return u.name.toLowerCase().contains(q) ||
                u.phone.toLowerCase().contains(q) ||
                u.email.toLowerCase().contains(q);
          }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BackButton(
        titleWidget: isSearching
            ? TextField(
                controller: searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: "Search users by name or phone...",
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  filled: false,
                  contentPadding: EdgeInsets.zero,
                ),
                onChanged: (val) {
                  setState(() {
                    searchQuery = val.trim();
                  });
                },
              )
            : const Text(
                'Users',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
        actions: [
          IconButton(
            icon: Icon(
              isSearching ? Icons.close : Icons.search,
              color: Colors.black,
            ),
            tooltip: isSearching ? "Close Search" : "Search Users",
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                if (!isSearching) {
                  searchQuery = "";
                  searchController.clear();
                }
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(height: 1, color: Colors.grey.shade200),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Active Members (${filteredUsers.length})",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                  ),
                ),
                if (searchQuery.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        searchQuery = "";
                        searchController.clear();
                      });
                    },
                    child: const Text(
                      "Clear filter",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: filteredUsers.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.person_search_outlined,
                            size: 64,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            searchQuery.isEmpty
                                ? "No active users found"
                                : "No users matching '$searchQuery'",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            searchQuery.isEmpty
                                ? "Check blocked users to see suspended accounts."
                                : "Try searching by a different name or phone number.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.separated(
                    itemCount: filteredUsers.length,
                    separatorBuilder: (ctx, i) =>
                        Divider(height: 1, color: Colors.grey.shade200),
                    itemBuilder: (context, index) {
                      final user = filteredUsers[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ScreenUserDetails(user: user),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundColor: Colors.grey.shade200,
                                backgroundImage: AssetImage(user.avatar),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      user.phone,
                                      style: TextStyle(
                                        color: Colors.grey.shade500,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              TextButton(
                                onPressed: () => _confirmBlockUser(user),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.red,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 8,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    side: BorderSide(
                                      color: Colors.red.withValues(alpha: 0.3),
                                    ),
                                  ),
                                ),
                                child: const Text(
                                  "Block",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
