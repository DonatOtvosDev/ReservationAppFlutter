import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reservation_app/l10n/flutter_gen/gen_l10n/app_localizations.dart';

import 'package:provider/provider.dart';
import 'package:reservation_app/providers/screens.dart';

class ImageUploader extends StatelessWidget {
  final ImagePicker picker = ImagePicker();
  final String screen;
  ImageUploader(this.screen, {super.key});

  Future<void> _getImage(ImageSource imageSource, BuildContext ctx,
      AppLocalizations applocal) async {
    final XFile? image = await picker.pickImage(
        source: imageSource, maxWidth: 720, maxHeight: 480);
    if (image == null) return;

    if (ctx.mounted) {
      final bool accepted = await showDialog(
          context: ctx,
          builder: ((context) => AlertDialog(
                contentPadding: const EdgeInsets.all(0),
                content: Image.file(File(image.path)),
                actions: [
                  TextButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      label: Text(applocal.delete),
                      icon: const Icon(Icons.delete)),
                  TextButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      label: Text(applocal.submit),
                      icon: const Icon(Icons.save)),
                ],
              )));
      if (!accepted) {
        return;
      }
    } else {
      return;
    }
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(
              margin: const EdgeInsets.only(left: 7),
              child: Text(applocal.loadingtxt)),
        ],
      ),
    );
    if (ctx.mounted) {
      showDialog(
        barrierDismissible: false,
        context: ctx,
        builder: (BuildContext context) {
          return alert;
        },
      );
      await Provider.of<ScreenProvider>(ctx, listen: false)
          .uploadNewPicture(screen, File(image.path));

      if (ctx.mounted) Navigator.of(ctx).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLocalization = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          appLocalization.changepic,
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
        IconButton(
          onPressed: () =>
              _getImage(ImageSource.camera, context, appLocalization),
          icon: const Icon(
            Icons.add_a_photo,
          ),
        ),
        IconButton(
            onPressed: () =>
                _getImage(ImageSource.gallery, context, appLocalization),
            icon: const Icon(
              Icons.camera,
            ))
      ],
    );
  }
}
