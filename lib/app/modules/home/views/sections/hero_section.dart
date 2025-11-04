import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import '../../../../widgets/typed_text.dart';
import '../../controllers/home_controller.dart';
import '../../../../theme/app_colors.dart';

class HeroSection extends GetView<HomeController> {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWide = size.width >= 1200;
    final isMobile = size.width < 600;

    return Obx(() {
      final profile = controller.profile.value;

      return Container(
        height: size.height,
        width: double.infinity,
        child: Stack(
          children: [
            // Animated Background with Particles
            const _AnimatedBackground(),

            // Background Image with Parallax Effect
            if (profile?.heroImage != null && profile!.heroImage.isNotEmpty)
              Positioned.fill(
                child: Image.network(
                  profile.heroImage,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const SizedBox.shrink(),
                ),
              ),

            // Gradient Overlays
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.black.withOpacity(0.5),
                      Colors.black.withOpacity(0.8),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),

            // Radial gradient from center
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 1.0,
                    colors: [
                      AppColors.themeColor.withOpacity(0.1),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // Main Content
            Positioned.fill(
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile
                        ? 24
                        : isWide
                        ? 80
                        : 40,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Animated entrance for name
                      TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 1000),
                        tween: Tween(begin: 0.0, end: 1.0),
                        curve: Curves.easeOut,
                        builder: (context, value, child) {
                          return Transform.translate(
                            offset: Offset(0, 50 * (1 - value)),
                            child: Opacity(opacity: value, child: child),
                          );
                        },
                        child: Column(
                          children: [
                            // Greeting Text
                            Text(
                              'HELLO, I\'M',
                              style: TextStyle(
                                color: AppColors.themeColor,
                                fontSize: isMobile ? 14 : 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 3,
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Name with Gradient
                            ShaderMask(
                              shaderCallback: (bounds) => LinearGradient(
                                colors: [
                                  AppColors.sectionDescription,
                                  AppColors.themeColor,
                                ],
                              ).createShader(bounds),
                              child: Text(
                                profile?.name.toUpperCase() ?? 'LOADING...',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: isMobile
                                      ? 36
                                      : isWide
                                      ? 72
                                      : 56,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 2,
                                  height: 1.2,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Typed text with box background
                      TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 1200),
                        tween: Tween(begin: 0.0, end: 1.0),
                        curve: Curves.easeOut,
                        builder: (context, value, child) {
                          return Transform.translate(
                            offset: Offset(0, 30 * (1 - value)),
                            child: Opacity(opacity: value, child: child),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.themeColor.withOpacity(0.3),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.themeColor.withOpacity(0.2),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child:
                              profile?.typedItems != null &&
                                  profile!.typedItems.isNotEmpty
                              ? TypedText(
                                  items: profile.typedItems,
                                  style: TextStyle(
                                    fontSize: isMobile
                                        ? 18
                                        : isWide
                                        ? 32
                                        : 24,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Lucida Console',
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Short tagline/description
                      TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 1400),
                        tween: Tween(begin: 0.0, end: 1.0),
                        curve: Curves.easeOut,
                        builder: (context, value, child) {
                          return Opacity(opacity: value, child: child);
                        },
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: isMobile ? 300 : 600,
                          ),
                          child: Text(
                            'Transforming infrastructure with code, containers, and continuous delivery',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.sectionDescription.withOpacity(
                                0.8,
                              ),
                              fontSize: isMobile ? 14 : 16,
                              height: 1.6,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 48),

                      // CTA Buttons with animations
                      TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 1600),
                        tween: Tween(begin: 0.0, end: 1.0),
                        curve: Curves.easeOut,
                        builder: (context, value, child) {
                          return Transform.translate(
                            offset: Offset(0, 20 * (1 - value)),
                            child: Opacity(opacity: value, child: child),
                          );
                        },
                        child: Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          alignment: WrapAlignment.center,
                          children: [
                            _PrimaryButton(
                              label: 'LET\'S TALK',
                              icon: Icons.arrow_forward_rounded,
                              onPressed: () => controller.scrollToSection(7),
                            ),
                            _SecondaryButton(
                              label: 'VIEW WORK',
                              icon: Icons.work_outline_rounded,
                              onPressed: () => controller.scrollToSection(3),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 60),

                    ],
                  ),
                ),
              ),
            ),

            // Scroll Indicator
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: _ScrollIndicator(
                onTap: () => controller.scrollToSection(1),
              ),
            ),
          ],
        ),
      );
    });
  }
}

