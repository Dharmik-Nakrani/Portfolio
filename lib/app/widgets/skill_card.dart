import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../data/models/skill_model.dart';
import '../theme/app_colors.dart';

class SkillCard extends StatefulWidget {
  final SkillModel skill;
  const SkillCard({super.key, required this.skill});

  @override
  State<SkillCard> createState() => _SkillCardState();
}

class _SkillCardState extends State<SkillCard> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _animController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _progressAnimation = Tween<double>(
      begin: 0,
      end: widget.skill.percentage / 100,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    ));
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
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isHovered 
                ? AppColors.themeColor.withOpacity(0.5)
                : Colors.white.withOpacity(0.1),
            width: 2,
          ),
        ),
        child: Stack(
          children: [
            // Skill Logo
            Center(
              child: AnimatedOpacity(
                opacity: _isHovered ? 0.2 : 1.0,
                duration: const Duration(milliseconds: 300),
                child: CachedNetworkImage(
                  imageUrl: widget.skill.imageUrl,
                  width: 100,
                  height: 100,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
            
            // Circular Progress on Hover
            if (_isHovered)
              Center(
                child: AnimatedBuilder(
                  animation: _progressAnimation,
                  builder: (context, child) {
                    return SizedBox(
                      width: 140,
                      height: 140,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(
                            value: _progressAnimation.value,
                            strokeWidth: 12,
                            backgroundColor: Colors.white.withOpacity(0.2),
                            color: AppColors.themeColor,
                          ),
                          Container(
                            width: 100,
                            height: 100,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '${widget.skill.percentage}%',
                            style: const TextStyle(
                              color: AppColors.themeColor,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            
            // Skill Name
            Positioned(
              bottom: 12,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  widget.skill.name,
                  style: const TextStyle(
                    color: AppColors.sectionDescription,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
