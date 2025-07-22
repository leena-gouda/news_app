import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/routing/app_router.dart';
import 'core/routing/routes.dart';
import 'core/utils/notification_service.dart';
import 'firebase_options.dart';

// Api Key: 1a0ac09f5f074de4abe53a2af46bcac1


bool isLogin = false;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('📩 إشعار من الخلفية: ${message.notification?.title}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await isLoggedIn();

  await NotificationService.init(); // دي اللي هنشرحها دلوقتي

  if (kIsWeb) {
    await FirebaseMessaging.instance.setAutoInitEnabled(true);
    try {
      await FirebaseMessaging.instance.useServiceWorker(
        serviceWorkerScriptUrl: '/firebase-messaging-sw.js',
      );
    } catch (e) {
      debugPrint('Service worker registration failed: $e');
    }
  }
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MyApp(appRouter: AppRouter()));
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
    runApp(const ErrorApp() as Widget); // Create a simple error widget
  }
}

extension on FirebaseMessaging {
  useServiceWorker({required String serviceWorkerScriptUrl}) {}
}

class ErrorApp {
  const ErrorApp();
}

class MyApp extends StatelessWidget {
  final AppRouter appRouter;

  const MyApp({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(428, 926),
    minTextAdapt: true,
    splitScreenMode: true,
    builder: (_ , child) => MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0.0,
          ),
          useMaterial3: true,
          fontFamily: GoogleFonts.poppins().fontFamily,
        ),
        initialRoute: isLogin == true ? Routes.homeScreen : Routes.splashScreen,
        onGenerateRoute: appRouter.generateRoute,
      )
    );

  }
}

isLoggedIn() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? email = prefs.getString("email");
  if (email != null && email.isNotEmpty) {
    isLogin = true;
  } else {
    isLogin = false;
  }
}