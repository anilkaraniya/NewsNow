import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:news_now/src/view/presentation/components/bottom_nav_body.dart';
import 'package:news_now/src/view/presentation/components/crystal_navigation_bar_item.dart';

class CrystalNavigationBar extends StatelessWidget {
  const CrystalNavigationBar({
    super.key,
    required this.items,
    this.currentIndex = 0,
    this.height = 105,
    this.onTap,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.margin = const EdgeInsets.all(8),
    this.itemPadding = const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.easeOutQuint,
    this.indicatorColor,
    this.marginR = const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
    this.paddingR = const EdgeInsets.only(bottom: 5, top: 10),
    this.borderRadius = 30,
    this.splashBorderRadius,
    this.backgroundColor = Colors.transparent,
    this.outlineBorderColor = Colors.white24,
    this.boxShadow = const [
      BoxShadow(
        color: Colors.transparent,
        spreadRadius: 0,
        blurRadius: 0,
        offset: Offset(0, 0),
      ),
    ],
    this.enableFloatingNavBar = true,
    this.enablePaddingAnimation = true,
    this.splashColor,
  });

  final List<CrystalNavigationBarItem> items;

  final int currentIndex;

  final Function(int)? onTap;

  final Color? selectedItemColor;

  final Color? unselectedItemColor;

  final EdgeInsets margin;

  final EdgeInsets itemPadding;

  final Duration duration;

  final Curve curve;

  final Color? indicatorColor;

  final EdgeInsetsGeometry? marginR;

  final EdgeInsetsGeometry? paddingR;

  final double? borderRadius;

  final double? height;

  final Color? backgroundColor;

  final Color outlineBorderColor;

  final List<BoxShadow> boxShadow;
  final bool enableFloatingNavBar;
  final bool enablePaddingAnimation;

  final Color? splashColor;

  final double? splashBorderRadius;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return enableFloatingNavBar
        ? BottomAppBar(
            color: Colors.transparent,
            padding: EdgeInsets.zero,
            elevation: 0,
            height: height! < 105 ? 105 : height,
            child: Padding(
              padding: marginR!,
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: boxShadow,
                  borderRadius: BorderRadius.circular(borderRadius!),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(borderRadius!),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaY: 10, sigmaX: 10),
                    child: Container(
                      padding: paddingR,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(borderRadius!),
                        border: Border.all(color: outlineBorderColor),
                        color: backgroundColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: BottomNavBody(
                            items: items,
                            currentIndex: currentIndex,
                            curve: curve,
                            duration: duration,
                            selectedItemColor: selectedItemColor,
                            theme: theme,
                            unselectedItemColor: unselectedItemColor,
                            onTap: onTap!,
                            itemPadding: itemPadding,
                            indicatorColor: indicatorColor,
                            splashColor: splashColor,
                            splashBorderRadius: splashBorderRadius),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        : Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            color: backgroundColor,
            child: Padding(
              padding: margin,
              child: BottomNavBody(
                  items: items,
                  currentIndex: currentIndex,
                  curve: curve,
                  duration: duration,
                  selectedItemColor: selectedItemColor,
                  theme: theme,
                  unselectedItemColor: unselectedItemColor,
                  onTap: onTap!,
                  itemPadding: itemPadding,
                  indicatorColor: indicatorColor,
                  splashColor: splashColor,
                  splashBorderRadius: splashBorderRadius),
            ),
          );
  }
}
