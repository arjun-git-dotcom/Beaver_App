import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:social_media/constants.dart';
import 'package:social_media/features/data/data_sources/remote_data_source/cloudinary/cloudinary_data_source.dart';
import 'package:social_media/features/data/data_sources/remote_data_source/remote_data_source.dart';
import 'package:social_media/features/data/model/comment/comment_model.dart';
import 'package:social_media/features/data/model/post/post_model.dart';
import 'package:social_media/features/data/model/reply/reply_model.dart';
import 'package:social_media/features/data/model/savedpost/savedpost_model.dart';
import 'package:social_media/features/data/model/user/user_model.dart';
import 'package:social_media/features/domain/entities/comments/comments.dart';
import 'package:social_media/features/domain/entities/posts/post_entity.dart';
import 'package:social_media/features/domain/entities/replys/replay_entity.dart';
import 'package:social_media/features/domain/entities/savedposts/savedposts_entity.dart';
import 'package:social_media/features/domain/entities/user/user_entity.dart';

class FirebaseRemoteDataSourceImpl implements FirebaseRemoteDataSource {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;
  final CloudinaryRepository cloudinaryRepository;

  FirebaseRemoteDataSourceImpl(
      {required this.firebaseFirestore,
      required this.firebaseAuth,
      required this.cloudinaryRepository});

