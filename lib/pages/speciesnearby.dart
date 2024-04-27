import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lottie/lottie.dart';
import 'package:wildsense/pages/rare_species.dart';

class SpeciesNearby extends StatefulWidget {
  const SpeciesNearby({Key? key}) : super(key: key);

  @override
  State<SpeciesNearby> createState() => _SpeciesNearbyState();
}

class _SpeciesNearbyState extends State<SpeciesNearby> {
  String? selectedCountry;
  List<String> countries = ['Select country']; // Add default value here
  bool isLoading = false; // Track loading state
  bool isDropdownClicked = false;
  late User _user;

  @override
  void initState() {
    super.initState();
    fetchCountries();
    _user = FirebaseAuth.instance.currentUser!;
  }

  Future<void> fetchCountries() async {
    QuerySnapshot countriesSnapshot =
    await FirebaseFirestore.instance.collection('countries').get();
    setState(() {
      countries.addAll(countriesSnapshot.docs.map((doc) => doc.id).toList());
      if (countries.isNotEmpty) {
        selectedCountry = countries[0];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    final screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    return Container(
      width: screenWidth * 0.99,
      height: screenHeight * 0.25,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(
          color: Colors.grey, // Specify the color of the stroke
          width: 1, // Specify the width of the stroke
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // Adjust the offset to make the shadow appear on the outer side
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: AnimatedContainer(
                  width: screenWidth * 0.4,
                  duration: Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    color: selectedCountry != null
                        ? Color(0xFFFFFFFF)
                        : Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                      color: Colors.grey, // Specify the color of the stroke
                      width: 1, // Specify the width of the stroke
                    ),
                  ),
                  child: Stack(
                    children: [
                      isDropdownClicked || selectedCountry != null
                          ? SizedBox()
                          : Center(
                        child: Lottie.asset(
                          'assets/searching.json',
                          width: 100,
                          height: 100,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: DropdownButtonHideUnderline(
                          child: Center(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: selectedCountry,
                              items: countries.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value.toUpperCase(),
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                setState(() {
                                  selectedCountry = value;
                                  isLoading = true;
                                  isDropdownClicked = false;
                                });
                                // Simulate loading for at least 10 seconds
                                Future.delayed(Duration(seconds: 30), () {
                                  if (mounted && isLoading) {
                                    setState(() {
                                      isLoading = false;
                                    });
                                  }
                                });
                              },
                              icon: Icon(Icons.location_on_outlined,
                                  color: Color(0xFF5D3F3F)),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 5),
            Divider(color: Colors.grey),
            SizedBox(height: 10), // Add the line image here
            Expanded(
              child: Stack(
                children: [
                  selectedCountry != null && selectedCountry != 'Select country'
                      ? FutureBuilder<DocumentSnapshot>(
                    future: selectedCountry != null
                        ? FirebaseFirestore.instance
                        .collection('countries')
                        .doc(selectedCountry)
                        .get()
                        : Future.value(null),
                    builder: (context, snapshot) {
                      print('Selected country: $selectedCountry');
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return isLoading
                            ? Center(
                          child: Lottie.asset(
                            'assets/searching.json',
                            width: 900,
                            height: 900,
                          ),
                        )
                            : SizedBox();
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }
                      if (!snapshot.hasData || snapshot.data!.data() == null) {
                        return Center(child: Text('No species data found for this country'));
                      }

                      var speciesData;
                      if (snapshot.hasData && snapshot.data!.data() != null) {
                        speciesData = (snapshot.data!.data() as Map<String, dynamic>)['species'];
                      }
                      if (speciesData == null) {
                        return Center(child: Text('No species data found for this country'));
                      }
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: speciesData.length,
                        itemBuilder: (context, index) {
                          var species = speciesData[index];
                          return GestureDetector(
                            onTap: () async {
                              String speciesDescription = species['desc']; // Fetch description here
                              String rareSpeciesName = species['name']; // Assuming the species name is stored in the 'name' field
                              try {
                                await storeRareSpeciesData(_user.uid, rareSpeciesName);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SpeciesDetails(
                                      speciesName: species['name'],
                                      imgUrl: species['img_url'],
                                      speciesDescription: speciesDescription,
                                      ranges: species['ranges'], // Pass the selected country's ID here
                                    ),
                                  ),
                                );
                              } catch (e) {
                                print('Error storing rare species data: $e');
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Column(
                                children: [
                                  ClipOval(
                                    child: Image.network(
                                      species['img_url'],
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.fill,
                                      errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _truncateSpeciesName(species['name']),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  )
                      : Center(
                    child: Lottie.asset(
                      'assets/countries.json',
                      width: 900,
                      height: 700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _truncateSpeciesName(String name) {
    if (name.length <= 10) {
      return name;
    } else {
      int lastSpaceIndex = name.substring(0, 10).lastIndexOf(' ');
      if (lastSpaceIndex == -1) {
        return name.substring(0, 10) + '...';
      } else {
        return name.substring(0, lastSpaceIndex) + '...';
      }
    }
  }

  Future<void> storeRareSpeciesData(String userId, String rareSpeciesName) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Create a reference to the detected species collection
      CollectionReference detectedSpeciesCollectionRef = firestore.collection('detectedspecies');

      // Create a reference to the document for storing all rare species count
      DocumentReference allRareSpeciesCountDocRef = detectedSpeciesCollectionRef.doc(userId);

      // Increment the count for the rare species
      await allRareSpeciesCountDocRef.set({
        'rareCount': FieldValue.increment(1),
      }, SetOptions(merge: true));

      // Create a reference to the collection for storing individual rare species
      CollectionReference rareSpeciesCollectionRef = allRareSpeciesCountDocRef.collection('rare_species');

      // Store the rare species name
      await rareSpeciesCollectionRef.add({
        'name': rareSpeciesName,
        'timestamp': FieldValue.serverTimestamp(), // Optionally, add a timestamp
      });

      print('Rare species data stored successfully.');
    } catch (e) {
      print("Error storing rare species data: $e");
      throw e;
    }
  }
}
