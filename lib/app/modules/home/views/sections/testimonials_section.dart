import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:portfolio/app/data/models/testimonial_model.dart';
import '../../controllers/home_controller.dart';
import '../../../../theme/app_colors.dart';

class TestimonialsSection extends GetView<HomeController> {
  const TestimonialsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWide = size.width >= 1200;
    final isMobile = size.width < 600;

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 800),
      padding: EdgeInsets.fromLTRB(isWide ? 120 : 20, 80, isWide ? 80 : 20, 80),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.bgDark, const Color(0xFF0a0a0a), AppColors.bgDark],
        ),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionHeader(title: 'CLIENT TESTIMONIALS'),

            const SizedBox(height: 60),

            // Testimonials Carousel
            Obx(() {
              final testimonials = controller.testimonials;

              if (testimonials.isEmpty) {
                return _buildEmptyState();
              }

              return _TestimonialsCarousel(
                testimonials: testimonials,
                isMobile: isMobile,
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(60),
        child: Column(
          children: [
            Icon(
              Icons.rate_review_rounded,
              size: 100,
              color: AppColors.themeColor.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 20),
            Text(
              'No testimonials yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.sectionDescription.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Client feedback will appear here',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.sectionDescription.withValues(alpha: 0.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Section Header
class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.themeColor,
                    AppColors.themeColor.withValues(alpha: 0.3),
                  ],
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: AppColors.sectionDescription,
                  letterSpacing: 2,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 1000),
          tween: Tween(begin: 0.0, end: 1.0),
          curve: Curves.easeOut,
          builder: (context, value, child) {
            return Container(
              height: 3,
              width: 200 * value,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.themeColor,
                    AppColors.themeColor.withValues(alpha: 0.3),
                  ],
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            );
          },
        ),
      ],
    );
  }
}

// Testimonials Carousel
class _TestimonialsCarousel extends StatefulWidget {
  final List testimonials;
  final bool isMobile;

  const _TestimonialsCarousel({
    required this.testimonials,
    required this.isMobile,
  });

  @override
  State<_TestimonialsCarousel> createState() => _TestimonialsCarouselState();
}

