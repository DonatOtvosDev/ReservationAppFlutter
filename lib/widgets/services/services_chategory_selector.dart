import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:reservation_app/providers/services.dart';

class CategorySelect extends StatelessWidget {
  const CategorySelect({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Hero(
        tag: "categoryselector",
        child: Container(
          padding: const EdgeInsets.all(3),
          height: 70,
          width: 250,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13),
              color: Theme.of(context).colorScheme.secondary),
          child: ListView.builder(
              padding: const EdgeInsets.all(0),
              itemCount: Provider.of<Services>(context, listen: false)
                  .items
                  .keys
                  .length,
              itemBuilder: ((ctx, i) => ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(
                      Provider.of<Services>(context, listen: false)
                          .items
                          .keys
                          .elementAt(i)),
                  child: Text(Provider.of<Services>(context, listen: false)
                      .items
                      .keys
                      .elementAt(i))))),
        ),
      ),
    );
  }
}
