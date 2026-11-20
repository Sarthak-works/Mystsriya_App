import 'package:flutter/material.dart';
import 'package:momworkapp/Screen/main/Colors.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
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
          'Notification',
          style: TextStyle(
              color: Colors.black45, fontSize: 16, fontFamily: 'Lexend'),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Container(
        color: Colors.white,
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: 1,
          shrinkWrap: true,
          padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
          scrollDirection: Axis.vertical,
          separatorBuilder: (context, index) => const SizedBox(width: 15),
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 2),
                ],
                // border: Border.all(color: Colors.grey),
                borderRadius: const BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Welcome To This App  ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Lexend'),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Thank You',
                          style: TextStyle(
                              color: Colors.grey, fontFamily: 'Lexend'),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    width: 50,
                    child: ClipRRect(
                        child: Image.asset(
                      'assets/images/post.png',
                      fit: BoxFit.cover,
                    )),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    ));
  }
}
