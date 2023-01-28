

import 'package:flutter/material.dart';
import 'package:flutter_app/bootstrap/app_helper.dart';
import 'package:flutter_app/bootstrap/helpers.dart';
import 'package:flutter_app/bootstrap/shared_pref/sp_auth.dart';
import 'package:flutter_app/resources/widgets/app_version_widget.dart';
import 'package:flutter_app/resources/widgets/cached_image_widget.dart';
import 'package:flutter_app/resources/widgets/woosignal_ui.dart';
import 'package:nylo_framework/theme/helper/ny_theme.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:woosignal/models/menu_link.dart';
import 'package:woosignal/models/response/woosignal_app.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeDrawerWidget extends StatefulWidget {
  const HomeDrawerWidget({Key? key, required this.wooSignalApp})
      : super(key: key);

  final WooSignalApp? wooSignalApp;

  @override
  _HomeDrawerWidgetState createState() => _HomeDrawerWidgetState();
}

class _HomeDrawerWidgetState extends State<HomeDrawerWidget> {
  List<MenuLink> _menuLinks = [];
  String? _themeType;

  @override
  void initState() {
    super.initState();
    _menuLinks = AppHelper.instance.appConfig?.menuLinks ?? [];
    _themeType = AppHelper.instance.appConfig!.theme;
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = (Theme.of(context).brightness == Brightness.dark);
    return Drawer(
      child: Container(
        color: ThemeColor.get(context).background,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Center(child: StoreLogo()),
              decoration: BoxDecoration(
                color: ThemeColor.get(context).background,
              ),
            ),
            if (["compo"].contains(_themeType) == false)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    child: Text(
                      trans("Menu"),
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                    padding: EdgeInsets.only(left: 16, top: 8, bottom: 8),
                  ),
                  if (widget.wooSignalApp!.wpLoginEnabled == 1)
                    ListTile(
                      title: Text(
                        trans("Profile"),
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .copyWith(fontSize: 16),
                      ),
                      leading: Icon(Icons.account_circle),
                      onTap: _actionProfile,
                    ),
                  if (widget.wooSignalApp!.wishlistEnabled == true)
                    ListTile(
                      title: Text(
                        trans("Wishlist"),
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .copyWith(fontSize: 16),
                      ),
                      leading: Icon(Icons.favorite_border),
                      onTap: _actionWishlist,
                    ),
                  ListTile(
                    title: Text(
                      trans("Cart"),
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(fontSize: 16),
                    ),
                    leading: Icon(Icons.shopping_cart),
                    onTap: _actionCart,
                  ),
                ],
              ),
            if (widget.wooSignalApp!.appTermsLink != null &&
                widget.wooSignalApp!.appPrivacyLink != null)
              Padding(
                child: Text(
                  trans("About Us"),
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                padding: EdgeInsets.only(left: 16, top: 8, bottom: 8),
              ),
            if (widget.wooSignalApp!.appTermsLink != null &&
                widget.wooSignalApp!.appTermsLink!.isNotEmpty)
              ListTile(
                title: Text(
                  trans("Terms and conditions"),
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(fontSize: 16),
                ),
                leading: Icon(Icons.menu_book_rounded),
                trailing: Icon(Icons.keyboard_arrow_right_rounded),
                onTap: _actionTerms,
              ),
            if (widget.wooSignalApp!.appPrivacyLink != null &&
                widget.wooSignalApp!.appPrivacyLink!.isNotEmpty)
              ListTile(
                title: Text(
                  trans("Privacy policy"),
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(fontSize: 16),
                ),
                trailing: Icon(Icons.keyboard_arrow_right_rounded),
                leading: Icon(Icons.account_balance),
                onTap: _actionPrivacy,
              ),
            ListTile(
              title: Text(trans((isDark ? "Light Mode" : "Dark Mode")),
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(fontSize: 16)),
              leading: Icon(Icons.brightness_4_rounded),
              onTap: () {
                setState(() {
                  NyTheme.set(context,
                      id: isDark
                          ? "default_light_theme"
                          : "default_dark_theme");
                });
              },
            ),
            if (_menuLinks.isNotEmpty)
              Padding(
                child: Text(
                  trans("Social"),
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                padding: EdgeInsets.only(left: 16, top: 8, bottom: 8),
              ),
            ..._menuLinks
                .where((element) => element.label != "")
                .map((menuLink) => ListTile(
                      title: Text(menuLink.label,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .copyWith(fontSize: 16)),
                      leading: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: CachedImageWidget(
                          image: menuLink.iconUrl,
                          width: 40,
                        ),
                      ),
                      onTap: () async =>
                          await launchUrl(Uri.parse(menuLink.linkUrl)),
                    ))
                .toList(),
            ListTile(
              title: AppVersionWidget(),
            ),
          ],
        ),
      ),
    );
  }

  _actionTerms() => openBrowserTab(url: widget.wooSignalApp!.appTermsLink!);

  _actionPrivacy() => openBrowserTab(url: widget.wooSignalApp!.appPrivacyLink!);

  _actionProfile() async {
    Navigator.pop(context);
    if (widget.wooSignalApp!.wpLoginEnabled == 1 && !(await authCheck())) {
      UserAuth.instance.redirect = "/account-detail";
      Navigator.pushNamed(context, "/account-landing");
      return;
    }
    Navigator.pushNamed(context, "/account-detail");
  }

  _actionWishlist() async {
    Navigator.pop(context);
    Navigator.pushNamed(context, "/wishlist");
  }

  _actionCart() {
    Navigator.pop(context);
    Navigator.pushNamed(context, "/cart");
  }
}
