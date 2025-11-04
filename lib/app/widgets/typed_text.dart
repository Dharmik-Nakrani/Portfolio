import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class TypedText extends StatefulWidget {
  final List<String> items;
  final TextStyle? style;
  final int typeSpeedMs;
  final int backSpeedMs;
  final int backDelayMs;

  const TypedText({
    super.key,
    required this.items,
    this.style,
    this.typeSpeedMs = 100,
    this.backSpeedMs = 50,
    this.backDelayMs = 2000,
  });

  @override
  State<TypedText> createState() => _TypedTextState();
}

class _TypedTextState extends State<TypedText> {
  late Timer _timer;
  int itemIndex = 0;
  int charIndex = 0;
  bool deleting = false;
  
  String get currentItem => widget.items.isNotEmpty ? widget.items[itemIndex] : '';

  @override
  void initState() {
    super.initState();
    _startTyping();
  }

  void _startTyping() {
    if (widget.items.isEmpty) return;
    
    _timer = Timer.periodic(
      Duration(milliseconds: deleting ? widget.backSpeedMs : widget.typeSpeedMs),
      (timer) {
        setState(() {
          if (!deleting) {
            charIndex++;
            if (charIndex > currentItem.length) {
              deleting = true;
              _timer.cancel();
              Future.delayed(
                Duration(milliseconds: widget.backDelayMs),
                _startTyping,
              );
            }
          } else {
            charIndex--;
            if (charIndex <= 0) {
              deleting = false;
              itemIndex = (itemIndex + 1) % widget.items.length;
            }
          }
        });
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final displayText = currentItem.substring(0, charIndex.clamp(0, currentItem.length));
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'I am ',
          style: widget.style?.copyWith(color: AppColors.sectionDescription),
        ),
        Flexible(
          child: Text(
            displayText,
            style: widget.style?.copyWith(color: AppColors.themeColor),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        AnimatedOpacity(
          opacity: deleting || charIndex == currentItem.length ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 500),
          child: Container(
            width: 2,
            height: 30,
            color: AppColors.themeColor,
          ),
        ),
      ],
    );
  }
}
