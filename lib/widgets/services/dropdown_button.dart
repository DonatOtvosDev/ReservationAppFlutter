import 'package:flutter/material.dart';

class ServiceChategorySelector extends StatelessWidget {
  final String chosenChategory;
  final Function switchChategory;
  final Iterable<dynamic> keys;
  const ServiceChategorySelector(
      this.chosenChategory, this.keys, this.switchChategory,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      child: DropdownButton(
        icon: Icon(
          Icons.arrow_drop_down_circle_outlined,
          color: Theme.of(context).colorScheme.secondary,
          size: 18,
        ),
        style: TextStyle(
            color: Theme.of(context).colorScheme.secondary, fontSize: 16),
        value: chosenChategory,
        onChanged: (key) => switchChategory(key),
        items: [
          chosenChategory,
          ...keys.where((element) => element != chosenChategory)
        ]
            .map((keyname) => DropdownMenuItem(
                  value: keyname,
                  child: Text(keyname),
                ))
            .toList(),
      ),
    );
  }
}
