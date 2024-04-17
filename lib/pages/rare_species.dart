import 'package:flutter/material.dart';
import 'package:wildsense/pages/imagefetcher.dart';
import 'package:wildsense/pages/taxonomy.dart';
import 'package:lottie/lottie.dart'; // Import the lottie package

class SpeciesDetails extends StatefulWidget {
  final String speciesName;
  final String speciesDescription;
  final String imgUrl;
  final String ranges;

  SpeciesDetails({
    required this.speciesName,
    required this.speciesDescription,
    required this.imgUrl,
    required this.ranges,
  });

  @override
  _SpeciesDetailsState createState() => _SpeciesDetailsState();
}

class _SpeciesDetailsState extends State<SpeciesDetails> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Simulate a delay for 2-3 seconds before loading data
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
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
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Container(
                      width: 200,
                      height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
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
                          image: NetworkImage(widget.imgUrl),
                          fit: BoxFit.fill,
                          alignment: Alignment.center,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    widget.speciesName,
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
                      widget.speciesDescription,
                      textAlign: TextAlign.justify,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Divider(
                    color: Colors.grey,
                    thickness: 1,
                    indent: 10,
                    endIndent: 10,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Taxonomy',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'SF Pro',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  TaxonomyWidget(speciesName: widget.speciesName),
                  SizedBox(height: 20),
                  Divider(
                    color: Colors.grey,
                    thickness: 1,
                    indent: 10,
                    endIndent: 10,
                  ),
                  SizedBox(height: 10,),
                  Text(
                    'Distribution Map',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'SF Pro',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 30),
                  _isLoading
                      ? Center(
                    child: Lottie.asset(
                      'assets/loading_animation.json',
                      height: 100,
                      width: 100,
                    ),
                  )
                      : Center(
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              backgroundColor: Colors.transparent,
                              child: Container(
                                width: 300,
                                height: 300,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white,
                                      blurRadius: 10.0,
                                      spreadRadius: 2.0,
                                    ),
                                  ],
                                ),
                                child: Image.network(
                                  widget.ranges,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        width: 350,
                        height: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white,
                              blurRadius: 12.0,
                              spreadRadius: 1.0,
                            ),
                          ],
                        ),
                        child: Image.network(
                          widget.ranges,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
