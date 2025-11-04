class TestimonialModel {
  final String id;
  final String name;
  final String location;
  final String imageUrl;
  final String testimonial;
  final int order;

  TestimonialModel({
    required this.id,
    required this.name,
    required this.location,
    required this.imageUrl,
    required this.testimonial,
    required this.order,
  });

  factory TestimonialModel.fromFirestore(String id, Map<String, dynamic> data) {
    return TestimonialModel(
      id: id,
      name: data['name'] ?? '',
      location: data['location'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      testimonial: data['testimonial'] ?? '',
      order: data['order'] ?? 0,
    );
  }
}
