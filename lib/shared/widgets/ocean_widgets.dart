import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// Ocean themed background with gradient and wave
class OceanBackground extends StatelessWidget {
  final Widget child;
  final bool showWave;
  final bool showBubbles;
  final double waveHeight;

  const OceanBackground({
    super.key,
    required this.child,
    this.showWave = true,
    this.showBubbles = true,
    this.waveHeight = 120,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.skyGradient,
      ),
      child: Stack(
        children: [
          if (showBubbles) const Positioned.fill(child: BubbleDecoration()),
          if (showWave)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: waveHeight,
              child: const WaveDecoration(),
            ),
          child,
        ],
      ),
    );
  }
}

/// Animated wave decoration at the bottom
class WaveDecoration extends StatefulWidget {
  final Color? color;

  const WaveDecoration({super.key, this.color});

  @override
  State<WaveDecoration> createState() => _WaveDecorationState();
}

class _WaveDecorationState extends State<WaveDecoration>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
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
          painter: WavePainter(
            animationValue: _controller.value,
            color: widget.color ?? AppColors.lightBlue.withOpacity(0.3),
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class WavePainter extends CustomPainter {
  final double animationValue;
  final Color color;

  WavePainter({required this.animationValue, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height);

    for (double i = 0; i <= size.width; i++) {
      path.lineTo(
        i,
        size.height * 0.5 +
            sin((i / size.width * 2 * pi) + (animationValue * 2 * pi)) *
                size.height *
                0.2,
      );
    }

    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);

    // Second wave layer
    final paint2 = Paint()
      ..color = color.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    final path2 = Path();
    path2.moveTo(0, size.height);

    for (double i = 0; i <= size.width; i++) {
      path2.lineTo(
        i,
        size.height * 0.6 +
            sin((i / size.width * 2 * pi) +
                    (animationValue * 2 * pi) +
                    pi / 2) *
                size.height *
                0.15,
      );
    }

    path2.lineTo(size.width, size.height);
    path2.close();

    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(covariant WavePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

/// Floating bubble decorations
class BubbleDecoration extends StatefulWidget {
  const BubbleDecoration({super.key});

  @override
  State<BubbleDecoration> createState() => _BubbleDecorationState();
}

class _BubbleDecorationState extends State<BubbleDecoration>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Bubble> _bubbles = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    // Generate random bubbles
    final random = Random();
    for (int i = 0; i < 15; i++) {
      _bubbles.add(Bubble(
        x: random.nextDouble(),
        y: random.nextDouble(),
        size: 4 + random.nextDouble() * 12,
        speed: 0.5 + random.nextDouble() * 1.5,
        opacity: 0.1 + random.nextDouble() * 0.3,
      ));
    }
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
          painter: BubblePainter(
            bubbles: _bubbles,
            animationValue: _controller.value,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class Bubble {
  double x;
  double y;
  double size;
  double speed;
  double opacity;

  Bubble({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
  });
}

class BubblePainter extends CustomPainter {
  final List<Bubble> bubbles;
  final double animationValue;

  BubblePainter({required this.bubbles, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    for (final bubble in bubbles) {
      final currentY =
          (bubble.y - animationValue * bubble.speed) % 1.2 - 0.1;
      if (currentY < 0 || currentY > 1) continue;

      final paint = Paint()
        ..color = Colors.white.withOpacity(bubble.opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(bubble.x * size.width, currentY * size.height),
        bubble.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant BubblePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

/// Ocean themed card with soft shadow and rounded corners
class OceanCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? color;
  final Gradient? gradient;
  final VoidCallback? onTap;
  final double borderRadius;

  const OceanCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.gradient,
    this.onTap,
    this.borderRadius = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: gradient == null ? (color ?? AppColors.white) : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.oceanBlue.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(20),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Cute speech bubble widget
class SpeechBubble extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final bool isRight;

  const SpeechBubble({
    super.key,
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.isRight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(20),
          topRight: const Radius.circular(20),
          bottomLeft: isRight ? const Radius.circular(20) : Radius.zero,
          bottomRight: isRight ? Radius.zero : const Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.oceanBlue.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          color: textColor ?? AppColors.grey700,
          height: 1.5,
        ),
      ),
    );
  }
}

/// Ocean themed icon button
class OceanIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? iconColor;
  final double size;

  const OceanIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.backgroundColor,
    this.iconColor,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(size / 2),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: backgroundColor ?? AppColors.paleBlue,
            borderRadius: BorderRadius.circular(size / 2),
            boxShadow: [
              BoxShadow(
                color: AppColors.oceanBlue.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: iconColor ?? AppColors.oceanBlue,
            size: size * 0.5,
          ),
        ),
      ),
    );
  }
}

/// Cute ocean character avatar
class OceanAvatar extends StatelessWidget {
  final String? imageUrl;
  final IconData? fallbackIcon;
  final double size;
  final Color? backgroundColor;

  const OceanAvatar({
    super.key,
    this.imageUrl,
    this.fallbackIcon,
    this.size = 60,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.lightBlue,
        borderRadius: BorderRadius.circular(size / 2),
        border: Border.all(
          color: AppColors.white,
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.oceanBlue.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size / 2),
        child: imageUrl != null
            ? Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _buildFallback(),
              )
            : _buildFallback(),
      ),
    );
  }

  Widget _buildFallback() {
    return Center(
      child: Icon(
        fallbackIcon ?? Icons.person,
        size: size * 0.5,
        color: AppColors.white,
      ),
    );
  }
}

/// Animated floating action button with ocean style
class OceanFloatingButton extends StatelessWidget {
  final IconData icon;
  final String? label;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final bool extended;

  const OceanFloatingButton({
    super.key,
    required this.icon,
    this.label,
    this.onPressed,
    this.backgroundColor,
    this.extended = false,
  });

  @override
  Widget build(BuildContext context) {
    if (extended && label != null) {
      return FloatingActionButton.extended(
        onPressed: onPressed,
        backgroundColor: backgroundColor ?? AppColors.oceanBlue,
        elevation: 4,
        highlightElevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        icon: Icon(icon, color: AppColors.white),
        label: Text(
          label!,
          style: const TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: backgroundColor ?? AppColors.oceanBlue,
      elevation: 4,
      highlightElevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(icon, color: AppColors.white),
    );
  }
}

/// Stats badge with ocean theme
class OceanStatBadge extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color? color;

  const OceanStatBadge({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final badgeColor = color ?? AppColors.oceanBlue;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: badgeColor, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: badgeColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: badgeColor,
            ),
          ),
        ],
      ),
    );
  }
}

/// Cute tag/chip with ocean theme
class OceanChip extends StatelessWidget {
  final String label;
  final Color? color;
  final IconData? icon;
  final bool selected;
  final VoidCallback? onTap;

  const OceanChip({
    super.key,
    required this.label,
    this.color,
    this.icon,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final chipColor = color ?? AppColors.oceanBlue;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(50),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? chipColor : chipColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              color: chipColor.withOpacity(selected ? 1 : 0.3),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 16,
                  color: selected ? AppColors.white : chipColor,
                ),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: selected ? AppColors.white : chipColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
