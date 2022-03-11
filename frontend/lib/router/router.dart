import 'package:go_router/go_router.dart';
import 'package:rye/features/auth/login_page.dart';
import 'package:rye/features/home.dart';

class MainRouter {
  get router => _router;
  final _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => Home(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginPage(),
      ),
    ],
  );
}
