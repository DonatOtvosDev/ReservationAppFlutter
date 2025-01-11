import 'package:flutter/material.dart';

import 'package:reservation_app/modells/home_screen_modell.dart';

class HomeScreenHeader extends StatelessWidget {
  final HomeScreenData screenData;
  const HomeScreenHeader(this.screenData, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment(0.8, 1),
                colors: [
                  Color.fromRGBO(233, 161, 120, 1),
                  Color.fromRGBO(168, 68, 72, 1),
                ]),
            borderRadius: const BorderRadius.all(
              Radius.circular(30),
            )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                width: MediaQuery.of(context).size.width,
                child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      screenData.title,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ))),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.45,
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(screenData.subtitle,
                    style: const TextStyle(color: Colors.white)),
              ),
            ),
            const Divider(
              height: 20,
              thickness: 5,
              color: Colors.white30,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.1,
                  vertical: 10),
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(screenData.slogan,
                    style: const TextStyle(color: Colors.white)),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.2,
                  vertical: 5),
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    screenData.news.toUpperCase(),
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
