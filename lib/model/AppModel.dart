///*
// * Copyright (c) 2019 Hannah Burkhardt. All rights reserved.
// */
//import 'package:fluttercouch/document.dart';
//import 'package:fluttercouch/fluttercouch.dart';
//import 'package:fluttercouch/mutable_document.dart';
//import 'package:fluttercouch/query/query.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
//import 'package:scoped_model/scoped_model.dart';
//
//class AppModel extends Model with Fluttercouch {
//  Document docExample;
//  Query query;
//
//  Document user;
//  var _userInfo;
//
//  AppModel() {
//    initPlatformState();
//  }
//
//
//
//  setUserInfo(var userInfo) async {
//    _userInfo = userInfo;
//    user = await getDocumentWithId("user/${_userInfo['username']}");
//  }
//
//  initPlatformState() async {
//    try {
//      await initDatabaseWithName("mapapp-couchbase");
//      setReplicatorEndpoint("ws://localhost:4984/mapapp-couchbase");
//      setReplicatorType("PUSH_AND_PULL");
////      setReplicatorBasicAuthentication(<String, String>{
////        "username": "sync_gateway",
////        "password": "password"
////      });
//      setReplicatorContinuous(true);
//      initReplicator();
//      startReplicator();
//      docExample = await getDocumentWithId("hannahtest");
//      notifyListeners();
//    } on PlatformException catch(e) {
//      print("Exception when initializing AppModel scoped model Platform State: $e");
//    }
//
//  }
//
//
//}
//
