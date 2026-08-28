import 'package:flutter/material.dart';
import 'widgets/cinematic_band_anim.dart';

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({super.key});
  static const String routeName = '/tests';

  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  OverlayEntry? _transitionOverlay;

  void _triggerSceneTransition() {
    if (_transitionOverlay != null) return;

    _transitionOverlay = OverlayEntry(
      builder: (context) => AngledBandTransition(
        message: 'SCENARIO COMPLETED!', 
        onComplete: () {
          _transitionOverlay?.remove();
          _transitionOverlay = null;
          
        },
        duration: 2200,
      ),
    );

    Overlay.of(context).insert(_transitionOverlay!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: _triggerSceneTransition,
          child: const Text('Trigger Cinematic Bands'),
        ),
      ),
    );
  }
}
