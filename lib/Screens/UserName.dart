import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../app_localizations.dart';
import 'UserDOB.dart';
import '../ads/ads.dart';
import '../util/color.dart';

class UserName extends StatefulWidget {
  @override
  _UserNameState createState() => _UserNameState();
}

BannerAd ad1;
Ads ads = new Ads();

class _UserNameState extends State<UserName> {
  Map<String, dynamic> userData = {}; //user personal info
  String username = '';

  @override
  void initState() {
    ad1 = ads.myBanner();
    super.initState();
    ad1.load();
    /*
      ..show(
        anchorOffset: 180.0,
        anchorType: AnchorType.bottom,
      );
      */
  }

  @override
  void dispose() {
    ads.disable(ad1);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: AnimatedOpacity(
        opacity: 1.0,
        duration: Duration(milliseconds: 50),
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: FloatingActionButton(
            elevation: 10,
            child: IconButton(
              color: secondryColor,
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            backgroundColor: Colors.white38,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Padding(
                    child: Text(
                      AppLocalizations.of(context).translate('user_name_name'),
                      style: TextStyle(fontSize: 40),
                    ),
                    padding: EdgeInsets.only(left: 50, top: 120),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Container(
                  child: TextFormField(
                    style: TextStyle(fontSize: 23),
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)
                          .translate('user_name_hint'),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: primaryColor)),
                      helperText: AppLocalizations.of(context)
                          .translate('user_name_helper'),
                      helperStyle:
                          TextStyle(color: secondryColor, fontSize: 15),
                    ),
                    onChanged: (value) {
                      setState(() {
                        username = value;
                      });
                    },
                  ),
                ),
              ),
              username.length > 0
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 40),
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
                                    .translate('search_location_continue_cap'),
                                style: TextStyle(
                                    fontSize: 15,
                                    color: textColor,
                                    fontWeight: FontWeight.bold),
                              ))),
                          onTap: () {
                            userData.addAll({'UserName': "$username"});
                            print(userData);
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => UserDOB(userData)));
                          },
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: InkWell(
                          child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              height: MediaQuery.of(context).size.height * .065,
                              width: MediaQuery.of(context).size.width * .75,
                              child: Center(
                                  child: Text(
                                AppLocalizations.of(context)
                                    .translate('search_location_continue_cap'),
                                style: TextStyle(
                                    fontSize: 15,
                                    color: secondryColor,
                                    fontWeight: FontWeight.bold),
                              ))),
                          onTap: () {},
                        ),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
