import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:momworkapp/Screen/auth/ForgotPasswordNew.dart';
import 'package:momworkapp/Screen/main/DashBoardScreen.dart';

import '../../services/auth_services.dart';
import '../../utils/utils.dart';
import '../main/Colors.dart';
import '../widgets/custom_bottom_tab_bar.dart';
import 'ForgotPassword.dart';

class LoginNewScreen extends StatefulWidget {
  const LoginNewScreen({Key? key}) : super(key: key);

  @override
  State<LoginNewScreen> createState() => _LoginNewScreenState();
}

class _LoginNewScreenState extends State<LoginNewScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController temail = TextEditingController();
  TextEditingController tpassword = TextEditingController();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  bool passHideShow = true;
  bool loading = false;
  String firebaseToken = "";

  loginAPI() async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Container(
            height: 50,
            width: 50,
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.41,
              vertical: MediaQuery.of(context).size.height * 0.44,
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5), color: Colors.white),
            child: CircularProgressIndicator(
              color: MyColors.bacgroundcolors,
              strokeWidth: 2,
            ),
          ),
        );
      },
    );

    var body = {
      'email': temail.text,
      'password': tpassword.text,
      "token": firebaseToken
    };
    var result = await Services().login(context, body: body);

    if (result != null) {
      if (result.status) {
        Navigator.pop(context);

        Utils.prefs!.setString('token', result.data.token);
        Utils.prefs!.setString('userid', result.data.id);
        Utils.prefs!.setString('userName', result.data.name);
        Utils.prefs!.setString('userImage', result.data.image);

        Utils.prefs!.setBool('loginStatus', true);

        if (temail.text.toString()=="ekasjot@gmail.com") {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) {
                return DashBoardScreen();
              },
            ),
                (route) => false,
          );
        } else {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const CustomBottomTabBar();
              },
            ),
                (route) => false,
          );
        }

      } else {
        Navigator.pop(context);
      }
    }
  }

  getFirebaseToken() async {
    await _firebaseMessaging.requestPermission();
    if (Platform.isIOS) {

      firebaseToken = (await _firebaseMessaging.getAPNSToken()).toString();
      await Future.delayed(Duration(seconds: 2));
      firebaseToken = (await _firebaseMessaging.getToken())!;
    } else {
      firebaseToken = (await _firebaseMessaging.getToken())!;
    }

    print(firebaseToken);
  }

  Future<void> getNotification() async {
    await FirebaseMessaging.instance.requestPermission();
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

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
    var initSetting =
    InitializationSettings(android: androidInit, iOS: iosInit);
    flutterLocalNotificationsPlugin.initialize(initSetting);
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        log('Flutter Notification message from main');
        log('Get Initial Message');
      }
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      log('Get Message');
      log(notification!.title!);
      log(notification.body!);

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
        payload: "${notification.title}",
      );
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('A new onMessageOpenedApp event was published!');
      log(message.notification!.title!);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFirebaseToken();
    getNotification();
  }
