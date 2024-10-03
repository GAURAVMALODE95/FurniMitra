import 'package:flutter/material.dart';
import 'package:furnimitra/Screens/Login.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              children: [
                buildPage(
                  image: 'assets/ideas.png',
                  title: 'Ideas',
                  subtitle: 'Unlock Cutting-Edge Ideas with FurniMitra!',
                ),
                buildPage(
                  image: 'assets/deals.jpg',
                  title: 'Offers',
                  subtitle:
                      'Discover the Latest Exclusive Deals at FurniMitra!',
                ),
                buildPage(
                  image: 'assets/store.jpg',
                  title: 'Shop at Stores',
                  subtitle: 'Shop with Ease at Your Favorite Stores!',
                ),
              ],
            ),
          ),
          SmoothPageIndicator(
            controller: _pageController,
            count: 3,
            effect: ExpandingDotsEffect(
              dotWidth: 15.0,
              dotHeight: 6.0,
              activeDotColor: Colors.white,
              dotColor: Colors.grey,
            ),
          ),
          SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  child: Text('Sign Up or Log In'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Colors.black,
                    minimumSize: Size(double.infinity, 50),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text('Maybe later'),
                  style: TextButton.styleFrom(
                    primary: Colors.white,
                    minimumSize: Size(double.infinity, 50),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 32.0),
        ],
      ),
    );
  }

  Widget buildPage(
      {required String image,
      required String title,
      required String subtitle}) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.0,
              color: Color.fromARGB(255, 2, 171, 255),
            ),
          ),
          SizedBox(height: 20.0),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 21.0,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            width: 280.0,
            height: 240.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.cover,
              ),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ],
      ),
    );
  }
}
