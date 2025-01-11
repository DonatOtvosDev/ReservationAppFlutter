import 'package:flutter/material.dart';

class HomeScreenBody extends StatelessWidget {
  final String header;
  final String content;
  const HomeScreenBody(this.header, this.content, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment(0.8, 1),
              colors: [
                Color.fromRGBO(168, 68, 72, 1),
                Color.fromRGBO(233, 161, 120, 1),
              ]),
          borderRadius: const BorderRadius.all(Radius.circular(30))),
      child: Text(
        "$header:\n$content",
        style: const TextStyle(color: Colors.white, fontSize: 16),
        textAlign: TextAlign.justify,
        softWrap: true,
      ),
    );
  }
}
