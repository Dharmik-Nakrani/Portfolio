import 'package:flutter/material.dart';
import '../data/models/experience_model.dart';
import '../theme/app_colors.dart';

// Timeline Card with animation
class TimelineCard extends StatefulWidget {
  final experience;
  final int index;
  final bool isLeft;

  const TimelineCard({
    required this.experience,
    required this.index,
    required this.isLeft,
  });

  @override
  State<TimelineCard> createState() => TimelineCardState();
}

class TimelineCardState extends State<TimelineCard> {
  bool _isExpanded = false;
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 500 + (widget.index * 150)),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(
            isMobile ? 0 : (widget.isLeft ? -50 : 50) * (1 - value),
            0,
          ),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 40),
        child: isMobile
            ? _buildMobileCard()
            : Row(
                children: [
                  // Left Side
                  if (widget.isLeft) ...[
                    Expanded(child: _buildCard()),
                    const SizedBox(width: 20),
                    _buildTimelineDot(),
                    Expanded(child: Container()),
                  ] else ...[
                    Expanded(child: Container()),
                    _buildTimelineDot(),
                    const SizedBox(width: 20),
                    Expanded(child: _buildCard()),
                  ],
                ],
              ),
      ),
    );
  }

  Widget _buildMobileCard() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTimelineDot(),
        const SizedBox(width: 20),
        Expanded(child: _buildCard()),
      ],
    );
  }

  Widget _buildTimelineDot() {
    return Column(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                AppColors.themeColor,
                AppColors.themeColor.withOpacity(0.7),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.themeColor.withOpacity(0.5),
                blurRadius: 15,
                spreadRadius: 3,
              ),
            ],
          ),
          child: Center(
            child: Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCard() {
    final isEducation = widget.experience.isEducation;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () => setState(() => _isExpanded = !_isExpanded),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: _isHovered
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.themeColor.withOpacity(0.1),
                      Colors.white.withOpacity(0.05),
                    ],
                  )
                : null,
            color: _isHovered ? null : Colors.white.withOpacity(0.03),
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
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  // Icon
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isEducation
                            ? [const Color(0xFF667eea), const Color(0xFF764ba2)]
                            : [
                                const Color(0xFF11998e),
                                const Color(0xFF38ef7d),
                              ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color:
                              (isEducation
                                      ? const Color(0xFF667eea)
                                      : const Color(0xFF11998e))
                                  .withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Icon(
                      isEducation ? Icons.school_rounded : Icons.work_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Title and Dates
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.experience.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.sectionDescription,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.experience.dateRange,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.themeColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Tag Badge
                  if (widget.experience.tag != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
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
                      child: Text(
                        widget.experience.tag!,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 16),

              // Organization
              Row(
                children: [
                  Icon(
                    Icons.business_rounded,
                    size: 16,
                    color: AppColors.sectionDescription.withOpacity(0.6),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${widget.experience.organization}, ${widget.experience.location}',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.sectionDescription.withOpacity(0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Divider
              Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.white.withOpacity(0.2),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Highlights
              ...widget.experience.highlights
                  .take(_isExpanded ? 100 : 2)
                  .map<Widget>(
                    (highlight) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 6),
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.themeColor,
                                  AppColors.themeColor.withOpacity(0.5),
                                ],
                              ),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              highlight,
                              style: TextStyle(
                                fontSize: 14,
                                height: 1.6,
                                color: AppColors.sectionDescription.withOpacity(
                                  0.9,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

              // Show More Button
              if (widget.experience.highlights.length > 2)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: InkWell(
                    onTap: () => setState(() => _isExpanded = !_isExpanded),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _isExpanded ? 'Show Less' : 'Show More',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.themeColor,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          _isExpanded
                              ? Icons.keyboard_arrow_up_rounded
                              : Icons.keyboard_arrow_down_rounded,
                          color: AppColors.themeColor,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
