import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:social_media/constants.dart';
import 'package:social_media/features/data/data_sources/remote_data_source/cloudinary/cloudinary_data_source.dart';
import 'package:social_media/features/data/data_sources/remote_data_source/remote_data_sources.dart/credential_remote_data_source/credential_remote_data_source.dart';
import 'package:social_media/features/data/model/user/user_model.dart';
import 'package:social_media/features/domain/entities/user/user_entity.dart';

class CredentialRemoteDataSourceImpl implements CredentialRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final CloudinaryRepository cloudinaryRepository;
  final FirebaseFirestore firebaseFirestore;
  CredentialRemoteDataSourceImpl(
      {required this.firebaseAuth,
      required this.cloudinaryRepository,
      required this.firebaseFirestore});

  @override
  Future<bool> islogin() async => firebaseAuth.currentUser?.uid != null;

  @override
  Future<void> logOut() async {
    await GoogleSignIn().signOut();
    return firebaseAuth.signOut();
  }

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
      } else if (e.code == 'wrong-password') {
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
              following: user.following,
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
  Future<String> googleSignIn() async {
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    final User? user = userCredential.user;

    final firebaseUser = UserEntity(
        uid: user!.uid,
        name: user.displayName ?? "",
        email: user.email ?? "",
        profileUrl: user.photoURL,
        location: null,
        bio: null,
        username: user.displayName,
        followers: const [],
        following: const [],
        totalFollowers: 0,
        totalFollowing: 0,
        website: null);
    createUserWithImage(firebaseUser, user.photoURL ?? "");

    return user.uid;
  }

  @override
  Future<void> createUser(UserEntity user) async {
    final uid = user.uid ?? await getCurrentUid();
    final userCollection =
        firebaseFirestore.collection(FirebaseConstants.users).doc(uid);

    var userDoc = await userCollection.get();
    final newUser = UserModel(
            name: user.name,
            email: user.email,
            uid: uid,
            username: user.username,
            bio: user.bio,
            website: user.website,
            followers: user.followers,
            following: user.following,
            totalFollowers: user.totalFollowers,
            totalFollowing: user.totalFollowing,
            profileUrl: user.profileUrl,
            totalPosts: user.totalPosts)
        .toJson();

    try {
      if (!userDoc.exists) {
        await userCollection.set(newUser);
      } else {
        await userCollection.update(newUser);
      }
    } catch (error) {
      toast('some error occured');
      rethrow;
    }
  }

  @override
  Future<String> getCurrentUid() async => firebaseAuth.currentUser!.uid;
}
