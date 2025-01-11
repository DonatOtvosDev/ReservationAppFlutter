import 'package:flutter/material.dart';

class UserFilterSelector extends StatelessWidget {
  final String chosenFilter;
  final Function switchChategory;
  final List<String> filters;
  const UserFilterSelector(
      this.chosenFilter, this.switchChategory, this.filters,
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
          style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16),
          value: chosenFilter,
          onChanged: (key) => switchChategory(key),
          items: [
            chosenFilter,
            ...filters.where((element) => element != chosenFilter)
          ]
              .map((keyname) => DropdownMenuItem(
                    value: keyname,
                    child: Text(
                      keyname,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                  ))
              .toList(),
        ));
  }
}
