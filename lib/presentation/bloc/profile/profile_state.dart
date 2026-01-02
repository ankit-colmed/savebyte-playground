import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? profileImage;
  final String? bio;
  final int followers;
  final int following;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.profileImage,
    this.bio,
    this.followers = 0,
    this.following = 0,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    profileImage,
    bio,
    followers,
    following,
  ];

  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? profileImage,
    String? bio,
    int? followers,
    int? following,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      bio: bio ?? this.bio,
      followers: followers ?? this.followers,
      following: following ?? this.following,
    );
  }
}

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitialState extends ProfileState {
  const ProfileInitialState();
}

class ProfileLoadingState extends ProfileState {
  const ProfileLoadingState();
}

class ProfileLoadedState extends ProfileState {
  final UserProfile profile;

  const ProfileLoadedState({required this.profile});

  @override
  List<Object?> get props => [profile];
}

class ProfileUpdatingState extends ProfileState {
  final UserProfile profile;

  const ProfileUpdatingState({required this.profile});

  @override
  List<Object?> get props => [profile];
}

class ProfileUpdatedState extends ProfileState {
  final UserProfile profile;
  final String message;

  const ProfileUpdatedState({
    required this.profile,
    required this.message,
  });

  @override
  List<Object?> get props => [profile, message];
}

class ProfileErrorState extends ProfileState {
  final String message;

  const ProfileErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}

class ProfileLogoutState extends ProfileState {
  const ProfileLogoutState();
}