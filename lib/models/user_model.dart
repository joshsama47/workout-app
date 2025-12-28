class UserModel {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoURL;
  final String? name;

  UserModel({
    required this.uid,
    this.email,
    this.displayName,
    this.photoURL,
    this.name,
  });

  UserModel copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoURL,
    String? name,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      name: name ?? this.name,
    );
  }
}
