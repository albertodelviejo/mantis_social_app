import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../app_localizations.dart';
import 'UserDOB.dart';
import 'UserName.dart';
import '../util/color.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Container(
                  height: MediaQuery.of(context).size.height * .8,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 150,
                        ),
                        Text(
                          AppLocalizations.of(context)
                              .translate('welcome_title'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 35,
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.normal),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.all(8),
                          title: Text(
                            AppLocalizations.of(context)
                                .translate('welcome_please'),
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.all(8),
                          title: Text(
                            AppLocalizations.of(context)
                                .translate('welcome_yourself'),
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            AppLocalizations.of(context)
                                .translate('welcome_true'),
                            style: TextStyle(
                              fontSize: 17,
                            ),
                          ),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.all(8),
                          title: Text(
                            AppLocalizations.of(context)
                                .translate('welcome_cool'),
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            AppLocalizations.of(context)
                                .translate('welcome_respect'),
                            style: TextStyle(
                              fontSize: 17,
                            ),
                          ),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.all(8),
                          title: Text(
                            AppLocalizations.of(context)
                                .translate('welcome_safe'),
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            AppLocalizations.of(context)
                                .translate('welcome_not_quick'),
                            style: TextStyle(
                              fontSize: 17,
                            ),
                          ),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.all(8),
                          title: Text(
                            AppLocalizations.of(context)
                                .translate('welcome_proactive'),
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            AppLocalizations.of(context)
                                .translate('welcome_report'),
                            style: TextStyle(
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 40, top: 50),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: InkWell(
                    child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(25),
                            gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [
                                  primaryColor.withOpacity(.5),
                                  primaryColor.withOpacity(.8),
                                  primaryColor,
                                  primaryColor
                                ])),
                        height: MediaQuery.of(context).size.height * .065,
                        width: MediaQuery.of(context).size.width * .75,
                        child: Center(
                            child: Text(
                          AppLocalizations.of(context)
                              .translate('welcome_got_it'),
                          style: TextStyle(
                              fontSize: 15,
                              color: textColor,
                              fontWeight: FontWeight.bold),
                        ))),
                    onTap: () async {
                      User _user = FirebaseAuth.instance.currentUser;
                      if (_user.displayName != null) {
                        if (_user.displayName.length > 0) {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => UserDOB(
                                      {'UserName': _user.displayName})));
                        } else {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => UserName()));
                        }
                      } else {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => UserName()));
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
