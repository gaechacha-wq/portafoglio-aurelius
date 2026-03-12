import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

/// Un esempio di data class immutabile per un'app finanziaria.
/// Usa @freezed per generare copyWith, toString, ==, hashCode.
@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String id,
    required String fullName,
    String? email,
    @Default(0.0) double totalBalance,
    @Default(false) bool isPremium,
    DateTime? createdAt,
  }) = _UserProfile;

  // Indispensabile per serializzare/deserializzare da Firebase
  factory UserProfile.fromJson(Map<String, dynamic> json) => _$UserProfileFromJson(json);
}
