import 'dart:io';

import 'package:cf_tracker/utils/blinking_text.dart';
import 'package:cf_tracker/utils/config.dart';
import 'package:cf_tracker/utils/theme.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../user_info.dart';

class AddMealPage extends StatefulWidget {
  @override
  _AddMealPageState createState() => _AddMealPageState();
}

class _AddMealPageState extends State<AddMealPage> {

  var foodImage;
  String imageUrl;
  String meal = "";
  double enzymes = 0;

  void sendImage() {
    if (Platform.isIOS) {
      showCupertinoModalPopup(context: context, builder: (BuildContext context) {
        return new CupertinoActionSheet(
            actions: <Widget>[
              new CupertinoActionSheetAction(
                  child: new Text("Take Photo"),
                  onPressed: takePhoto
              ),
              new CupertinoActionSheetAction(
                  child: new Text("Photo Library"),
                  onPressed: pickImage
              )
            ],
            cancelButton: new CupertinoActionSheetAction(
              child: const Text("Cancel"),
              isDefaultAction: true,
              onPressed: () {
                Navigator.pop(context);
              },
            )
        );
      });
    }
    else if (Platform.isAndroid) {
      showModalBottomSheet(context: context, builder: (BuildContext context) {
        return new SafeArea(
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new ListTile(
                leading: new Icon(Icons.camera_alt),
                title: new Text('Take Photo'),
                onTap: takePhoto,
              ),
              new ListTile(
                leading: new Icon(Icons.photo_library),
                title: new Text('Photo Library'),
                onTap: pickImage,
              ),
              new ListTile(
                leading: new Icon(Icons.clear),
                title: new Text('Cancel'),
                onTap: () {
                  router.pop(context);
                },
              ),
            ],
          ),
        );
      });
    }
  }

  Future<void> pickImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        foodImage = image;
      });
      StorageUploadTask imageUploadTask = FirebaseStorage.instance.ref().child("meals").child(currUser.id).child("${new DateTime.now()}.png").putFile(image);
      imageUploadTask.events.listen((event) {
        print("UPLOADING: ${event.snapshot.bytesTransferred.toDouble() / event.snapshot.totalByteCount.toDouble()}");
      });
      var downurl = await (await imageUploadTask.onComplete).ref.getDownloadURL();
      print(downurl);
      imageUrl = downurl.toString();
    }
    router.pop(context);
  }

  Future<void> takePhoto() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        foodImage = image;
      });
      StorageUploadTask imageUploadTask = FirebaseStorage.instance.ref().child("meals").child(currUser.id).child("${new DateTime.now()}.png").putFile(image);
      imageUploadTask.events.listen((event) {
        print("UPLOADING: ${event.snapshot.bytesTransferred.toDouble() / event.snapshot.totalByteCount.toDouble()}");
      });
      var downurl = await (await imageUploadTask.onComplete).ref.getDownloadURL();
      print(downurl);
      imageUrl = downurl.toString();
    }
    router.pop(context);
  }
  
  submitMeal() {
    print(meal);
    print(imageUrl);
    print(enzymes);
    if (imageUrl != null && meal != "" && enzymes != 0.0) {
      FirebaseDatabase.instance.reference().child("users").child(currUser.id).child("meals").push().set({
        "meal": meal,
        "imageUrl": imageUrl,
        "enzymes": enzymes,
        "date": DateTime.now().toString()
      });
      router.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new CupertinoNavigationBar(
        middle: new Text("Add Meal", style: TextStyle(color: Colors.white)),
        previousPageTitle: "Home",
        actionsForegroundColor: Colors.white,
        backgroundColor: mainColor,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: new Container(
        width: MediaQuery.of(context).size.width - 16,
        child: new CupertinoButton(
          child: new Text("Add Meal"),
          color: mainColor,
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
          onPressed: () {
            submitMeal();
          },
        ),
      ),
      backgroundColor: currBackgroundColor,
      body: new SingleChildScrollView(
        padding: EdgeInsets.all(8.0),
        child: new Column(
          children: <Widget>[
            new Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
              color: currCardColor,
              elevation: 6.0,
              child: new InkWell(
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
                onTap: () {
                  sendImage();
                },
                child: new Container(
                  width: double.infinity,
                  height: 200.0,
                  padding: EdgeInsets.all(8.0),
                  child: (foodImage != null) ? new Image.file(foodImage) : new Icon(Icons.add_a_photo, size: 50),
                ),
              ),
            ),
            new Padding(padding: EdgeInsets.all(4.0)),
            new Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
              color: currCardColor,
              elevation: 6.0,
              child: new Container(
                width: double.infinity,
                padding: EdgeInsets.all(8.0),
                child: new Column(
                  children: <Widget>[
                    new CheckboxListTile(
                      title: new Text("Breakfast"),
                      value: meal == "Breakfast",
                      onChanged: (value) {
                        if (value) {
                          setState(() {
                            meal = "Breakfast";
                          });
                        }
                      },
                    ),
                    new CheckboxListTile(
                      title: new Text("Lunch"),
                      value: meal == "Lunch",
                      onChanged: (value) {
                        if (value) {
                          setState(() {
                            meal = "Lunch";
                          });
                        }
                      },
                    ),
                    new CheckboxListTile(
                      title: new Text("Dinner"),
                      value: meal == "Dinner",
                      onChanged: (value) {
                        if (value) {
                          setState(() {
                            meal = "Dinner";
                          });
                        }
                      },
                    ),
                    new CheckboxListTile(
                      title: new Text("Snack"),
                      value: meal == "Snack",
                      onChanged: (value) {
                        if (value) {
                          setState(() {
                            meal = "Snack";
                          });
                        }
                      },
                    )
                  ],
                )
              ),
            ),
            new Padding(padding: EdgeInsets.all(4.0)),
            new Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
              color: currCardColor,
              elevation: 6.0,
              child: new Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(8.0),
                  child: new Column(
                    children: <Widget>[
                      new ListTile(
                        title: new Text("Enzymes"),
                        trailing: Container(
                          width: 200.0,
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              new IconButton(
                                icon: Icon(Icons.remove),
                                color: mainColor,
                                onPressed: () {
                                  setState(() {
                                    enzymes -= 0.5;
                                  });
                                },
                              ),
                              new Text(enzymes.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),),
                              new IconButton(
                                icon: Icon(Icons.add),
                                color: mainColor,
                                onPressed: () {
                                  setState(() {
                                    enzymes += 0.5;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
              ),
            )
          ],
        ),
      ),
    );
  }
}