// test@gmail.com
// test123456

  @override
  Widget build(BuildContext context) {
    return Scaffold(
   //   appBar: AppBar(backgroundColor: Colors.grey[350],),
      body: SingleChildScrollView(
        child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.grey[300],
            child: Container(
              margin: EdgeInsets.all(25),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [


                    GestureDetector(
                      onTap: (){Navigator.pop(context);},
                      child: Container(
                        margin: EdgeInsets.only(top: 50),
                        child: CircleAvatar(
                          backgroundColor: Colors.grey[350],
                          child: Icon(Icons.arrow_back_outlined),
                        ),
                      ),
                    ),

                    SizedBox(height: 25,),

                    Center(
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: Text(
                          'Login',
                          softWrap: true,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 26,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Lexend'

                          ),
                        ),
                      ),
                    ),

                    SizedBox(height:20,),


                    Text(
                      'Email',
                      style: TextStyle(
                          color: MyColors.greyshade600,
                          fontSize: 16,
                          fontFamily: 'Lexend'),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter Email Address';
                        } else if (!RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value)) {
                          return 'Please Enter Valid Email Address';
                        }
                        return null;
                      },
                      controller: temail,
                      keyboardType: TextInputType.emailAddress,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[100],
                        hintText: 'Email Address',
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                        ),
                        border: textFieldBorder(),
                        focusedBorder: textFieldBorder(),
                        enabledBorder: textFieldBorder(),
                        disabledBorder: textFieldBorder(),
                        contentPadding: const EdgeInsets.all(15),
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      'Password',
                      style: TextStyle(
                          color: MyColors.greyshade600,
                          fontSize: 16,
                          fontFamily: 'Lexend'),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      validator: (value) {
                        return Utils.passwordValidator(value ?? "");
                      },
                      controller: tpassword,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      obscureText: passHideShow,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[100],
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(
                                  () {
                                passHideShow = !passHideShow;
                              },
                            );
                          },
                          icon: Align(
                            widthFactor: 1.0,
                            heightFactor: 1.0,
                            child: Image(
                              image: passHideShow
                                  ? const AssetImage(
                                  'assets/images/pass_show.png')
                                  : const AssetImage(
                                  'assets/images/pass_off.png'),
                              height: 25,
                              width: 25,
                            ),
                          ),
                        ),
                        hintText: 'Password',
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                        ),
                        border: textFieldBorder(),
                        focusedBorder: textFieldBorder(),
                        enabledBorder: textFieldBorder(),
                        disabledBorder: textFieldBorder(),
                        contentPadding: const EdgeInsets.all(15),
                      ),
                    ),

                    SizedBox(height: 15,),

                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return const ForgotPasswordNew();
                          },
                        ));
                      },
                      child: Container(
                        alignment: Alignment.bottomRight,
                        child: Text('Forgot Password?',
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 16,
                                fontFamily: 'Lexend')),
                      ),
                    ),


                    SizedBox(height: 60,),

                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(MyColors.bacgroundcolors),
                          minimumSize: WidgetStatePropertyAll(const Size(double.infinity, 40)),
                          shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(5)),
                                  side: BorderSide(color: MyColors.bacgroundcolors)
                              )
                          )
                      ),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          loginAPI();
                        }
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'Lexend'),
                      ),
                    ),

                    // SizedBox(height: 90,),
                    //
                    // Center(
                    //   child: Text(
                    //     'or log in with ',
                    //     style: TextStyle(
                    //         color: MyColors.greyshade600,
                    //         fontSize: 16,
                    //         fontFamily: 'Lexend'),
                    //   ),
                    // ),
                    //
                    // SizedBox(height: 15,),
                    //
                    // Align(
                    //   alignment: Alignment.bottomCenter,
                    //   child: Container(
                    //     margin: EdgeInsets.only(left: 20, right: 20),
                    //     padding: const EdgeInsets.only(left: 20, right: 20),
                    //     child: MaterialButton(
                    //       onPressed: (){
                    //
                    //       },
                    //       color: Colors.white,
                    //       elevation: 10,
                    //       child: Row(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         children: [
                    //           Container(
                    //             child: Image.asset("assets/images/google.png", height: 50, width: 30,),
                    //             // decoration: BoxDecoration(
                    //             //   image: DecorationImage(
                    //             //       image:
                    //             //       AssetImage('assets/images/google.png'),
                    //             //       fit: BoxFit.cover),
                    //             //   shape: BoxShape.circle,
                    //             // ),
                    //           ),
                    //           SizedBox(
                    //             width: 10,
                    //           ),
                    //           Text("Log In with Google")
                    //         ],
                    //       ),
                    //
                    //     ),
                    //   ),
                    // ),



                  ],
                ),
              ),
            )
        ),
      ),
    );
  }
}

