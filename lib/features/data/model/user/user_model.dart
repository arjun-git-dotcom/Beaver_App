import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media/features/domain/entities/user/user_entity.dart';

class UserModel extends UserEntity {
  @override
  final String? username;
  @override
  final String? name;
  @override
  final String? uid;
  @override
  final String? bio;
  @override
  final String? website;
  @override
  final String? email;
  @override
  final String? profileUrl;
  @override
  final List? followers;
  @override
  final List? following;
  @override
  final num? totalFollowers;
  @override
  final num? totalFollowing;
  @override
  final num? totalPosts;
  const UserModel(
      {this.username,
      this.name,
      this.uid,
      this.bio,
      this.website,
      this.email,
      this.profileUrl,
      this.followers,
      this.following,
      this.totalFollowers,
      this.totalFollowing,
      this.totalPosts})
      : super(
            username: username,
            name: name,
            uid: uid,
            bio: bio,
            website: website,
            email: email,
            profileUrl: profileUrl,
            followers: followers,
            following: following,
            totalFollowers: totalFollowers,
            totalFollowing: totalFollowing,
            totalPosts: totalPosts);

  factory UserModel.fromSnapshot(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return UserModel(
        email: snapshot['email'],
        totalPosts: snapshot['totalPosts'],
        username: snapshot['username'],
        uid: snapshot['uid'],
        bio: snapshot['bio'],
        website: snapshot['website'],
        profileUrl: snapshot['profileUrl'],
        name: snapshot['name'],
        totalFollowers: snapshot['totalFollowers'],
        totalFollowing: snapshot['totalFollowing'],
        following: List<String>.from(
          snapshot['following']??[],
        ),
        followers: List<String>.from(snapshot['followers']??[]));
  }

  Map<String, dynamic> toJson() => {
    'uid':uid,
     'email':email,
      'username':username,
       'bio':bio,
 'website':website,
        'profileUrl':profileUrl,
 'name':name,
 "totalPosts":totalPosts,
 'totalFollowers':totalFollowers,
  'totalFollowing':totalFollowing,
   'following':following,
   'followers':followers
 };
}
