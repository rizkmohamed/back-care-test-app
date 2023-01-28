

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
export 'src/wave.dart';

class AppLoaderWidget extends StatelessWidget {
  const AppLoaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDark = (Theme.of(context).brightness == Brightness.dark);
    return SpinKitDoubleBounce(
      color: Color(!isDark ? 0xFF424242 : 0xFF6320C0),
    );
  }
}
