import 'package:flutter/material.dart';
import 'package:flutter_app/bootstrap/app.dart';
import 'package:flutter_app/bootstrap/app_helper.dart';
import 'package:flutter_app/bootstrap/boot.dart';
import 'package:nylo_framework/nylo_framework.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Nylo nylo = await Nylo.init(setup: Boot.nylo, setupFinished: Boot.finished);

  String initialRoute = AppHelper.instance.appConfig!.appStatus != null
      ? '/home'
      : '/no-connection';

  runApp(
    AppBuild(
      navigatorKey: NyNavigator.instance.router.navigatorKey,
      onGenerateRoute: nylo.router!.generator(),
      initialRoute: initialRoute,
      debugShowCheckedModeBanner: false,
    ),
  );
}
