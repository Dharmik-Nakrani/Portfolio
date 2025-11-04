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
  
  final int? yearsExperience;
  final int? totalProjects;
  final int? totalCertifications;

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
    this.yearsExperience,
    this.totalProjects,
    this.totalCertifications,
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
      yearsExperience: data['yearsExperience'],
      totalProjects: data['totalProjects'],
      totalCertifications: data['totalCertifications'],
    );
  }
}
