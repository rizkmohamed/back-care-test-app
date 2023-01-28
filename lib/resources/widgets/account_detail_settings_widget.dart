

import 'package:flutter/material.dart';
import 'package:flutter_app/bootstrap/shared_pref/sp_auth.dart';
import 'package:nylo_framework/nylo_framework.dart';

class AccountDetailSettingsWidget extends StatelessWidget {
  const AccountDetailSettingsWidget({Key? key, required this.refreshAccount})
      : super(key: key);
  final Function refreshAccount;
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Card(
          child: ListTile(
            leading: Icon(Icons.account_circle),
            title: Text(trans("Update details")),
            onTap: () =>
                Navigator.pushNamed(context, "/account-update").then((onValue) {
              refreshAccount();
            }),
          ),
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.local_shipping),
            title: Text(trans("Billing/shipping details")),
            onTap: () =>
                Navigator.pushNamed(context, "/account-shipping-details"),
          ),
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.no_accounts_rounded),
            title: Text(trans("Delete Account")),
            onTap: () => Navigator.pushNamed(context, "/account-delete"),
          ),
        ),
        Card(
          child: ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text(trans("Logout")),
            onTap: () => authLogout(context),
          ),
        ),
      ],
    );
  }
}
