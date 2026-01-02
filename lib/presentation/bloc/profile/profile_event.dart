import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class ProfileInitEvent extends ProfileEvent {
  final String userId;

  const ProfileInitEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class ProfileRefreshEvent extends ProfileEvent {
  final String userId;

  const ProfileRefreshEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class ProfileUpdateEvent extends ProfileEvent {
  final String userId;
  final String name;
  final String email;
  final String? profileImage;

  const ProfileUpdateEvent({
    required this.userId,
    required this.name,
    required this.email,
    this.profileImage,
  });

  @override
  List<Object?> get props => [userId, name, email, profileImage];
}

class ProfileLogoutEvent extends ProfileEvent {
  const ProfileLogoutEvent();
}