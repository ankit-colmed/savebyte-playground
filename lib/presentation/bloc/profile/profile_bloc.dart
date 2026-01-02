import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(const ProfileInitialState()) {
    on<ProfileInitEvent>(_onInitEvent);
    on<ProfileRefreshEvent>(_onRefreshEvent);
    on<ProfileUpdateEvent>(_onUpdateEvent);
    on<ProfileLogoutEvent>(_onLogoutEvent);
  }

  Future<void> _onInitEvent(
      ProfileInitEvent event,
      Emitter<ProfileState> emit,
      ) async {
    emit(const ProfileLoadingState());
    try {
      // Simulate API call to fetch profile
      await Future.delayed(const Duration(seconds: 1));

      final profile = UserProfile(
        id: event.userId,
        name: 'John Doe',
        email: 'john.doe@example.com',
        bio: 'Flutter developer | Clean Architecture enthusiast',
        profileImage: null,
        followers: 150,
        following: 89,
      );

      emit(ProfileLoadedState(profile: profile));
    } catch (e) {
      emit(ProfileErrorState(message: e.toString()));
    }
  }

  Future<void> _onRefreshEvent(
      ProfileRefreshEvent event,
      Emitter<ProfileState> emit,
      ) async {
    if (state is ProfileLoadedState) {
      final currentProfile = (state as ProfileLoadedState).profile;
      emit(ProfileLoadingState());

      try {
        // Simulate API call to refresh profile
        await Future.delayed(const Duration(seconds: 1));

        final updatedProfile = currentProfile.copyWith(
          followers: currentProfile.followers + 1,
        );

        emit(ProfileLoadedState(profile: updatedProfile));
      } catch (e) {
        emit(ProfileErrorState(message: e.toString()));
      }
    }
  }

  Future<void> _onUpdateEvent(
      ProfileUpdateEvent event,
      Emitter<ProfileState> emit,
      ) async {
    if (state is ProfileLoadedState) {
      final currentProfile = (state as ProfileLoadedState).profile;
      emit(ProfileUpdatingState(profile: currentProfile));

      try {
        // Simulate API call to update profile
        await Future.delayed(const Duration(seconds: 1));

        final updatedProfile = currentProfile.copyWith(
          name: event.name,
          email: event.email,
          profileImage: event.profileImage,
        );

        emit(ProfileUpdatedState(
          profile: updatedProfile,
          message: 'Profile updated successfully',
        ));

        // Emit loaded state after a short delay
        await Future.delayed(const Duration(milliseconds: 500));
        emit(ProfileLoadedState(profile: updatedProfile));
      } catch (e) {
        emit(ProfileErrorState(message: 'Update failed: ${e.toString()}'));
      }
    }
  }

  Future<void> _onLogoutEvent(
      ProfileLogoutEvent event,
      Emitter<ProfileState> emit,
      ) async {
    emit(const ProfileLoadingState());
    try {
      // Simulate logout API call
      await Future.delayed(const Duration(milliseconds: 500));
      emit(const ProfileLogoutState());
    } catch (e) {
      emit(ProfileErrorState(message: e.toString()));
    }
  }
}