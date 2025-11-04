class ProfileModel {
  final String name;
  final String email;
  final String phone;
  final String location;
  final String profileImage;
  final String heroImage;
  final List<String> typedItems;
  final String aboutMe;
  final Map<String, String> socialLinks;

  ProfileModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.location,
    required this.profileImage,
    required this.heroImage,
    required this.typedItems,
    required this.aboutMe,
    required this.socialLinks,
  });

  factory ProfileModel.fromFirestore(Map<String, dynamic> data) {
    return ProfileModel(
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      location: data['location'] ?? '',
      profileImage: data['profileImage'] ?? '',
      heroImage: data['heroImage'] ?? '',
      typedItems: List<String>.from(data['typedItems'] ?? []),
      aboutMe: data['aboutMe'] ?? '',
      socialLinks: Map<String, String>.from(data['socialLinks'] ?? {}),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'location': location,
      'profileImage': profileImage,
      'heroImage': heroImage,
      'typedItems': typedItems,
      'aboutMe': aboutMe,
      'socialLinks': socialLinks,
    };
  }
}
