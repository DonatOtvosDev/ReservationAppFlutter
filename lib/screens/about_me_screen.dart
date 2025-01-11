import 'package:flutter/material.dart';
import 'package:reservation_app/l10n/flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:reservation_app/providers/auth.dart';

import 'package:reservation_app/widgets/drawer.dart';
import 'package:reservation_app/widgets/my_app_bar.dart';
import 'package:reservation_app/widgets/about_me_screen/header.dart';
import 'package:reservation_app/widgets/about_me_screen/body.dart';
import 'package:reservation_app/widgets/about_me_screen/description.dart';
import 'package:reservation_app/widgets/home_screen/pic_holder.dart';

import 'package:reservation_app/screens/about_me_screen_edit.dart';

import 'package:reservation_app/providers/screens.dart';
import 'package:reservation_app/modells/about_me_screen_modell.dart';

class AboutMeScreen extends StatefulWidget {
  const AboutMeScreen({super.key});
  static const routerName = "/aboutme";

  @override
  State<AboutMeScreen> createState() => _AboutMeScreenState();
}

class _AboutMeScreenState extends State<AboutMeScreen> {
  bool _didRun = false;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    if (!_didRun) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<ScreenProvider>(context, listen: false)
          .getAboutMeScreen()
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _didRun = true;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    AboutMeScreenData? screenData =
        Provider.of<ScreenProvider>(context).aboutMeScreen;
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
                          builder: (context) => AboutMeScreenEdit(screenData)));
                },
                icon: const Icon(Icons.edit))
        ],
        appbar: AppBar(),
        title: Text(AppLocalizations.of(context)!.aboutme),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  const ImageHolder(
                      "http://api.wombat-tech.tk/aboutmescreen/picture"),
                  AboutMeHeader(screenData!),
                  AboutMeBody(screenData),
                  AboutMeScreenDescription(screenData),
                  const SizedBox(
                    height: 45,
                  )
                ],
              ),
            ),
      drawer: const AppDrawer(),
    );
  }
}
