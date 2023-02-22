import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:social_media_sw25/constants/collection_names.dart';

class NewsFeedScreen extends StatefulWidget {
  const NewsFeedScreen({Key? key}) : super(key: key);

  @override
  State<NewsFeedScreen> createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  String? username;
  String? picture;
  String? email;

  final postController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            _writePostWidget(context),
            _listOfPosts(),
          ],
        ),
      ),
    );
  }

  Widget _writePostWidget(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Home Page',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircleAvatar(
                radius: 22,
              ),
              SizedBox(width: 12),
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.black),
                ),
                child: TextFormField(
                  controller: postController,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Write a post',
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (postController.text.isNotEmpty) {
                    await _postAPost();
                  }
                },
                child: Text('Post'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _postWidget(Map<String, dynamic> data) {
    return Card(
      margin: EdgeInsets.all(12),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(
                data['picture'] ?? '',
              ),
            ),
            title: Text(data['username'] ?? 'User'),
            subtitle: Text(data['time'] ?? 'NOW'),
          ),
          Container(
            child: Text(
              data['content'] ?? '',
            ),
          ),
          SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _listOfPosts() {
    final collectionStream = FirebaseFirestore.instance
        .collection(CollectionNames.postsCollection)
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
        stream: collectionStream,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return ListView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return _postWidget(data);
            }).toList(),
          );
        });
  }

  Future<void> _postAPost() async {
    await FirebaseFirestore.instance.collection('posts').doc().set({
      'content': postController.text,
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'username': username!,
      'picture': picture!,
      'email': email!,
      'time': DateTime.now().toUtc().toString(),
    });
    postController.clear();
  }

  void _fetchUserData() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final snapshot = await FirebaseFirestore.instance
        .collection(CollectionNames.userCollection)
        .doc(uid)
        .get();
    final data = snapshot.data()!;
    email = data['email'];
    picture = data['profile_picture'];
    username = data['user_name'];
  }

  void _fetchPosts() {}
}
