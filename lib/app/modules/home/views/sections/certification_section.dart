import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controllers/home_controller.dart';
import '../../../../theme/app_colors.dart';

class CertificationSection extends GetView<HomeController> {
  const CertificationSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWide = size.width >= 1200;
    final isMobile = size.width < 600;

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 800),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF0a0a0a),
            AppColors.bgDark,
            const Color(0xFF0a0a0a),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Animated Background Circles
          ..._buildBackgroundCircles(),

          // Content
          Padding(
            padding: EdgeInsets.fromLTRB(
              isWide ? 120 : 20,
              80,
              isWide ? 80 : 20,
              80,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionHeader(title: 'CERTIFICATIONS'),
                  const SizedBox(height: 20),
                  Text(
                    'Professional achievements and credentials',
                    style: TextStyle(
                      fontSize: isMobile ? 14 : 16,
                      color: AppColors.sectionDescription.withOpacity(0.7),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 60),

                  // Certifications Grid
                  Obx(() {
                    final certs = controller.certifications;

                    if (certs.isEmpty) {
                      return _buildEmptyState();
                    }

                    return LayoutBuilder(
                      builder: (context, constraints) {
                        final crossAxisCount = constraints.maxWidth > 900
                            ? 3
                            : constraints.maxWidth > 600
                            ? 2
                            : 1;

                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                mainAxisSpacing: 30,
                                crossAxisSpacing: 30,
                                childAspectRatio: 0.85,
                              ),
                          itemCount: certs.length,
                          itemBuilder: (context, index) {
                            return TweenAnimationBuilder<double>(
                              duration: Duration(
                                milliseconds: 400 + (index * 150),
                              ),
                              tween: Tween(begin: 0.0, end: 1.0),
                              curve: Curves.easeOut,
                              builder: (context, value, child) {
                                return Transform.scale(
                                  scale: 0.8 + (0.2 * value),
                                  child: Opacity(opacity: value, child: child),
                                );
                              },
                              child: _CertificationCard(
                                certification: certs[index],
                                index: index,
                              ),
                            );
                          },
                        );
                      },
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildBackgroundCircles() {
    return [
      Positioned(
        top: 100,
        right: -100,
        child: _AnimatedCircle(size: 300, delay: 0),
      ),
      Positioned(
        bottom: 150,
        left: -80,
        child: _AnimatedCircle(size: 250, delay: 2),
      ),
      Positioned(
        top: 300,
        left: 100,
        child: _AnimatedCircle(size: 180, delay: 4),
      ),
    ];
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(60),
        child: Column(
          children: [
            Icon(
              Icons.workspace_premium_rounded,
              size: 100,
              color: AppColors.themeColor.withOpacity(0.3),
            ),
            const SizedBox(height: 20),
            Text(
              'No certifications yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.sectionDescription.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Professional credentials will appear here',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.sectionDescription.withOpacity(0.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Animated Background Circle
class _AnimatedCircle extends StatefulWidget {
  final double size;
  final int delay;

  const _AnimatedCircle({required this.size, required this.delay});

  @override
  State<_AnimatedCircle> createState() => _AnimatedCircleState();
}

class _AnimatedCircleState extends State<_AnimatedCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 10 + widget.delay),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                AppColors.themeColor.withOpacity(0.05 * _controller.value),
                Colors.transparent,
              ],
            ),
          ),
        );
      },
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
                    AppColors.themeColor.withOpacity(0.3),
                  ],
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w900,
                color: AppColors.sectionDescription,
                letterSpacing: 2,
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
                    AppColors.themeColor.withOpacity(0.3),
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

// Certification Card with 3D effect
class _CertificationCard extends StatefulWidget {
  final certification;
  final int index;

  const _CertificationCard({required this.certification, required this.index});

  @override
  State<_CertificationCard> createState() => _CertificationCardState();
}

class _CertificationCardState extends State<_CertificationCard>
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
      child: GestureDetector(
        onTap: () {
          if (widget.certification.credlyUrl != null) {
            launchUrl(Uri.parse(widget.certification.credlyUrl!));
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateX(_isHovered ? -0.05 : 0)
            ..rotateY(_isHovered ? 0.05 : 0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: _isHovered
                  ? [
                      BoxShadow(
                        color: AppColors.themeColor.withOpacity(0.4),
                        blurRadius: 30,
                        spreadRadius: 10,
                        offset: const Offset(0, 10),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                children: [
                  // Glass Background
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.1),
                          Colors.white.withOpacity(0.05),
                        ],
                      ),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(24),
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
                                Colors.white.withOpacity(0.1),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                  // Content
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        // Badge Image/Icon
                        Expanded(child: Center(child: _buildBadge())),

                        const SizedBox(height: 20),

                        // Certification Name
                        Text(
                          widget.certification.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.sectionDescription,
                            height: 1.4,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 16),

                        // Verification Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.themeColor,
                                AppColors.themeColor.withOpacity(0.7),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.themeColor.withOpacity(0.3),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.verified_rounded,
                                color: Colors.white,
                                size: 16,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'VERIFIED',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ),

                        if (widget.certification.credlyUrl != null) ...[
                          const SizedBox(height: 12),
                          Text(
                            'Tap to view credential',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.themeColor.withOpacity(0.8),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Hover Overlay
                  if (_isHovered)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.themeColor.withOpacity(0.1),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),

                  // Corner Decoration
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            AppColors.themeColor.withOpacity(0.3),
                            AppColors.themeColor.withOpacity(0.1),
                          ],
                        ),
                      ),
                      child: const Icon(
                        Icons.workspace_premium_rounded,
                        color: AppColors.themeColor,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBadge() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: _isHovered ? 180 : 160,
      height: _isHovered ? 180 : 160,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            AppColors.themeColor.withOpacity(0.3),
            AppColors.themeColor.withOpacity(0.1),
            Colors.transparent,
          ],
        ),
        boxShadow: _isHovered
            ? [
                BoxShadow(
                  color: AppColors.themeColor.withOpacity(0.5),
                  blurRadius: 30,
                  spreadRadius: 10,
                ),
              ]
            : [],
      ),
      child: widget.certification.imageUrl.isNotEmpty
          ? ClipOval(
              child: Image.network(
                widget.certification.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildBadgeFallback();
                },
              ),
            )
          : _buildBadgeFallback(),
    );
  }

  Widget _buildBadgeFallback() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.themeColor, AppColors.themeColor.withOpacity(0.6)],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.themeColor.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              Icons.workspace_premium_rounded,
              size: 80,
              color: Colors.white.withOpacity(0.9),
            ),
            Positioned(
              bottom: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  widget.certification.name.split(' ').first,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.themeColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
