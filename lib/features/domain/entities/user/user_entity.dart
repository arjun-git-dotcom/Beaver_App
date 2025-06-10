import 'dart:io';
import 'package:equatable/equatable.dart';


class UserEntity extends Equatable {
  final String? username;
  final String? name;
  final String? uid;
  final String? bio;
  final String? website;
  final String? email;
  final String? profileUrl;
  final List? followers;
  final List? following;
  final num? totalFollowers;
  final num? totalFollowing;
  final num? totalPosts;
  final String? location;

  //not send to DB
 final File? imageFile;
  final String? password;
  final String? otheruid;

  const UserEntity(
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
      this.password,
      this.otheruid,
      this.totalPosts,
      this.location,
      this.imageFile
      });

  @override
  List<Object?> get props => [
        username,
        name,
        uid,
        bio,
        website,
        email,
        profileUrl,
        followers,
        following,
        totalFollowers,
        totalFollowing,
        location,
        password,
        otheruid,
        imageFile,
        totalPosts
      ];
}





