import 'package:flutter/material.dart';
import 'package:reservation_app/l10n/flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:reservation_app/providers/auth.dart';

import 'package:reservation_app/widgets/drawer.dart';
import 'package:reservation_app/widgets/my_app_bar.dart';
import 'package:reservation_app/widgets/home_screen/header.dart';
import 'package:reservation_app/widgets/home_screen/body.dart';
import 'package:reservation_app/widgets/home_screen/location.dart';
import 'package:reservation_app/widgets/home_screen/pic_holder.dart';

import 'package:reservation_app/screens/home_screen_edit_screen.dart';

import 'package:reservation_app/providers/screens.dart';
import 'package:reservation_app/modells/home_screen_modell.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _didRun = false;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    if (!_didRun) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<ScreenProvider>(context, listen: false)
          .getHomeScreen()
          .then((_) {
        setState(() {
          _isLoading = false;
        });
        Provider.of<UserAuth>(context, listen: false).tryautoLogIn();
        _didRun = true;
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    HomeScreenData? screenData =
        Provider.of<ScreenProvider>(context).homeScreen;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: MyAppBar(
        [
          if (Provider.of<UserAuth>(context).isAuthenticatedAdmin)
            IconButton(
                onPressed: () {
                  if (screenData == null) return;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomeScreenEdit(screenData)));
                },
                icon: const Icon(Icons.edit))
        ],
        appbar: AppBar(),
        title: Text(AppLocalizations.of(context)!.home),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(children: [
                HomeScreenHeader(screenData!),
                const ImageHolder(
                    "http://api.wombat-tech.tk/homescreen/picture"),
                HomeScreenBody(
                    AppLocalizations.of(context)!.intro, screenData.intro),
                HomeScreenLocation(screenData),
                HomeScreenBody(AppLocalizations.of(context)!.servicedescription,
                    screenData.description),
                const Divider(
                  height: 40,
                  thickness: 0,
                  color: Colors.white,
                ),
              ]),
            ),
      bottomSheet: Container(
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        height: 30,
        child: FittedBox(
          fit: BoxFit.fitHeight,
          child: Text(
            screenData?.advertisement ?? "Add",
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
          ),
        ),
      ),
      drawer: const AppDrawer(),
    );
  }
}
