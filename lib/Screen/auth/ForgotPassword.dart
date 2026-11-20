import 'dart:async';

import 'package:flutter/material.dart';
import 'package:momworkapp/Screen/auth/ResetPassword.dart';
import 'package:momworkapp/Screen/main/Colors.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';

import '../../services/auth_services.dart';
import '../../utils/utils.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final formKey = GlobalKey<FormState>();
  TextEditingController temail = TextEditingController();
  OtpFieldController otpController = OtpFieldController();

  bool emailestatus = false;
  String otp = '';
  String finalotp = '';

  int seconds = 60; // Set the initial timer value in seconds
  late Timer timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (seconds > 0) {
          seconds--;
        } else {
          timer.cancel();
        }
      });
    });
  }

  resendOTP() {
    setState(() {
      seconds = 60;
      startTimer();
      forgotVerfiyEmailData();
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  forgotVerfiyEmailData() async {
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
    };
    var result = await Services().forgotVerfiyEmail(context, body: body);
    if (result != null) {
      if (result.status) {
        Navigator.pop(context);
        finalotp = result.data.otp;
        setState(() {
          temail.text = result.data.email;
          finalotp = finalotp;
          emailestatus = true;
        });
      }
    }
  }

  forgotVerfiyOTPData() async {
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
      'otp': otp,
      'email': temail.text,
    };
    var result = await Services().forgotVerfiyOTP(context, body: body);

    if (result != null) {
      if (result.status) {
        var email = result.data.email;
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return ResetPassword(email: email);
          },
        ));
      } else {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: MyColors.greyshade600, //change your color here
          ),
          centerTitle: true,
          title: const Text(
            'Forgot Password',
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontFamily: 'Lexend'),
          ),
          backgroundColor: Colors.white,
          elevation: 1,
        ),
        body: Container(
          color: Colors.white,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  emailestatus
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              "Enter the 4 digit verification code sent to: ",
                              style:
                                  TextStyle(fontSize: 16, fontFamily: 'Lexend'),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              temail.text,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: MyColors.bacgroundcolors,
                                  fontFamily: 'Lexend'),
                            ),
                          ],
                        )
                      : const Text(
                          'Enter the Email Address associated with your account and we will send you a code to Forgot your password.',
                          style: TextStyle(fontSize: 16, fontFamily: 'Lexend'),
                        ),
                  const SizedBox(
                    height: 20,
                  ),
                  Form(
                      key: formKey,
                      child: emailestatus
                          ? Column(
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                OTPTextField(
                                  controller: otpController,
                                  length: 4,
                                  width: MediaQuery.of(context).size.width,
                                  textFieldAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  fieldWidth: 45,
                                  fieldStyle: FieldStyle.box,
                                  otpFieldStyle: OtpFieldStyle(
                                      borderColor: MyColors.bacgroundcolors,
                                      enabledBorderColor:
                                          MyColors.bacgroundcolors,
                                      focusBorderColor:
                                          MyColors.bacgroundcolors),
                                  outlineBorderRadius: 10,
                                  style: const TextStyle(fontSize: 17),
                                  onChanged: (pin) {
                                    setState(() {
                                      otp = pin;
                                    });
                                  },
                                  onCompleted: (pin) {
                                    setState(() {
                                      otp = pin;
                                    });
                                  },
                                ),
                                const SizedBox(height: 30),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      seconds == 0 ? "" : 'Re-send code in ',
                                      style: TextStyle(
                                          fontSize: 16, fontFamily: 'Lexend'),
                                    ),
                                    GestureDetector(
                                      onTap: seconds == 0 ? resendOTP : null,
                                      child: Text(
                                        seconds == 0
                                            ? 'Resend OTP'
                                            : '00:${seconds <= 9 ? "0$seconds" : seconds}',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: MyColors.bacgroundcolors,
                                            fontFamily: 'Lexend'),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  'Email Address',
                                  style: TextStyle(
                                      color: MyColors.greyshade600,
                                      fontSize: 16,
                                      fontFamily: 'Lexend'),
                                ),
                                const SizedBox(height: 10),
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
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    prefixIcon: const Align(
                                      widthFactor: 1.0,
                                      heightFactor: 1.0,
                                      child: Image(
                                        image: AssetImage(
                                            'assets/images/email.png'),
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
                              ],
                            )),
                  const Spacer(),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: MyColors.bacgroundcolors,
                        minimumSize: const Size(double.infinity, 40)),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        if (emailestatus) {
                          setState(() {
                            if (otp.length == 4) {
                              forgotVerfiyOTPData();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Please Enter OTP',
                                    style: TextStyle(fontFamily: 'Lexend'),
                                  ),
                                ),
                              );
                            }
                            emailestatus = true;
                          });
                        } else {
                          setState(() {
                            forgotVerfiyEmailData();
                            emailestatus = false;
                          });
                        }
                      }
                    },
                    child: Text(
                      emailestatus ? 'Verify' : "Submit",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Lexend'),
                    ),
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
