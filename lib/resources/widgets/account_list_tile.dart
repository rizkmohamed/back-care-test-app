import 'package:flutter/material.dart';

class AccountListTile extends StatelessWidget {
  final void Function()? ontap;
  final String? title;
  final bool ishead;
  final Widget? icon;
  const AccountListTile(
      {super.key,
      this.ontap,
      required this.title,
      this.ishead = true,
      this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ishead
          ? MediaQuery.of(context).size.height * 0.047
          : MediaQuery.of(context).size.height * 0.033,
      child: ListTile(
          onTap: ontap,
          title: ishead
              ? Text(
                  title!,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(fontWeight: FontWeight.bold),
                )
              : Text(
                  title!,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(color: Color.fromARGB(255, 49, 48, 48)),
                ),
          leading: ishead ? icon : null),
    );
  }
}
