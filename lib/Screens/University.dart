import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mantissocial/util/university_suggestions_th.dart';
import '../app_localizations.dart';
import '../util/university_suggestions_en.dart';
import '../util/color.dart';
import 'AllowLocation.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

class University extends StatefulWidget {
  final Map<String, dynamic> userData;
  University(this.userData);

  @override
  _UniversityState createState() => _UniversityState();
}

class _UniversityState extends State<University> {
  String university = '';
  TextEditingController textEditingController = new TextEditingController();
  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();

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
                      AppLocalizations.of(context)
                          .translate('university_title'),
                      style: TextStyle(fontSize: 40),
                    ),
                    padding: EdgeInsets.only(left: 50, top: 120),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Container(
                  child: SimpleAutoCompleteTextField(
                    key: key,
                    suggestions:
                        AppLocalizations.of(context).locale.languageCode == 'th'
                            ? suggestionsthai
                            : suggestions,
                    controller: textEditingController,
                    style: TextStyle(fontSize: 23),
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)
                          .translate('university_hint'),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: primaryColor)),
                      helperText: AppLocalizations.of(context)
                          .translate('university_helper'),
                      helperStyle:
                          TextStyle(color: secondryColor, fontSize: 15),
                    ),
                    textChanged: (value) {
                      setState(() {
                        university = value;
                      });
                    },
                  ),
                ),
              ),
              university.length > 0
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
                            university = textEditingController.value.text;
                            widget.userData.addAll({
                              'editInfo': {
                                'university': "$university",
                                'userGender': widget.userData['userGender'],
                                'showOnProfile':
                                    widget.userData['showOnProfile'],
                                'facebook_url': widget.userData['facebook_url'],
                                'instagram_url':
                                    widget.userData['instagram_url'],
                                'line_url': widget.userData['line_url'],
                                'snapchat_url': widget.userData['snapchat_url'],
                                'tiktok_url': widget.userData['tiktok_url'],
                                'twitter_url': widget.userData['twitter_url'],
                                'wechat_url': widget.userData['wechat_url'],
                                'whatsapp_url': widget.userData['whatsapp_url'],
                              }
                            });
                            widget.userData.remove('showOnProfile');
                            widget.userData.remove('userGender');

                            print(widget.userData);
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) =>
                                        AllowLocation(widget.userData)));
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
