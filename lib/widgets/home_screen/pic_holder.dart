import 'package:flutter/material.dart';
import 'package:reservation_app/l10n/flutter_gen/gen_l10n/app_localizations.dart';

class ImageHolder extends StatelessWidget {
  final String url;
  const ImageHolder(this.url, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      constraints: const BoxConstraints(minHeight: 100),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          gradient: const LinearGradient(
              begin: Alignment(0.2, 1),
              end: Alignment.topRight,
              colors: [
                Color.fromRGBO(165, 108, 144, 1),
                Color.fromRGBO(131, 59, 106, 1)
              ]),
          borderRadius: const BorderRadius.all(
            Radius.circular(30),
          )),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Image.network(
            url,
            fit: BoxFit.cover,
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Padding(
                padding: const EdgeInsets.all(18),
                child: Text(AppLocalizations.of(context)!.imgnonavailable,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w700)),
              );
            },
          )),
    );
  }
}
