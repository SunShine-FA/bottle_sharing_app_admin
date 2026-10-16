import 'dart:io';
import 'package:bottle_sharing_app_admin/model/app_data.dart';
import 'package:bottle_sharing_app_admin/view/items/confirm_dialog.dart';
import 'package:flutter/material.dart' hide BackButton;
import 'package:image_picker/image_picker.dart';
import 'package:bottle_sharing_app_admin/view/items/back_button.dart';

class ScreenSendNotification extends StatefulWidget {
  const ScreenSendNotification({super.key});

  @override
  State<ScreenSendNotification> createState() => _ScreenSendNotificationState();
}

class _ScreenSendNotificationState extends State<ScreenSendNotification> {
  final AppData appData = AppData.instance;
  bool isHistory = true;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final ImagePicker picker = ImagePicker();

  File? selectedImage;
  String selectedAudience = "All Users";
  bool isSending = false;

  @override
  void initState() {
    super.initState();
    appData.addListener(_onAppDataChanged);
  }

  @override
  void dispose() {
    appData.removeListener(_onAppDataChanged);
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void _onAppDataChanged() {
    if (mounted) setState(() {});
  }

  Future<void> pickImage() async {
    try {
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null && mounted) {
        setState(() {
          selectedImage = File(image.path);
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error selecting image: $e")),
      );
    }
  }

  void sendNotification() async {
    final title = titleController.text.trim();
    final description = descriptionController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter a notification title."),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter the notification message body."),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      isSending = true;
    });

    final now = DateTime.now();
    final date =
        "${now.day.toString().padLeft(2, '0')}/"
        "${now.month.toString().padLeft(2, '0')}/"
        "${now.year}";

    final newNotification = NotificationItem(
      id: "n_${DateTime.now().millisecondsSinceEpoch}",
      title: title,
      description: description,
      localImagePath: selectedImage?.path,
      date: date,
      targetAudience: selectedAudience,
    );

    appData.addNotification(newNotification);

    await Future.delayed(const Duration(milliseconds: 350));
    if (!mounted) return;

    setState(() {
      isSending = false;
      titleController.clear();
      descriptionController.clear();
      selectedImage = null;
      isHistory = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Notification broadcasted to $selectedAudience!"),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _confirmDeleteNotification(NotificationItem item) async {
    final confirmed = await ConfirmDialog.show(
      context: context,
      title: "Delete Notification",
      message: "Remove this notification record from history?",
      confirmText: "Delete",
      confirmColor: Colors.red,
      icon: Icons.delete_outline,
    );

    if (confirmed && mounted) {
      appData.deleteNotification(item.id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Notification removed from history."),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final notifications = appData.notifications;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const BackButton(
        titleWidget: Text(
          'Notifications',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(height: 1, color: Colors.grey.shade200),
            const SizedBox(height: 16),

            // Segmented Switcher
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F4F7),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => isHistory = true),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isHistory ? Colors.black : Colors.transparent,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Text(
                            "History (${notifications.length})",
                            style: TextStyle(
                              color: isHistory ? Colors.white : Colors.grey.shade700,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => isHistory = false),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: !isHistory ? Colors.black : Colors.transparent,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Text(
                            "Create Broadcast",
                            style: TextStyle(
                              color: !isHistory ? Colors.white : Colors.grey.shade700,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            if (isHistory)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: notifications.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 60),
                          child: Column(
                            children: [
                              Icon(
                                Icons.notifications_off_outlined,
                                size: 54,
                                color: Colors.grey.shade300,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                "No notification history",
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Column(
                        children: List.generate(
                          notifications.length,
                          (index) => Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: _buildHistoryCard(notifications[index]),
                          ),
                        ),
                      ),
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Target Audience",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F8FA),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: selectedAudience,
                          items: [
                            "All Users",
                            "SubAdmins Only",
                            "VIP Bottle Hosts",
                            "Hawaii Members",
                          ].map((a) {
                            return DropdownMenuItem<String>(
                              value: a,
                              child: Text(a),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => selectedAudience = val);
                            }
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    const Text(
                      "Notification Title",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        hintText: "e.g. Weekend Table Specials",
                        prefixIcon: Icon(Icons.campaign_outlined, size: 20),
                      ),
                    ),

                    const SizedBox(height: 18),

                    const Text(
                      "Message Description",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: descriptionController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        hintText: "Write clear broadcast announcement...",
                      ),
                    ),

                    const SizedBox(height: 18),

                    const Text(
                      "Attach Banner / Image (Optional)",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),

                    GestureDetector(
                      onTap: pickImage,
                      child: Container(
                        width: double.infinity,
                        height: 140,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7F8FA),
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: selectedImage == null
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.cloud_upload_outlined,
                                    size: 38,
                                    color: Colors.grey.shade700,
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    "Tap to choose image banner",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "PNG, JPG up to 5MB",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              )
                            : Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(14),
                                    child: Image.file(
                                      selectedImage!,
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() => selectedImage = null);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                          color: Colors.black87,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),

                    const SizedBox(height: 36),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: isSending ? null : sendNotification,
                        child: isSending
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                "Broadcast Notification",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryCard(NotificationItem item) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  item.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      item.targetAudience,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    item.date,
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                  const SizedBox(width: 4),
                  InkWell(
                    onTap: () => _confirmDeleteNotification(item),
                    child: Icon(
                      Icons.delete_outline,
                      size: 18,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            item.description,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade700,
              height: 1.4,
            ),
          ),

          if (item.localImagePath != null &&
              File(item.localImagePath!).existsSync()) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(
                File(item.localImagePath!),
                width: double.infinity,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
