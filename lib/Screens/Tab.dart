import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../app_localizations.dart';
import 'Profile/profile.dart';
import 'Splash.dart';
import 'blockUserByAdmin.dart';
import 'notifications.dart';
import '../models/user_model.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'Calling/incomingCall.dart';
import 'Chat/home_screen.dart';
import 'Home.dart';
import '../util/color.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

List likedByList = [];

class Tabbar extends StatefulWidget {
  final bool isPaymentSuccess;
  final String plan;
  Tabbar(this.plan, this.isPaymentSuccess);
  @override
  TabbarState createState() => TabbarState();
}

//_
class TabbarState extends State<Tabbar> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  CollectionReference docRef = FirebaseFirestore.instance.collection('Users');
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  UserModel currentUser;
  List<UserModel> matches = [];
  List<UserModel> newmatches = [];

  List<UserModel> users = [];

  /// Past purchases
  List<PurchaseDetails> purchases = [];
  InAppPurchaseConnection _iap = InAppPurchaseConnection.instance;
  bool isPuchased = false;
  @override
  void initState() {
    super.initState();
    // Show payment success alert.
    if (widget.isPaymentSuccess != null && widget.isPaymentSuccess) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await Alert(
          context: context,
          type: AlertType.success,
          title: AppLocalizations.of(context).translate('tab_alert_title'),
          desc: AppLocalizations.of(context).translate('tab_alert_desc') +
              " ${widget.plan} plan.",
          buttons: [
            DialogButton(
              child: Text(
                "Ok",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
              width: 120,
            )
          ],
        ).show();
      });
    }
    _getAccessItems();
    _getCurrentUser();
    _getMatches();
    _getpastPurchases();
  }

  Map items = {};
  _getAccessItems() async {
    FirebaseFirestore.instance
        .collection("Item_access")
        .snapshots()
        .listen((doc) {
      if (doc.docs.length > 0) {
        items = doc.docs[0].data();
        print(doc.docs[0].data());
      }

      if (mounted) setState(() {});
    });
  }

  Future<void> _getpastPurchases() async {
    print('in past purchases');
    QueryPurchaseDetailsResponse response = await _iap.queryPastPurchases();
    print('response   ${response.pastPurchases}');
    for (PurchaseDetails purchase in response.pastPurchases) {
      // if (Platform.isIOS) {
      await _iap.completePurchase(purchase);
      // }
    }
    setState(() {
      purchases = response.pastPurchases;
    });
    if (response.pastPurchases.length > 0) {
      purchases.forEach((purchase) async {
        print('   ${purchase.productID}');
        await _verifyPuchase(purchase.productID);
      });
    }
  }

  /// check if user has pruchased
  PurchaseDetails _hasPurchased(String productId) {
    return purchases.firstWhere((purchase) => purchase.productID == productId,
        orElse: () => null);
  }

  ///verifying pourchase of user
  Future<void> _verifyPuchase(String id) async {
    PurchaseDetails purchase = _hasPurchased(id);

    if (purchase != null && purchase.status == PurchaseStatus.purchased) {
      print(purchase.productID);
      if (Platform.isIOS) {
        await _iap.completePurchase(purchase);
        print('Achats ant??rieurs........$purchase');
        isPuchased = true;
      }
      isPuchased = true;
    } else {
      isPuchased = false;
    }
  }

  int swipecount = 0;
  _getSwipedcount() {
    FirebaseFirestore.instance
        .collection('/Users/${currentUser.id}/CheckedUser')
        .where(
          'timestamp',
          isGreaterThan: Timestamp.now().toDate().subtract(Duration(days: 1)),
        )
        .snapshots()
        .listen((event) {
      print(event.docs.length);
      setState(() {
        swipecount = event.docs.length;
      });
      return event.docs.length;
    });
  }

