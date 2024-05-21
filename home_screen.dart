import 'package:flutter/material.dart';
import 'home_page.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/3.jpg'), // Replace with your image path
                fit: BoxFit.cover, // Ensure the image covers the whole screen
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Spacer(), // Pushes the button and text to the bottom
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => hpd4()),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                        textStyle: TextStyle(fontSize: 20),
                        shadowColor: Colors.grey,
                        elevation: 5,
                        backgroundColor: Colors.lightBlue, // Set button color to yellow
                      ),
                      // Set text color directly on the ElevatedButton widget
                      // You can use colors or define custom colors here
                      child: Text('Play Now', style: TextStyle(color: Colors.white)),
                    ),
                    SizedBox(height: 110), // Adjust the space between button and screen bottom
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
