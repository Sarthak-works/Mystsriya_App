import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:momworkapp/Screen/auth/AddBankAccountScreen.dart';
import 'package:momworkapp/Screen/auth/LoginScreen.dart';
import 'package:momworkapp/Screen/main/Colors.dart';
import 'package:momworkapp/services/auth_services.dart';
import 'package:momworkapp/utils/utils.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();

  TextEditingController tname = TextEditingController();
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
      'name': tname.text,
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
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
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
                  'Welcome to Mystsriya',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Lexend'),
                ),
                SizedBox(
                  height: height * 0.008,
                ),
                const Text(
                  'Create your account',
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Lexend'),
                ),
                SizedBox(
                  height: height * 0.050,
                ),
                Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Full Name',
                        style: TextStyle(
                            color: MyColors.greyshade600,
                            fontSize: 16,
                            fontFamily: 'Lexend'),
                      ),
                      SizedBox(
                        height: height * 0.010,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter Your Name';
                          }
                          return null;
                        },
                        controller: tname,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp("[a-z A-Z]"))
                        ],
                        decoration: InputDecoration(
                          prefixIcon: const Align(
                            widthFactor: 1.0,
                            heightFactor: 1.0,
                            child: Image(
                              image: AssetImage('assets/images/user.png'),
                              height: 25,
                              width: 25,
                            ),
                          ),
                          hintText: 'Name',
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
                        'Phone Number',
                        style: TextStyle(
                            color: MyColors.greyshade600,
                            fontSize: 16,
                            fontFamily: 'Lexend'),
                      ),
                      SizedBox(height: height * 0.015),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter Your Mobile No';
                          } else if (!RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)')
                              .hasMatch(value)) {
                            return 'Please Enter Valid Mobile No';
                          }
                          return null;
                        },
                        controller: tmobileno,
                        maxLength: 12,
                        keyboardType: TextInputType.phone,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          prefixIcon: const Align(
                            widthFactor: 1.0,
                            heightFactor: 1.0,
                            child: Image(
                              image: AssetImage('assets/images/smartphone.png'),
                              height: 25,
                              width: 25,
                            ),
                          ),
                          counterText: "",
                          hintText: 'Phone Number',
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
                      SizedBox(height: height * 0.025),
                      Text(
                        'Email Address',
                        style: TextStyle(
                            color: MyColors.greyshade600,
                            fontSize: 16,
                            fontFamily: 'Lexend'),
                      ),
                      SizedBox(height: height * 0.015),
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
                      SizedBox(height: height * 0.025),
                      Text(
                        'Password',
                        style: TextStyle(
                            color: MyColors.greyshade600,
                            fontSize: 16,
                            fontFamily: 'Lexend'),
                      ),
                      SizedBox(height: height * 0.015),
                      TextFormField(
                        validator: (value) {
                          return Utils.passwordValidator(value ?? "");
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
                      SizedBox(height: height * 0.025),
                      Text(
                        'Confirm Password',
                        style: TextStyle(
                            color: MyColors.greyshade600,
                            fontSize: 16,
                            fontFamily: 'Lexend'),
                      ),
                      SizedBox(height: height * 0.015),
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
                      SizedBox(height: height * 0.025),
                      Text(
                        'Address',
                        style: TextStyle(
                            color: MyColors.greyshade600,
                            fontSize: 16,
                            fontFamily: 'Lexend'),
                      ),
                      SizedBox(height: height * 0.015),
                      SizedBox(
                        height: 55,
                        child: GooglePlaceAutoCompleteTextField(
                          boxDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.black12),
                          ),
                          textEditingController: taddress,
                          googleAPIKey:
                              "AIzaSyCziqe1Q-d4HMC3D9ZyYDFkBtx8ZHrzGzM",
                          inputDecoration: InputDecoration(
                            hintText: 'Address',
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: width * 0.03),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                            border: InputBorder.none,
                          ),
                          showError: false,
                          debounceTime: 800, // default 600 ms,
                          isLatLngRequired: true,
                          getPlaceDetailWithLatLng: (prediction) {
                            setState(() {
                              lat = prediction.lat.toString();
                              long = prediction.lng.toString();
                            });
                            log("placeDetails lat is : ${prediction.lat}");
                            log("placeDetails lng is : ${prediction.lng}");
                          }, // this callback is called when isLatLngRequired is true
                          itemClick: (prediction) {
                            taddress.text = prediction.description!;
                            taddress.selection;
                          },

                          seperatedBuilder: const Divider(),
                          isCrossBtnShown: false,
                        ),
                      ),
                      SizedBox(height: height * 0.025),
                      Text(
                        'Refer Optional',
                        style: TextStyle(
                            color: MyColors.greyshade600,
                            fontSize: 16,
                            fontFamily: 'Lexend'),
                      ),
                      SizedBox(height: height * 0.015),
                      TextFormField(
                        controller: trefercode,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          hintText: 'Refer & Earn',
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
                      // sosical Account
                      SizedBox(
                        height: height * 0.025,
                      ),
                      Text(
                        'Instagram',
                        style: TextStyle(
                            color: MyColors.greyshade600,
                            fontSize: 16,
                            fontFamily: 'Lexend'),
                      ),
                      SizedBox(height: height * 0.015),
                      TextFormField(
                        controller: tinstgram,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          prefixIcon: const Align(
                            widthFactor: 1.0,
                            heightFactor: 1.0,
                            child: Image(
                              image: AssetImage('assets/images/inst.png'),
                              height: 25,
                              width: 25,
                              color: Colors.grey,
                            ),
                          ),
                          hintText: 'Instagram',
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

                      // facebook
                      SizedBox(
                        height: height * 0.025,
                      ),
                      Text(
                        'Facebook',
                        style: TextStyle(
                            color: MyColors.greyshade600,
                            fontSize: 16,
                            fontFamily: 'Lexend'),
                      ),
                      SizedBox(height: height * 0.015),
                      TextFormField(
                        controller: tfacebook,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          prefixIcon: const Align(
                            widthFactor: 1.0,
                            heightFactor: 1.0,
                            child: Image(
                              image: AssetImage('assets/images/facebook.png'),
                              height: 25,
                              width: 25,
                            ),
                          ),
                          hintText: 'Facebook',
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

                      // youtube
                      SizedBox(
                        height: height * 0.025,
                      ),
                      Text(
                        'YouTube',
                        style: TextStyle(
                            color: MyColors.greyshade600,
                            fontSize: 16,
                            fontFamily: 'Lexend'),
                      ),
                      SizedBox(height: height * 0.015),
                      TextFormField(
                        controller: tyoutube,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          prefixIcon: const Align(
                            widthFactor: 1.0,
                            heightFactor: 1.0,
                            child: Image(
                              image: AssetImage('assets/images/youtube.png'),
                              height: 25,
                              width: 25,
                            ),
                          ),
                          hintText: 'YouTube',
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
                SizedBox(height: height * 0.020),
                Row(
                  children: [
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            isChecked = !isChecked;
                          });
                        },
                        child: isChecked
                            ? Image.asset(
                                'assets/images/checktrue.png',
                                height: 24,
                                width: 24,
                              )
                            : Image.asset(
                                'assets/images/checkbox.png',
                                height: 24,
                                width: 24,
                                color: MyColors.bacgroundcolors,
                              )
                        // checkbox
                        ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text.rich(TextSpan(children: [
                      const TextSpan(
                        text: 'I agreed to Mystsriya ',
                      ),
                      TextSpan(
                          text: 'Privacy Policy,\nTerms & Condition',
                          style: TextStyle(
                              color: MyColors.bacgroundcolors,
                              fontFamily: 'Lexend')),
                    ]))
                  ],
                ),
                SizedBox(height: height * 0.10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: MyColors.bacgroundcolors,
                      minimumSize: const Size(double.infinity, 40)),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      if (lat.isEmpty && long.isEmpty) {
                        Fluttertoast.showToast(
                          msg: 'Please Select Valid Address',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black54,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      } else if (!isChecked) {
                        Fluttertoast.showToast(
                          msg: 'Please Accept Terms & Conditions.',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black54,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      } else if (tinstgram.text.isEmpty &&
                          tfacebook.text.isEmpty &&
                          tyoutube.text.isEmpty) {
                        Fluttertoast.showToast(
                          msg: 'Please enter any one social media account',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black54,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      } else {
                        registerAPI();
                      }
                    }
                  },
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Lexend'),
                  ),
                ),
                SizedBox(
                  height: height * 0.020,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account? ",
                      style: TextStyle(fontFamily: 'Lexend'),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return const LoginScreen();
                          },
                        ));
                      },
                      child: Text(
                        "Login",
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
    );
  }
}