  Future<void> saveTokenFirebase(String userID) async {
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      await firebaseFirestore
          .collection("users")
          .doc(userID)
          .set({"fcmToken": token}, SetOptions(merge: true));
    }
    print(token);
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
  Future<void> followUser(UserEntity user) async {
    print('working');
    final userCollection =
        firebaseFirestore.collection(FirebaseConstants.users);

    final myDocRef = await userCollection.doc(user.uid).get();
    final otherUserDocRef = await userCollection.doc(user.otheruid).get();

    if (myDocRef.exists && otherUserDocRef.exists) {
      List myFollowingList = myDocRef.get("following");
      List otherUserFollowersList = otherUserDocRef.get("followers");

      // My Following List
      if (myFollowingList.contains(user.otheruid)) {
        userCollection.doc(user.uid).update({
          "following": FieldValue.arrayRemove([user.otheruid])
        }).then((value) {
          final userCollection = firebaseFirestore
              .collection(FirebaseConstants.users)
              .doc(user.uid);

          userCollection.get().then((value) {
            if (value.exists) {
              final totalFollowing = value.get('totalFollowing');
              userCollection.update({"totalFollowing": totalFollowing - 1});
              return;
            }
          });
        });
      } else {
        userCollection.doc(user.uid).update({
          "following": FieldValue.arrayUnion([user.otheruid])
        }).then((value) {
          final userCollection = firebaseFirestore
              .collection(FirebaseConstants.users)
              .doc(user.uid);

          userCollection.get().then((value) {
            if (value.exists) {
              final totalFollowing = value.get('totalFollowing');
              userCollection.update({"totalFollowing": totalFollowing + 1});
              return;
            }
          });
        });
      }

      // Other User Following List
      if (otherUserFollowersList.contains(user.uid)) {
        userCollection.doc(user.otheruid).update({
          "followers": FieldValue.arrayRemove([user.uid])
        }).then((value) {
          final userCollection = firebaseFirestore
              .collection(FirebaseConstants.users)
              .doc(user.otheruid);

          userCollection.get().then((value) {
            if (value.exists) {
              final totalFollowers = value.get('totalFollowers');
              userCollection.update({"totalFollowers": totalFollowers - 1});
              return;
            }
          });
        });
      } else {
        userCollection.doc(user.otheruid).update({
          "followers": FieldValue.arrayUnion([user.uid])
        }).then((value) {
          final userCollection = firebaseFirestore
              .collection(FirebaseConstants.users)
              .doc(user.otheruid);

          userCollection.get().then((value) {
            if (value.exists) {
              final totalFollowers = value.get('totalFollowers');
              userCollection.update({"totalFollowers": totalFollowers + 1});
              return;
            }
          });
        });
      }
    }
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
         
       final userCredential= await firebaseAuth.signInWithEmailAndPassword(
            email: user.email!, password: user.password!);

       saveTokenFirebase(userCredential.user!.uid);
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

      saveTokenFirebase(userCredential.user!.uid);

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
    final postRef = postCollection.doc(post.postId);
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
  Stream<List<PostEntity>> getSinglePost(String postId) {
    final postCollection = firebaseFirestore
        .collection(FirebaseConstants.posts)
        .orderBy("createAt", descending: true)
        .where("postId", isEqualTo: postId);
    return postCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => PostModel.fromSnapShot(e)).toList());
  }

  @override
  Future<void> updatePost(PostEntity post) async {
    final postCollection =
        firebaseFirestore.collection(FirebaseConstants.posts);

    Map<String, dynamic> postInfo = {};

    if (post.description != "" || post.description != null) {
      postInfo['description'] = post.description;
    }

    if (post.postImageUrl != "" || post.postImageUrl != null) {
      postInfo['postImageUrl'] = post.postImageUrl;
      postCollection.doc(post.postId).update(postInfo);
    }
  }

  @override
  Future<void> savePost(String postId, String userId) async {
    var savedPosts = firebaseFirestore.collection('saved posts');
    var existing = await savedPosts
        .where("userId", isEqualTo: userId)
        .where("postId", isEqualTo: postId)
        .get();

    if (existing.docs.isEmpty) {
      savedPosts.add({
        "userId": userId,
        "postId": postId,
        "savedAt": FieldValue.serverTimestamp()
      });
    } else {
      print('post already present');
    }
  }

  @override
  Stream<List<SavedpostsEntity>> readSavedPost(String userId) {
    final savedPostsuser = firebaseFirestore
        .collection("saved posts")
        .where("userId", isEqualTo: userId);

    var savedposts = savedPostsuser.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => SavedpostModel.fromSnapshot(e)).toList());
    print(savedposts);

    return savedposts;
  }

  @override
  Future<void> createComment(CommentEntity comment) async {
    var collection = firebaseFirestore
        .collection(FirebaseConstants.posts)
        .doc(comment.postId)
        .collection(FirebaseConstants.comment)
        .doc(comment.commentId);
    final newcomment = CommentModel(
            commentId: comment.commentId!,
            userId: comment.userId!,
            username: comment.username!,
            description: comment.description!,
            likes: const [],
            totalReplys: 0,
            createdAt: comment.createdAt!,
            postId: comment.postId!,
            profileUrl: comment.profileUrl!)
        .toJson();

    try {
      final commentDocRef = await collection.get();
      if (!commentDocRef.exists) {
        collection.set(newcomment).then((value) {
          final postcollection = firebaseFirestore
              .collection(FirebaseConstants.posts)
              .doc(comment.postId);

          postcollection.get().then((value) {
            if (value.exists) {
              final totalComments = value.get('totalComments');
              postcollection.update({"totalComments": totalComments + 1});
              return;
            }
          });
        });
      } else {
        collection.update(newcomment);
      }
    } catch (e) {
      print('some error occured $e');
    }
  }

  @override
  Future<void> deleteComment(CommentEntity comment) async {
    final commentCollection = firebaseFirestore
        .collection(FirebaseConstants.posts)
        .doc(comment.postId)
        .collection(FirebaseConstants.comment);
    try {
      commentCollection.doc(comment.commentId).delete();

      var postcollection = firebaseFirestore
          .collection(FirebaseConstants.posts)
          .doc(comment.postId);
      final value = await postcollection.get();

      if (value.exists) {
        postcollection.update({'totalcomments': FieldValue.increment(-1)});
      }
    } catch (e) {
      print('some errors occured $e');
    }
  }

  @override
  Future<void> likeComment(CommentEntity comment) async {
    String uid = await getCurrentUid();

    final commentDoc = firebaseFirestore
        .collection('posts')
        .doc(comment.postId)
        .collection('comments')
        .doc(comment.commentId);

    try {
      final commentDocget = await commentDoc.get();

      if (commentDocget.exists) {
        List value = commentDocget.get('likes');
        if (!value.contains(uid)) {
          await commentDoc.update({
            'totalLikes': FieldValue.increment(1),
            "likes": FieldValue.arrayUnion([uid])
          });
        } else {
          await commentDoc.update({
            'totalLikes': FieldValue.increment(-1),
            "likes": FieldValue.arrayRemove([uid])
          });
        }
      }
    } catch (e) {
      print('some errors occured $e');
    }
  }

  @override
  Stream<List<CommentEntity>> readComment(String postId) {
    print(postId);
    final commentCollection = firebaseFirestore
        .collection('posts')
        .doc(postId)
        .collection('comments');

    return commentCollection.snapshots().map((querySnapshot) {
      return querySnapshot.docs
          .map((e) => CommentModel.fromSnapshot(e))
          .toList();
    });
  }

  @override
  Future<void> updateComment(CommentEntity comment) async {
    final commentCollection = firebaseFirestore
        .collection('posts')
        .doc(comment.postId)
        .collection('comments')
        .doc(comment.commentId);

    Map<String, dynamic> commentInfo = {};

    if (comment.description != "" || comment.description != null) {
      commentInfo['description'] = comment.description;
      commentCollection.update(commentInfo);
    }
  }

  @override
  Future<void> createReply(ReplyEntity reply) async {
    final collection = firebaseFirestore
        .collection(FirebaseConstants.posts)
        .doc(reply.postId)
        .collection(FirebaseConstants.comment)
        .doc(reply.commentId)
        .collection(FirebaseConstants.reply)
        .doc(reply.replyId);

    final newreply = ReplyModel(
            replyId: reply.replyId!,
            commentId: reply.commentId,
            userId: reply.userId!,
            username: reply.username!,
            description: reply.description!,
            likes: const [],
            createdAt: reply.createdAt!,
            postId: reply.postId!,
            profileUrl: reply.profileUrl!)
        .toJson();
    try {
      final replyDocRef = await collection.get();
      if (!replyDocRef.exists) {
        collection.set(newreply);
      } else {
        collection.update(newreply);
      }
    } catch (e) {
      print('some errors occured $e');
    }
  }

  @override
  Future<void> deleteReply(ReplyEntity reply) async {
    final collection = firebaseFirestore
        .collection(FirebaseConstants.posts)
        .doc(reply.postId)
        .collection(FirebaseConstants.comment)
        .doc(reply.commentId)
        .collection(FirebaseConstants.reply)
        .doc(reply.replyId);

    try {
      final replyDocRef = await collection.get();
      if (!replyDocRef.exists) {
        collection.delete();
      }
    } catch (e) {
      print("some errors occured $e");
    }
  }

  @override
  Future<void> likeReply(ReplyEntity reply) async {
    String uid = await getCurrentUid();
    final collection = firebaseFirestore
        .collection(FirebaseConstants.posts)
        .doc(reply.postId)
        .collection(FirebaseConstants.comment)
        .doc(reply.commentId)
        .collection(FirebaseConstants.reply)
        .doc(reply.replyId);

    try {
      final replyDocRef = await collection.get();
      if (replyDocRef.exists) {
        final likes = replyDocRef.get('likes');
        if (!likes.contains(uid)) {
          collection.update({
            "likes": FieldValue.arrayUnion([uid])
          });
        } else {
          collection.update({
            "likes": FieldValue.arrayRemove([uid])
          });
        }
      }
    } catch (e) {
      print('some error occured $e');
    }
  }

  @override
  Stream<List<ReplyEntity>> readReply(ReplyEntity reply) {
    final collection = firebaseFirestore
        .collection(FirebaseConstants.posts)
        .doc(reply.replyId)
        .collection(FirebaseConstants.comment)
        .doc(reply.commentId)
        .collection(FirebaseConstants.reply);

    return collection.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((e) => ReplyModel.fromSnapshot(e)).toList();
    });
  }

  @override
  Future<void> updateReply(ReplyEntity reply) async {
    final collection = firebaseFirestore
        .collection(FirebaseConstants.posts)
        .doc(reply.postId)
        .collection(FirebaseConstants.comment)
        .doc(reply.commentId)
        .collection(FirebaseConstants.reply)
        .doc(reply.replyId);

    Map<String, dynamic> replyInfo = {};

    if (reply.description != "" || reply.description != null) {
      replyInfo['description'] = reply.description;
      collection.update(replyInfo);
    }
  }
  

}
