import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:momworkapp/Screen/auth/LoginNewScreen.dart';
import 'package:momworkapp/Screen/auth/RegisterNewScreen.dart';
import 'package:momworkapp/Screen/auth/ResetPasswordNew.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../services/auth_services.dart';
import '../../utils/utils.dart';
import '../main/Colors.dart';
import '../widgets/custom_bottom_tab_bar.dart';
import 'LoginScreen.dart';

class LoginHomeScreen extends StatefulWidget {
  const LoginHomeScreen({Key? key}) : super(key: key);

  @override
  State<LoginHomeScreen> createState() => _LoginHomeScreenState();
}

class _LoginHomeScreenState extends State<LoginHomeScreen> {
  String name="", email="", number="";
  // creating firebase instance
   final FirebaseAuth auth = FirebaseAuth.instance;
  
  Future<void> signup(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      // Getting users credential
      UserCredential result = await auth.signInWithCredential(authCredential);
      User user = result.user!;

      if (result != null) {
        setState(() {
          name = user.displayName.toString();
          email = user.email.toString();
          number = user.phoneNumber.toString();

          loginAPI();
        });
      } else {
        Fluttertoast.showToast(
          msg: "Something went wrong. Please try again later.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.red,
          fontSize: 16.0,
        );
      }
      // for go to the HomePage screen
    }
  }

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
      "email": email.toString(),
      "address": "Y"
    };
    var result = await Services().gLogin(context, body: body);

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
      //  Navigator.pop(context);
        registerAPI();
      }
    }
  }

   registerAPI() async {
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
       'name': name.toString(),
       'email': email.toString(),
       'password': "mystsriya@2024",
       'c_password': "mystsriya@2024",
       'mobile_number': number!="null"? number : "",
       'terms_conditions': '1',
       'address': "",
       'refer_code': "",
       'long': "",
       'lat': "",
       'instagram_link': "",
       'youtube_link': "",
       'facebook_link': "",
     };
     var result = await Services().register(context, body: body);

     if (result != null) {
       if (result.status) {
         Utils.prefs!.setString('userid', result.data.id);
         Utils.prefs!.setString('userName', result.data.name);
         Utils.prefs!.setString('userImage', result.data.image);
         Utils.prefs!.setString('token', result.data.token);
         Navigator.pop(context);

         Navigator.pushReplacement(context, MaterialPageRoute(
           builder: (context) {
             return ResetPasswordNew(email: email, isGoogleSignin: true,);
           },
         ));
       } else {
         Navigator.pop(context);
       }
     }
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Center(
              child: Image.asset(
                'assets/images/newLogo.png',
                height: 150,
              ),
            ),
          ),

          SizedBox(height: 150,),


          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.white),
                      minimumSize: WidgetStatePropertyAll(const Size(150, 45),),
                      shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                              side: BorderSide(color: Colors.black)
                          )
                      )
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>  const RegisterNewScreen()));
                  },
                  child: const Text(
                    "Register",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'Lexend'),
                  ),
                ),

                SizedBox(width: 20,),

                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(MyColors.bacgroundcolors),
                      minimumSize: WidgetStatePropertyAll(Size(150, 45),),
                      shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          )
                      )
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>  const LoginNewScreen()));
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Lexend'),
                  ),
                ),

              ],
            ),
          ),

          SizedBox(height: 15,),

          Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: MaterialButton(
                onPressed: (){
                  signup(context);
                },
                color: Colors.white,
                elevation: 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Image.asset("assets/images/google.png", height: 50, width: 30,),
                      // decoration: BoxDecoration(
                      //   image: DecorationImage(
                      //       image:
                      //       AssetImage('assets/images/google.png'),
                      //       fit: BoxFit.cover),
                      //   shape: BoxShape.circle,
                      // ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Log In with Google")
                  ],
                ),

              ),
          ),

          SizedBox(height: 15,),

          Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: SignInWithAppleButton(
              onPressed: () async {
                try {
                  final result =
                  await SignInWithApple.getAppleIDCredential(
                    scopes: [
                      AppleIDAuthorizationScopes.email,
                      AppleIDAuthorizationScopes.fullName,
                    ],

                  );

                  print(result);
                  setState(() {
                    name = result.givenName.toString();
                    email = result.email.toString();

                    loginAPI();
                  });
                  // You can use the result to authenticate the user with your server.
                } catch (error) {
                  print(error.toString());
                }
              },
            ),
          ),

          SizedBox(height: 100,)

        ],
      )
    );
  }
}
