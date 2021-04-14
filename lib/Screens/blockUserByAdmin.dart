import 'package:flutter/material.dart';
import '../app_localizations.dart';
import '../util/color.dart';

class BlockUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondryColor.withOpacity(.5),
      body: AlertDialog(
        actionsPadding: EdgeInsets.only(right: 10),
        backgroundColor: Colors.white,
        actions: [
          Text("for more info visit: https://help.deligence.com"),
        ],
        title: Column(
          children: [
            Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Center(
                  child: Container(
                      height: 50,
                      width: 100,
                      child: Image.asset(
                        "asset/mantis_main_logo.png",
                        fit: BoxFit.contain,
                      )),
                )),
            Text(
              AppLocalizations.of(context)
                  .translate('block_user_by_admin_sorry'),
              style: TextStyle(color: primaryColor),
            ),
          ],
        ),
        content:
            Text(AppLocalizations.of(context).translate('block_user_message')),
      ),
    );
  }
}
