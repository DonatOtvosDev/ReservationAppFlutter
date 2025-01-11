import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reservation_app/l10n/flutter_gen/gen_l10n/app_localizations.dart';
import 'package:material_color_generator/material_color_generator.dart';

import 'package:reservation_app/screens/home_screen.dart';
import 'package:reservation_app/screens/login_screen.dart';
import 'package:reservation_app/screens/services_screen.dart';
import 'package:reservation_app/screens/calendar_screen.dart';
import 'package:reservation_app/screens/day_screen.dart';
import 'package:reservation_app/screens/admin_calendar_screen.dart';
import 'package:reservation_app/screens/reservations_screen.dart';
import 'package:reservation_app/screens/about_me_screen.dart';
import 'package:reservation_app/screens/account_edit_screen.dart';
import 'package:reservation_app/screens/users_edit_screen.dart';

import 'package:reservation_app/providers/services.dart';
import 'package:reservation_app/providers/auth.dart';
import 'package:reservation_app/providers/months.dart';
import 'package:reservation_app/providers/day.dart';
import 'package:reservation_app/providers/screens.dart';
import 'package:reservation_app/providers/users.dart';

void main() => runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => UserAuth()),
        ChangeNotifierProxyProvider<UserAuth, Months>(
            create: (ctx) => Months(null, null, []),
            update: (ctx, userAuth, previousMonths) => Months(
                userAuth.token, userAuth.accessLevel, previousMonths!.items)),
        ChangeNotifierProxyProvider<UserAuth, DayProvider>(
            create: (ctx) => DayProvider(null, null),
            update: (ctx, userAuth, previousMonths) =>
                DayProvider(userAuth.token, userAuth.accessLevel)),
        ChangeNotifierProxyProvider<UserAuth, Services>(
            create: (ctx) => Services(null, null, {}),
            update: (ctx, userAuth, previousServices) => Services(
                userAuth.token, userAuth.accessLevel, previousServices!.items)),
        ChangeNotifierProxyProvider<UserAuth, ScreenProvider>(
            create: (ctx) => ScreenProvider(null, null, null, null),
            update: (ctx, userAuth, previousSreen) => ScreenProvider(
                userAuth.token,
                userAuth.accessLevel,
                previousSreen?.aboutMeScreen,
                previousSreen?.homeScreen)),
        ChangeNotifierProxyProvider<UserAuth, UsersProvider>(
          create: (ctx) => UsersProvider(null, null, null),
          update: (ctx, userAuth, previousUsers) => UsersProvider(
              previousUsers?.myData, userAuth.token, userAuth.accessLevel),
        )
      ],
      child: const MyApp(),
    ));

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
          fontFamily: "Ubuntu",
          primaryColor: const Color.fromRGBO(233, 161, 120, 1),
          colorScheme: ColorScheme.fromSwatch(
              backgroundColor: const Color.fromRGBO(246, 225, 195, 1),
              primarySwatch: generateMaterialColor(
                  color: const Color.fromRGBO(233, 161, 120, 1)),
              accentColor: const Color.fromRGBO(168, 68, 72, 1)),
          textButtonTheme: const TextButtonThemeData(
              style: ButtonStyle(
                  foregroundColor: MaterialStatePropertyAll<Color>(
                      Color.fromRGBO(168, 68, 72, 1)),
                  textStyle: MaterialStatePropertyAll<TextStyle>(TextStyle(
                    fontFamily: "Ubuntu",
                    fontSize: 18,
                  ))))),
      home: const HomeScreen(),
      routes: {
        AboutMeScreen.routerName: (context) => const AboutMeScreen(),
        ServiceScreen.routeName: (context) => const ServiceScreen(),
        LoginScreen.routeName: (context) => const LoginScreen(),
        CalendarScreen.routerName: (context) => const CalendarScreen(),
        DayScreen.routerName: (context) => const DayScreen(),
        CalendarScreenAdmin.routerName: (context) =>
            const CalendarScreenAdmin(),
        ReservationsScreen.routeName: (context) => const ReservationsScreen(),
        AccountEditScreen.routeName: (context) => const AccountEditScreen(),
        UsersScreen.routeName: (context) => const UsersScreen()
      },
    );
  }
}
