import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/bootstrap/helpers.dart';
import 'package:flutter_app/bootstrap/shared_pref/sp_auth.dart';
import 'package:flutter_app/resources/widgets/account_detail_orders_widget.dart';
import 'package:flutter_app/resources/widgets/account_detail_settings_widget.dart';
import 'package:flutter_app/resources/widgets/account_list_tile.dart';
import 'package:flutter_app/resources/widgets/app_loader_widget.dart';
import 'package:flutter_app/resources/widgets/grey_border.dart';
import 'package:flutter_app/resources/widgets/safearea_widget.dart';
import 'package:flutter_app/resources/widgets/woosignal_ui.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:wp_json_api/exceptions/invalid_user_token_exception.dart';
import 'package:wp_json_api/models/responses/wc_customer_info_response.dart';
import 'package:wp_json_api/wp_json_api.dart';

class AccountDetailPage extends StatefulWidget {
  final bool showLeadingBackButton;
  const AccountDetailPage({this.showLeadingBackButton = true});
  @override
  _AccountDetailPageState createState() => _AccountDetailPageState();
}

class _AccountDetailPageState extends State<AccountDetailPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  bool _isLoading = true;
  int _currentTabIndex = 0;
  WCCustomerInfoResponse? _wcCustomerInfoResponse;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    _fetchWpUserData();
  }

  _fetchWpUserData() async {
    String? userToken = await readAuthToken();

    WCCustomerInfoResponse? wcCustomerInfoResponse;
    try {
      wcCustomerInfoResponse = await WPJsonAPI.instance
          .api((request) => request.wcCustomerInfo(userToken!));
    } on InvalidUserTokenException catch (_) {
      showToastNotification(
        context,
        title: trans("Oops!"),
        description: trans("Something went wrong"),
        style: ToastNotificationStyleType.DANGER,
      );
      await authLogout(context);
    } on Exception catch (_) {
      showToastNotification(
        context,
        title: trans("Oops!"),
        description: trans("Something went wrong"),
        style: ToastNotificationStyleType.DANGER,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }

    if (wcCustomerInfoResponse != null &&
        wcCustomerInfoResponse.status == 200) {
      setState(() {
        _wcCustomerInfoResponse = wcCustomerInfoResponse;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget? activeBody;
    if (_currentTabIndex == 0) {
      activeBody = AccountDetailOrdersWidget();
    } else if (_currentTabIndex == 1) {
      activeBody = AccountDetailSettingsWidget(
        refreshAccount: () {
          setState(() {
            _isLoading = true;
          });
          _fetchWpUserData();
        },
      );
    }

    if (activeBody == null) {
      return SizedBox.shrink();
    }
    String? userAvatar;
    String? userFirstName = "";
    String? userLastName = "";
    if (_wcCustomerInfoResponse != null &&
        _wcCustomerInfoResponse!.data != null) {
      userAvatar = _wcCustomerInfoResponse!.data!.avatar;

      userFirstName = _wcCustomerInfoResponse!.data!.firstName;
      userLastName = _wcCustomerInfoResponse!.data!.lastName;
    }
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 242, 244, 245),
      appBar: AppBar(
        elevation: 0,
        leading: widget.showLeadingBackButton
            ? Container(
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () => Navigator.pop(context),
                ),
                margin: EdgeInsets.only(left: 0),
              )
            : Container(),
        title: Text(trans("Account")),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: false,
      body: SafeAreaWidget(
        child: _isLoading
            ? AppLoaderWidget()
            : Column(
                children: <Widget>[
                  // Container(
                  //   margin: EdgeInsets.only(top: 10, bottom: 10),
                  //   padding: EdgeInsets.symmetric(horizontal: 16),
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.center,
                  //     mainAxisAlignment: MainAxisAlignment.start,
                  //     children: <Widget>[
                  //       Row(
                  //         crossAxisAlignment: CrossAxisAlignment.center,
                  //         mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //         children: <Widget>[
                  //           Container(
                  //             margin: EdgeInsets.only(top: 10),
                  //             child: userAvatar != null
                  //                 ? CircleAvatar(
                  //                     backgroundImage: NetworkImage(userAvatar),
                  //                   )
                  //                 : Icon(
                  //                     Icons.account_circle_rounded,
                  //                     size: 65,
                  //                   ),
                  //             height: 90,
                  //             width: 90,
                  //           ),
                  //           Expanded(
                  //             child: Padding(
                  //               child: Text(
                  //                 [userFirstName, userLastName]
                  //                     .where((t) => (t != null || t != ""))
                  //                     .toList()
                  //                     .join(" "),
                  //                 style: TextStyle(
                  //                   fontSize: 20,
                  //                   fontWeight: FontWeight.w600,
                  //                 ),
                  //               ),
                  //               padding: EdgeInsets.only(left: 16),
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //       Padding(
                  //         child: TabBar(
                  //           tabs: [
                  //             Tab(text: trans("Orders")),
                  //             Tab(text: trans("Settings")),
                  //           ],
                  //           controller: _tabController,
                  //           indicatorSize: TabBarIndicatorSize.tab,
                  //           labelColor: Colors.white,
                  //           unselectedLabelColor: Colors.black87,
                  //           indicator: BubbleTabIndicator(
                  //             indicatorHeight: 30.0,
                  //             indicatorRadius: 5,
                  //             indicatorColor: Colors.black87,
                  //             tabBarIndicatorSize: TabBarIndicatorSize.tab,
                  //           ),
                  //           onTap: _tabsTapped,
                  //         ),
                  //         padding: EdgeInsets.symmetric(vertical: 8),
                  //       ),
                  //     ],
                  //   ),
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(8),
                  //     boxShadow:
                  //         (Theme.of(context).brightness == Brightness.light)
                  //             ? wsBoxShadow()
                  //             : null,
                  //     color: ThemeColor.get(context).backgroundContainer,
                  //   ),
                  // ),
                  // Expanded(child: activeBody),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: userAvatar != null
                          ? CircleAvatar(
                              backgroundImage: NetworkImage(userAvatar),
                              radius: 70,
                            )
                          : CircleAvatar(
                              radius: 70,
                              child: Icon(
                                Icons.account_circle_rounded,
                                size: 65,
                              ),
                            ),
                    ),
                  ),
                  GreyBorder(
                      child: Column(
                    children: [
                      AccountListTile(
                        title: trans("Login"),
                        icon: Icon(Icons.lock_outline),
                        ontap: (() {
                          Navigator.pushNamed(context, "/account-landing");
                        }),
                      ),
                      Divider(
                        thickness: 1.5,
                      ),
                      AccountListTile(
                        title: trans("My Orders"),
                        icon: Icon(Icons.shopping_cart_outlined),
                        ontap: (() {
                          Navigator.pushNamed(context, "/account-landing");
                        }),
                      ),
                      Divider(
                        thickness: 1.5,
                      ),
                      AccountListTile(
                        title: trans("My Adresses"),
                        icon: Icon(Icons.location_on_outlined),
                        ontap: (() {
                          Navigator.pushNamed(context, "/account-landing");
                        }),
                      ),
                    ],
                  )),
                  SizedBox(),
                  GreyBorder(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AccountListTile(
                        ishead: false,
                        title: trans("My Coupons"),
                        ontap: (() {
                          Navigator.pushNamed(context, "/account-landing");
                        }),
                        // ontap: Navigator.pushNamed(context, "/account-delete"),
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      AccountListTile(
                        ishead: false,
                        title: trans("About Us"),
                        ontap: (() {
                          Navigator.pushNamed(context, "/account-landing");
                        }),
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      AccountListTile(
                        ishead: false,
                        title: trans("Account Setting"),
                        ontap: (() {
                          Navigator.pushNamed(context, "/account-landing");
                        }),
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      AccountListTile(
                        ishead: false,
                        title: trans("Notification"),
                        ontap: (() {
                          Navigator.pushNamed(context, "/account-landing");
                        }),

                        // ontap: Navigator.pushNamed(context, "/account-delete"),
                      ),
                      Divider(
                        thickness: 1.5,
                      ),
                      AccountListTile(
                        ishead: false,
                        title: trans("Contact Us"),
                        ontap: (() {
                          Navigator.pushNamed(context, "/account-landing");
                        }),
                      ),
                      Divider(
                        thickness: 1.5,
                      ),
                      AccountListTile(
                        ishead: false,
                        title: trans("Rate the App"),
                        ontap: (() {
                          Navigator.pushNamed(context, "/account-landing");
                        }),
                      ),
                      Divider(
                        thickness: 1.5,
                      ),
                      AccountListTile(
                        ishead: false,
                        title: trans("Clear History"),
                        ontap: (() {
                          Navigator.pushNamed(context, "/account-landing");
                        }),
                      ),
                    ],
                  ))
                ],
              ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  _tabsTapped(int i) {
    setState(() {
      _currentTabIndex = i;
    });
  }
}
