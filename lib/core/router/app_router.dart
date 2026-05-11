import 'package:go_router/go_router.dart';
import '../../features/product/presentation/pages/splash/splash_page.dart';
import '../../features/product/presentation/pages/product_page.dart'; 
import '../../features/product/presentation/pages/bookmark_page.dart';
import '../../features/product/presentation/pages/battery_page.dart';

final router = GoRouter(
  initialLocation: '/',
  // Ini untuk menangani kalau ada rute yang nyasar agar tidak muncul layar putih "Page Not Found"
  errorBuilder: (context, state) => const ProductPage(), 
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const ProductPage(), 
    ),
    GoRoute(
      path: '/bookmarks',
      builder: (context, state) => const BookmarkPage(), 
    ),
    GoRoute(
      path: '/battery',
      builder: (context, state) =>
          const BatteryPage(),
    ),
  ],
);