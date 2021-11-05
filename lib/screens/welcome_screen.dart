import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/components/roundedbutton.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    //upperBound: 100.0,
    animation = ColorTween(
      begin: Colors.blueGrey,
      end: Color(0xff303030),
    ).animate(controller);
    controller.forward();
    // animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
    //controller.reverse(from: 1.0); to reverse for easeIn

    // animation.addStatusListener((status) {
    //   // print(status);
    //   if (status == AnimationStatus.completed) {
    //     controller.reverse(from: 1.0);
    //   } else if (status == AnimationStatus.dismissed) {
    //     controller.forward();
    //   }
    // });
    controller.addListener(() {
      setState(() {
        print(animation.value);
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      //to add transition effect on background color
      //backgroundColor: Colors.red.withOpacity(container.value),
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    // height: animation.value * 100,
                    height: 60.0,
                  ),
                ),
                // ignore: deprecated_member_use
                TyperAnimatedTextKit(
                  text: ['Flash Chat'],
                  textStyle: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    //color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            Roundedbutton(
              title: 'Log In',
              //colour: Color(0xff00EDB3),
              onPressed: () {
                Navigator.pushNamed(context, '/first');
              },
            ),
            Roundedbutton(
                title: 'Register',
                // colour: Color(0xff00EDB3),
                onPressed: () {
                  Navigator.pushNamed(context, '/second');
                })
          ],
        ),
      ),
    );
  }
}
