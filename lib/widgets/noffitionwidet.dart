import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:social_app/model/nofiticol.dart';
import 'package:social_app/page/profile.dart';
import 'package:social_app/widgets/profile/userProfileImage.dart';
import 'package:intl/intl.dart';

class NotificationTile extends StatelessWidget {
  final NotificationModel notificationModel;

  const NotificationTile({
    required this.notificationModel,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    Profile(uid: notificationModel.fromUser!.id!)));
      },
      leading: GestureDetector(
        onTap: () {},
        child: UserProfileImage(
          size: 50,
          radius: 30,
          name: notificationModel.postModel!.author.name!,
          imageUrl: notificationModel.fromUser!.profilePictureURL ?? 'xxx',
        ),
      ),
      title: Text.rich(
        TextSpan(
          children: [
            TextSpan(
                text: "${notificationModel.fromUser!.name}",
                style: const TextStyle(
                    fontWeight: FontWeight.w700, color: Colors.white)),
            const TextSpan(text: " "),
            TextSpan(
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
              text: _getText(notificationModel),
            ),
          ],
        ),
      ),
      subtitle: Text(
        DateFormat.yMd().add_jm().format(notificationModel.dateTime!),
        style: TextStyle(
          color: Colors.grey[600],
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: _getTrailing(context, notificationModel),
    );
  }

  String _getText(NotificationModel notificationModel) {
    switch (notificationModel.notificationType) {
      case NotificationType.like:
        return 'Thích Ảnh Bạn';

      case NotificationType.comment:
        return 'Bình Luận Ảnh Bạn';

      case NotificationType.follow:
        return 'Theo Dõi Bạn';

      case NotificationType.unfollow:
        return 'Bỏ Theo Dõi Bạn';

      default:
        return "";
    }
  }

  Widget _getTrailing(
      BuildContext context, NotificationModel notificationModel) {
    if (notificationModel.notificationType == NotificationType.like ||
        notificationModel.notificationType == NotificationType.comment) {
      return GestureDetector(
        onTap: () {},
        child: CachedNetworkImage(
          height: 60,
          width: 60,
          imageUrl: notificationModel.postModel!.imageUrl,
          fit: BoxFit.cover,
        ),
      );
    } else if (notificationModel.notificationType == NotificationType.follow ||
        notificationModel.notificationType == NotificationType.unfollow) {
      return const SizedBox(
        height: 60,
        width: 60,
        child: Icon(Icons.person_add, color: Colors.white),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
