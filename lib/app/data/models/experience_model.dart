
class ExperienceModel {
  final String id;
  final String title;
  final String organization;
  final String location;
  final String startDate;
  final String? endDate;
  final bool isEducation;
  final List<String> highlights;
  final String? tag;
  final int order;

  ExperienceModel({
    required this.id,
    required this.title,
    required this.organization,
    required this.location,
    required this.startDate,
    this.endDate,
    required this.isEducation,
    required this.highlights,
    this.tag,
    required this.order,
  });

  factory ExperienceModel.fromFirestore(String id, Map<String, dynamic> data) {
    return ExperienceModel(
      id: id,
      title: data['title'] ?? '',
      organization: data['organization'] ?? '',
      location: data['location'] ?? '',
      startDate: data['startDate'] ?? '' ,
      endDate: data['endDate'] ?? '',
      isEducation: data['isEducation'] ?? false,
      highlights: List<String>.from(data['highlights'] ?? []),
      tag: data['tag'],
      order: data['order'] ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'organization': organization,
      'location': location,
      'startDate': startDate,
      'endDate': endDate,
      'isEducation': isEducation,
      'highlights': highlights,
      'tag': tag,
      'order': order,
    };
  }

  String get dateRange {
    final start = startDate;
    final end = endDate ?? 'Present';
    return '$start - $end';
  }
}
