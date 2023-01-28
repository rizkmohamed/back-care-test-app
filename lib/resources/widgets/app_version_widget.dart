
import 'package:flutter/material.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:package_info/package_info.dart';

class AppVersionWidget extends StatelessWidget {
  const AppVersionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (BuildContext context, AsyncSnapshot<PackageInfo> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Text("");
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Text("");
          case ConnectionState.done:
            if (snapshot.hasError) return Text("");
            return Padding(
              child: Text("${trans("Version")}: ${snapshot.data!.version}",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(fontWeight: FontWeight.w300)),
              padding: EdgeInsets.only(top: 15, bottom: 15),
            );
        }
      },
    );
  }
}
