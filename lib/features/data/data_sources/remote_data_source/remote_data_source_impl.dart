import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:social_media/constants.dart';
import 'package:social_media/features/data/data_sources/remote_data_source/remote_data_source.dart';
import 'package:social_media/features/data/model/user/user_model.dart';
import 'package:social_media/features/domain/entities/user/user_entity.dart';

class FirebaseRemoteDataSourceImpl implements FirebaseRemoteDataSource {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;

  FirebaseRemoteDataSourceImpl(
      {required this.firebaseFirestore, required this.firebaseAuth});
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
      await firebaseAuth
          .createUserWithEmailAndPassword(
              email: user.email!, password: user.password!)
          .then((value) async {
        if (value.user?.uid != null) {
          await createUser(user);
        }
      });
      return;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        toast('email is already registered, login Instead');
      } else {
        toast('something went wrong ');
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
          FirebaseFirestore.instance.collection('users').doc(user.uid).get();

      if (userDoc != null) {
        await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
          'uid': user.uid,
       
          'name': user.displayName ?? '',
          'email': user.email ?? '',
          'profileUrl':  '',
          'location': null,
           "bio":null,
           "username":null,
           "followers":null,
           "following":null,
           "totalfollowers":null,
           "totalfollowing":null,
           "website":null



        });
      }
    }
    return user!.uid;
  }
}

