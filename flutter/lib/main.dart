import 'package:easy_localization/easy_localization.dart';
import 'package:employees_app/core/config/app_config.dart';
import 'package:employees_app/core/config/app_config_provider.dart';
import 'package:employees_app/presentation/navigation/router.dart';
import 'package:employees_app/presentation/providers/ui/scaffold_messenger_provider.dart';
import 'package:employees_app/presentation/style/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  final AppConfig appConfig = AppConfig.dev();

  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  SystemChrome.setPreferredOrientations([.portraitUp]);

  runApp(
    ProviderScope(
      overrides: [appConfigProvider.overrideWithValue(appConfig)],
      child: EasyLocalization(
        supportedLocales: const [Locale('en')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      routerConfig: router,
      title: ref.watch(appConfigProvider).appName,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      scaffoldMessengerKey: ref.read(scaffoldMessengerKeyProvider),
      locale: context.locale,
      theme: AppTheme.clearTheme,
      darkTheme: AppTheme.darkTheme,
    );
  }
}
