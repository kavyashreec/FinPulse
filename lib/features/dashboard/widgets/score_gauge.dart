import 'dart:math';
import 'package:flutter/material.dart';

class ScoreGauge extends StatefulWidget {
  final double income;
  final double expense;
  const ScoreGauge({super.key, required this.income, required this.expense});
  @override
  State<ScoreGauge> createState() => _ScoreGaugeState();
}

class _ScoreGaugeState extends State<ScoreGauge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  double get _score {
    if (widget.income <= 0) return 30;
    final savingsRate =
        ((widget.income - widget.expense) / widget.income).clamp(0.0, 1.0);
    return (50 + savingsRate * 50).clamp(0, 100);
  }

  String get _label {
    final s = _score;
    if (s >= 80) return 'EXCELLENT';
    if (s >= 60) return 'GOOD';
    if (s >= 40) return 'FAIR';
    return 'NEEDS WORK';
  }

  Color get _labelColor {
    final s = _score;
    if (s >= 80) return const Color(0xFF22C55E);
    if (s >= 60) return const Color(0xFF4F8EF7);
    if (s >= 40) return const Color(0xFFEAB308);
    return const Color(0xFFEF4444);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1400));
    _animation = Tween<double>(begin: 0, end: _score / 100).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(children: [
        const Text(
          'FINANCIAL HEALTH SCORE',
          textAlign: TextAlign.center,
          style: TextStyle(
              letterSpacing: 2,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF8BA3C7)),
        ),
        const SizedBox(height: 20),
        AnimatedBuilder(
          animation: _animation,
          builder: (context, _) => SizedBox(
            width: 160,
            height: 160,
            child: CustomPaint(
              painter: _GaugePainter(progress: _animation.value),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _score.toInt().toString(),
                      style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.5,
                          height: 1,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _label,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                          color: _labelColor),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          _score >= 70
              ? 'Your score is looking great this month!'
              : 'Try to save more to improve your score.',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12, color: Color(0xFF8BA3C7)),
        ),
      ]),
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double progress;
  _GaugePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2 - 10;

    // Background track
    final bgPaint = Paint()
      ..color = const Color(0xFF1A2C45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc — white/light blue
    final fgPaint = Paint()
      ..color = const Color(0xFF4F8EF7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * progress,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter _) => true;
}