// Animated Background with Particles
class _AnimatedBackground extends StatefulWidget {
  const _AnimatedBackground();

  @override
  State<_AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<_AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
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
        return CustomPaint(
          painter: _ParticlesPainter(_controller.value),
          size: Size.infinite,
        );
      },
    );
  }
}

class _ParticlesPainter extends CustomPainter {
  final double animation;

  _ParticlesPainter(this.animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Draw floating particles
    for (int i = 0; i < 30; i++) {
      final x = (size.width / 30 * i + animation * 100) % size.width;
      final y =
          (math.sin(animation * 2 * math.pi + i) * size.height / 4) +
          size.height / 2;
      final radius = 2.0 + math.sin(animation * math.pi + i) * 1.5;

      paint.color = AppColors.themeColor.withOpacity(
        0.1 + math.sin(animation * math.pi + i) * 0.1,
      );
      canvas.drawCircle(Offset(x, y), radius, paint);
    }

    // Draw connecting lines
    paint.strokeWidth = 0.5;
    paint.style = PaintingStyle.stroke;

    for (int i = 0; i < 10; i++) {
      final x1 = (size.width / 10 * i + animation * 50) % size.width;
      final y1 = size.height * 0.3;
      final x2 = (size.width / 10 * (i + 1) + animation * 50) % size.width;
      final y2 = size.height * 0.7;

      paint.color = AppColors.themeColor.withOpacity(0.05);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
    }
  }

  @override
  bool shouldRepaint(_ParticlesPainter oldDelegate) => true;
}

// Primary Button
class _PrimaryButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const _PrimaryButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  State<_PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<_PrimaryButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: ElevatedButton.icon(
          onPressed: widget.onPressed,
          icon: Icon(widget.icon, size: 20),
          label: Text(
            widget.label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.themeColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            elevation: _isHovered ? 12 : 6,
            shadowColor: AppColors.themeColor.withOpacity(0.5),
          ),
        ),
      ),
    );
  }
}

// Secondary Button
class _SecondaryButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  const _SecondaryButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  State<_SecondaryButton> createState() => _SecondaryButtonState();
}

class _SecondaryButtonState extends State<_SecondaryButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: OutlinedButton.icon(
          onPressed: widget.onPressed,
          icon: Icon(widget.icon, size: 20),
          label: Text(
            widget.label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: _isHovered ? Colors.white : AppColors.themeColor,
            side: BorderSide(color: AppColors.themeColor, width: 2),
            backgroundColor: _isHovered
                ? AppColors.themeColor.withOpacity(0.1)
                : Colors.transparent,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
          ),
        ),
      ),
    );
  }
}

// Stat Item
// Animated Stat Item with Counter
class _StatItem extends StatefulWidget {
  final String number;
  final String label;

  const _StatItem({
    required this.number,
    required this.label,
  });

  @override
  State<_StatItem> createState() => _StatItemState();
}

class _StatItemState extends State<_StatItem> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;
  
  @override
  void initState() {
    super.initState();
    
    // Extract number from string (e.g., "3+" -> 3)
    final numStr = widget.number.replaceAll(RegExp(r'[^0-9]'), '');
    final targetNumber = int.tryParse(numStr) ?? 0;
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _animation = IntTween(begin: 0, end: targetNumber).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    
    // Start animation after a delay
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) _controller.forward();
    });
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasPlus = widget.number.contains('+');
    
    return Column(
      children: [
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Text(
              '${_animation.value}${hasPlus ? '+' : ''}',
              style: const TextStyle(
                color: AppColors.themeColor,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
        const SizedBox(height: 4),
        Text(
          widget.label,
          style: TextStyle(
            color: AppColors.sectionDescription.withOpacity(0.7),
            fontSize: 12,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}


// Scroll Indicator
class _ScrollIndicator extends StatefulWidget {
  final VoidCallback onTap;

  const _ScrollIndicator({required this.onTap});

  @override
  State<_ScrollIndicator> createState() => _ScrollIndicatorState();
}

class _ScrollIndicatorState extends State<_ScrollIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0,
      end: 10,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Column(
        children: [
          Text(
            'SCROLL DOWN',
            style: TextStyle(
              color: AppColors.sectionDescription.withOpacity(0.6),
              fontSize: 10,
              letterSpacing: 2,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _animation.value),
                child: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.themeColor,
                  size: 32,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
