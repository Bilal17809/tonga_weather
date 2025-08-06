import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../extension/weather_condition_extension.dart';

class IconAnimationController {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late TickerProvider _vsync;
  WeatherCondition _currentCondition = WeatherCondition.clear;

  void initialize({
    required TickerProvider vsync,
    required WeatherCondition condition,
  }) {
    _vsync = vsync;
    _currentCondition = condition;
    _animationController = AnimationController(
      duration: _getDurationForCondition(condition),
      vsync: vsync,
    );
    _animation = _getAnimationForCondition(condition);
    _startAnimation();
  }

  Duration _getDurationForCondition(WeatherCondition condition) {
    switch (condition) {
      case WeatherCondition.clear:
        return const Duration(seconds: 16);
      case WeatherCondition.thunderstorm:
        return const Duration(milliseconds: 1500);
      default:
        return const Duration(seconds: 3);
    }
  }

  Animation<double> _getAnimationForCondition(WeatherCondition condition) {
    return Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  void _startAnimation() {
    switch (_currentCondition) {
      case WeatherCondition.clear:
        _animationController.repeat();
        break;
      default:
        _animationController.repeat(reverse: true);
        break;
    }
  }

  void updateCondition(WeatherCondition newCondition) {
    if (_currentCondition != newCondition) {
      _animationController.dispose();
      _currentCondition = newCondition;
      _animationController = AnimationController(
        duration: _getDurationForCondition(newCondition),
        vsync: _vsync,
      );
      _animation = _getAnimationForCondition(newCondition);
      _startAnimation();
    }
  }

  Widget applyAnimation(Widget child) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return _getTransformedWidget(child);
      },
    );
  }

  Widget _getTransformedWidget(Widget child) {
    switch (_currentCondition) {
      case WeatherCondition.clear:
        return Transform.rotate(
          angle: _animation.value * 2 * math.pi,
          child: child,
        );
      case WeatherCondition.thunderstorm:
        double opacity = 0.2 + (0.8 * _animation.value);
        return Opacity(opacity: opacity, child: child);
      default:
        return Transform.translate(
          offset: Offset(0, -6 * _animation.value),
          child: child,
        );
    }
  }

  void dispose() {
    _animationController.dispose();
  }

  AnimationController get controller => _animationController;
}
