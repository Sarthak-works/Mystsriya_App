import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:momworkapp/Screen/main/Colors.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../services/auth_services.dart';
import '../../utils/utils.dart';
import '../widgets/custom_bottom_tab_bar.dart';
import 'AddBankAccountScreen.dart';
import 'ResetPasswordNew.dart';

class RegisterNewScreen extends StatefulWidget {
  const RegisterNewScreen({Key? key}) : super(key: key);

  @override
  State<RegisterNewScreen> createState() => _RegisterNewScreenState();
}

class _RegisterNewScreenState extends State<RegisterNewScreen> {

  final formKey = GlobalKey<FormState>();

  TextEditingController tname = TextEditingController();
  TextEditingController tLname = TextEditingController();
  TextEditingController taddress = TextEditingController();
  TextEditingController tmobileno = TextEditingController();
  TextEditingController temail = TextEditingController();
  TextEditingController tpassword = TextEditingController();
  TextEditingController tconfirmpassword = TextEditingController();
  TextEditingController trefercode = TextEditingController();
  TextEditingController controller = TextEditingController();
  TextEditingController tinstgram = TextEditingController();
  TextEditingController tfacebook = TextEditingController();
  TextEditingController tyoutube = TextEditingController();

  bool isChecked = false;
  String isStatus = "";
  bool passHideShow = true;
  bool confirmPassHideShow = true;
  String lat = '';
  String long = '';
  var name="", email="";
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
      if (result!.status!) {
        Navigator.pop(context);

        Utils.prefs!.setString('token', result.data!.token);
        Utils.prefs!.setString('userid', result.data!.id);
        Utils.prefs!.setString('userName', result.data!.name);
        Utils.prefs!.setString('userImage', result.data!.image);

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
        registerAPIWithGoogle();
      }
    }
  }

  registerAPIWithGoogle() async {
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
      'mobile_number': "",
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
      'name': tname.text+" "+tLname.text.toString(),
      'email': temail.text,
      'password': tpassword.text,
      'c_password': tconfirmpassword.text,
      'mobile_number': tmobileno.text,
      'terms_conditions': '1',
      'address': taddress.text,
      'refer_code': trefercode.text,
      'long': long,
      'lat': lat,
      'instagram_link': tinstgram.text,
      'youtube_link': tyoutube.text,
      'facebook_link': tfacebook.text,
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
            return AddBankAccountScreen(
              type: "add",
              fromMain: true,
            );
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
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
        //  height: MediaQuery.of(context).size.height,
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

                  SizedBox(height: 15,),

                  Center(
                    child: Container(
                      margin: EdgeInsets.all(10),
                      child: Text(
                        'Register',
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

                  SizedBox(height:15,),

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text(
                              'First Name',
                              style: TextStyle(
                                  color: MyColors.greyshade600,
                                  fontSize: 16,
                                  fontFamily: 'Lexend'),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please Enter Your First Name';
                                }
                                return null;
                              },
                              controller: tname,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp("[a-z A-Z]"))
                              ],
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[100],
                                hintText: 'First Name',
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

                          ],
                        ),
                      ),

                      SizedBox(width: 20,),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text(
                              'Last Name',
                              style: TextStyle(
                                  color: MyColors.greyshade600,
                                  fontSize: 16,
                                  fontFamily: 'Lexend'),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please Enter Your Last Name';
                                }
                                return null;
                              },
                              controller: tLname,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp("[a-z A-Z]"))
                              ],
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[100],
                                hintText: 'Last Name',
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

                          ],
                        ),
                      ),

                    ],
                  ),

                  SizedBox(height: 15,),

                  Text(
                    'Email Address',
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
                  SizedBox(height: 15,),

                  Text(
                    'Mobile Number',
                    style: TextStyle(
                        color: MyColors.greyshade600,
                        fontSize: 16,
                        fontFamily: 'Lexend'),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter Mobile Number';
                      } else if (value.length!=10) {
                        return 'Please Enter Valid Mobile Number';
                      }
                      return null;
                    },
                    controller: tmobileno,
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[100],
                      hintText: 'Mobile Number',
                      counterText: "",
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
                  SizedBox(height: 15),
                  Text(
                    'Confirm Password',
                    style: TextStyle(
                        color: MyColors.greyshade600,
                        fontSize: 16,
                        fontFamily: 'Lexend'),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    validator: (value) {
                      if (tpassword.text != tconfirmpassword.text) {
                        return 'Password Does Not Match';
                      }
                      return null;
                    },
                    controller: tconfirmpassword,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    obscureText: confirmPassHideShow,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[100],
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(
                                () {
                              confirmPassHideShow = !confirmPassHideShow;
                            },
                          );
                        },
                        icon: Align(
                          widthFactor: 1.0,
                          heightFactor: 1.0,
                          child: Image(
                            image: confirmPassHideShow
                                ? const AssetImage(
                                'assets/images/pass_show.png')
                                : const AssetImage(
                                'assets/images/pass_off.png'),
                            height: 25,
                            width: 25,
                          ),
                        ),
                      ),
                      hintText: 'Confirm Password',
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

                  SizedBox(height: 40,),

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
                        registerAPI();
                      }
                    },
                    child: const Text(
                      "Create Account",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Lexend'),
                    ),
                  ),

                  SizedBox(height: 15,),

                  Center(
                      child: Text.rich(
                        textAlign: TextAlign.center,
                          TextSpan(
                              text: "By continuing, you agree to our ",
                              style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
                              children: [
                                TextSpan(
                                  recognizer: TapGestureRecognizer()..onTap=(){_launchURL("https://mystsriya.com/terms-and-conditions/");},
                                  text: "Terms of Service",
                                  style: TextStyle(color: Colors.blue, fontSize: 14, fontWeight: FontWeight.w400),
                                ),

                                TextSpan(
                                  text: " and ",
                                  style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
                                ),

                                TextSpan(
                                  recognizer: TapGestureRecognizer()..onTap=(){_launchURL("https://mystsriya.com/privacy-policy");},
                                  text: "Privacy Policy",
                                  style: TextStyle(color: Colors.blue, fontSize: 14, fontWeight: FontWeight.w400),
                                ),

                              ]
                          )
                      )
                  ),

                  SizedBox(height: 20,),

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
                          Text("Sign Up with Google")
                        ],
                      ),

                    ),
                  ),

                ],
              ),
            ),
          )
        ),
      ),
    );
  }

  _launchURL(siteurl) async {
    final Uri url = Uri.parse(siteurl);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

}
