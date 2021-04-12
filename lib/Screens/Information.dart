import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:swipe_stack/swipe_stack.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/user_model.dart';
import '../util/color.dart';
import 'Chat/Matches.dart';
import 'Chat/chatPage.dart';
import 'Profile/EditProfile.dart';
import 'reportUser.dart';

class Info extends StatelessWidget {
  final UserModel currentUser;
  final UserModel user;

  final GlobalKey<SwipeStackState> swipeKey;
  Info(
    this.user,
    this.currentUser,
    this.swipeKey,
  );

  @override
  Widget build(BuildContext context) {
    bool isMe = user.id == currentUser.id;
    bool isMatched = swipeKey == null;
    //  if()

    //matches.any((value) => value.id == user.id);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50), topRight: Radius.circular(50)),
            color: Colors.white),
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    height: 500,
                    width: MediaQuery.of(context).size.width,
                    child: Swiper(
                      key: UniqueKey(),
                      physics: ScrollPhysics(),
                      itemBuilder: (BuildContext context, int index2) {
                        return user.imageUrl.length != null
                            ? Hero(
                                tag: "abc",
                                child: CachedNetworkImage(
                                  imageUrl: user.imageUrl[index2] ?? '',
                                  fit: BoxFit.cover,
                                  useOldImageOnUrlChange: true,
                                  placeholder: (context, url) =>
                                      CupertinoActivityIndicator(
                                    radius: 20,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                              )
                            : Container();
                      },
                      itemCount: user.imageUrl.length,
                      pagination: new SwiperPagination(
                          alignment: Alignment.bottomCenter,
                          builder: DotSwiperPaginationBuilder(
                              activeSize: 13,
                              color: secondryColor,
                              activeColor: primaryColor)),
                      control: new SwiperControl(
                        color: primaryColor,
                        disableColor: secondryColor,
                      ),
                      loop: false,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            subtitle: Text("${user.address}"),
                            title: Text(
                              "${user.name}, ${user.editInfo['showMyAge'] != null ? !user.editInfo['showMyAge'] ? user.age : "" : user.age}",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                            trailing: FloatingActionButton(
                                backgroundColor: Colors.white,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(
                                  Icons.arrow_downward,
                                  color: primaryColor,
                                )),
                          ),
                          user.editInfo['job_title'] != null
                              ? ListTile(
                                  dense: true,
                                  leading:
                                      Icon(Icons.work, color: primaryColor),
                                  title: Text(
                                    "${user.editInfo['job_title']}${user.editInfo['company'] != null ? ' at ${user.editInfo['company']}' : ''}",
                                    style: TextStyle(
                                        color: secondryColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                )
                              : Container(),
                          user.editInfo['university'] != null
                              ? ListTile(
                                  dense: true,
                                  leading:
                                      Icon(Icons.stars, color: primaryColor),
                                  title: Text(
                                    "${user.editInfo['university']}",
                                    style: TextStyle(
                                        color: secondryColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                )
                              : Container(),
                          user.editInfo['living_in'] != null
                              ? ListTile(
                                  dense: true,
                                  leading:
                                      Icon(Icons.home, color: primaryColor),
                                  title: Text(
                                    "Living in ${user.editInfo['living_in']}",
                                    style: TextStyle(
                                        color: secondryColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                )
                              : Container(),
                          !isMe
                              ? ListTile(
                                  dense: true,
                                  leading: Icon(
                                    Icons.location_on,
                                    color: primaryColor,
                                  ),
                                  title: Text(
                                    "${user.editInfo['DistanceVisible'] != null ? user.editInfo['DistanceVisible'] ? 'Less than ${user.distanceBW} KM away' : 'Distance not visible' : 'Less than ${user.distanceBW} KM away'}",
                                    style: TextStyle(
                                        color: secondryColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                )
                              : Container(),
                          Divider(),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  user.editInfo['about'] != null
                      ? Text(
                          "${user.editInfo['about']}",
                          style: TextStyle(
                              color: secondryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        )
                      : Container(),
                  SizedBox(
                    height: 20,
                  ),
                  user.editInfo['about'] != null ? Divider() : Container(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: socialMediaRow(user),
                  ),
                  InkWell(
                    onTap: () => showDialog(
                        barrierDismissible: true,
                        context: context,
                        builder: (context) => ReportUser(
                              currentUser: currentUser,
                              seconduser: user,
                            )),
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: Text(
                            "REPORT ${user.name}".toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: secondryColor),
                          ),
                        )),
                  ),
                  Divider(),
                  SizedBox(
                    height: 100,
                  ),
                ],
              ),
            ),
            !isMatched
                ? Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          FloatingActionButton(
                              heroTag: UniqueKey(),
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.clear,
                                color: Colors.red,
                                size: 30,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                swipeKey.currentState.swipeLeft();
                              }),
                          FloatingActionButton(
                              heroTag: UniqueKey(),
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.favorite,
                                color: Colors.lightBlueAccent,
                                size: 30,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                swipeKey.currentState.swipeRight();
                              }),
                        ],
                      ),
                    ),
                  )
                : isMe
                    ? Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Align(
                            alignment: Alignment.bottomRight,
                            child: FloatingActionButton(
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.edit,
                                  color: primaryColor,
                                ),
                                onPressed: () => Navigator.pushReplacement(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) =>
                                            EditProfile(user))))),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Align(
                            alignment: Alignment.bottomRight,
                            child: FloatingActionButton(
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.message,
                                  color: primaryColor,
                                ),
                                onPressed: () => Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) => ChatPage(
                                              sender: currentUser,
                                              second: user,
                                              chatId: chatId(user, currentUser),
                                            ))))),
                      )
          ],
        ),
      ),
    );
  }
}