/*
  configurePushNotification(User user) async {
    await _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(
            alert: true, sound: true, provisional: false, badge: true));

    _firebaseMessaging.getToken().then((token) {
      print(token);
      docRef.doc(user.uid).update({
        'pushToken': token,
      });
    });

    _firebaseMessaging.configure(
      onLaunch: (Map<String, dynamic> message) async {
        print('===============onLaunch$message');
        if (Platform.isIOS && message['type'] == 'Call') {
          Map callInfo = {};
          callInfo['channel_id'] = message['channel_id'];
          callInfo['senderName'] = message['senderName'];
          callInfo['senderPicture'] = message['senderPicture'];
          bool iscallling = await _checkcallState(message['channel_id']);
          print("=================$iscallling");
          if (iscallling) {
            await Navigator.push(context,
                MaterialPageRoute(builder: (context) => Incoming(message)));
          }
        } else if (Platform.isAndroid && message['data']['type'] == 'Call') {
          bool iscallling =
              await _checkcallState(message['data']['channel_id']);
          print("=================$iscallling");
          if (iscallling) {
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Incoming(message['data'])));
          } else {
            print("Timeout");
          }
        }
      },
      onMessage: (Map<String, dynamic> message) async {
        print("onmessage$message");
        if (Platform.isIOS && message['type'] == 'Call') {
          Map callInfo = {};
          callInfo['channel_id'] = message['channel_id'];
          callInfo['senderName'] = message['senderName'];
          callInfo['senderPicture'] = message['senderPicture'];
          await Navigator.push(context,
              MaterialPageRoute(builder: (context) => Incoming(callInfo)));
        } else if (Platform.isAndroid && message['data']['type'] == 'Call') {
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Incoming(message['data'])));
        } else
          print("object");
      },
      onResume: (Map<String, dynamic> message) async {
        print('onResume$message');
        if (Platform.isIOS && message['type'] == 'Call') {
          Map callInfo = {};
          callInfo['channel_id'] = message['channel_id'];
          callInfo['senderName'] = message['senderName'];
          callInfo['senderPicture'] = message['senderPicture'];
          bool iscallling = await _checkcallState(message['channel_id']);
          print("=================$iscallling");
          if (iscallling) {
            await Navigator.push(context,
                MaterialPageRoute(builder: (context) => Incoming(message)));
          }
        } else if (Platform.isAndroid && message['data']['type'] == 'Call') {
          bool iscallling =
              await _checkcallState(message['data']['channel_id']);
          print("=================$iscallling");
          if (iscallling) {
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Incoming(message['data'])));
          } else {
            print("Timeout");
          }
        }
      },
    );
  }
*/
  configurePushNotificationNew(User user) async {
    await _firebaseMessaging.requestPermission(
        alert: true, sound: true, provisional: false, badge: true);

    _firebaseMessaging.getToken().then((token) {
      print(token);
      docRef.doc(user.uid).update({
        'pushToken': token,
      });
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("onmessage$message");
      if (Platform.isIOS && message.data['type'] == 'Call') {
        Map callInfo = {};
        callInfo['channel_id'] = message.data['channel_id'];
        callInfo['senderName'] = message.data['senderName'];
        callInfo['senderPicture'] = message.data['senderPicture'];
        await Navigator.push(context,
            MaterialPageRoute(builder: (context) => Incoming(callInfo)));
      } else if (Platform.isAndroid && message.data['type'] == 'Call') {
        await Navigator.push(context,
            MaterialPageRoute(builder: (context) => Incoming(message.data)));
      } else
        print("object");
    });
  }

  _checkcallState(channelId) async {
    bool iscalling = await FirebaseFirestore.instance
        .collection("calls")
        .doc(channelId)
        .get()
        .then((value) {
      return value.data()["calling"] ?? false;
    });
    return iscalling;
  }

  _getMatches() async {
    User user = _firebaseAuth.currentUser;
    return FirebaseFirestore.instance
        .collection('/Users/${user.uid}/Matches')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((ondata) {
      matches.clear();
      newmatches.clear();
      if (ondata.docs.length > 0) {
        ondata.docs.forEach((f) async {
          DocumentSnapshot doc = await docRef.doc(f.data()['Matches']).get();
          if (doc.exists) {
            UserModel tempuser = UserModel.fromDocument(doc);
            tempuser.distanceBW = calculateDistance(
                    currentUser.coordinates['latitude'],
                    currentUser.coordinates['longitude'],
                    tempuser.coordinates['latitude'],
                    tempuser.coordinates['longitude'])
                .round();

            matches.add(tempuser);
            newmatches.add(tempuser);
            if (mounted) setState(() {});
          }
        });
      }
    });
  }

  _getCurrentUser() async {
    User user = _firebaseAuth.currentUser;
    return docRef.doc("${user.uid}").snapshots().listen((data) async {
      currentUser = UserModel.fromDocument(data);
      if (mounted) setState(() {});
      users.clear();
      userRemoved.clear();
      getUserList();
      getLikedByList();
      configurePushNotificationNew(user);
      if (!isPuchased) {
        _getSwipedcount();
      }
      return currentUser;
    });
  }

  query() {
    if (currentUser.showGender.contains('everyone')) {
      return docRef
          .where(
            'age',
            isGreaterThanOrEqualTo: int.parse(currentUser.ageRange['min']),
          )
          .where('age',
              isLessThanOrEqualTo: int.parse(currentUser.ageRange['max']))
          .orderBy('age', descending: false);
    } else {
      return docRef
          .where('editInfo.userGender', whereIn: currentUser.showGender)
          .where(
            'age',
            isGreaterThanOrEqualTo: int.parse(currentUser.ageRange['min']),
          )
          .where('age',
              isLessThanOrEqualTo: int.parse(currentUser.ageRange['max']))
          //FOR FETCH USER WHO MATCH WITH USER SEXUAL ORIENTAION
          // .where('sexualOrientation.orientation',
          //     arrayContainsAny: currentUser.sexualOrientation)
          .orderBy('age', descending: false);
    }
  }

  Future getUserList() async {
    List checkedUser = [];
    FirebaseFirestore.instance
        .collection('/Users/${currentUser.id}/CheckedUser')
        .get()
        .then((data) {
      checkedUser.addAll(data.docs.map((f) => f['DislikedUser']));
      checkedUser.addAll(data.docs.map((f) => f['LikedUser']));
    }).then((_) {
      query().get().then((data) async {
        if (data.docs.length < 1) {
          print("no more data");
          return;
        }
        users.clear();
        userRemoved.clear();
        for (var doc in data.docs) {
          UserModel temp = UserModel.fromDocument(doc);
          var distance = calculateDistance(
              currentUser.coordinates['latitude'],
              currentUser.coordinates['longitude'],
              temp.coordinates['latitude'],
              temp.coordinates['longitude']);
          temp.distanceBW = distance.round();
          if (checkedUser.any(
            (value) => value == temp.id,
          )) {
          } else {
            if (distance <= currentUser.maxDistance &&
                temp.id != currentUser.id &&
                !temp.isBlocked) {
              users.add(temp);
            }
          }
        }
        if (mounted) setState(() {});
      });
    });
  }

  getLikedByList() {
    docRef
        .doc(currentUser.id)
        .collection("LikedBy")
        .snapshots()
        .listen((data) async {
      likedByList.addAll(data.docs.map((f) => f['LikedBy']));
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Exit'),
              content: Text('Do you want to exit the app?'),
              actions: <Widget>[
                FlatButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('No'),
                ),
                FlatButton(
                  onPressed: () => SystemChannels.platform
                      .invokeMethod('SystemNavigator.pop'),
                  child: Text('Yes'),
                ),
              ],
            );
          },
        );
      },
      child: Scaffold(
        body: currentUser == null
            ? Center(child: Splash())
            : currentUser.isBlocked
                ? BlockUser()
                : DefaultTabController(
                    length: 4,
                    initialIndex: widget.isPaymentSuccess != null
                        ? widget.isPaymentSuccess
                            ? 0
                            : 1
                        : 1,
                    child: Scaffold(
                        appBar: AppBar(
                          elevation: 0,
                          backgroundColor: primaryColor,
                          automaticallyImplyLeading: false,
                          title: TabBar(
                              labelColor: Colors.white,
                              indicatorColor: Colors.white,
                              unselectedLabelColor: Colors.black,
                              isScrollable: false,
                              indicatorSize: TabBarIndicatorSize.label,
                              tabs: [
                                Tab(
                                  icon: Icon(
                                    Icons.person,
                                    size: 30,
                                  ),
                                ),
                                Tab(
                                  icon: Icon(
                                    Icons.whatshot,
                                  ),
                                ),
                                Tab(
                                  icon: Icon(
                                    Icons.notifications,
                                  ),
                                ),
                                Tab(
                                  icon: Icon(
                                    Icons.message,
                                  ),
                                )
                              ]),
                        ),
                        body: TabBarView(
                          children: [
                            Center(
                                child: Profile(
                                    currentUser, isPuchased, purchases, items)),
                            Center(
                                child: CardPictures(
                                    currentUser, users, swipecount, items)),
                            Center(child: Notifications(currentUser)),
                            Center(
                                child: HomeScreen(
                                    currentUser, matches, newmatches)),
                          ],
                          physics: NeverScrollableScrollPhysics(),
                        )),
                  ),
      ),
    );
  }
}

double calculateDistance(lat1, lon1, lat2, lon2) {
  var p = 0.017453292519943295;
  var c = cos;
  var a = 0.5 -
      c((lat2 - lat1) * p) / 2 +
      c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
  return 12742 * asin(sqrt(a));
}
