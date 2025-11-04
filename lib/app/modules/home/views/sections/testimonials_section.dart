import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../controllers/home_controller.dart';
import '../../../../theme/app_colors.dart';

class TestimonialsSection extends GetView<HomeController> {
  const TestimonialsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 1200;
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        isWide ? 300 : 20,
        80,
        isWide ? 80 : 20,
        80,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionTitle(title: 'TESTIMONIALS'),
            const SizedBox(height: 32),
            
            Obx(() {
              final testimonials = controller.testimonials;
              
              if (testimonials.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: Text('No testimonials yet'),
                  ),
                );
              }
              
              return CarouselSlider.builder(
                itemCount: testimonials.length,
                options: CarouselOptions(
                  autoPlay: true,
                  enlargeCenterPage: true,
                  viewportFraction: isWide ? 0.7 : 0.9,
                  height: 380,
                  autoPlayInterval: const Duration(seconds: 5),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                ),
                itemBuilder: (context, index, realIndex) {
                  final testimonial = testimonials[index];
                  return _TestimonialCard(
                    name: testimonial.name,
                    location: testimonial.location,
                    imageUrl: testimonial.imageUrl,
                    testimonial: testimonial.testimonial,
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Container(
          width: 100,
          height: 3,
          decoration: BoxDecoration(
            color: AppColors.themeColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }
}

class _TestimonialCard extends StatelessWidget {
  final String name;
  final String location;
  final String imageUrl;
  final String testimonial;

  const _TestimonialCard({
    required this.name,
    required this.location,
    required this.imageUrl,
    required this.testimonial,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Profile Image
          CircleAvatar(
            radius: 60,
            backgroundColor: AppColors.themeColor,
            child: CircleAvatar(
              radius: 56,
              backgroundImage: CachedNetworkImageProvider(imageUrl),
            ),
          ),
          const SizedBox(height: 16),
          
          // Name
          Text(
            name,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          
          // Location
          Text(
            location,
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 14,
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Testimonial Text
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.bgDark,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SingleChildScrollView(
                child: Text(
                  '"$testimonial"',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
