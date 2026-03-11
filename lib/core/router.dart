import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../features/auth/presentation/providers/auth_provider.dart';
import '../features/auth/presentation/providers/onboarding_provider.dart';
import '../features/auth/presentation/screens/change_password_screen.dart';
import '../features/auth/presentation/screens/email_verification_screen.dart';
import '../features/auth/presentation/screens/forgot_password_screen.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/onboarding/onboarding_screen.dart';
import '../features/auth/presentation/screens/register_screen.dart';
import '../features/auth/presentation/screens/reset_password_screen.dart';
import '../features/auth/presentation/screens/reset_password_success.dart';
import '../features/auth/presentation/screens/user_type_selection_screen.dart';
import '../features/auth/presentation/screens/splash_screen.dart';
import '../features/lenders/presentation/screens/lenders_manager_screen.dart';
import '../features/lenders/presentation/screens/bank_accounts_manager_screen.dart';
import '../features/customers/presentation/screens/customers_list_screen.dart';
import '../features/customers/presentation/screens/customer_detail_screen.dart';
import '../features/customers/presentation/screens/customer_registration_screen.dart';
import '../features/loans/presentation/screens/loan_applications_list_screen.dart';
import '../features/loans/presentation/screens/loan_application_form_screen.dart';
import '../main.dart';

class AppRouter extends ChangeNotifier {
  static GoRouter router(AuthProvider authProvider) {
    return GoRouter(
      initialLocation: '/splash',
      refreshListenable: authProvider,
      routes: [
        GoRoute(
          path: '/splash',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/onboarding',
          builder: (context, state) => const OnboardingScreen(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/user-type',
          builder: (context, state) => const UserTypeSelectionScreen(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: '/verify-email',
          builder: (context, state) {
            final email = state.uri.queryParameters['email'] ?? '';
            return EmailVerificationScreen(email: email);
          },
        ),
        GoRoute(
          path: '/forgot-password',
          builder: (context, state) => const ForgotPasswordScreen(),
        ),
        GoRoute(
          path: '/reset-password',
          builder: (context, state) {
            final token = state.uri.queryParameters['token'] ?? '';
            return ResetPasswordScreen(token: token);
          },
        ),
        GoRoute(
          path: '/reset-password-success',
          builder: (context, state) => const ResetPasswordSuccessScreen(),
        ),
        GoRoute(
          path: '/change-password',
          builder: (context, state) => const ChangePasswordScreen(),
        ),
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const MainScreen(),
        ),
        GoRoute(
          path: '/lenders',
          builder: (context, state) => const LendersManagerScreen(),
        ),
        GoRoute(
          path: '/lenders/:id/bank-accounts',
          builder: (context, state) {
            final id = state.pathParameters['id'] ?? '';
            return BankAccountsManagerScreen(lenderId: id);
          },
        ),
        GoRoute(
          path: '/customers',
          builder: (context, state) => const CustomersListScreen(),
        ),
        GoRoute(
          path: '/customers/new',
          builder: (context, state) => const CustomerRegistrationScreen(),
        ),
        GoRoute(
          path: '/customers/:id',
          builder: (context, state) {
            final id = state.pathParameters['id'] ?? '';
            return CustomerDetailScreen(customerId: id);
          },
        ),
        GoRoute(
          path: '/loan-applications',
          builder: (context, state) => const LoanApplicationsListScreen(),
        ),
        GoRoute(
          path: '/loan-applications/new',
          builder: (context, state) {
            final customerId = state.uri.queryParameters['customerId'];
            return LoanApplicationFormScreen(customerId: customerId);
          },
        ),
      ],
      redirect: (context, state) {
        final auth = context.read<AuthProvider>();
        final onboarding = context.read<OnboardingProvider>();

        final isSplash = state.matchedLocation == '/splash';
        final isOnboarding = state.matchedLocation == '/onboarding';
        final isLoggingIn = state.matchedLocation == '/login';
        final isUserType = state.matchedLocation == '/user-type';
        final isRegistering = state.matchedLocation == '/register';
        final isForgotPassword = state.matchedLocation == '/forgot-password';
        final isVerifyEmail = state.matchedLocation == '/verify-email';
        final isResetPassword = state.matchedLocation == '/reset-password';
        final isResetPasswordSuccess =
            state.matchedLocation == '/reset-password-success';
        final isChangePassword = state.matchedLocation == '/change-password';

        if (auth.status == AuthStatus.initial || auth.status == AuthStatus.loading) {
          return isSplash ? null : '/splash';
        }

        if (!onboarding.isCompleted) {
          return isOnboarding ? null : '/onboarding';
        }

        if (auth.status == AuthStatus.unauthenticated) {
          if (isLoggingIn ||
              isUserType ||
              isRegistering ||
              isForgotPassword ||
              isVerifyEmail ||
              isResetPassword ||
              isResetPasswordSuccess) {
            return null;
          }

          return '/login';
        }

        if (auth.status == AuthStatus.authenticated) {
          if (state.matchedLocation.startsWith('/lenders') || 
              state.matchedLocation.startsWith('/customers') || 
              state.matchedLocation.startsWith('/loan-applications') ||
              isChangePassword) {
            return null;
          }

          if (isSplash ||
              isOnboarding ||
              isLoggingIn ||
              isUserType ||
              isRegistering ||
              isForgotPassword ||
              isVerifyEmail ||
              isResetPassword ||
              isResetPasswordSuccess) {
            return '/dashboard';
          }
        }

        return null;
      },
    );
  }
}
