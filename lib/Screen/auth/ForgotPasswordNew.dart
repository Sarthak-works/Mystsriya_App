import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:momworkapp/Screen/auth/ResetPasswordNew.dart';
import 'package:otp_text_field/otp_field.dart';

import '../../services/auth_services.dart';
import '../../utils/utils.dart';
import '../main/Colors.dart';
import 'ResetPassword.dart';

class ForgotPasswordNew extends StatefulWidget {
  const ForgotPasswordNew({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordNew> createState() => _ForgotPasswordNewState();
}

class _ForgotPasswordNewState extends State<ForgotPasswordNew> {
  final formKey = GlobalKey<FormState>();
  TextEditingController temail = TextEditingController();
  TextEditingController totp = TextEditingController();
  // OtpFieldController otpController = OtpFieldController();

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
      'otp': totp.text,
      'email': temail.text,
    };
    var result = await Services().forgotVerfiyOTP(context, body: body);

    if (result != null) {
      if (result.status) {
        var email = result.data.email;
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return ResetPasswordNew(email: email);
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
                          emailestatus ? "Verify Account" : 'Forgot Password',
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


                    Center(
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: Text(
                          emailestatus ? "Code has been sent to "+temail.text.toString()+". Enter the code to verify your account."
                              : 'No worries! Enter your email address below and we will send you a code to reset password.',
                          softWrap: true,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                              fontFamily: 'Lexend'

                          ),
                        ),
                      ),
                    ),

                    SizedBox(height:20,),


                    Text(
                      emailestatus ? "Code" : 'E-mail',
                      style: TextStyle(
                          color: MyColors.greyshade600,
                          fontSize: 16,
                          fontFamily: 'Lexend'),
                    ),
                    SizedBox(height: 8),
                    emailestatus ? TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter Code';
                        } else if (value.length!=4) {
                          return 'Please Enter Valid Code';
                        }
                        return null;
                      },
                      controller: totp,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      maxLength: 4,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[100],
                        hintText: '4 Digit Code',
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                        ),
                        border: textFieldBorder(),
                        focusedBorder: textFieldBorder(),
                        enabledBorder: textFieldBorder(),
                        disabledBorder: textFieldBorder(),
                        contentPadding: const EdgeInsets.all(15),
                      ),
                    )
                    : TextFormField(
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
                        hintText: 'Enter your Email',
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

                    SizedBox(height: 80,),

                    emailestatus ? Row(
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
                                ? "Didn't Receive Code? Resend OTP"
                                : '00:${seconds <= 9 ? "0$seconds" : seconds}',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontFamily: 'Lexend'),
                          ),
                        ),
                      ],
                    ) : Container(),


                    SizedBox(height: 80,),

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
                          if (emailestatus) {
                            setState(() {
                              if (totp.text.length == 4) {
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
                      child:  Text(
                        emailestatus ? "Verify Account" : "Send Reset Instruction",
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
            )
        ),
      ),
    );
  }
}
