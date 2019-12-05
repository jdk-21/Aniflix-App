import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

class NavigationButtonValidation extends Given1WithWorld<String,FlutterWorld> {
  @override
  Future<void> executeStep(String input1) async {
    await FlutterDriverUtils.tap(world.driver, find.byValueKey(input1),timeout: Duration(minutes: 1));
  }

  @override
  RegExp get pattern => RegExp(r"I expect the user taps on {string}");

}
class SettingsValidation extends Then1WithWorld<String,FlutterWorld> {
  @override
  Future<void> executeStep(String input1) async {
    await FlutterDriverUtils.tap(world.driver, find.byValueKey(input1),timeout: Duration(minutes: 1));
  }

  @override
  RegExp get pattern => RegExp(r"I expect the user taps on {string}");

}

class ScreenValidation extends Then1WithWorld<String, FlutterWorld> {

  @override
  Future<void> executeStep(String input1) async {
    await FlutterDriverUtils.waitForFlutter(world.driver,timeout: Duration(minutes: 1));
    await FlutterDriverUtils.isPresent(find.byValueKey(input1), world.driver,timeout: Duration(minutes: 1));

  }

  @override
  RegExp get pattern => RegExp(r"user should land on {string}");

}