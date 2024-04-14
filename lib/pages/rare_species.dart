import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SpeciesDetails extends StatelessWidget {
  final String speciesName;
  final String speciesDescription;
  final String imgUrl;

  SpeciesDetails({
    required this.speciesName,
    required this.speciesDescription,
    required this.imgUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/newbackground.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Text(
                'Rare Species Details',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.w700
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: 160, // Adjust width and height as needed
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                  image: DecorationImage(
                    image: NetworkImage(imgUrl),
                    fit: BoxFit.cover, // Adjust fit as needed
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                speciesName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 18,
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 10),
              Divider(
                color: Colors.grey,
                thickness: 1,
                indent: 10,
                endIndent: 10,
              ),
              SizedBox(height: 10),
              Text(
                'About',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  speciesDescription,
                  textAlign: TextAlign.justify,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Range Map',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Image.asset(
                'assets/images/locationn.png',
                width: 300,
              ),
              SizedBox(height: 7),
              ElevatedButton(
                onPressed: () {
                  // Implement the button functionality
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.zero,
                  ),
                  backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.transparent),
                  overlayColor:
                  MaterialStateProperty.all<Color>(Colors.transparent),
                  elevation: MaterialStateProperty.all<double>(2),
                  foregroundColor:
                  MaterialStateProperty.all<Color>(Colors.transparent),
                  shadowColor:
                  MaterialStateProperty.all<Color>(Colors.transparent),
                ),
                child: Container(
                  width: 200,
                  height: 35,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(1.00, -0.01),
                      end: Alignment(-1, 0.01),
                      colors: [Color(0xFF9C3FE4), Color(0xFFC65647)],
                    ),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Center(
                    child: Text(
                      'View Range Map',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        height: 0,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40), // Adjust spacing as needed
            ],
          ),
        ),
      ),
    );
  }
}
