import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_media/constants.dart';
import 'package:social_media/features/data/data_sources/remote_data_source/remote_data_sources.dart/user_remote_data_source/user_remote_data_source.dart';
import 'package:social_media/features/data/model/user/user_model.dart';
import 'package:social_media/features/domain/entities/user/user_entity.dart';

class UserRemoteSourceImpl implements UserRemoteDataSource {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;
  UserRemoteSourceImpl(
      {required this.firebaseAuth, required this.firebaseFirestore});
  @override
  Future<void> followUser(UserEntity user) async {
    final userCollection =
        firebaseFirestore.collection(FirebaseConstants.users);

    try {
      await firebaseFirestore.runTransaction((transaction) async {
        final myDocRef = userCollection.doc(user.uid);
        final otherUserDocRef = userCollection.doc(user.otheruid);

        final myDocSnapshot = await transaction.get(myDocRef);
        final otherUserDocSnapshot = await transaction.get(otherUserDocRef);

        if (!myDocSnapshot.exists || !otherUserDocSnapshot.exists) {
          throw Exception("One or both users don't exist");
        }

        List myFollowingList = myDocSnapshot.get("following") ?? [];

        bool isAlreadyFollowing = myFollowingList.contains(user.otheruid);

        if (isAlreadyFollowing) {
          transaction.update(myDocRef, {
            "following": FieldValue.arrayRemove([user.otheruid]),
            "totalFollowing": (myDocSnapshot.get('totalFollowing') ?? 0) - 1
          });

          transaction.update(otherUserDocRef, {
            "followers": FieldValue.arrayRemove([user.uid]),
            "totalFollowers":
                (otherUserDocSnapshot.get('totalFollowers') ?? 0) - 1
          });
        } else {
          transaction.update(myDocRef, {
            "following": FieldValue.arrayUnion([user.otheruid]),
            "totalFollowing": (myDocSnapshot.get('totalFollowing') ?? 0) + 1
          });

          transaction.update(otherUserDocRef, {
            "followers": FieldValue.arrayUnion([user.uid]),
            "totalFollowers":
                (otherUserDocSnapshot.get('totalFollowers') ?? 0) + 1
          });
        }
      });

      print("Follow/unfollow transaction completed successfully");
    } catch (e) {
      print("Error in followUser transaction: $e");
      rethrow;
    }
  }

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

    return userCollection.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList();
    });
  }

  @override
  Future<void> updateUser(UserEntity user) async {
    final userCollection =
        firebaseFirestore.collection(FirebaseConstants.users);

    Map<String, dynamic> userInformation = {};
    if (user.username != '' && user.username != null) {
      userInformation['username'] = user.username;
    }
    if (user.profileUrl != '' && user.profileUrl != null) {
      userInformation['profileUrl'] = user.profileUrl;
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
    if (user.totalPosts != null) {
      userInformation['totalPosts'] = user.totalPosts;
    }
    userCollection.doc(user.uid).update(userInformation);
  }


}
