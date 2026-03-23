import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:app/core/app_config_provider.dart';
import 'package:app/core/settings_provider.dart';
import 'package:app/core/theme.dart';
import 'package:app/core/router.dart';
import 'package:app/features/auth/presentation/providers/auth_provider.dart';
import 'package:app/features/auth/presentation/providers/onboarding_provider.dart';
import 'package:app/features/auth/presentation/providers/user_type_provider.dart';
import 'package:app/l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  final prefs = await SharedPreferences.getInstance();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppConfigProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider(prefs)),
        ChangeNotifierProvider(create: (_) => OnboardingProvider(prefs)),
        ChangeNotifierProvider(create: (_) => UserTypeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const CuotaApp(),
    ),
  );
}

class CuotaApp extends StatelessWidget {
  const CuotaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final auth = context.watch<AuthProvider>();

    return MaterialApp.router(
      title: 'Kashap',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      locale: settings.locale,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('es'),
      ],
      routerConfig: AppRouter.router(auth),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final auth = context.read<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none_rounded),
                onPressed: () => context.push('/notifications'),
              ),
              Positioned(
                right: 12,
                top: 12,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 12,
                    minHeight: 12,
                  ),
                  child: const Text(
                    '2',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => auth.logout(),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.dashboard_rounded, size: 80, color: Color(0xFF16A34A)),
              const SizedBox(height: 16),
              Text(
                'Dashboard',
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              const Text('Bienvenido al panel principal de Kashap'),
              const SizedBox(height: 48),
              ElevatedButton.icon(
                onPressed: () => context.push('/portal'),
                icon: const Icon(Icons.account_circle_outlined),
                label: Text(l10n.customerPortal),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => context.push('/lenders'),
                icon: const Icon(Icons.business_outlined),
                label: Text(l10n.lendersTitle),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => context.push('/customers'),
                icon: const Icon(Icons.people_outline),
                label: Text(l10n.customersTitle),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.secondary,
                  foregroundColor: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => context.push('/loan-applications'),
                icon: const Icon(Icons.description_outlined),
                label: Text(l10n.loanApplications),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.withValues(alpha: 0.1),
                  foregroundColor: Colors.orange,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => context.push('/reports'),
                      icon: const Icon(Icons.bar_chart_rounded),
                      label: Text(l10n.reportsTitle),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple.withValues(alpha: 0.1),
                        foregroundColor: Colors.purple,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => context.push('/users'),
                      icon: const Icon(Icons.group_outlined),
                      label: Text(l10n.usersTitle),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.withValues(alpha: 0.1),
                        foregroundColor: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
