import 'package:cash_swift/utils/extensions.dart';
import 'package:cash_swift/providers/selected_theme_provider.dart';
import 'package:cash_swift/providers/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeToggle extends ConsumerWidget {
  ThemeToggle({super.key});
  final List<Widget> themeModeList = [
    DarkToggle(),
    LightToggle(),
    AutoToggle()
  ];
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnimatedSwitcher(
        layoutBuilder: (currentChild, previousChildren) {
          previousChildren.clear();
          return currentChild!;
        },
        duration: Duration(milliseconds: 500),
        transitionBuilder: (child, animation) => SizeTransition(
              sizeFactor: Tween<double>(begin: 0, end: 1).animate(animation),
              child: FadeTransition(
                opacity: Tween<double>(begin: 0, end: 1)
                    .chain(CurveTween(curve: Curves.linear))
                    .animate(animation),
                child: child,
              ),
            ),
        child: themeModeList[ref.watch(selectedThemeProvider).maybeWhen(
              data: (data) => data,
              orElse: () => 2,
            )]);
  }
}

class AutoToggle extends ConsumerWidget {
  const AutoToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    return IconButton(
        onPressed: () async {
          final sharedPreferences = await SharedPreferences.getInstance();
          sharedPreferences.setInt("theme", 0);
          ref.refresh(themeProvider.future);
          ref.refresh(selectedThemeProvider.future);
        },
        icon: Icon(
          Icons.auto_mode_sharp,
          color: Colors.indigo.shade400,
          size: context.rSize(100),
        ));
  }
}

class LightToggle extends ConsumerWidget {
  const LightToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
        onPressed: () async {
          final sharedPreferences = await SharedPreferences.getInstance();
          sharedPreferences.setInt("theme", 2);
          ref.refresh(themeProvider.future);
          ref.refresh(selectedThemeProvider.future);
        },
        icon: Icon(CupertinoIcons.sun_max_fill,
            color: Colors.yellow.shade900, size: context.rSize(100)));
  }
}

class DarkToggle extends ConsumerWidget {
  const DarkToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    return IconButton(
        onPressed: () async {
          final sharedPreferences = await SharedPreferences.getInstance();
          sharedPreferences.setInt("theme", 1);
          ref.refresh(themeProvider.future);
          ref.refresh(selectedThemeProvider.future);
        },
        icon: Icon(
          CupertinoIcons.moon_stars_fill,
          color: Colors.blueGrey,
          size: context.rSize(100),
          // )
        ));
  }
}
