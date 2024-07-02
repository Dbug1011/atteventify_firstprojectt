import 'package:atteventify/autho/auth_page.dart';
import 'package:atteventify/presentation/analyticsscreen_screen/analyticsscreen_screen.dart';
import 'package:atteventify/presentation/app_navigation_screen/app_navigation_screen.dart';
import 'package:atteventify/presentation/attendancedetails_screen/attendancedetails_screen.dart';
import 'package:atteventify/presentation/eventdetails_screen/eventdetails_screen.dart';
import 'package:atteventify/presentation/generatedlist_screen/generatedlist_screen.dart';
import 'package:atteventify/presentation/generatorscreen_screen/generatorscreen_screen.dart';
import 'package:atteventify/presentation/homescreen_page/homescreen_page.dart';
import 'package:atteventify/presentation/loginscreen_screen/loginscreen_screen.dart';
import 'package:atteventify/presentation/logo_one_screen/logo_one_screen.dart';
import 'package:atteventify/presentation/scannerscreen_screen/scannerscreen_screen.dart';
import 'package:atteventify/presentation/signupscreen_screen/signupscreen_screen.dart';
import 'package:atteventify/presentation/twohomescreen_screen/twohomescreen_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String logoOneScreen = '/logo_one_screen';

  static const String loginscreenScreen = '/loginscreen_screen';

  static const String signupscreenScreen = '/signupscreen_screen';

  static const String homescreenPage = '/homescreen_page';

  static const String twohomescreenScreen = '/twohomescreen_screen';

  static const String eventdetailsScreen = '/eventdetails_screen';

  static const String attendancedetailsScreen = '/attendancedetails_screen';

  static const String scannerscreenScreen = '/scannerscreen_screen';

  static const String generatedlistScreen = '/generatedlist_screen';

  static const String generatorscreenScreen = '/generatorscreen_screen';

  static const String analyticsscreenScreen = '/analyticsscreen_screen';

  static const String appNavigationScreen = '/app_navigation_screen';

  static const String initialRoute = '/initialRoute';
  // static const String generate = '/generate_code_page';
  static const String scan = '/scan_code_page';
  static const String generate = '/QRCodeGenerator';
  static const String authscreen = '/auth_page';
  static const String generator = '/GenerateCodePage';

  static Map<String, WidgetBuilder> routes = {
    logoOneScreen: (context) => const LogoOneScreen(),
    loginscreenScreen: (context) => LoginscreenScreen(),
    homescreenPage: (context) => HomescreenPage(),
    signupscreenScreen: (context) => SignupscreenScreen(),
    twohomescreenScreen: (context) => TwohomescreenScreen(),
    eventdetailsScreen: (context) =>
        EventdetailsScreen(event: {}), // Provide a default empty event
    attendancedetailsScreen: (context) =>
        AttendancedetailsScreen(eventData: {}, eventId: ''),
    scannerscreenScreen: (context) => ScannerscreenScreen(eventId: ''),
    generatedlistScreen: (context) => GeneratedlistScreen(),
    generatorscreenScreen: (context) => GenerateCodePage(),
    analyticsscreenScreen: (context) => AnalyticsscreenScreen(),
    appNavigationScreen: (context) => const AppNavigationScreen(),
    initialRoute: (context) => AuthPage(),
    authscreen: (context) => AuthPage(),
  };
}
