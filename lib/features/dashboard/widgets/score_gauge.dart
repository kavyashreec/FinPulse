import 'dart:math';
import 'package:flutter/material.dart';

class ScoreGauge extends StatefulWidget {
  const ScoreGauge({super.key});

  @override
  State<ScoreGauge> createState() => _ScoreGaugeState();
}

class _ScoreGaugeState extends State<ScoreGauge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  final double score = 78;
  final double maxScore = 100;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _animation = Tween<double>(
      begin: 0,
      end: score / maxScore,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

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
      child: Column(
        children: [
          const SizedBox(height: 24),

          const Text(
            "FINANCIAL HEALTH SCORE",
            textAlign: TextAlign.center,
            style: TextStyle(
              letterSpacing: 2,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF64748B),
            ),
          ),

          const SizedBox(height: 30),

          AnimatedBuilder(
            animation: _animation,
            builder: (context, _) {
              return SizedBox(
                width: 190,
                height: 190,
                child: CustomPaint(
                  painter: _GaugePainter(progress: _animation.value),
                  child: Center(
                    child: Transform.translate(
                      offset: const Offset(0, 2),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            score.toInt().toString(),
                            style: const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.5,
                                height: 1, // 🔥 CRITICAL
                                color: Color(0xFF334155),
                            ),
                            textHeightBehavior: const TextHeightBehavior(
                                applyHeightToFirstAscent: false,
                                applyHeightToLastDescent: false,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            "EXCELLENT",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                              height: 1, // 🔥 CRITICAL
                              color: Color(0xFF22C55E),
                            ),
                            textHeightBehavior: TextHeightBehavior(
                                applyHeightToFirstAscent: false,
                                applyHeightToLastDescent: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 26),

          const Text(
            "Your score is in the top 5% of users this month.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
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

    /// Background ring
    final backgroundPaint = Paint()
      ..color = const Color(0xFFE9EEF5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    /// Progress ring
    final progressPaint = Paint()
      ..color = const Color(0xFF334155)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    final startAngle = -pi / 2;
    final sweepAngle = 2 * pi * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}