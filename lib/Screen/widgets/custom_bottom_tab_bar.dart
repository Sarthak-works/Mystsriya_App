import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:momworkapp/Screen/main/CampaignDetailsScreenNew.dart';
import 'package:momworkapp/Screen/main/CampaignsDetailsScreen.dart';
import 'package:momworkapp/Screen/main/CampaignsScreen.dart';
import 'package:momworkapp/Screen/main/CampaignsScreenNew.dart';
import 'package:momworkapp/Screen/main/Colors.dart';
import 'package:momworkapp/Screen/main/DashBoardScreen.dart';
import 'package:momworkapp/Screen/main/ProfileScreen.dart';
import 'package:momworkapp/utils/utils.dart';

import '../main/CampaignScreenNewFilter.dart';
import '../main/WalletScreen.dart';

class CustomBottomTabBar extends StatefulWidget {
  const CustomBottomTabBar({super.key});

  @override
  State<CustomBottomTabBar> createState() => _CustomBottomTabBarState();
}

class _CustomBottomTabBarState extends State<CustomBottomTabBar> {
  int selectedTabIndex = 0;
  void onItemTabTap(int index) {
    setState(() {
      selectedTabIndex = index;
    });
  }

  static List<Widget> customScreenList = <Widget>[
    DashBoardScreen(),
  //  CampaignsScreenNew(),
    const ProfileScreen(),
  ];

  static List<Widget> screenList = <Widget>[
    DashBoardScreen(),
  //  CampaignsScreenNew(),
    CampaignScreenNewFilter(),
    WalletScreen(isSourceProfile: false,),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Utils.prefs!.getString("userName")=="Test Ekas" ? customScreenList[selectedTabIndex] : screenList[selectedTabIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black,
              blurRadius: 5,
            ),
          ],
        ),
        child: Utils.prefs!.getString("userName")=="Test Ekas" ? BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: selectedTabIndex,
          onTap: onItemTabTap,
          backgroundColor: Colors.white,
          selectedItemColor: MyColors.bacgroundcolors,
          unselectedItemColor: Colors.black,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage('assets/images/home.png'),
                size: 30,
              ),
              label: 'Home',
            ),

            BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage("assets/images/profile.png"),
                size: 30,
              ),
              label: 'Profile',
            ),
          ],
        ) : BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: selectedTabIndex,
          onTap: onItemTabTap,
          backgroundColor: Colors.white,
          selectedItemColor: MyColors.bacgroundcolors,
          unselectedItemColor: Colors.black,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage('assets/images/home.png'),
                size: 30,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage('assets/images/campaign.png'),
                size: 30,
              ),
              label: 'Campaigns',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage('assets/images/earnings.png'),
                size: 30,
              ),
              label: 'Earnings',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage("assets/images/profile.png"),
                size: 30,
              ),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getNotification() async {
    await FirebaseMessaging.instance.requestPermission();
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    /// Create an Android Notification Channel.
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'Mom', // id
      'High Importance Notifications', // title// description
      importance: Importance.high,
    );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    var androidInit =
    const AndroidInitializationSettings('@mipmap/launcher_icon'); //for logo
    var iosInit = const DarwinInitializationSettings();
    var initSetting = InitializationSettings(android: androidInit, iOS: iosInit);
    flutterLocalNotificationsPlugin.initialize(initSetting,
      onDidReceiveBackgroundNotificationResponse: (details) {
        if((details.payload ?? "").isNotEmpty) {
          var data = jsonDecode(details.payload ?? "");
          redirectFromNotification(title: data['title'],data: data['data']);
        }
      },
      onDidReceiveNotificationResponse: (details) {
        if((details.payload ?? "").isNotEmpty) {
          var data = jsonDecode(details.payload ?? "");
          redirectFromNotification(title: data['title'],data: data['data']);
        }
      },
    );
    var showNotification = Platform.isAndroid ? true:false;
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: showNotification, badge: showNotification, sound: showNotification);
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        log('Flutter Notification message from main');
        log('Get Initial Message');
        log('Data : ${message.data}');
        redirectFromNotification(title: message.notification?.title ?? "", data: message.data);
      }
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      log('Get Message');
      log('Data : ${message.data}');
      log(notification!.title!);
      log(notification.body!);
      var data = {"title":notification.title,"data":message.data};
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          iOS: const DarwinNotificationDetails(),
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            icon: '@mipmap/launcher_icon',
          ),
        ),
        payload: jsonEncode(data),
      );
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('A new onMessageOpenedApp event was published!');
      log(message.notification!.title!);
      log('Data : ${message.data}');
      redirectFromNotification(title: message.notification?.title ?? "", data: message.data);
    });
  }

  redirectFromNotification({required String title, Map? data}) {
    print("title : $title, data : $data");
    if(title == "Payment Received") {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return WalletScreen();
      },));
    } else if (data != null && (data ?? {}).isNotEmpty) {
      title = title.toLowerCase();
      if(title == "campaign activated" || title == "approved campaign" || title == "rejected campaign" || title.contains("task approved") || title.contains("task rejected") || title.contains("task added. did you check it?")) {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return CampaignDetailsScreenNew(id: data['campaignID'].toString(),);
        },));
      } else if(data['campaignID'] != null){
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return CampaignDetailsScreenNew(id: data['campaignID'].toString(),);
        },));
      }
    }
  }
}
