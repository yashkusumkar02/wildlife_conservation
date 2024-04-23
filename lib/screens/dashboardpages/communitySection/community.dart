import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
<<<<<<< HEAD
import 'package:lottie/lottie.dart';
=======
>>>>>>> origin/master

class Post {
  final String id;
  String title;
  String description;
  String? image;
  bool isLiked;
  int likes;
  List<String> comments;
<<<<<<< HEAD
  List<String> commentUsernames; // Add list for usernames
=======
>>>>>>> origin/master
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
<<<<<<< HEAD
    this.commentUsernames = const [], // Initialize comment usernames list
=======
>>>>>>> origin/master
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
      QuerySnapshot usersSnapshot = await _firestore.collection('users').get();
      usersSnapshot.docs.forEach((doc) {
<<<<<<< HEAD
        setState(() {
          _userNames[doc.id] = doc["name"];
        });
        // _userProfileImages[doc.id] = doc['profileImageUrl'];
      });
      setState(() {

      }); // Trigger a rebuild after fetching user data
=======
        _userNames[doc.id] = doc['name'];
        _userProfileImages[doc.id] = doc['profileImageUrl'];
      });
      setState(() {}); // Trigger a rebuild after fetching user data
>>>>>>> origin/master
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
<<<<<<< HEAD
              commentUsernames: List<String>.from(data['commentUsernames'] ?? []), // Add usernames list
=======
>>>>>>> origin/master
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
<<<<<<< HEAD
                      SizedBox(height: 10),
=======
>>>>>>> origin/master
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
<<<<<<< HEAD
                              _showCommentsBottomSheet(posts[index]);
=======
                              // Implement comment functionality
>>>>>>> origin/master
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

<<<<<<< HEAD

=======
>>>>>>> origin/master
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
        'comments': [],
<<<<<<< HEAD
        'commentUsernames': [], // Add empty list for usernames
=======
>>>>>>> origin/master
        'shares': 0,
      });
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
<<<<<<< HEAD

  Future<void> _addComment(String postId, String comment) async {
    try {
      final docRef = _firestore.collection('posts').doc(postId);
      await docRef.update({
        'comments': FieldValue.arrayUnion([comment]), // Add comment to post
        'commentUsernames': FieldValue.arrayUnion(
            [_currentUser.displayName ?? 'Anonymous']), // Add username to post
      });
    } catch (e) {
      print('Error adding comment: $e');
    }
  }

  // Add a method to show comments in bottom sheet
  void _showCommentsBottomSheet(Post post) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                Text(
                  'Comments',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                if (post.comments.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: Column(
                        children: [
                          Lottie.asset(
                            'assets/comment.json',
                            width: 200,
                            height: 200,
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Be the first to comment!',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: post.comments.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            _userProfileImages[post.userId] ?? '',
                          ),
                        ),
                        title: Text(
                          post.commentUsernames[index],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(post.comments[index]),
                      );
                    },
                  ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Add a comment',
                  ),
                  onFieldSubmitted: (value) {
                    _addComment(post.id, value); // Call method to save comment
                    Navigator.of(context).pop(); // Close bottom sheet after commenting
                  },
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }
}
=======
}

>>>>>>> origin/master
