import 'package:flutter/material.dart';

class SpinningHero extends StatelessWidget {
  final Object tag;
  final Widget child;
  SpinningHero({this.tag, this.child});

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
        // Animation<double> newAnimation = 
        //   Tween<double>(begin: 0, end: 0.5).animate(animation);
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