import 'package:bottle_sharing_app_admin/model/app_data.dart';
import 'package:bottle_sharing_app_admin/view/screens/screen_add_subadmin.dart';
import 'package:bottle_sharing_app_admin/view/screens/screen_subadmin_details.dart';
import 'package:flutter/material.dart' hide BackButton;
import 'package:bottle_sharing_app_admin/view/items/back_button.dart';

class ScreenSubadmins extends StatefulWidget {
  const ScreenSubadmins({super.key});

  @override
  State<ScreenSubadmins> createState() => _ScreenSubadminsState();
}

class _ScreenSubadminsState extends State<ScreenSubadmins> {
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

  @override
  Widget build(BuildContext context) {
    final subadmins = appData.subadmins;
    final filtered = searchQuery.isEmpty
        ? subadmins
        : subadmins.where((s) {
            final q = searchQuery.toLowerCase();
            return s.name.toLowerCase().contains(q) ||
                s.email.toLowerCase().contains(q);
          }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BackButton(
        titleWidget: isSearching
            ? TextField(
                controller: searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: "Search subadmins...",
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
                'SubAdmins',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
        actions: [
          IconButton(
            icon: Icon(
              isSearching ? Icons.close : Icons.search,
              color: Colors.black,
            ),
            tooltip: isSearching ? "Close Search" : "Search SubAdmins",
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
                  "Team Members (${filtered.length})",
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
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shield_outlined,
                            size: 60, color: Colors.grey.shade300),
                        const SizedBox(height: 14),
                        Text(
                          searchQuery.isEmpty
                              ? "No SubAdmins Assigned"
                              : "No subadmins matching '$searchQuery'",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          searchQuery.isEmpty
                              ? "Tap the '+' button below to add team members."
                              : "Check spelling or add a new team member.",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    itemCount: filtered.length,
                    separatorBuilder: (ctx, i) =>
                        Divider(height: 1, color: Colors.grey.shade200),
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ScreenSubadminDetails(subadmin: item),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 14),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundColor: Colors.black,
                                child: Text(
                                  item.name.isNotEmpty
                                      ? item.name[0].toUpperCase()
                                      : "A",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      item.email,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.chevron_right,
                                color: Colors.black45,
                                size: 20,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ScreenAddSubadmin()),
          );
        },
        backgroundColor: Colors.black,
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
