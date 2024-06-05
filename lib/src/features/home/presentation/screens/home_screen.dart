import '/core/constants/app_string.dart';
import 'package:flutter/Material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_color.dart';
import '../../../../../core/router/app_router.dart';
import '../../../account/domain/user.dart';
import '../../../../../shared/widgets/loading_widget.dart';
import '../controllers/home_controller.dart';
import '../widgets/user_tile.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final HomeController homeController = ref.read(homeProvider.notifier);
    return Scaffold(
        appBar: AppBar(
          title: const Text(AppString.appName),
          elevation: 0.0,
          actions: [
            InkWell(
              onTap: () => context.pushNamed(AppRoutes.accountRoute),
              child: const Padding(
                padding: EdgeInsets.only(right: 16),
                child: CircleAvatar(
                  backgroundColor: Colors.white70,
                  radius: 20,
                  child: Icon(
                    CupertinoIcons.person,
                    size: 30,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Center(
            child: SizedBox(
                width: kIsWeb ? 450 : double.infinity,
                child: _buildUserList(homeController))));
  }

  Widget _buildUserList(HomeController homeController) {
    return StreamBuilder(
        stream: homeController.getUserStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingWidget();
          } else if (snapshot.hasData) {
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              addAutomaticKeepAlives: false,
              padding: const EdgeInsets.all(16),
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                return UserTile(
                  userModel: UserModel(
                      id: snapshot.data?.docs[index]['id'],
                      name: snapshot.data?.docs[index]['name'],
                      email: snapshot.data?.docs[index]['email'],
                      fcmToken: snapshot.data?.docs[index]['fcmToken']),
                );
              },
            );
          } else {
            return const SizedBox.shrink();
          }
        });
  }
}
