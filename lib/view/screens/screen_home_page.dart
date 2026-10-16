import 'package:bottle_sharing_app_admin/model/app_data.dart';
import 'package:bottle_sharing_app_admin/view/screens/screen_blocked_users.dart';
import 'package:bottle_sharing_app_admin/view/screens/screen_send_notification.dart';
import 'package:bottle_sharing_app_admin/view/screens/screen_settings.dart';
import 'package:bottle_sharing_app_admin/view/screens/screen_stories.dart';
import 'package:bottle_sharing_app_admin/view/screens/screen_subadmins.dart';
import 'package:bottle_sharing_app_admin/view/screens/screen_users.dart';
import 'package:flutter/material.dart';

class ScreenHomePage extends StatefulWidget {
  const ScreenHomePage({super.key});

  @override
  State<ScreenHomePage> createState() => _ScreenHomePageState();
}

class _ScreenHomePageState extends State<ScreenHomePage> {
  final AppData appData = AppData.instance;
  String searchQuery = "";
  bool isSearching = false;
  final TextEditingController searchController = TextEditingController();

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
    final activeUserCount = appData.activeUsers.length;
    final storyCount = appData.stories.length;
    final subadminCount = appData.subadmins.length;
    final blockedCount = appData.blockedUsers.length;

    final dashboardItems = [
      _DashboardModule(
        title: "Users",
        subtitle: "Manage profiles, activity & access",
        icon: Icons.people_alt_outlined,
        badgeText: "$activeUserCount active",
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ScreenUsers()),
        ),
      ),
      _DashboardModule(
        title: "My Stories",
        subtitle: "Curate states, cities & club stories",
        icon: Icons.auto_stories_outlined,
        badgeText: "$storyCount stories",
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ScreenStories()),
        ),
      ),
      _DashboardModule(
        title: "SubAdmins",
        subtitle: "Assign administrative access & roles",
        icon: Icons.admin_panel_settings_outlined,
        badgeText: "$subadminCount members",
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ScreenSubadmins()),
        ),
      ),
      _DashboardModule(
        title: "Blocked Users",
        subtitle: "Review suspended accounts & restrictions",
        icon: Icons.person_off_outlined,
        badgeText: "$blockedCount blocked",
        badgeColor: blockedCount > 0 ? Colors.red.shade50 : null,
        badgeTextColor: blockedCount > 0 ? Colors.red.shade700 : null,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ScreenBlockedUsers()),
        ),
      ),
      _DashboardModule(
        title: "Notifications",
        subtitle: "Broadcast announcements & club alerts",
        icon: Icons.notifications_active_outlined,
        badgeText: "${appData.notifications.length} sent",
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ScreenSendNotification()),
        ),
      ),
      _DashboardModule(
        title: "Settings",
        subtitle: "Account credentials & security preferences",
        icon: Icons.settings_outlined,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ScreenSettings()),
        ),
      ),
    ];

    final filteredItems = searchQuery.isEmpty
        ? dashboardItems
        : dashboardItems
            .where((item) =>
                item.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
                item.subtitle.toLowerCase().contains(searchQuery.toLowerCase()))
            .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // Dark Header Container
            Container(
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Share Bottle Admin",
                            style: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            "Dashboard",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            isSearching = !isSearching;
                            if (!isSearching) {
                              searchQuery = "";
                              searchController.clear();
                            }
                          });
                        },
                        icon: Container(
                          height: 38,
                          width: 38,
                          decoration: BoxDecoration(
                            color: isSearching
                                ? Colors.white
                                : Colors.grey.shade800,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            isSearching ? Icons.close : Icons.search,
                            color: isSearching ? Colors.black : Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),

                  if (isSearching) ...[
                    const SizedBox(height: 12),
                    TextField(
                      controller: searchController,
                      autofocus: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Search dashboard modules...",
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        prefixIcon:
                            const Icon(Icons.search, color: Colors.white70),
                        filled: true,
                        fillColor: Colors.grey.shade900,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (val) {
                        setState(() {
                          searchQuery = val.trim();
                        });
                      },
                    ),
                  ],

                  const SizedBox(height: 18),

                  // Quick Stats Row
                  Row(
                    children: [
                      _buildQuickStat(
                        label: "Users",
                        value: "$activeUserCount",
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ScreenUsers()),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildQuickStat(
                        label: "Stories",
                        value: "$storyCount",
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ScreenStories()),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildQuickStat(
                        label: "SubAdmins",
                        value: "$subadminCount",
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ScreenSubadmins()),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildQuickStat(
                        label: "Blocked",
                        value: "$blockedCount",
                        isAlert: blockedCount > 0,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ScreenBlockedUsers()),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Modules List
            Expanded(
              child: filteredItems.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off,
                              size: 48, color: Colors.grey.shade400),
                          const SizedBox(height: 12),
                          Text(
                            "No modules found for '$searchQuery'",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 8),
                      itemCount: filteredItems.length,
                      separatorBuilder: (ctx, i) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        return Material(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          elevation: 0,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: item.onTap,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                    color: Colors.grey.shade200, width: 1),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF2F4F7),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      item.icon,
                                      color: Colors.black87,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.title,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          item.subtitle,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (item.badgeText != null) ...[
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: item.badgeColor ??
                                            Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        item.badgeText!,
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: item.badgeTextColor ??
                                              Colors.grey.shade700,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                  ],
                                  const Icon(
                                    Icons.chevron_right,
                                    color: Colors.black45,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStat({
    required String label,
    required String value,
    required VoidCallback onTap,
    bool isAlert = false,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Text(
                value,
                style: TextStyle(
                  color: isAlert ? Colors.redAccent : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardModule {
  final String title;
  final String subtitle;
  final IconData icon;
  final String? badgeText;
  final Color? badgeColor;
  final Color? badgeTextColor;
  final VoidCallback onTap;

  _DashboardModule({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.badgeText,
    this.badgeColor,
    this.badgeTextColor,
    required this.onTap,
  });
}
