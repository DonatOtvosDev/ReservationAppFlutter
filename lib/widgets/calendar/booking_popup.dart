import 'package:flutter/material.dart';

import 'package:reservation_app/modells/appointment_modells.dart';

import 'package:provider/provider.dart';
import 'package:reservation_app/modells/service_modell.dart';
import 'package:reservation_app/providers/services.dart';

class BookingPopUp extends StatelessWidget {
  final Appointment appointment;
  const BookingPopUp(this.appointment, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Hero(
      tag: appointment.id,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: SizedBox(
          width: MediaQuery.of(context).size.width - 40,
          height: MediaQuery.of(context).size.height * 0.25,
          child: Card(
            color: Colors.grey,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: FutureBuilder(
              future: Provider.of<Services>(context).fetchAndSetServices(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else {
                  final List<Service> allServices =
                      Provider.of<Services>(context).allServices;
                  return Container(
                    padding: const EdgeInsets.all(12),
                    child: ListView.builder(
                        padding: const EdgeInsets.all(0),
                        itemCount: allServices.length,
                        itemBuilder: ((ctx, i) => SizedBox(
                              height: 55,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6),
                                child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context, allServices[i]);
                                    },
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  allServices[i].name,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16),
                                                ),
                                                Text(
                                                  allServices[i].type,
                                                  style: const TextStyle(
                                                      fontSize: 12),
                                                )
                                              ]),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                  "${allServices[i].price} ${allServices[i].comment}"),
                                              Text(
                                                  "${allServices[i].duration} min")
                                            ],
                                          )
                                        ])),
                              ),
                            ))),
                  );
                }
              },
            ),
          ),
        ),
      ),
    ));
  }
}
