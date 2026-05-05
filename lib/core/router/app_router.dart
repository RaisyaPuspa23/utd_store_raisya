import 'package:go_router/go_router.dart';
import '../../features/product/presentation/pages/splash/splash_page.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashPage(),
    ),
  ],
);