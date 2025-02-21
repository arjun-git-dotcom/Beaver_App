import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:social_media/constants.dart';
import 'package:social_media/features/data/data_sources/remote_data_source/cloudinary/cloudinary_data_source.dart';
import 'package:social_media/features/data/data_sources/remote_data_source/remote_data_source.dart';
import 'package:social_media/features/data/model/post/post_model.dart';
import 'package:social_media/features/data/model/user/user_model.dart';
import 'package:social_media/features/domain/entities/posts/post_entity.dart';
import 'package:social_media/features/domain/entities/user/user_entity.dart';

class FirebaseRemoteDataSourceImpl implements FirebaseRemoteDataSource {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;
  final CloudinaryRepository cloudinaryRepository;

  FirebaseRemoteDataSourceImpl(
      {required this.firebaseFirestore,
      required this.firebaseAuth,
      required this.cloudinaryRepository});
  @override
  Future<void> createUserWithImage(UserEntity user, String profileUrl) async {
    final userCollection =
        firebaseFirestore.collection(FirebaseConstants.users);

    final uid = await getCurrentUid();
    userCollection.doc(uid).get().then((userDoc) {
      final newUser = UserModel(
              name: user.name,
              email: user.email,
              uid: uid,
              username: user.username,
              bio: user.bio,
              website: user.website,
              followers: user.followers,
              following: user.followers,
              totalFollowers: user.totalFollowers,
              totalFollowing: user.totalFollowing,
              profileUrl: profileUrl,
              totalPosts: user.totalPosts)
          .toJson();

      if (!userDoc.exists) {
        userCollection.doc(uid).set(newUser);
      } else {
        userCollection.doc(uid).update(newUser);
      }
    }).catchError((error) {
      toast('some error occured');
    });
  }

  @override
  Future<void> createUser(UserEntity user) async {
    final userCollection =
        firebaseFirestore.collection(FirebaseConstants.users);

    final uid = await getCurrentUid();
    userCollection.doc(uid).get().then((userDoc) {
      final newUser = UserModel(
              name: user.name,
              email: user.email,
              uid: uid,
              username: user.username,
              bio: user.bio,
              website: user.website,
              followers: user.followers,
              following: user.followers,
              totalFollowers: user.totalFollowers,
              totalFollowing: user.totalFollowing,
              profileUrl: user.profileUrl,
              totalPosts: user.totalPosts)
          .toJson();

      if (!userDoc.exists) {
        userCollection.doc(uid).set(newUser);
      } else {
        userCollection.doc(uid).update(newUser);
      }
    }).catchError((error) {
      toast('some error occured');
    });
  }

  @override
  Future<String> getCurrentUid() async => firebaseAuth.currentUser!.uid;

