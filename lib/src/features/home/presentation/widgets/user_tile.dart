import '../../../../../core/router/app_router.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_color.dart';
import '../../../account/domain/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  const UserTile({super.key, required this.userModel});
  final UserModel userModel;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => context.pushNamed(
        AppRoutes.chatRoute,
        pathParameters: {
          'receiverId': userModel.id ?? 'not_found',
          'receiverName': userModel.name ?? 'not_found',
          'receiverToken': userModel.fcmToken ?? 'not_found',
        },
      ),
      contentPadding: EdgeInsets.zero,
      dense: true,
      leading: CircleAvatar(
        backgroundColor: AppColors.primaryColor.withOpacity(0.3),
        radius: 20,
        child: const Icon(
          CupertinoIcons.person,
          size: 28,
          color: AppColors.primaryColor,
        ),
      ),
      title: Text(
        userModel.name ?? 'N/A',
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(userModel.email ?? "N/A"),
    );
  }
}
