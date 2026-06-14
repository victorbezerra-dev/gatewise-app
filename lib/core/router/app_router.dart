import 'package:go_router/go_router.dart';
import '../../modules/authenticate/presentation/auth_screen.dart';
import '../../modules/host/presentation/host_screen.dart';
import '../../modules/organizations/presentation/organization_details_screen.dart';
import '../../modules/spaces/presentation/provision_device_screen.dart';
import '../../modules/spaces/presentation/space_details_screen.dart';
import '../../modules/spaces/presentation/spaces_screen.dart';
import '../../modules/splash_screen/presentation/splash_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashPage()),
    GoRoute(
      path: '/auth-login',
      builder: (context, state) => const AuthLoginScreen(),
    ),
    GoRoute(path: '/main', builder: (context, state) => const HostScreen()),
    GoRoute(
      path: '/organizations/:id',
      builder: (context, state) {
        final id = int.tryParse(state.pathParameters['id'] ?? '');
        return OrganizationDetailsScreen(organizationId: id ?? 0);
      },
    ),
    GoRoute(path: '/spaces', builder: (context, state) => const SpacesScreen()),
    GoRoute(
      path: '/spaces/:id',
      builder: (context, state) {
        final id = int.tryParse(state.pathParameters['id'] ?? '');
        return SpaceDetailsScreen(spaceId: id ?? 0);
      },
    ),
    GoRoute(
      path: '/spaces/:id/provision',
      builder: (context, state) {
        final id = int.tryParse(state.pathParameters['id'] ?? '');
        return ProvisionDeviceScreen(spaceId: id ?? 0);
      },
    ),
  ],
);
