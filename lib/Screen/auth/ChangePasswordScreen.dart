import 'package:flutter/material.dart';
import 'package:momworkapp/Screen/main/Colors.dart';
import 'package:momworkapp/utils/utils.dart';

import '../../services/auth_services.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController toldpassword = TextEditingController();
  TextEditingController tnewpassword = TextEditingController();
  TextEditingController tconfirmpassword = TextEditingController();

  bool oldPassHideShow = true;
  bool passHideShow = true;
  bool confirmPassHideShow = true;

  changePasswordAPI() async {
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
      'old_password': toldpassword.text,
      'new_password': tnewpassword.text,
      'confirm_password': tconfirmpassword.text
    };

    print('body:::::::::::::$body');

    var result = await Services().changePassword(body: body);
    Navigator.pop(context);
    if (result != null) {
      if (result) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: MyColors.greyshade600, //change your color here
          ),
          centerTitle: true,
          title: const Text(
            'Change Password',
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontFamily: 'Lexend'),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: SizedBox(
              height: height * 0.91,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: height * 0.025,
                        ),
                        Text(
                          'Old Password',
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
                              return 'Please Enter Your Old Password';
                            }
                            return null;
                          },
                          controller: toldpassword,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          obscureText: oldPassHideShow,
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
                                    oldPassHideShow = !oldPassHideShow;
                                  },
                                );
                              },
                              icon: Align(
                                widthFactor: 1.0,
                                heightFactor: 1.0,
                                child: Image(
                                  image: oldPassHideShow
                                      ? const AssetImage(
                                          'assets/images/pass_show.png')
                                      : const AssetImage(
                                          'assets/images/pass_off.png'),
                                  height: 25,
                                  width: 25,
                                ),
                              ),
                            ),
                            hintText: 'Old Password',
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
                            return Utils.passwordValidator(value ?? "", oldPassword: toldpassword.text);
                          },
                          controller: tnewpassword,
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
                          height: height * 0.025,
                        ),
                        Text(
                          'Confirm Password',
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
                            if (tnewpassword.text !=
                                tconfirmpassword.text) {
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
                        changePasswordAPI();
                      }
                    },
                    child: const Text(
                      "Change",
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
