import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../ads/ads.dart';
import 'package:image/image.dart' as i;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../app_localizations.dart';
import '../../models/user_model.dart';
import '../../util/color.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class EditProfile extends StatefulWidget {
  final UserModel currentUser;
  EditProfile(this.currentUser);

  @override
  EditProfileState createState() => EditProfileState();
}

class EditProfileState extends State<EditProfile> {
  final TextEditingController aboutCtlr = new TextEditingController();
  final TextEditingController companyCtlr = new TextEditingController();
  final TextEditingController livingCtlr = new TextEditingController();
  final TextEditingController jobCtlr = new TextEditingController();
  final TextEditingController universityCtlr = new TextEditingController();
  final TextEditingController facebookCtlr = new TextEditingController();
  final TextEditingController instagramCtlr = new TextEditingController();
  final TextEditingController tiktokCtlr = new TextEditingController();
  final TextEditingController twitterCtlr = new TextEditingController();
  final TextEditingController lineCtlr = new TextEditingController();
  final TextEditingController whatsappCtlr = new TextEditingController();
  final TextEditingController snapchatCtlr = new TextEditingController();
  final TextEditingController wechatCtlr = new TextEditingController();
  bool visibleAge = false;
  bool visibleDistance = true;

  var showMe;
  Map editInfo = {};
  Ads _ads = new Ads();
  BannerAd _ad;
  @override
  void initState() {
    super.initState();
    aboutCtlr.text = widget.currentUser.editInfo['about'];
    companyCtlr.text = widget.currentUser.editInfo['company'];
    livingCtlr.text = widget.currentUser.editInfo['living_in'];
    universityCtlr.text = widget.currentUser.editInfo['university'];
    jobCtlr.text = widget.currentUser.editInfo['job_title'];
    instagramCtlr.text = widget.currentUser.editInfo['instagram_url'];
    facebookCtlr.text = widget.currentUser.editInfo['facebook_url'];
    tiktokCtlr.text = widget.currentUser.editInfo['tiktok_url'];
    twitterCtlr.text = widget.currentUser.editInfo['twitter_url'];
    lineCtlr.text = widget.currentUser.editInfo['line_url'];
    whatsappCtlr.text = widget.currentUser.editInfo['whatsapp_url'];
    snapchatCtlr.text = widget.currentUser.editInfo['snapchat_url'];
    wechatCtlr.text = widget.currentUser.editInfo['wechat_url'];
    setState(() {
      showMe = widget.currentUser.editInfo['userGender'];
      visibleAge = widget.currentUser.editInfo['showMyAge'] ?? false;
      visibleDistance = widget.currentUser.editInfo['DistanceVisible'] ?? true;
    });
    _ad = _ads.myBanner();
    super.initState();
    _ad..load();
  }

  @override
  void dispose() {
    super.dispose();
    print(editInfo.length);
    if (editInfo.length > 0) {
      updateData();
    }
    _ads.disable(_ad);
  }

  Future updateData() async {
    FirebaseFirestore.instance
        .collection("Users")
        .doc(widget.currentUser.id)
        .set({'editInfo': editInfo, 'age': widget.currentUser.age},
            SetOptions(merge: true));
  }

