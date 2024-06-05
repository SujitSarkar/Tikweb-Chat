import '../../src/features/splash/presentation/splash_screen.dart';
import '../../src/features/account/presentation/screens/accrount_screen.dart';
import '../../src/features/chat/presentation/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../src/features/authentication/presentation/screens/auth_screen.dart';
import '../../src/features/home/presentation/screens/home_screen.dart';
import '../../shared/widgets/error_screen.dart';

class AppRoutes {
  static const splashRoute = "/splash";
  static const authRoute = "/auth";
  static const homeRoute = "/home";
  static const chatRoute = "/chat";
  static const accountRoute = "/account";

  static final GoRouter routes = GoRouter(
      initialLocation: splashRoute,
      debugLogDiagnostics: true,
      errorBuilder: (context, state) => const ErrorScreen(),
      routes: [
        GoRoute(
          path: splashRoute,
          name: splashRoute,
          builder: (BuildContext context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: authRoute,
          name: authRoute,
          builder: (BuildContext context, state) => const AuthScreen(),
        ),
        GoRoute(
          path: homeRoute,
          name: homeRoute,
          builder: (_, state) => const HomeScreen(),
          redirect: (context, state) => _authRedirect(context),
        ),
        GoRoute(
          path: '$chatRoute/:receiverId/:receiverName/:receiverToken',
          name: chatRoute,
          pageBuilder: (_, state) {
            final receiverId = state.pathParameters['receiverId'];
            final receiverName = state.pathParameters['receiverName'];
            final receiverToken = state.pathParameters['receiverToken'];
            return MaterialPage(
                child: ChatScreen(
                    reveiverId: receiverId!,
                    reveiverName: receiverName!,
                    reveiverToken: receiverToken!));
          },
          redirect: (context, state) => _authRedirect(context),
        ),
        GoRoute(
          path: accountRoute,
          name: accountRoute,
          builder: (_, state) => const AccountScreen(),
          redirect: (context, state) => _authRedirect(context),
        ),
      ]);

  static String? _authRedirect(BuildContext context) {
    return FirebaseAuth.instance.currentUser == null
        ? context.namedLocation(authRoute)
        : null;
  }
}


// GoRoute(
        //   name: "/two",
        //   path: '/two',
        //   builder: (context, state) {
        //     final UserModel user = state.extra as UserModel;
        //     return ScreenTwo(userModel: user);
        //   },
        // ),
        // context.pushNamed('/two',
        //           extra: UserModel(
        //               name: 'Sujit Sarkar',
        //               email: 'sujit@gmail.com',
        //               address: 'Dhaka Bangladesh'));