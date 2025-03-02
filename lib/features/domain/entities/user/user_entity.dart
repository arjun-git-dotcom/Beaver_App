import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:social_media/features/core/validator.dart';

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

Either<ValidationError, Tuple2<String, String>> validate(
    String email, String password) {
  final emailValidation = Validator.validateEmail(email);
  final passwordValidation = Validator.validatePassword(password);

  if (emailValidation.isLeft()) {
    return const Left(ValidationError.invalidEmail);
  }
  if (passwordValidation.isLeft()) {
    return const Left(ValidationError.weakPassword);
  }
  return right(Tuple2(email, password));
}