  @override
  Stream<List<UserEntity>> getSingleUser(String uid) {
    final userCollection = firebaseFirestore
        .collection(FirebaseConstants.users)
        .where('uid', isEqualTo: uid)
        .limit(1);

    return userCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList());
  }

  @override
  Stream<List<UserEntity>> getUsers(UserEntity user) {
    final userCollection =
        firebaseFirestore.collection(FirebaseConstants.users);

    return userCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList());
  }

  @override
  Future<bool> islogin() async => firebaseAuth.currentUser?.uid != null;

  @override
  Future<void> logOut() async => firebaseAuth.signOut();

  @override
  Future<void> loginUser(UserEntity user) async {
    try {
      if (user.email!.isNotEmpty || user.password!.isNotEmpty) {
        await firebaseAuth.signInWithEmailAndPassword(
            email: user.email!, password: user.password!);
      } else {
        print('fields cannot be empty');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        toast('user not found');
      } else if (e.code == 'wrong password') {
        toast('invalid email or password');
      }
    }
  }

  @override
  Future<void> registerUser(UserEntity user) async {
    try {
      UserCredential userCredential =
          await firebaseAuth.createUserWithEmailAndPassword(
        email: user.email!,
        password: user.password!,
      );

      if (userCredential.user?.uid != null) {
        String profileUrl = "";

        if (user.imageFile != null) {
          profileUrl = await cloudinaryRepository.uploadImageToStorage(
              user.imageFile, "profileImages", false);
        }

        await createUserWithImage(user, profileUrl);
        await createUser(user);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        toast('Email is already registered, login instead.');
      } else {
        toast('Something went wrong.');
      }
    }
  }

  @override
  Future<void> updateUser(UserEntity user) async {
    final userCollection =
        firebaseFirestore.collection(FirebaseConstants.users);

    Map<String, dynamic> userInformation = Map();
    if (user.username != '' && user.username != null) {
      userInformation['username'] = user.username;
    }
    if (user.website != '' && user.website != null) {
      userInformation['website'] = user.website;
    }
    if (user.profileUrl != '' && user.profileUrl != null) {
      userInformation['profielUrl'] = user.profileUrl;
    }
    if (user.bio != '' && user.bio != null) {
      userInformation['bio'] = user.bio;
    }
    if (user.name != '' && user.name != null) {
      userInformation['name'] = user.name;
    }
    if (user.totalFollowers != null) {
      userInformation['totalFollowers'] = user.totalFollowers;
    }
    if (user.totalFollowing != null) {
      userInformation['totalFollowing'] = user.totalFollowing;
    }
    if (user.totalPosts == null) {
      userInformation['totalPosts'] = user.totalPosts;
    }
    userCollection.doc(user.uid).update(userInformation);
  }

  @override
  Future<String> googleSignIn() async {
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    final User? user = userCredential.user;

    if (user != null) {
      final userDoc =
          FirebaseFirestore.instance.collection(FirebaseConstants.users).doc(user.uid).get();

      if (userDoc != null) {
        await FirebaseFirestore.instance.collection(FirebaseConstants.users).doc(user.uid).set({
          'uid': user.uid,
          'name': user.displayName ?? '',
          'email': user.email ?? '',
          'profileUrl': '',
          'location': null,
          "bio": null,
          "username": null,
          "followers": null,
          "following": null,
          "totalfollowers": null,
          "totalfollowing": null,
          "website": null
        });
      }
    }
    return user!.uid;
  }

  @override
  Future<void> createPost(PostEntity post) async {
    final postCollection =
        firebaseFirestore.collection(FirebaseConstants.posts);
    final newpost = PostModel(
      postId: post.postId,
      creatorUid: post.creatorUid,
      username: post.username,
      description: post.description,
      postImageUrl: post.postImageUrl,
      likes: [],
      totalLikes: 0,
      totalComments: 0,
      createAt: post.createAt,
      userProfileUrl: post.userProfileUrl,
    ).toJson();
    try {
      final postDocRef = await postCollection.doc(post.postId).get();
      if (!postDocRef.exists) {
        postCollection.doc(post.postId).set(newpost, SetOptions(merge: true));
      } else {
        postCollection.doc(post.postId).update(newpost);
      }
    } catch (e) {
      print('some error occured $e');
    }
  }

  @override
  Future<void> deletePost(PostEntity post) async {
    final postCollection =
        firebaseFirestore.collection(FirebaseConstants.posts);

    try {
      postCollection.doc(post.postId).delete();
    } catch (e) {
      print('some error occured $e');
    }
  }

  @override
  Future<void> likePost(PostEntity post) async {
    final postCollection =
        firebaseFirestore.collection(FirebaseConstants.posts);
    final currentuid = await getCurrentUid();
    final postRef =  postCollection.doc(post.postId);
    final postRefget = await postRef.get();

    if (postRefget.exists) {
      List likes = postRefget.get('likes');
      if (likes.contains(currentuid)) {
        postCollection.doc(post.postId).update({
          'likes': FieldValue.arrayRemove([currentuid]),
          'totalLikes': FieldValue.increment(-1)
        });
      } else {
        postCollection.doc(post.postId).update({
          'likes': FieldValue.arrayUnion([currentuid]),
          "totalLikes": FieldValue.increment(1)
        });
      }
    }
  }

  @override
  Stream<List<PostEntity>> readPost(PostEntity post) {
    final postCollection = firebaseFirestore
        .collection(FirebaseConstants.posts)
        .orderBy("createAt", descending: true);
    return postCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => PostModel.fromSnapShot(e)).toList());
  }

  @override
  Future<void> updatePost(PostEntity post) async {
    final postCollection =
        firebaseFirestore.collection(FirebaseConstants.posts);

    Map<String, dynamic> postInfo = Map();

    if (post.description != "" || post.description != null) {
      postInfo['description'] = post.description;
    }

    if (post.postImageUrl != "" || post.postImageUrl != null) {
      postInfo['postImageUrl'] = post.postImageUrl;
      postCollection.doc(post.postId).update(postInfo);
    }
  }

//image --->firebaseFirestore

  // @override
  // Future<String> uploadImageToStorage(
  //     File? file, String childName, bool isPost) async {
  //   Reference ref = firebaseStorage
  //       .ref()
  //       .child(childName)
  //       .child(firebaseAuth.currentUser!.uid);
  //   if (isPost) {
  //     String id = Uuid().v1();
  //     ref = ref.child(id);
  //   }

  //   final uploadTask = ref.putFile(file!);
  //   final imageUrl =
  //       (await uploadTask.whenComplete(() {})).ref.getDownloadURL();

  //   return await imageUrl;
  // }
}