Widget socialMediaRow(UserModel user) {
  final String facebookUrl = user.editInfo['facebook_url'];
  final String instagramUrl = user.editInfo['instagram_url'];
  final String tiktokUrl = user.editInfo['tiktok_url'];
  final String twitterUrl = user.editInfo['twitter_url'];
  final String snapchatUrl = user.editInfo['snapchat_url'];
  final String whatsappUrl = user.editInfo['whatsapp_url'];
  final String wechatUrl = user.editInfo['wechat_url'];
  final String lineUrl = user.editInfo['line_url'];

  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (facebookUrl != null)
          GestureDetector(
            onTap: () => launch(facebookUrl),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Stack(children: [
                Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: new BoxDecoration(
                    color: Color(0xff3b5998),
                    shape: BoxShape.circle,
                  ),
                ),
                Positioned(
                  left: 10,
                  top: 10,
                  child: Container(
                      child: Image.asset(
                    'asset/facebook.png',
                    height: 20,
                    width: 20,
                  )),
                ),
              ]),
            ),
          ),
        if (instagramUrl != null)
          GestureDetector(
            onTap: () => launch(instagramUrl),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Stack(children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: new BoxDecoration(
                    color: Color(0xffC13584),
                    shape: BoxShape.circle,
                  ),
                ),
                Positioned(
                  left: 10,
                  top: 10,
                  child: Container(
                      child: Image.asset(
                    'asset/instagram.png',
                    height: 20,
                    width: 20,
                  )),
                ),
              ]),
            ),
          ),
        if (tiktokUrl != null)
          GestureDetector(
            onTap: () => launch(tiktokUrl),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Stack(children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: new BoxDecoration(
                    color: Color(0xff010101),
                    shape: BoxShape.circle,
                  ),
                ),
                Positioned(
                  left: 10,
                  top: 10,
                  child: Container(
                      child: Image.asset(
                    'asset/tiktok.png',
                    height: 20,
                    width: 20,
                  )),
                ),
              ]),
            ),
          ),
        if (twitterUrl != null)
          GestureDetector(
            onTap: () => launch(twitterUrl),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Stack(children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: new BoxDecoration(
                    color: Color(0xff1DA1F2),
                    shape: BoxShape.circle,
                  ),
                ),
                Positioned(
                  left: 10,
                  top: 10,
                  child: Container(
                      child: Image.asset(
                    'asset/twitter.png',
                    height: 20,
                    width: 20,
                  )),
                ),
              ]),
            ),
          ),
        if (snapchatUrl != null)
          GestureDetector(
            onTap: () => launch(snapchatUrl),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Stack(children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: new BoxDecoration(
                    color: Color(0xffFFFC00),
                    shape: BoxShape.circle,
                  ),
                ),
                Positioned(
                  left: 5,
                  top: 5,
                  child: Container(
                      child: Image.asset(
                    'asset/snapchat.png',
                    height: 30,
                    width: 30,
                  )),
                ),
              ]),
            ),
          ),
        if (whatsappUrl != null)
          GestureDetector(
            onTap: () => launch(whatsappUrl),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Stack(children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: new BoxDecoration(
                    color: Color(0xff25D366),
                    shape: BoxShape.circle,
                  ),
                ),
                Positioned(
                  left: 10,
                  top: 10,
                  child: Container(
                      child: Image.asset(
                    'asset/whatsapp.png',
                    height: 20,
                    width: 20,
                  )),
                ),
              ]),
            ),
          ),
        if (wechatUrl != null)
          GestureDetector(
            onTap: () => launch(wechatUrl),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Stack(children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: new BoxDecoration(
                    color: Color(0xff7bb32e),
                    shape: BoxShape.circle,
                  ),
                ),
                Positioned(
                  left: 10,
                  top: 10,
                  child: Container(
                      child: Image.asset(
                    'asset/wechat.png',
                    height: 20,
                    width: 20,
                  )),
                ),
              ]),
            ),
          ),
        if (lineUrl != null)
          GestureDetector(
            onTap: () => launch(lineUrl),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Stack(children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: new BoxDecoration(
                    color: Color(0xff00B900),
                    shape: BoxShape.circle,
                  ),
                ),
                Positioned(
                  left: 5,
                  top: 5,
                  child: Container(
                      child: Image.asset(
                    'asset/line.png',
                    height: 30,
                    width: 30,
                  )),
                ),
              ]),
            ),
          ),
      ],
    ),
  );
}
