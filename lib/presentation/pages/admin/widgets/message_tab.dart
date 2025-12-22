import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../controllers/admin_controller.dart';

class MessagesTab extends GetView<AdminController> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Messages',
                    style: AppTextStyles.headline2,
                  ),
                  SizedBox(width: 16),
                  Obx(() => controller.unreadCount.value > 0
                      ? Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.purple, AppColors.cyan],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${controller.unreadCount.value} New',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                      : SizedBox()),
                ],
              ),
              IconButton(
                onPressed: controller.loadMessages,
                icon: Icon(Icons.refresh, color: AppColors.cyan),
              ),
            ],
          ),
        ),
        Expanded(
          child: Obx(() {
            if (controller.messages.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inbox, size: 80, color: Colors.white30),
                    SizedBox(height: 20),
                    Text(
                      'No Messages Yet',
                      style: AppTextStyles.headline3,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Messages from your portfolio will appear here',
                      style: AppTextStyles.body1.copyWith(color: Colors.white60),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 32),
              itemCount: controller.messages.length,
              itemBuilder: (context, index) {
                final message = controller.messages[index];
                return _MessageCard(message: message);
              },
            );
          }),
        ),
      ],
    );
  }
}

class _MessageCard extends StatelessWidget {
  final message;

  const _MessageCard({required this.message});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminController>();

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: message.isRead
            ? AppColors.glassBackground
            : AppColors.purple.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: message.isRead
              ? AppColors.glassBorder
              : AppColors.purple.withOpacity(0.3),
          width: message.isRead ? 1 : 2,
        ),
      ),
      child: ExpansionTile(
        tilePadding: EdgeInsets.all(20),
        childrenPadding: EdgeInsets.fromLTRB(20, 0, 20, 20),
        leading: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: message.isRead
                  ? [Colors.white30, Colors.white12]
                  : [AppColors.purple, AppColors.cyan],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            message.isRead ? Icons.mail_outline : Icons.mark_email_unread,
            color: Colors.white,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.name,
                    style: AppTextStyles.headline3.copyWith(fontSize: 18),
                  ),
                  if (message.company.isNotEmpty)
                    Text(
                      message.company,
                      style: TextStyle(
                        color: AppColors.cyan,
                        fontSize: 14,
                      ),
                    ),
                ],
              ),
            ),
            Text(
              DateFormat('MMM dd, yyyy').format(message.createdAt),
              style: TextStyle(color: Colors.white60, fontSize: 12),
            ),
          ],
        ),
        subtitle: Padding(
          padding: EdgeInsets.only(top: 8),
          child: Row(
            children: [
              Icon(Icons.email, size: 14, color: Colors.white60),
              SizedBox(width: 6),
              Text(
                message.email,
                style: TextStyle(color: Colors.white60, fontSize: 13),
              ),
              if (message.phone.isNotEmpty) ...[
                SizedBox(width: 16),
                Icon(Icons.phone, size: 14, color: Colors.white60),
                SizedBox(width: 6),
                Text(
                  message.phone,
                  style: TextStyle(color: Colors.white60, fontSize: 13),
                ),
              ],
            ],
          ),
        ),
        onExpansionChanged: (expanded) {
          if (expanded && !message.isRead) {
            controller.markAsRead(message.id);
          }
        },
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.glassBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              message.message,
              style: AppTextStyles.body1,
            ),
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: () => _deleteMessage(message.id),
                icon: Icon(Icons.delete, size: 18, color: Colors.red),
                label: Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _deleteMessage(String id) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Color(0xFF0D1117),
        title: Text('Delete Message', style: AppTextStyles.headline3.copyWith(fontSize: 20)),
        content: Text('Are you sure you want to delete this message?', style: AppTextStyles.body1),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () {
              Get.find<AdminController>().deleteMessage(id);
              Get.back();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}