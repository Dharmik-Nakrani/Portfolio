import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:portfolio/app/theme/app_colors.dart';

class EnhancedSkillCard extends StatefulWidget {
  final skill;
  final int index;

  const EnhancedSkillCard({
    super.key,
    required this.skill,
    required this.index,
  });

  @override
  State<EnhancedSkillCard> createState() => _EnhancedSkillCardState();
}

class _EnhancedSkillCardState extends State<EnhancedSkillCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _animController;
  late Animation<double> _progressAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0,
      end: widget.skill.percentage / 100,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));

    _rotationAnimation = Tween<double>(begin: 0, end: math.pi).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _animController.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _animController.reverse();
      },
      child: AnimatedBuilder(
        animation: _animController,
        builder: (context, child) {
          final angle = _rotationAnimation.value;
          final transform = Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(angle);

          return Transform(
            transform: transform,
            alignment: Alignment.center,
            child: angle > math.pi / 2 ? _buildBackCard() : _buildFrontCard(),
          );
        },
      ),
    );
  }

  Widget _buildFrontCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.05),
            Colors.white.withOpacity(0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _isHovered
              ? AppColors.themeColor.withOpacity(0.5)
              : Colors.white.withOpacity(0.1),
          width: 2,
        ),
        boxShadow: _isHovered
            ? [
                BoxShadow(
                  color: AppColors.themeColor.withOpacity(0.2),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ]
            : [],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.themeColor.withOpacity(0.2),
                    AppColors.themeColor.withOpacity(0.05),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: widget.skill.imageUrl.isNotEmpty
                  ? Image.network(
                      widget.skill.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildIconFallback();
                      },
                    )
                  : _buildIconFallback(),
            ),
            const SizedBox(height: 16),
            Text(
              widget.skill.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.sectionDescription,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackCard() {
    return Transform(
      transform: Matrix4.rotationY(math.pi),
      alignment: Alignment.center,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.themeColor.withOpacity(0.2),
              AppColors.themeColor.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.themeColor.withOpacity(0.5),
            width: 2,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Circular Progress
              SizedBox(
                width: 120,
                height: 120,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: CircularProgressIndicator(
                        value: _progressAnimation.value,
                        strokeWidth: 8,
                        backgroundColor: Colors.white.withOpacity(0.1),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.themeColor,
                        ),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${(widget.skill.percentage).toInt()}%',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppColors.themeColor,
                          ),
                        ),
                        const Text(
                          'Proficiency',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.sectionDescription,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.skill.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.sectionDescription,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconFallback() {
    return Center(
      child: Text(
        widget.skill.name[0].toUpperCase(),
        style: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.themeColor,
        ),
      ),
    );
  }
}
