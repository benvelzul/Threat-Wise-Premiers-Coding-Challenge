import 'package:flutter/material.dart';

class AngledBandTransition extends StatefulWidget {
  final String message;
  final VoidCallback onComplete;
  final int duration;

  const AngledBandTransition({
    super.key,
    required this.message,
    required this.onComplete,
    required this.duration,
  });

  @override
  State<AngledBandTransition> createState() => _AngledBandTransitionState();
}

class _AngledBandTransitionState extends State<AngledBandTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  
  late Animation<double> _slideIn;
  late Animation<double> _textFade;
  late Animation<double> _slideOut;

  @override
  void initState() {
    super.initState();
    {
      _controller = AnimationController(
        duration: Duration(milliseconds: widget.duration),
        vsync: this,
      );
      _slideIn = Tween<double>(begin: -1.2, end: 0.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.0, 0.35, curve: Curves.easeOutCubic),
        ),
      );

      _textFade = TweenSequence<double>([
        TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 15), // Fade in
        TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.0), weight: 55), // Hold bold text
        TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 15), // Fade out
      ]).animate(
        CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.30, 0.75),
        ),
      );
      _slideOut = Tween<double>(begin: 0.0, end: 1.2).animate(
        CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.70, 1.0, curve: Curves.easeInCubic),
        ),
      );

      // Listen for animation completion to run callback cleanup
      _controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.onComplete();
        }
      });

      // Start the scene transition immediately
      _controller.forward();
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
        final currentOffset = _slideIn.value + _slideOut.value;

        return Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _BandPainter(progressOffset: currentOffset),
              ),
            ),
            Center(
              child: FadeTransition(
                opacity: _textFade,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    widget.message.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// Custom Painter to draw overlapping offset canvas bands
class _BandPainter extends CustomPainter {
  final double progressOffset;
  _BandPainter({required this.progressOffset});

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    
    // Slant skew configuration (higher means more aggressively angled)
    const double angleSkew = 150.0; 

    // Define 3 brand/theme band colours
    final paints = [
      Paint()..color = Colors.blue.shade900,
      Paint()..color = Colors.blue.shade600,
      Paint()..color = Colors.blueAccent,
    ];

    // Draw bands from back to front
    for (int i = 0; i < paints.length; i++) {
      final Path path = Path();
      
      // Calculate a staggered delay per band using multiplication factors
      final double bandDelay = i * 0.12; 
      final double xTransform = (progressOffset - bandDelay) * width;

      // Coordinate math to draw a parallelogram shifting across screenspace
      path.moveTo(xTransform - angleSkew, 0); // Top Left
      path.lineTo(xTransform + width, 0); // Top Right
      path.lineTo(xTransform + width + angleSkew, height); // Bottom Right
      path.lineTo(xTransform, height); // Bottom Left
      path.close();

      canvas.drawPath(path, paints[i]);
    }
  }

  @override
  bool shouldRepaint(covariant _BandPainter oldDelegate) {
    return oldDelegate.progressOffset != progressOffset;
  }
}
