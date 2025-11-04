import 'package:btl_food_delivery_app/admin/Auth/admin_login_page.dart';
import 'package:btl_food_delivery_app/core/config/theme_config.dart';
import 'package:btl_food_delivery_app/core/constants/stripe_key_constants.dart';
import 'package:btl_food_delivery_app/l10n/app_localizations.dart';
import 'package:btl_food_delivery_app/l10n/l10n.dart';
import 'package:btl_food_delivery_app/pages/bottom_nav.dart';
import 'package:btl_food_delivery_app/pages/onboarding.dart';
import 'package:btl_food_delivery_app/routes/app_routes.dart';
import 'package:btl_food_delivery_app/services/shared_pref.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = StripeKeyConstants.publicKey;
  await Firebase.initializeApp();
  await GetStorage.init("Food Delivery");
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale newLocale) {
    _MainAppState? state = context.findAncestorStateOfType<_MainAppState>();
    state?.setLocale(newLocale);
  }

  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MainAppState();
}

class _MainAppState extends State<MyApp> {
  Locale _locale = Locale('en');

  Future<void> _loadLocale() async {
    Locale savedLocale = await SharedPref().getLanguage();
    setState(() {
      _locale = savedLocale;
    });
  }

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
    SharedPref().setLanguage(locale.languageCode);
  }

  @override
  void initState() {
    super.initState();
    _loadLocale();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      builder: (context, child) {
        return MaterialApp(
          theme: ThemeConfig.lightTheme,
          darkTheme: ThemeConfig.darkTheme,
          themeMode: ThemeMode.system,
          debugShowCheckedModeBanner: false,
          supportedLocales: L10n.all,
          locale: _locale,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            AppLocalizations.delegate,
          ],
          initialRoute: AppRoutes.SPASH,
          home: child,
        );
      },
      child: AuthCheck(),
    );
  }
}

class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        } else if (snapshot.hasData) {
          return BottomNav();
        } else {
          return Onboarding();
        }
      },
    );
  }
}
