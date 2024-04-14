import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ArticleView extends StatelessWidget {
  final String title;
  final String imageUrl;

  ArticleView({
    required this.title,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                height: 350,
                child: Stack(
                  alignment: Alignment.centerLeft, // Align the image to the left
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        height: double.infinity,
                        width: MediaQuery.of(context).size.width, // Use full width of the screen
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 16, // Adjust the shadow height as needed
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 10,
                              offset: Offset(0, 3), // Adjust the offset as needed
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 20), // Added padding to move text to the left
                child: Align(
                  alignment: Alignment.centerLeft, // Align text to the left
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left, // Set text alignment to left
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('articles')
                      .where('title', isEqualTo: title)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(); // Show loading indicator while fetching data
                    }
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                      final fullDescription = snapshot.data!.docs.first['full_desc'];
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: fullDescription,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      );
                    }
                    return Text('No data available'); // Show message if no data found
                  },
                ),
              ),
              SizedBox(height: 20), // Add additional space at the bottom
            ],
          ),
        ),
      ),
    );
  }
}
