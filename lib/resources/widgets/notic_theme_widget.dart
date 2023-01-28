

import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/app/models/bottom_nav_item.dart';
import 'package:flutter_app/bootstrap/app_helper.dart';
import 'package:flutter_app/bootstrap/shared_pref/sp_auth.dart';
import 'package:flutter_app/resources/pages/account_detail_page.dart';
import 'package:flutter_app/resources/pages/account_landing_page.dart';
import 'package:flutter_app/resources/pages/cart_page.dart';
import 'package:flutter_app/resources/pages/wishlist_page_widget.dart';
import 'package:flutter_app/resources/pages/home_search_page.dart';
import 'package:flutter_app/resources/widgets/app_loader_widget.dart';
import 'package:flutter_app/resources/widgets/notic_home_widget.dart';
import 'package:woosignal/models/response/woosignal_app.dart';

import '../../bootstrap/helpers.dart';
import '../pages/browse_category_page.dart';

class NoticThemeWidget extends StatefulWidget {
  NoticThemeWidget(
      {Key? key, required this.globalKey, required this.wooSignalApp})
      : super(key: key);
  final GlobalKey globalKey;
  final WooSignalApp? wooSignalApp;

  @override
  _NoticThemeWidgetState createState() => _NoticThemeWidgetState();
}

class _NoticThemeWidgetState extends State<NoticThemeWidget> {
  Widget? activeWidget;

  int _currentIndex = 2;
  // List<BottomNavItem>? allNavWidgets;
  List<TabItem>? allNavTabWidgets;

  @override
  void initState() {
    super.initState();

    activeWidget = NoticHomeWidget(wooSignalApp: widget.wooSignalApp);
    _loadTabs();
  }

  _loadTabs() async {
    // allNavWidgets = await bottomNavWidgets();
    // setState(() {});

    allNavTabWidgets = await bottomNavWidgets();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // convex tab widget
    List<Widget> tabWidget = [
      HomeSearchPage(),
      // BrowseCategoryPage(),
      CartPage(),
      NoticHomeWidget(wooSignalApp: widget.wooSignalApp),
      AccountDetailPage(showLeadingBackButton: false),
      WishListPageWidget(),
    ];
    return Scaffold(
        body: activeWidget,
        resizeToAvoidBottomInset: false,
        bottomNavigationBar:
            //  allNavWidgets == null
            allNavTabWidgets == null
                ? AppLoaderWidget()
                :
                //  BottomNavigationBar(
                //     onTap: (currentIndex) =>
                //         _changeMainWidget(currentIndex, allNavWidgets!),
                //     currentIndex: _currentIndex,
                //     unselectedItemColor: Colors.white,
                //     // fixedColor: Colors.white,
                //     selectedLabelStyle: TextStyle(color: Colors.white),
                //     unselectedLabelStyle: TextStyle(
                //       color: Colors.white,
                //     ),
                //     showSelectedLabels: false,
                //     showUnselectedLabels: true,
                //     items:
                //         allNavWidgets!.map((e) => e.bottomNavigationBarItem).toList(),
                //   ),
                ConvexAppBar(
                    initialActiveIndex: _currentIndex,
                    style: TabStyle.fixedCircle,
                    backgroundColor: Color.fromARGB(255, 49, 6, 122),
                    activeColor: Colors.white,
                    color: Colors.white,
                    disableDefaultTabController: true,
                    top: -15,
                    // height: MediaQuery.of(context).size.height * 0.1,
                    onTap:
                        //  (currentIndex) =>
                        //     _changeMainWidget(currentIndex, allNavTabWidgets!),
                        (currentIndex) {
                      _currentIndex = currentIndex;
                      activeWidget = tabWidget[currentIndex];
                      setState(() {});
                    },
                    items: allNavTabWidgets!

                    // allNavWidgets!.map((e) => e.bottomNavigationBarItem).toList(),
                    ));
  }

  // Future<List<BottomNavItem>> bottomNavWidgets() async {
  //   List<BottomNavItem> items = [];
  //   items.add(
  //     BottomNavItem(
  //         id: 1,
  //         bottomNavigationBarItem: BottomNavigationBarItem(
  //           icon: Icon(Icons.search),
  //           label: 'Search',
  //         ),
  //         tabWidget: HomeSearchPage()),
  //   );

  //   items.add(BottomNavItem(
  //     id: 2,
  //     bottomNavigationBarItem: BottomNavigationBarItem(
  //         icon: Icon(Icons.shopping_cart_outlined), label: 'Cart'),
  //     tabWidget: CartPage(),
  //   ));

