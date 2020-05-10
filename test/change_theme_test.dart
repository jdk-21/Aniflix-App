import 'package:aniflix_app/components/screens/settings.dart';
import 'package:aniflix_app/themes/themeManager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('Change the theme in the Settings', (WidgetTester tester) async {
        ThemeManager manager = ThemeManager.getInstance();
        await tester.pumpWidget(MaterialApp(home: Settings(),));
        // Tap the Theme button.
        await tester.tap(find.byKey(Key("themes")));
        // Rebuild the widget after the state has changed.
        await tester.pump();
        await tester.tap(find.byKey(Key(manager.Themes[manager.Themes.length-1].themeName)).last);
        // Rebuild the widget after the state has changed.
        await tester.pump();
        expect(manager.actualTheme.themeName,manager.Themes[manager.Themes.length-1].themeName);
        expect(manager.actualThemeIndex, manager.Themes.length-1);
  });
}
