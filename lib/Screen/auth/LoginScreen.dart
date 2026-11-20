import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:momworkapp/Screen/auth/ForgotPassword.dart';
import 'package:momworkapp/Screen/auth/RegisterScreen.dart';
import 'package:momworkapp/Screen/main/Colors.dart';
import 'package:momworkapp/Screen/widgets/custom_bottom_tab_bar.dart';
import 'package:momworkapp/services/auth_services.dart';

import '../../utils/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController temail = TextEditingController();
  TextEditingController tpassword = TextEditingController();
//  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
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

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const CustomBottomTabBar();
            },
          ),
          (route) => false,
        );
      } else {
        Navigator.pop(context);
      }
    }
  }

  // getFirebaseToken() async {
  //   await _firebaseMessaging.requestPermission();
  //   firebaseToken = (await _firebaseMessaging.getToken())!;
  //   print(firebaseToken);
  // }
  //
  // Future<void> getNotification() async {
  //   await FirebaseMessaging.instance.requestPermission();
  //   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //       FlutterLocalNotificationsPlugin();
  //
  //   /// Create an Android Notification Channel.
  //   /// We use this channel in the `AndroidManifest.xml` file to override the
  //   /// default FCM channel to enable heads up notifications.
  //   AndroidNotificationChannel channel = const AndroidNotificationChannel(
  //     'Mom', // id
  //     'High Importance Notifications', // title// description
  //     importance: Importance.high,
  //   );
  //   await flutterLocalNotificationsPlugin
  //       .resolvePlatformSpecificImplementation<
  //           AndroidFlutterLocalNotificationsPlugin>()
  //       ?.createNotificationChannel(channel);
  //   var androidInit =
  //       const AndroidInitializationSettings('@mipmap/launcher_icon'); //for logo
  //   var iosInit = const DarwinInitializationSettings();
  //   var initSetting =
  //       InitializationSettings(android: androidInit, iOS: iosInit);
  //   flutterLocalNotificationsPlugin.initialize(initSetting);
  //   FirebaseMessaging.instance
  //       .getInitialMessage()
  //       .then((RemoteMessage? message) {
  //     if (message != null) {
  //       log('Flutter Notification message from main');
  //       log('Get Initial Message');
  //     }
  //   });
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     RemoteNotification? notification = message.notification;
  //     log('Get Message');
  //     log(notification!.title!);
  //     log(notification.body!);
  //
  //     flutterLocalNotificationsPlugin.show(
  //       notification.hashCode,
  //       notification.title,
  //       notification.body,
  //       NotificationDetails(
  //         iOS: const DarwinNotificationDetails(),
  //         android: AndroidNotificationDetails(
  //           channel.id,
  //           channel.name,
  //           icon: '@mipmap/launcher_icon',
  //         ),
  //       ),
  //       payload: "${notification.title}",
  //     );
  //   });
  //   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //     log('A new onMessageOpenedApp event was published!');
  //     log(message.notification!.title!);
  //   });
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  //  getFirebaseToken();
  //  getNotification();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: SizedBox(
              height: height * 0.91,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: height * 0.05,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/images/newLogo.png',
                      height: height * 0.15,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.07,
                  ),
                  const Text(
                    'Login',
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Lexend'),
                  ),
                  SizedBox(
                    height: height * 0.008,
                  ),
                  const Text(
                    'Welcome back!',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Lexend'),
                  ),
                  Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: height * 0.025,
                        ),
                        Text(
                          'Email Address',
                          style: TextStyle(
                              color: MyColors.greyshade600,
                              fontSize: 16,
                              fontFamily: 'Lexend'),
                        ),
                        SizedBox(
                          height: height * 0.015,
                        ),
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
                            prefixIcon: const Align(
                              widthFactor: 1.0,
                              heightFactor: 1.0,
                              child: Image(
                                image: AssetImage('assets/images/email.png'),
                                height: 25,
                                width: 25,
                              ),
                            ),
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
                        SizedBox(
                          height: height * 0.025,
                        ),
                        Text(
                          'Password',
                          style: TextStyle(
                              color: MyColors.greyshade600,
                              fontSize: 16,
                              fontFamily: 'Lexend'),
                        ),
                        SizedBox(
                          height: height * 0.015,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please Enter Your Password';
                            }
                            return null;
                          },
                          controller: tpassword,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          obscureText: passHideShow,
                          decoration: InputDecoration(
                            prefixIcon: const Align(
                              widthFactor: 1.0,
                              heightFactor: 1.0,
                              child: Image(
                                image: AssetImage('assets/images/lock.png'),
                                height: 25,
                                width: 25,
                              ),
                            ),
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
                        SizedBox(
                          height: height * 0.015,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return const ForgotPassword();
                              },
                            ));
                          },
                          child: Container(
                            alignment: Alignment.bottomRight,
                            child: Text('Forgot Password?',
                                style: TextStyle(
                                    color: MyColors.bacgroundcolors,
                                    fontSize: 16,
                                    fontFamily: 'Lexend')),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: MyColors.bacgroundcolors,
                        minimumSize: const Size(double.infinity, 40)),
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
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't Have an Account?",
                        style: TextStyle(fontFamily: 'Lexend'),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return const RegisterScreen();
                            },
                          ));
                        },
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                              color: MyColors.bacgroundcolors,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Lexend'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