  //   items.add(
  //     BottomNavItem(
  //         id: 3,
  //         bottomNavigationBarItem: BottomNavigationBarItem(
  //           activeIcon: Icon(
  //             Icons.home,
  //             size: 40,
  //           ),
  //           icon: Icon(
  //             Icons.home,
  //           ),
  //           backgroundColor: Colors.deepPurple,
  //           label: 'Home',
  //         ),
  //         tabWidget: NoticHomeWidget(wooSignalApp: widget.wooSignalApp)),
  //   );

  //   if (AppHelper.instance.appConfig!.wpLoginEnabled == 1) {
  //     items.add(BottomNavItem(
  //       id: 4,
  //       bottomNavigationBarItem:
  //           BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
  //       tabWidget:
  // (await authCheck())
  //           ? AccountDetailPage(showLeadingBackButton: false)
  //           : AccountLandingPage(
  //               showBackButton: false,
  //             ),
  //     ))
  // ;
  //   }
  //   if (AppHelper.instance.appConfig!.wishlistEnabled == true) {
  //     items.add(BottomNavItem(
  //       id: 5,
  //       bottomNavigationBarItem: BottomNavigationBarItem(
  //         icon: Icon(Icons.favorite_border),
  //         label: 'Wishlist',
  //       ),
  //       tabWidget: WishListPageWidget(),
  //     ));
  //   }
  //   return items;
  // }

// convextab bar item

  Future<List<TabItem>> bottomNavWidgets() async {
    List<TabItem> items = [];
    items.add(
        // BottomNavItem(
        //     id: 1,
        //     bottomNavigationBarItem: BottomNavigationBarItem(
        //       icon: Icon(Icons.search),
        //       label: 'Search',
        //     ),
        //     tabWidget: HomeSearchPage()),
        TabItem(
      icon: Icon(
        Icons.search,
        // color: ThemeColor.get(context).bottomTabBarIconSelected
      ),
      title: 'Search',
    ));

    items.add(
        //   BottomNavItem(
        //   id: 2,
        //   bottomNavigationBarItem: BottomNavigationBarItem(
        //       icon: Icon(Icons.shopping_cart_outlined), label: 'Cart'),
        //   tabWidget: CartPage(),
        // )
        TabItem(
      icon: Icon(Icons.shopping_cart_outlined),
      title: 'Cart',
    ));

    items.add(
        // BottomNavItem(
        //     id: 3,
        //     bottomNavigationBarItem: BottomNavigationBarItem(
        //       activeIcon: Icon(
        //         Icons.home,
        //         size: 40,
        //       ),
        //       icon: Icon(
        //         Icons.home,
        //       ),
        //       backgroundColor: Colors.deepPurple,
        //       label: 'Home',
        //     ),
        //     tabWidget: NoticHomeWidget(wooSignalApp: widget.wooSignalApp)),
        TabItem(
      icon: Icon(
        Icons.home,
        color: Color.fromARGB(255, 49, 6, 122),
        size: 40,
      ),
      // title: 'Home',
    ));

    if (AppHelper.instance.appConfig!.wpLoginEnabled == 1) {
      items.add(
          // BottomNavItem(
          //   id: 4,
          //   bottomNavigationBarItem:
          //       BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
          //   tabWidget: (await authCheck())
          //       ? AccountDetailPage(showLeadingBackButton: false)
          //       : AccountLandingPage(
          //           showBackButton: false,
          //         ),
          // ));
          TabItem(
        icon: Icon(Icons.person),
        title: 'Account',
      ));
    }
    if (AppHelper.instance.appConfig!.wishlistEnabled == true) {
      items.add(
          //   BottomNavItem(
          //   id: 5,
          //   bottomNavigationBarItem: BottomNavigationBarItem(
          //     icon: Icon(Icons.favorite_border),
          //     label: 'Wishlist',
          //   ),
          //   tabWidget: WishListPageWidget(),
          // ));
          TabItem(
        icon: Icon(Icons.favorite_border),
        title: 'Wishlist',
      ));
    }
    return items;
  }

  // _changeMainWidget(
  //     int currentIndex, List<BottomNavItem> bottomNavWidgets) async {
  //   _currentIndex = currentIndex;
  //   activeWidget = bottomNavWidgets[_currentIndex].tabWidget;
  //   setState(() {});
  // }

  // _changeTabMainWidget(int currentIndex, List<TabItem> bottomNavWidgets) async {
  //   List<Widget> tabWidget = [HomeSearchPage(), ];
  //   _currentIndex = currentIndex;
  //   activeWidget = bottomNavWidgets[_currentIndex].tabWidget;
  //   setState(() {});
  // }
}
