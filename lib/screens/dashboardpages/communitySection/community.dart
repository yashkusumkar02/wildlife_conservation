import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Post {
  final String id;
  String title;
  String description;
  String? image;
  bool isLiked;
  int likes;
  List<String> comments;
  int shares;
  final String userId;

  Post({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.userId,
    this.isLiked = false,
    this.likes = 0,
    this.comments = const [],
    this.shares = 0,
  });

  void toggleLike() {
    isLiked = !isLiked;
    if (isLiked) {
      likes++;
    } else {
      likes--;
    }
  }
}

class CommunityHomePage extends StatefulWidget {
  const CommunityHomePage({Key? key, required List posts}) : super(key: key);

  @override
  _CommunityHomePageState createState() => _CommunityHomePageState();
}

class _CommunityHomePageState extends State<CommunityHomePage> {
  File? _selectedImage;
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _titleController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _loading = false;
  late User _currentUser;
  late Map<String, String> _userNames = {};
  late Map<String, String> _userProfileImages = {};

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser!;
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      QuerySnapshot usersSnapshot =
      await _firestore.collection('users').get();
      usersSnapshot.docs.forEach((doc) {
        _userNames[doc.id] = doc['name'];
        _userProfileImages[doc.id] = doc['profileImageUrl'];
      });
      setState(() {}); // Trigger a rebuild after fetching user data
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Community',
          style: TextStyle(fontWeight: FontWeight.w700, fontFamily: 'SF Pro'),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('posts').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No data available'));
          }
          final posts = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return Post(
              id: doc.id,
              title: data['title'] ?? '',
              description: data['description'] ?? '',
              image: data['imageUrl'] ?? '',
              userId: data['userId'] ?? '',
              isLiked: (data['likedBy'] ?? []).contains(_currentUser.uid),
              likes: data['likes'] ?? 0,
              comments: List<String>.from(data['comments'] ?? []),
              shares: data['shares'] ?? 0,
            );
          }).toList();

          return _buildPostList(posts);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Create a new post'),
                content: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          labelText: 'Title',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a title';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: 'Description',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a description';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      if (_selectedImage != null)
                        Image.file(
                          _selectedImage!,
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      ElevatedButton(
                        onPressed: () {
                          _openGallery(context);
                        },
                        child: Text('Select Image'),
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _savePost();
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text('Save'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildPostList(List<Post> posts) {
    return _loading
        ? Center(child: CircularProgressIndicator())
        : posts.isEmpty
        ? Center(
      child: Text(
        'No posts yet. Upload your first post!',
        style: TextStyle(color: Colors.grey),
      ),
    )
        : RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _loading = true;
        });
        await Future.delayed(Duration(seconds: 1));
        setState(() {
          _loading = false;
        });
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(
                      vertical: 10, horizontal: 20),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: NetworkImage(
                                  _userProfileImages[posts[index]
                                      .userId] ??
                                      '',
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                _userNames[posts[index].userId] ??
                                    'Unknown',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          if (posts[index].userId ==
                              _currentUser.uid)
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () async {
                                await _firestore
                                    .collection('posts')
                                    .doc(posts[index].id)
                                    .delete();
                                setState(() {
                                  posts.removeAt(index);
                                });
                              },
                            ),
                        ],
                      ),
                      SizedBox(height: 10),
                      posts[index].image != null
                          ? Image.network(
                        posts[index].image!,
                        width: double.infinity,
                        height: 400,
                        fit: BoxFit.cover,
                      )
                          : SizedBox(),
                      SizedBox(height: 10),
                      Text(
                        posts[index].title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        posts[index].description,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.favorite),
                            color: posts[index].isLiked
                                ? Colors.red
                                : Colors.grey,
                            onPressed: () {
                              setState(() {
                                posts[index].toggleLike();
                                _updateLikeStatus(
                                    posts[index].id,
                                    posts[index].isLiked);
                              });
                            },
                          ),
                          Text(
                            '${posts[index].likes}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.comment),
                            onPressed: () {
                              _showCommentDialog(context, posts[index].id);
                            },
                          ),
                          Text(
                            '${posts[index].comments.length}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.share),
                            onPressed: () {
                              // Implement share functionality
                            },
                          ),
                          Text(
                            '${posts[index].shares}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openGallery(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile =
    await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _savePost() async {
    try {
      String? imagePath;
      if (_selectedImage != null) {
        firebase_storage.Reference ref = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('images')
            .child('${DateTime.now().millisecondsSinceEpoch}');
        firebase_storage.UploadTask uploadTask =
        ref.putFile(_selectedImage!);
        await uploadTask.whenComplete(() async {
          imagePath = await ref.getDownloadURL();
        });
      }
      final docRef = await _firestore.collection('posts').add({
        'title': _titleController.text,
        'description': _descriptionController.text,
        'userId': _currentUser.uid,
        'imageUrl': imagePath,
        'likes': 0,
        'comments': [], // Initialize comments as an empty list
        'shares': 0,
      });

      // Store and increment the user's post count
      await storeDetectedUserPostsCount(_currentUser.uid);

      setState(() {
        _titleController.clear();
        _descriptionController.clear();
        _selectedImage = null;
      });
    } catch (e) {
      print('Error saving post: $e');
    }
  }

  Future<void> _updateLikeStatus(String postId, bool isLiked) async {
    try {
      final postRef = _firestore.collection('posts').doc(postId);
      if (isLiked) {
        await postRef.update({
          'likes': FieldValue.increment(1),
          'likedBy': FieldValue.arrayUnion([_currentUser.uid]),
        });
      } else {
        await postRef.update({
          'likes': FieldValue.increment(-1),
          'likedBy': FieldValue.arrayRemove([_currentUser.uid]),
        });
      }
    } catch (e) {
      print('Error updating like status: $e');
    }
  }

  Future<void> _showCommentDialog(BuildContext context, String postId) async {
    String comment = ''; // Initialize an empty comment

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add a Comment'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Enter your comment',
                  ),
                  onChanged: (value) {
                    comment = value; // Update the comment value as the user types
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Add the comment to Firestore
                await _addCommentToPost(postId, comment);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addCommentToPost(String postId, String comment) async {
    try {
      final postRef = _firestore.collection('posts').doc(postId);
      await postRef.update({
        'comments': FieldValue.arrayUnion([comment]), // Add the comment to the post's comments array
      });
    } catch (e) {
      print('Error adding comment: $e');
    }
  }




  Future<void> storeDetectedUserPostsCount(String userId) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Create a reference to the detected species collection
      CollectionReference detectedSpeciesCollectionRef =
      firestore.collection('detectedspecies');

      // Create a reference to the document for storing the user's post count
      DocumentReference userPostCountDocRef =
      detectedSpeciesCollectionRef.doc(userId);

      // Increment the count for the user's posts
      await userPostCountDocRef.set({
        'postCount': FieldValue.increment(1),
      }, SetOptions(merge: true));

      print('User post count stored successfully.');
    } catch (e) {
      print("Error storing user post count: $e");
      throw e;
    }
  }
}
