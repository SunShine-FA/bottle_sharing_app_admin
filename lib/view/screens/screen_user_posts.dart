import 'package:bottle_sharing_app_admin/model/user_model.dart';
import 'package:bottle_sharing_app_admin/view/items/confirm_dialog.dart';
import 'package:flutter/material.dart' hide BackButton;
import 'package:bottle_sharing_app_admin/view/items/back_button.dart';

class ScreenUserPosts extends StatefulWidget {
  final UserModel? user;

  const ScreenUserPosts({super.key, this.user});

  @override
  State<ScreenUserPosts> createState() => _ScreenUserPostsState();
}

class _ScreenUserPostsState extends State<ScreenUserPosts> {
  late UserModel user;
  final List<Map<String, dynamic>> posts = [];

  @override
  void initState() {
    super.initState();
    user = widget.user ??
        UserModel(
          id: "u1",
          name: "Jacob Jones",
          phone: "(219) 555-0114",
          email: "jacob.jones@example.com",
          avatar: "assets/images/JacobJones.png",
        );

    posts.addAll([
      {
        "id": "p1",
        "time": "07:38 AM",
        "venue": "VIP Bottle Lounge",
        "image": "assets/images/UsersPosts.png",
        "caption": "Celebrating the weekend with the best crew! #BottleSharing #VIP",
        "likes": "48",
      },
      {
        "id": "p2",
        "time": "Yesterday, 11:20 PM",
        "venue": "Neon Club Waikiki",
        "image": "assets/images/DrinkBarClub1.png",
        "caption": "Bottle table sharing ready! Join our table on Honolulu tonight.",
        "likes": "32",
      },
    ]);
  }

  void _showPostOptions(int index) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text(
                  "Delete Post",
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
                ),
                onTap: () async {
                  Navigator.pop(ctx);
                  final confirmed = await ConfirmDialog.show(
                    context: context,
                    title: "Delete Post",
                    message: "Are you sure you want to delete this post? This action cannot be undone.",
                    confirmText: "Delete",
                    confirmColor: Colors.red,
                    icon: Icons.delete_forever,
                  );
                  if (confirmed && mounted) {
                    setState(() {
                      posts.removeAt(index);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Post deleted by moderator."),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.visibility_off_outlined, color: Colors.black87),
                title: const Text("Hide from Feed"),
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Post is now hidden from public feed."),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BackButton(
        titleWidget: Text(
          "${user.name}'s Posts",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Divider(height: 1, thickness: 1, color: Colors.grey.shade200),
            Expanded(
              child: posts.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.photo_library_outlined, size: 54, color: Colors.grey.shade300),
                          const SizedBox(height: 12),
                          Text(
                            "No posts available",
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      itemCount: posts.length,
                      separatorBuilder: (ctx, i) => Divider(height: 24, thickness: 8, color: Colors.grey.shade100),
                      itemBuilder: (context, index) {
                        final post = posts[index];
                        return _buildPostCard(post, index);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostCard(Map<String, dynamic> post, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage(user.avatar),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "${post["time"]} • ${post["venue"]}",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.more_horiz,
                  color: Colors.grey.shade600,
                  size: 24,
                ),
                onPressed: () => _showPostOptions(index),
              ),
            ],
          ),
        ),
        Image.asset(
          post["image"] as String,
          width: double.infinity,
          height: 280,
          fit: BoxFit.cover,
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post["caption"] as String,
                style: const TextStyle(fontSize: 14, height: 1.3),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.favorite, size: 16, color: Colors.redAccent),
                  const SizedBox(width: 4),
                  Text(
                    "${post["likes"]} likes",
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
