import 'package:flutter/material.dart';

class SpinningHero extends StatelessWidget {
  final Object tag;
  final Widget child;
  SpinningHero({this.tag, this.child})
    : assert(tag != null),
      assert(child != null);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      child: child,
      flightShuttleBuilder: (
        BuildContext flightContext,
        Animation<double> animation,
        HeroFlightDirection flightDirection,
        BuildContext fromHeroContext,
        BuildContext toHeroContext,
      ) {
        Animation<double> newAnimation = animation;
        if (flightDirection == HeroFlightDirection.pop) {
          newAnimation = ReverseAnimation(newAnimation);
        }

        return RotationTransition(
          turns: newAnimation,
          child: Material(
            color: Colors.transparent,
            child: toHeroContext.widget
          ),
        );
      },
    );
  }
}