class _TestimonialsCarouselState extends State<_TestimonialsCarousel> {
  int _currentIndex = 0;
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          carouselController: _carouselController,
          itemCount: widget.testimonials.length,
          options: CarouselOptions(
            height: widget.isMobile ? 550 : 500,
            viewportFraction: widget.isMobile ? 0.9 : 0.7,
            enlargeCenterPage: true,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.easeInOut,
            onPageChanged: (index, reason) {
              setState(() => _currentIndex = index);
            },
          ),
          itemBuilder: (context, index, realIndex) {
            return Center(
              child: _TestimonialCard(
                testimonial: widget.testimonials[index],
                isActive: index == _currentIndex,
                isMobile: widget.isMobile,
              ),
            );
          },
        ),

        const SizedBox(height: 30),

        // Carousel Indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.testimonials.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _carouselController.animateToPage(entry.key),
              child: Container(
                width: _currentIndex == entry.key ? 40 : 12,
                height: 5,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  gradient: _currentIndex == entry.key
                      ? LinearGradient(
                          colors: [
                            AppColors.themeColor,
                            AppColors.themeColor.withValues(alpha: 0.6),
                          ],
                        )
                      : null,
                  color: _currentIndex == entry.key
                      ? null
                      : Colors.white.withValues(alpha: 0.3),
                  boxShadow: _currentIndex == entry.key
                      ? [
                          BoxShadow(
                            color: AppColors.themeColor.withValues(alpha: 0.5),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ]
                      : [],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// Testimonial Card - FIXED VERSION
class _TestimonialCard extends StatefulWidget {
  final TestimonialModel testimonial;
  final bool isActive;
  final bool isMobile;

  const _TestimonialCard({
    required this.testimonial,
    required this.isActive,
    required this.isMobile,
  });

  @override
  State<_TestimonialCard> createState() => _TestimonialCardState();
}

class _TestimonialCardState extends State<_TestimonialCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        transform: Matrix4.identity()
          ..scaleByDouble(widget.isActive ? 1.0 : 0.80, 1.0, 1.0, 0.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? AppColors.themeColor.withValues(alpha: 0.3)
                    : Colors.black.withValues(alpha: 0.3),
                blurRadius: _isHovered ? 30 : 20,
                spreadRadius: _isHovered ? 5 : 0,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Stack(
              alignment: AlignmentDirectional.center,
              fit: StackFit.passthrough,
              children: [
                // Glass Background
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withValues(alpha: 0.1),
                        Colors.white.withValues(alpha: 0.05),
                      ],
                    ),
                  ),
                ),

                // Shimmer Effect
                if (_isHovered)
                  AnimatedBuilder(
                    animation: _shimmerController,
                    builder: (context, child) {
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment(
                              -1 + 3 * _shimmerController.value,
                              -1,
                            ),
                            end: Alignment(3 * _shimmerController.value, 1),
                            colors: [
                              Colors.transparent,
                              Colors.white.withValues(alpha: 0.1),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                // Content - FIXED
                Container(
                  padding: EdgeInsets.all(widget.isMobile ? 24 : 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // IMPORTANT FIX
                    children: [
                      // Quote Icon
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.themeColor,
                              AppColors.themeColor.withValues(alpha: 0.7),
                            ],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.themeColor.withValues(
                                alpha: 0.4,
                              ),
                              blurRadius: 15,
                              spreadRadius: 3,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.format_quote_rounded,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Testimonial Text - FIXED with constraints
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: widget.isMobile ? 180 : 150,
                        ),
                        child: SingleChildScrollView(
                          child: Text(
                            '"${widget.testimonial.testimonial}"',
                            style: TextStyle(
                              fontSize: widget.isMobile ? 14 : 14,
                              height: 1.8,
                              color: AppColors.sectionDescription.withValues(
                                alpha: 0.9,
                              ),
                              fontStyle: FontStyle.italic,
                              letterSpacing: 0.3,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Star Rating
                      // _buildStarRating(5),

                      // const SizedBox(height: 16),

                      // Divider
                      Container(
                        height: 1,
                        width: 100,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              AppColors.themeColor.withValues(alpha: 0.5),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Profile Image
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.themeColor,
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.themeColor.withValues(
                                alpha: 0.3,
                              ),
                              blurRadius: 15,
                              spreadRadius: 3,
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: widget.testimonial.imageUrl.isNotEmpty
                              ? Image.network(
                                  widget.testimonial.imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return _buildAvatarFallback();
                                  },
                                )
                              : _buildAvatarFallback(),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Name
                      Text(
                        widget.testimonial.name,
                        style: TextStyle(
                          fontSize: widget.isMobile ? 8 : 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.sectionDescription,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 4),

                      // Location with icon
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            size: 14,
                            color: AppColors.themeColor,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              widget.testimonial.location,
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.themeColor,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Corner Badge
                // Positioned(
                //   top: 20,
                //   right: 20,
                //   child: Container(
                //     padding: const EdgeInsets.symmetric(
                //       horizontal: 12,
                //       vertical: 6,
                //     ),
                //     decoration: BoxDecoration(
                //       gradient: LinearGradient(
                //         colors: [
                //           AppColors.themeColor.withValues(alpha: 0.9),
                //           AppColors.themeColor.withValues(alpha: 0.7),
                //         ],
                //       ),
                //       borderRadius: BorderRadius.circular(20),
                //       boxShadow: [
                //         BoxShadow(
                //           color: AppColors.themeColor.withValues(alpha: 0.3),
                //           blurRadius: 10,
                //           spreadRadius: 2,
                //         ),
                //       ],
                //     ),
                //     child: Row(
                //       mainAxisSize: MainAxisSize.min,
                //       children: const [
                //         Icon(
                //           Icons.verified_rounded,
                //           color: Colors.white,
                //           size: 14,
                //         ),
                //         SizedBox(width: 4),
                //         Text(
                //           'VERIFIED',
                //           style: TextStyle(
                //             fontSize: 10,
                //             fontWeight: FontWeight.bold,
                //             color: Colors.white,
                //             letterSpacing: 0.5,
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarFallback() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.themeColor,
            AppColors.themeColor.withValues(alpha: 0.7),
          ],
        ),
      ),
      child: Center(
        child: Text(
          widget.testimonial.name[0].toUpperCase(),
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
