import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'make_image.dart';

class MascotRouteObserver extends NavigatorObserver with ChangeNotifier {
  final Set<Route<dynamic>> _popupRoutes = <Route<dynamic>>{};

  bool get isDialogVisible => _popupRoutes.isNotEmpty;

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
    if (widget.routeObserver.isDialogVisible) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: _floatController,
      builder: (context, child) {
        final floatOffset = 10 * math.sin(_floatController.value * 2 * math.pi);

        return Positioned(
          left: _offset.dx,
          top: _offset.dy + floatOffset,
          child: GestureDetector(
            onPanUpdate: (details) {
              final screenSize = MediaQuery.of(context).size;
              final newOffset = _offset + details.delta;
              setState(() {
                _offset = Offset(
                  newOffset.dx.clamp(0.0, screenSize.width - 100),
                  newOffset.dy.clamp(0.0, screenSize.height - 100),
                );
              });
            },
            child: SizedBox(
              width: 115,
              height: 115,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    left: 5,
                    top: 5,
                    child: ImageFiltered(
                      imageFilter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          Colors.black.withValues(alpha: 0.4),
                          BlendMode.srcIn,
                        ),
                        child: LocalImageWidget(
                          imagePath: 'assets/images/Gargoyle.png',
                          width: 100,
                          height: 100,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    child: LocalImageWidget(
                      imagePath: 'assets/images/Gargoyle.png',
                      width: 100,
                      height: 100,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
