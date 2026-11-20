import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:momworkapp/Screen/auth/LoginScreen.dart';

import '../utils/utils.dart';
import 'auth/LoginHomeScreen.dart';
import 'main/Colors.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  List<ContentConfig> listContentConfig = [];
  Color activeColor = MyColors.bacgroundcolors;
  Color inactiveColor = Color(0xff9932CC);
  double sizeIndicator = 20;

  int currentTab=0;
  late Function goToTab;

  bool isLastSlide=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Utils.prefs!.setBool('firstTime', false);
    listContentConfig.add(
      ContentConfig(
        widgetTitle: Container(
          child: CircleAvatar(
            radius: 140,
            backgroundImage: AssetImage( "assets/images/intro1.jpg",
            ),
          ),
        ),

      centerWidget: Container(
        margin: EdgeInsets.all(10),
        child: Text(
          'Start Earning \nToday',
          softWrap: true,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.black,
              fontSize: 40,
              fontWeight: FontWeight.w600,
              fontFamily: 'Lexend'

          ),
        ),
      ),
      
      marginDescription: EdgeInsets.all(20),

      widgetDescription: Container(
        margin: EdgeInsets.all(10),
        child: Text(
          'Make extra cash by sharing and reviewing the products you use daily',
          softWrap: true,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.black45,
              fontSize: 18,
              fontWeight: FontWeight.w400,
              fontFamily: 'Lexend'

          ),
        ),
      ),

      verticalScrollbarBehavior: ScrollbarBehavior.hide
      ),
    );
    listContentConfig.add(
      ContentConfig(
          widgetTitle: Container(
            child: CircleAvatar(
              radius: 140,
              backgroundImage: AssetImage( "assets/images/intro2.jpg",
              ),
            ),
          ),

          centerWidget: Container(
            margin: EdgeInsets.all(10),
            child: Text(
              'Join Campaigns \and Get Paid',
              softWrap: true,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 40,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Lexend'

              ),
            ),
          ),

          marginDescription: EdgeInsets.all(20),

          widgetDescription: Container(
            margin: EdgeInsets.all(10),
            child: Text(
              'Participate and receive payments easily right into your bank account',
              softWrap: true,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black45,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Lexend'

              ),
            ),
          ),

          verticalScrollbarBehavior: ScrollbarBehavior.hide
      ),
    );
    listContentConfig.add(
      ContentConfig(
          marginDescription: EdgeInsets.all(20),

          widgetTitle: Column(
          children: [
            Container(
              child: CircleAvatar(
                radius: 140,
                backgroundImage: AssetImage( "assets/images/intro3.jpg",
                ),
              ),
            ),

            SizedBox(height: 10,),

            Container(
              margin: EdgeInsets.all(10),
              child: Text(
                'Welcome to \nMystsriya',
                softWrap: true,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 40,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Lexend'

                ),
              ),
            ),

            SizedBox(height: 25,),

            Container(
              margin: EdgeInsets.all(10),
              child: Text(
                'Discover new products, review them, and earn rewards for your feedback.',
                softWrap: true,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black45,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Lexend'

                ),
              ),
            ),


          ],
        ),
        //  backgroundColor: MyColors.greyshade500,
          verticalScrollbarBehavior: ScrollbarBehavior.hide
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Expanded(
                child: IntroSlider(
                //  key: UniqueKey(),
                //  scrollPhysics: NeverScrollableScrollPhysics(),
                  // Content config
                  listContentConfig: listContentConfig,
                  // Skip button
                  isShowDoneBtn: false,
                  isShowNextBtn: false,
                  isShowPrevBtn: false,
                  isShowSkipBtn: false,
                
                  indicatorConfig: IndicatorConfig(
                    sizeIndicator: sizeIndicator,
                    indicatorWidget: Container(
                      width: sizeIndicator,
                      height: 10,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4), color: inactiveColor),
                    ),
                    activeIndicatorWidget: Container(
                      width: sizeIndicator,
                      height: 10,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4), color: activeColor),
                    ),
                    spaceBetweenIndicator: 10,
                    typeIndicatorAnimation: TypeIndicatorAnimation.sliding,
                  ),
                
                  // Navigation bar
                  navigationBarConfig: NavigationBarConfig(
                    navPosition: NavPosition.bottom,
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).viewPadding.top > 0 ? 20 : 10,
                      bottom: MediaQuery.of(context).viewPadding.bottom > 0 ? 20 : 10,
                    ),
                    //  backgroundColor: Colors.black.withOpacity(0.5),
                  ),
                
                  // Scroll behavior
                  isAutoScroll: false,
                  isLoopAutoScroll: false,
                  curveScroll: Curves.bounceIn,
                  refFuncGoToTab: (refFunc) {
                    goToTab = refFunc;
                  },
                  scrollPhysics: const BouncingScrollPhysics(),
                  onTabChangeCompleted: (value){
        
                    currentTab=value;
                    print("dfdsfds $currentTab");
        
                  },
                ),
              ),
        
              SizedBox(height: 15,),
        
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Visibility(
                    visible: currentTab!=2,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          minimumSize: WidgetStatePropertyAll(const Size(150, 45),),
                          shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(5)),
                                  side: BorderSide(color: Colors.black)
                              )
                          )
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>  const LoginHomeScreen()));
                      },
                      child: const Text(
                        "SKIP",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'Lexend'),
                      ),
                    ),
                  ),
        
                  SizedBox(width: 20,),
        
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(MyColors.bacgroundcolors),
                        minimumSize: WidgetStatePropertyAll(Size(currentTab==2 ? 250 : 150, 45),),
                        shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                            )
                        )
                    ),
                    onPressed: () {
                      setState(() {
                      });
        
                      if (currentTab==2){
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>  const LoginHomeScreen()));
                      } else if (currentTab<2) {
                        currentTab++;
                        goToTab(currentTab);
                      }
        
                        print("current tab $currentTab");
                    },
                    child: Text(
                      currentTab==2 ? "Let's Start" : "NEXT",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Lexend'),
                    ),
                  ),
        
                ],
              ),
        
            ],
          )
        ),
      ),
    );
  }

  // introPages() {
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //
  //       Container(
  //         child: CircleAvatar(
  //           radius: 140,
  //           backgroundImage: AssetImage( "assets/images/intro1.jpg",
  //           ),
  //         ),
  //       ),
  //
  //       SizedBox(height: 10,),
  //
  //       Container(
  //         margin: EdgeInsets.all(10),
  //         child: Text(
  //           'Start Earning \nToday',
  //           softWrap: true,
  //           textAlign: TextAlign.center,
  //           style: TextStyle(
  //               color: Colors.black,
  //               fontSize: 40,
  //               fontWeight: FontWeight.w600,
  //               fontFamily: 'Lexend'
  //
  //           ),
  //         ),
  //       ),
  //
  //       SizedBox(height: 25,),
  //
  //       Container(
  //         margin: EdgeInsets.all(10),
  //         child: Text(
  //           'Make extra cash by sharing and\n reviewing the products you use\n daily',
  //           softWrap: true,
  //           textAlign: TextAlign.center,
  //           style: TextStyle(
  //               color: Colors.black45,
  //               fontSize: 18,
  //               fontWeight: FontWeight.w400,
  //               fontFamily: 'Lexend'
  //
  //           ),
  //         ),
  //       ),
  //
  //       SizedBox(height: 55,),
  //
  //       Align(
  //         alignment: Alignment.bottomCenter,
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             ElevatedButton(
  //               style: ButtonStyle(
  //                   minimumSize: WidgetStatePropertyAll(const Size(150, 45),),
  //                   shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
  //                       RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.all(Radius.circular(5)),
  //                         side: BorderSide(color: Colors.black)
  //                       )
  //                   )
  //               ),
  //               onPressed: () {
  //
  //               },
  //               child: const Text(
  //                 "SKIP",
  //                 style: TextStyle(
  //                     fontWeight: FontWeight.bold,
  //                     color: Colors.black,
  //                     fontSize: 16,
  //                     fontFamily: 'Lexend'),
  //               ),
  //             ),
  //
  //             SizedBox(width: 20,),
  //
  //             ElevatedButton(
  //               style: ButtonStyle(
  //                   backgroundColor: WidgetStatePropertyAll(MyColors.bacgroundcolors),
  //                   minimumSize: WidgetStatePropertyAll(const Size(150, 45),),
  //                   shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
  //                       RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.all(Radius.circular(5)),
  //                       )
  //                   )
  //               ),
  //               onPressed: () {
  //
  //               },
  //               child: const Text(
  //                 "NEXT",
  //                 style: TextStyle(
  //                     fontWeight: FontWeight.bold,
  //                     color: Colors.white,
  //                     fontSize: 16,
  //                     fontFamily: 'Lexend'),
  //               ),
  //             ),
  //
  //           ],
  //         ),
  //       ),
  //
  //
  //
  //     ],
  //   );
  // }
}
