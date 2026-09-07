import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'make_image.dart';

final MascotRouteObserver mascotRouteObserver = MascotRouteObserver();

class MascotRouteObserver extends NavigatorObserver with ChangeNotifier {
  final Set<Route<dynamic>> _popupRoutes = <Route<dynamic>>{};
  bool _showOverlay = false;

  bool get isDialogVisible => _popupRoutes.isNotEmpty;
  bool get showOverlay => _showOverlay;

  void dismissStartupIntro() {
    if (_showOverlay) return;
    _showOverlay = true;
    notifyListeners();
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route is PopupRoute<dynamic>) {
      _popupRoutes.add(route);
      notifyListeners();
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (_popupRoutes.remove(route)) {
      notifyListeners();
    }
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (_popupRoutes.remove(route)) {
      notifyListeners();
    }
  }
}

class MascotOverlay extends StatefulWidget {
  final MascotRouteObserver routeObserver;

  const MascotOverlay({required this.routeObserver, super.key});

  @override
  State<MascotOverlay> createState() => _MascotOverlayState();
}

class _MascotOverlayState extends State<MascotOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _floatController;
  Offset _offset = const Offset(50, 100);

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    widget.routeObserver.addListener(_onRouteChanged);
  }

  @override
  void dispose() {
    widget.routeObserver.removeListener(_onRouteChanged);
    _floatController.dispose();
    super.dispose();
  }

  void _onRouteChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _floatController,
      builder: (context, child) {
        if (!widget.routeObserver.showOverlay) {
          return const SizedBox.shrink();
        }

        final floatOffset = 10 * math.sin(_floatController.value * 2 * math.pi);
        final screenSize = MediaQuery.sizeOf(context);
        const mascotWidth = 92.0;
        const mascotHeight = 112.0;

        return Positioned(
          left: _offset.dx,
          top: _offset.dy + floatOffset,
          child: GestureDetector(
            onPanUpdate: (details) {
              final newOffset = _offset + details.delta;
              setState(() {
                _offset = Offset(
                  newOffset.dx.clamp(12.0, screenSize.width - mascotWidth - 12),
                  newOffset.dy.clamp(
                    12.0,
                    screenSize.height - mascotHeight - 12,
                  ),
                );
              });
            },
            child: const LocalImageWidget(
              imagePath: 'assets/images/Gargoyle.png',
              width: mascotWidth,
              height: mascotHeight,
            ),
          ),
        );
      },
    );
  }
}
