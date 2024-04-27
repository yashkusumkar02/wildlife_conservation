import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

import 'article_info.dart';

class ListViewBuilder extends StatelessWidget {
  const ListViewBuilder({Key? key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('articles').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Show a loading indicator while fetching data
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        final List<DocumentSnapshot> documents = snapshot.data!.docs;

        // Check if there are documents available
        if (documents.isEmpty) {
          return Text('No articles found.');
        }

        // Get a random sublist of documents to display
        final random = Random();
        final maxCount = min(documents.length, 5); // Display maximum 5 articles
        final randomIndices = List.generate(maxCount, (index) => random.nextInt(documents.length));
        final randomDocuments = randomIndices.map((index) => documents[index]).toList();

        return Padding(
          padding: const EdgeInsets.only(bottom: 20.0), // Add padding at the bottom
          child: Column(
            children: randomDocuments.map((doc) {
              final title = doc['title'];
              final desc = doc['desc'];
              final imgUrl = doc['img_url'];

              return Padding(
                padding: const EdgeInsets.only(bottom: 10.0), // Add bottom padding to each article box
                child: GestureDetector(
                  onTap: () async {
                    await storeDetectedUserArticleCount(); // Store current user's article count
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ArticleView(title: title,  imageUrl: imgUrl,)),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Material(
                      elevation: 3.0,
                      borderRadius: BorderRadius.circular(10),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    child: Image.network(
                                      imgUrl,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 5.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 17.0,
                                      ),
                                    ),
                                    SizedBox(height: 5,),
                                    Text(
                                      desc,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Future<void> storeDetectedUserArticleCount() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      FirebaseAuth auth = FirebaseAuth.instance;

      // Get current user's ID
      String? userId = auth.currentUser?.uid;
      if (userId == null) {
        print('User not logged in.');
        return;
      }

      // Create a reference to the detected species collection
      CollectionReference detectedSpeciesCollectionRef =
      firestore.collection('detectedspecies');

      // Create a reference to the document for storing the user's article count
      DocumentReference userArticleCountDocRef =
      detectedSpeciesCollectionRef.doc(userId);

      // Increment the count for the user's articles
      await userArticleCountDocRef.set({
        'articleCount': FieldValue.increment(1),
      }, SetOptions(merge: true));

      print('User article count stored successfully.');
    } catch (e) {
      print("Error storing user article count: $e");
      throw e;
    }
  }
}