  Future source(
      BuildContext context, currentUser, bool isProfilePicture) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
              title: Text(isProfilePicture
                  ? AppLocalizations.of(context)
                      .translate('edit_profile_update_picture')
                  : AppLocalizations.of(context)
                      .translate('edit_profile_add_picture')),
              content: Text(
                AppLocalizations.of(context)
                    .translate('edit_profile_select_source'),
              ),
              insetAnimationCurve: Curves.decelerate,
              actions: currentUser.imageUrl.length < 9
                  ? <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: GestureDetector(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.photo_camera,
                                size: 28,
                              ),
                              Text(
                                AppLocalizations.of(context)
                                    .translate('edit_profile_camera'),
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                    decoration: TextDecoration.none),
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            showDialog(
                                context: context,
                                builder: (context) {
                                  getImage(ImageSource.camera, context,
                                      currentUser, isProfilePicture);
                                  return Center(
                                      child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ));
                                });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: GestureDetector(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.photo_library,
                                size: 28,
                              ),
                              Text(
                                AppLocalizations.of(context)
                                    .translate('edit_profile_gallery'),
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                    decoration: TextDecoration.none),
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  getImage(ImageSource.gallery, context,
                                      currentUser, isProfilePicture);
                                  return Center(
                                      child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ));
                                });
                          },
                        ),
                      ),
                    ]
                  : [
                      Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Center(
                            child: Column(
                          children: <Widget>[
                            Icon(Icons.error),
                            Text(
                              AppLocalizations.of(context)
                                  .translate('edit_profile_cant_more'),
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  decoration: TextDecoration.none),
                            ),
                          ],
                        )),
                      )
                    ]);
        });
  }

  Future getImage(
      ImageSource imageSource, context, currentUser, isProfilePicture) async {
    ImagePicker imagePicker = ImagePicker();
    var image = await imagePicker.getImage(source: imageSource);
    if (image != null) {
      File croppedFile = await ImageCropper.cropImage(
          sourcePath: image.path,
          cropStyle: CropStyle.circle,
          aspectRatioPresets: [CropAspectRatioPreset.square],
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Crop',
              toolbarColor: primaryColor,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.square,
              lockAspectRatio: true),
          iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
          ));
      if (croppedFile != null) {
        await uploadFile(
            await compressimage(croppedFile), currentUser, isProfilePicture);
      }
    }
    Navigator.pop(context);
  }

  Future uploadFile(File image, UserModel currentUser, isProfilePicture) async {
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('users/${currentUser.id}/${image.hashCode}.jpg');
    UploadTask uploadTask = storageReference.putFile(image);
    //if (uploadTask.isInProgress == true) {}
    uploadTask.whenComplete(() {
      storageReference.getDownloadURL().then((fileURL) async {
        Map<String, dynamic> updateObject = {
          "Pictures": FieldValue.arrayUnion([
            fileURL,
          ])
        };
        try {
          if (isProfilePicture) {
            //currentUser.imageUrl.removeAt(0);
            currentUser.imageUrl.insert(0, fileURL);
            print("object");
            await FirebaseFirestore.instance
                .collection("Users")
                .doc(currentUser.id)
                .set({"Pictures": currentUser.imageUrl},
                    SetOptions(merge: true));
          } else {
            await FirebaseFirestore.instance
                .collection("Users")
                .doc(currentUser.id)
                .set(updateObject, SetOptions(merge: true));
            widget.currentUser.imageUrl.add(fileURL);
          }
          if (mounted) setState(() {});
        } catch (err) {
          print("Error: $err");
        }
      });
    });
  }

  Future compressimage(File image) async {
    final tempdir = await getTemporaryDirectory();
    final path = tempdir.path;
    i.Image imagefile = i.decodeImage(image.readAsBytesSync());
    final compressedImagefile = File('$path.jpg')
      ..writeAsBytesSync(i.encodeJpg(imagefile, quality: 80));
    // setState(() {
    return compressedImagefile;
    // });
  }

  @override
  Widget build(BuildContext context) {
    // Profile _profile = new Profile(widget.currentUser);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          elevation: 0,
          title: Text(
            AppLocalizations.of(context).translate('edit_profile'),
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.white,
            onPressed: () => Navigator.pop(context),
          ),
          backgroundColor: primaryColor),
      body: Scaffold(
        backgroundColor: primaryColor,
        body: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50), topRight: Radius.circular(50)),
              color: Colors.white),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50), topRight: Radius.circular(50)),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height * .65,
                    width: MediaQuery.of(context).size.width,
                    child: GridView.count(
                        physics: NeverScrollableScrollPhysics(),
                        crossAxisCount: 3,
                        childAspectRatio:
                            MediaQuery.of(context).size.aspectRatio * 1.5,
                        crossAxisSpacing: 4,
                        padding: EdgeInsets.all(10),
                        children: List.generate(9, (index) {
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                decoration: widget.currentUser.imageUrl.length >
                                        index
                                    ? BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        // image: DecorationImage(
                                        //     fit: BoxFit.cover,
                                        //     image: CachedNetworkImageProvider(
                                        //       widget.currentUser.imageUrl[index],
                                        //     )),
                                      )
                                    : BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            style: BorderStyle.solid,
                                            width: 1,
                                            color: secondryColor)),
                                child: Stack(
                                  children: <Widget>[
                                    widget.currentUser.imageUrl.length > index
                                        ? CachedNetworkImage(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .2,
                                            fit: BoxFit.cover,
                                            imageUrl: widget.currentUser
                                                    .imageUrl[index] ??
                                                '',
                                            placeholder: (context, url) =>
                                                Center(
                                              child: CupertinoActivityIndicator(
                                                radius: 10,
                                              ),
                                            ),
                                            errorWidget:
                                                (context, url, error) => Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.error,
                                                    color: Colors.black,
                                                    size: 25,
                                                  ),
                                                  Text(
                                                    AppLocalizations.of(context)
                                                        .translate(
                                                            'edit_profile_enable_to_load'),
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        : Container(),
                                    // Center(
                                    //     child:
                                    //         widget.currentUser.imageUrl.length >
                                    //                 index
                                    //             ? CupertinoActivityIndicator(
                                    //                 radius: 10,
                                    //               )
                                    //             : Container()),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: Container(
                                          // width: 12,
                                          // height: 16,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: widget.currentUser.imageUrl
                                                        .length >
                                                    index
                                                ? Colors.white
                                                : primaryColor,
                                          ),
                                          child: widget.currentUser.imageUrl
                                                      .length >
                                                  index
                                              ? InkWell(
                                                  child: Icon(
                                                    Icons.cancel,
                                                    color: primaryColor,
                                                    size: 22,
                                                  ),
                                                  onTap: () async {
                                                    if (widget.currentUser
                                                            .imageUrl.length >
                                                        1) {
                                                      _deletePicture(index);
                                                    } else {
                                                      source(
                                                          context,
                                                          widget.currentUser,
                                                          true);
                                                    }
                                                  },
                                                )
                                              : InkWell(
                                                  child: Icon(
                                                    Icons.add_circle_outline,
                                                    size: 22,
                                                    color: Colors.white,
                                                  ),
                                                  onTap: () => source(
                                                      context,
                                                      widget.currentUser,
                                                      false),
                                                )),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        })),
                  ),
                  InkWell(
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
                                  primaryColor,
                                ])),
                        height: 50,
                        width: 340,
                        child: Center(
                            child: Text(
                          AppLocalizations.of(context)
                              .translate('edit_profile_add_media'),
                          style: TextStyle(
                              fontSize: 15,
                              color: textColor,
                              fontWeight: FontWeight.bold),
                        ))),
                    onTap: () async {
                      await source(context, widget.currentUser, false);
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListBody(
                      mainAxis: Axis.vertical,
                      children: <Widget>[
                        ListTile(
                          title: Text(
                            "About ${widget.currentUser.name}",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.black87),
                          ),
                          subtitle: CupertinoTextField(
                            controller: aboutCtlr,
                            cursorColor: primaryColor,
                            maxLines: 10,
                            minLines: 3,
                            placeholder: AppLocalizations.of(context)
                                .translate('edit_profile_about_you'),
                            padding: EdgeInsets.all(10),
                            onChanged: (text) {
                              editInfo.addAll({'about': text});
                            },
                          ),
                        ),
                        ListTile(
                          title: Text(
                            AppLocalizations.of(context)
                                .translate('edit_profile_job_title'),
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.black87),
                          ),
                          subtitle: CupertinoTextField(
                            controller: jobCtlr,
                            cursorColor: primaryColor,
                            placeholder: AppLocalizations.of(context)
                                .translate('edit_profile_add_job_title'),
                            padding: EdgeInsets.all(10),
                            onChanged: (text) {
                              editInfo.addAll({'job_title': text});
                            },
                          ),
                        ),
                        ListTile(
                          title: Padding(
                              padding: const EdgeInsets.only(bottom: 5.0),
                              child: Text(
                                AppLocalizations.of(context)
                                    .translate('edit_profile_company'),
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Colors.black87),
                              )),
                          subtitle: CupertinoTextField(
                            controller: companyCtlr,
                            cursorColor: primaryColor,
                            placeholder: AppLocalizations.of(context)
                                .translate('edit_profile_add_company'),
                            padding: EdgeInsets.all(10),
                            onChanged: (text) {
                              editInfo.addAll({'company': text});
                            },
                          ),
                        ),
                        ListTile(
                          title: Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: Text(
                              AppLocalizations.of(context)
                                  .translate('edit_profile_university'),
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Colors.black87),
                            ),
                          ),
                          subtitle: CupertinoTextField(
                            controller: universityCtlr,
                            cursorColor: primaryColor,
                            placeholder: AppLocalizations.of(context)
                                .translate('edit_profile_add_university'),
                            padding: EdgeInsets.all(10),
                            onChanged: (text) {
                              editInfo.addAll({'university': text});
                            },
                          ),
                        ),
                        ListTile(
                          title: Padding(
                              padding: const EdgeInsets.only(bottom: 5.0),
                              child: Text(
                                AppLocalizations.of(context)
                                    .translate('edit_profile_living_in'),
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Colors.black87),
                              )),
                          subtitle: CupertinoTextField(
                            controller: livingCtlr,
                            cursorColor: primaryColor,
                            placeholder: AppLocalizations.of(context)
                                .translate('edit_profile_add_city'),
                            padding: EdgeInsets.all(10),
                            onChanged: (text) {
                              editInfo.addAll({'living_in': text});
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: ListTile(
                            title: Text(
                              AppLocalizations.of(context)
                                  .translate('edit_profile_i_am'),
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Colors.black87),
                            ),
                            subtitle: DropdownButton(
                              iconEnabledColor: primaryColor,
                              iconDisabledColor: secondryColor,
                              isExpanded: true,
                              items: [
                                DropdownMenuItem(
                                  child: Text(AppLocalizations.of(context)
                                      .translate('edit_profile_man')),
                                  value: "man",
                                ),
                                DropdownMenuItem(
                                    child: Text(AppLocalizations.of(context)
                                        .translate('edit_profile_transgender')),
                                    value: "transgender"),
                                DropdownMenuItem(
                                    child: Text(AppLocalizations.of(context)
                                        .translate('edit_profile_woman')),
                                    value: "woman"),
                                DropdownMenuItem(
                                    child: Text(AppLocalizations.of(context)
                                        .translate('edit_profile_other')),
                                    value: "other"),
                              ],
                              onChanged: (val) {
                                editInfo.addAll({'userGender': val});
                                setState(() {
                                  showMe = val;
                                });
                              },
                              value: showMe,
                            ),
                          ),
                        ),
                        ListTile(
                          title: Padding(
                              padding: const EdgeInsets.only(bottom: 5.0),
                              child: Text(
                                "Instagram",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Colors.black87),
                              )),
                          subtitle: CupertinoTextField(
                            controller: instagramCtlr,
                            cursorColor: primaryColor,
                            placeholder: "Instagram profile",
                            padding: EdgeInsets.all(10),
                            onChanged: (text) {
                              bool _validURL = Uri.parse(text).isAbsolute;
                              if (_validURL || text == "") {
                                editInfo.addAll({'instagram_url': text});
                              }
                            },
                          ),
                        ),
                        ListTile(
                          title: Padding(
                              padding: const EdgeInsets.only(bottom: 5.0),
                              child: Text(
                                "Facebook",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Colors.black87),
                              )),
                          subtitle: CupertinoTextField(
                            controller: facebookCtlr,
                            cursorColor: primaryColor,
                            placeholder: "Facebook profile",
                            padding: EdgeInsets.all(10),
                            onChanged: (text) {
                              bool _validURL = Uri.parse(text).isAbsolute;
                              if (_validURL || text == "") {
                                editInfo.addAll({'facebook_url': text});
                              }
                            },
                          ),
                        ),
                        ListTile(
                          title: Padding(
                              padding: const EdgeInsets.only(bottom: 5.0),
                              child: Text(
                                "Tiktok",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Colors.black87),
                              )),
                          subtitle: CupertinoTextField(
                            controller: tiktokCtlr,
                            cursorColor: primaryColor,
                            placeholder: "Tikok profile",
                            padding: EdgeInsets.all(10),
                            onChanged: (text) {
                              bool _validURL = Uri.parse(text).isAbsolute;
                              if (_validURL || text == "") {
                                editInfo.addAll({'tiktok_url': text});
                              }
                            },
                          ),
                        ),
                        ListTile(
                          title: Padding(
                              padding: const EdgeInsets.only(bottom: 5.0),
                              child: Text(
                                "Twitter",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Colors.black87),
                              )),
                          subtitle: CupertinoTextField(
                            controller: twitterCtlr,
                            cursorColor: primaryColor,
                            placeholder: "Twitter profile",
                            padding: EdgeInsets.all(10),
                            onChanged: (text) {
                              bool _validURL = Uri.parse(text).isAbsolute;
                              if (_validURL || text == "") {
                                editInfo.addAll({'twitter_url': text});
                              }
                            },
                          ),
                        ),
                        ListTile(
                          title: Padding(
                              padding: const EdgeInsets.only(bottom: 5.0),
                              child: Text(
                                "Line",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Colors.black87),
                              )),
                          subtitle: CupertinoTextField(
                            controller: lineCtlr,
                            cursorColor: primaryColor,
                            placeholder: "Line profile",
                            padding: EdgeInsets.all(10),
                            onChanged: (text) {
                              bool _validURL = Uri.parse(text).isAbsolute;
                              if (_validURL || text == "") {
                                editInfo.addAll({'line_url': text});
                              }
                            },
                          ),
                        ),
                        ListTile(
                          title: Padding(
                              padding: const EdgeInsets.only(bottom: 5.0),
                              child: Text(
                                "Whatsapp",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Colors.black87),
                              )),
                          subtitle: CupertinoTextField(
                            controller: whatsappCtlr,
                            cursorColor: primaryColor,
                            placeholder: "Whatsapp number",
                            padding: EdgeInsets.all(10),
                            onChanged: (text) {
                              bool _validURL = Uri.parse(text).isAbsolute;
                              if (_validURL || text == "") {
                                editInfo.addAll({'whatsapp_url': text});
                              }
                            },
                          ),
                        ),
                        ListTile(
                          title: Padding(
                              padding: const EdgeInsets.only(bottom: 5.0),
                              child: Text(
                                "Snapchat",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Colors.black87),
                              )),
                          subtitle: CupertinoTextField(
                            controller: snapchatCtlr,
                            cursorColor: primaryColor,
                            placeholder: "Snapchat profile",
                            padding: EdgeInsets.all(10),
                            onChanged: (text) {
                              bool _validURL = Uri.parse(text).isAbsolute;
                              if (_validURL || text == "") {
                                editInfo.addAll({'snapchat_url': text});
                              }
                            },
                          ),
                        ),
                        ListTile(
                          title: Padding(
                              padding: const EdgeInsets.only(bottom: 5.0),
                              child: Text(
                                "WeChat",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Colors.black87),
                              )),
                          subtitle: CupertinoTextField(
                            controller: wechatCtlr,
                            cursorColor: primaryColor,
                            placeholder: "WeChat profile",
                            padding: EdgeInsets.all(10),
                            onChanged: (text) {
                              bool _validURL = Uri.parse(text).isAbsolute;
                              if (_validURL || text == "") {
                                editInfo.addAll({'wechat_url': text});
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ListTile(
                            title: Text(
                              AppLocalizations.of(context)
                                  .translate('edit_profile_control'),
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Colors.black87),
                            ),
                            subtitle: Card(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(AppLocalizations.of(context)
                                            .translate(
                                                'edit_profile_dont_show_age')),
                                      ),
                                      Switch(
                                          activeColor: primaryColor,
                                          value: visibleAge,
                                          onChanged: (value) {
                                            editInfo
                                                .addAll({'showMyAge': value});
                                            setState(() {
                                              visibleAge = value;
                                            });
                                          })
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(AppLocalizations.of(context)
                                            .translate(
                                                'edit_profile_make_visible_distance')),
                                      ),
                                      Switch(
                                          activeColor: primaryColor,
                                          value: visibleDistance,
                                          onChanged: (value) {
                                            editInfo.addAll(
                                                {'DistanceVisible': value});
                                            setState(() {
                                              visibleDistance = value;
                                            });
                                          })
                                    ],
                                  ),
                                ],
                              ),
                            )),
                        SizedBox(
                          height: 100,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _deletePicture(index) async {
    if (widget.currentUser.imageUrl[index] != null) {
      try {
        Reference _ref = FirebaseStorage.instance
            .refFromURL(widget.currentUser.imageUrl[index]);
        print(_ref.fullPath);
        await _ref.delete();
      } catch (e) {
        print(e);
      }
    }
    setState(() {
      widget.currentUser.imageUrl.removeAt(index);
    });
    var temp = [];
    temp.add(widget.currentUser.imageUrl);
    await FirebaseFirestore.instance
        .collection("Users")
        .doc("${widget.currentUser.id}")
        .set({"Pictures": temp[0]}, SetOptions(merge: true));
  }
}
