// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserInformation {
  String? userId;
  String? userName;
  String? fullName;
  String? emailId;
  DateTime? joined;
  String? profilePicture;
  String? profilePictureID;
  String? biography;
  String? companyName;
  String? jobTitle;
  String? githubUsername;
  String? linkedin;
  String? twitter;
  String? instagram;
  String? facebook;
  String? websiteURL;

  UserInformation({
    required this.userId,
    required this.userName,
    required this.fullName,
    required this.emailId,
    required this.joined,
    this.profilePicture,
    this.profilePictureID,
    this.biography,
    this.companyName,
    this.jobTitle,
    this.githubUsername,
    this.linkedin,
    this.twitter,
    this.instagram,
    this.facebook,
    this.websiteURL,
  });

  UserInformation copyWith({
    String? userId,
    String? userName,
    String? fullName,
    String? emailId,
    DateTime? joined,
    String? profilePicture,
    String? profilePictureID,
    String? biography,
    String? companyName,
    String? jobTitle,
    String? githubUsername,
    String? linkedin,
    String? twitter,
    String? instagram,
    String? facebook,
    String? websiteURL,
  }) {
    return UserInformation(
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      fullName: fullName ?? this.fullName,
      emailId: emailId ?? this.emailId,
      joined: joined ?? this.joined,
      profilePicture: profilePicture ?? this.profilePicture,
      profilePictureID: profilePictureID ?? this.profilePictureID,
      biography: biography ?? this.biography,
      companyName: companyName ?? this.companyName,
      jobTitle: jobTitle ?? this.jobTitle,
      githubUsername: githubUsername ?? this.githubUsername,
      linkedin: linkedin ?? this.linkedin,
      twitter: twitter ?? this.twitter,
      instagram: instagram ?? this.instagram,
      facebook: facebook ?? this.facebook,
      websiteURL: websiteURL ?? this.websiteURL,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'userName': userName,
      'fullName': fullName,
      'emailId': emailId,
      'joined': joined?.millisecondsSinceEpoch,
      'profilePicture': profilePicture,
      'biography': biography,
      'companyName': companyName,
      'jobTitle': jobTitle,
      'githubUsername': githubUsername,
      'linkedin': linkedin,
      'twitter': twitter,
      'instagram': instagram,
      'facebook': facebook,
      'websiteURL': websiteURL,
    };
  }

  factory UserInformation.fromMap(Map<String, dynamic> map) {
    return UserInformation(
      userId: map['\$id'] != null ? map['\$id'] as String : null,
      userName: map['userName'] != null ? map['userName'] as String : null,
      fullName: map['fullName'] != null ? map['fullName'] as String : null,
      emailId: map['emailId'] != null ? map['emailId'] as String : null,
      joined: map['\$createdAt'] != null
          ? DateTime.parse(map['\$createdAt'])
          : null,
      profilePicture: map['profilePicture'] != null
          ? map['profilePicture'] as String
          : null,
      profilePictureID: map['profilePictureID'] != null
          ? map['profilePictureID'] as String
          : null,
      biography: map['biography'] != null ? map['biography'] as String : null,
      companyName:
          map['companyName'] != null ? map['companyName'] as String : null,
      jobTitle: map['jobTitle'] != null ? map['jobTitle'] as String : null,
      githubUsername: map['githubUsername'] != null
          ? map['githubUsername'] as String
          : null,
      linkedin: map['linkedin'] != null ? map['linkedin'] as String : null,
      twitter: map['twitter'] != null ? map['twitter'] as String : null,
      instagram: map['instagram'] != null ? map['instagram'] as String : null,
      facebook: map['facebook'] != null ? map['facebook'] as String : null,
      websiteURL:
          map['websiteURL'] != null ? map['websiteURL'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserInformation.fromJson(String source) =>
      UserInformation.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserInformation(userId: $userId, userName: $userName, fullName: $fullName, emailId: $emailId, joined: $joined, profilePicture: $profilePicture, biography: $biography, companyName: $companyName, jobTitle: $jobTitle, githubUsername: $githubUsername, linkedin: $linkedin, twitter: $twitter, instagram: $instagram, facebook: $facebook, websiteURL: $websiteURL)';
  }

  @override
  bool operator ==(covariant UserInformation other) {
    if (identical(this, other)) return true;

    return other.userId == userId &&
        other.userName == userName &&
        other.fullName == fullName &&
        other.emailId == emailId &&
        other.joined == joined &&
        other.profilePicture == profilePicture &&
        other.biography == biography &&
        other.companyName == companyName &&
        other.jobTitle == jobTitle &&
        other.githubUsername == githubUsername &&
        other.linkedin == linkedin &&
        other.twitter == twitter &&
        other.instagram == instagram &&
        other.facebook == facebook &&
        other.websiteURL == websiteURL;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        userName.hashCode ^
        fullName.hashCode ^
        emailId.hashCode ^
        joined.hashCode ^
        profilePicture.hashCode ^
        biography.hashCode ^
        companyName.hashCode ^
        jobTitle.hashCode ^
        githubUsername.hashCode ^
        linkedin.hashCode ^
        twitter.hashCode ^
        instagram.hashCode ^
        facebook.hashCode ^
        websiteURL.hashCode;
  }
}
