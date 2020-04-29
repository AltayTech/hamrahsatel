import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../classes/app_theme.dart';
import '../classes/strings.dart';
import '../provider/Products.dart';
import '../screens/cart_screen.dart';
import '../widgets/badge.dart';
import '../widgets/favorite_view.dart';
import '../widgets/main_drawer.dart';
import '../widgets/profile_view.dart';
import '../widgets/qest_calculation.dart';
import 'home_screen.dart';
import 'product_screen.dart';

class NavigationBottomScreen extends StatefulWidget {
  static const routeName = '/NBS';

  @override
  _NavigationBottomScreenState createState() => _NavigationBottomScreenState();
}

class _NavigationBottomScreenState extends State<NavigationBottomScreen> {
  bool isLogin;
  int _selectedPageIndex = 0;
  bool inSearch = false;
  final searchTextController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<Products>(context, listen: false).retrieveShopCart();
  }

  void selectBNBItem(int index) {
    setState(
      () {
        _selectedPageIndex = index;
      },
    );
  }

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }

  final List<Map<String, Object>> _pages = [
    {
      'page': HomeScreeen(),
      'title': Strings.navHome,
    },
    {
      'page': QestCalculation(0.toString()),
      'title': Strings.navQest,
    },
    {
      'page': FavoriteView(),
      'title': Strings.naveFavorite,
    },
    {
      'page': ProfileView(),
      'title': Strings.navProfile,
    }
  ];

  void _selectBNBItem(int index) {
    setState(
      () {
        _selectedPageIndex = index;
      },
    );
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            contentTextStyle: TextStyle(
                color: AppTheme.bg,
                fontFamily: 'Iransans',
                fontSize: MediaQuery.of(context).textScaleFactor * 15.0),
            title: Text('خروج از اپلیکیشن'),
            content: Text('آیا میخواهید از اپلیکیشن خارج شوید؟'),
            actions: <Widget>[
              GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: Text("نه"),
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: () {
//                  Navigator.of(context).popUntil(ModalRoute.withName(LoginScreen.routeName));
                  Navigator.of(context).pop(true);
                },
                child: Text("بلی"),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppTheme.appBarColor,
            iconTheme: new IconThemeData(color: AppTheme.appBarIconColor),
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                onPressed: () {
                  inSearch = true;
                  setState(() {});
                },
                color: AppTheme.bg,
                icon: Icon(
                  Icons.search,
                ),
              ),
              Consumer<Products>(
                builder: (_, products, ch) => Badge(
                  color: products.cartItemsCount == 0
                      ? AppTheme.accent
                      : AppTheme.secondary,
                  value: products.cartItemsCount.toString(),
                  child: ch,
                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(CartScreen.routeName);
                  },
                  color: AppTheme.bg,
                  icon: Icon(
                    Icons.shopping_cart,
                  ),
                ),
              ),
            ],
          ),
          drawer: Theme(
            data: Theme.of(context).copyWith(
              // Set the transparency here
              canvasColor: Colors
                  .transparent, //or any other color you want. e.g Colors.blue.withOpacity(0.5)
            ),
            child: MainDrawer(),
          ),
          body: Stack(
            children: <Widget>[
              GestureDetector(
                onVerticalDragDown: (_) {
                  if (inSearch) {
                    inSearch = false;
                    setState(() {});
                  }
                },
                onTap: () {
                  if (inSearch) {
                    inSearch = false;
                    setState(() {});
                  }
                },
                child: _pages[_selectedPageIndex]['page'],
              ),
              inSearch
                  ? Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: AppBar().preferredSize.height,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppTheme.secondary,
                              width: 0.6,
                            ),
                          ),
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                    onTap: () {
                                      String brandsEndpoint = '';
                                      String colorsEndpoint = '';
                                      String sellcaseEndpoint = '';
                                      String priceRange = '';
                                      Provider.of<Products>(context,
                                              listen: false)
                                          .filterTitle
                                          .clear();

                                      Provider.of<Products>(context,
                                                  listen: false)
                                              .searchKey =
                                          searchTextController.text;

                                      Provider.of<Products>(context,
                                              listen: false)
                                          .sbrand = brandsEndpoint;
                                      Provider.of<Products>(context,
                                              listen: false)
                                          .scolor = colorsEndpoint;
                                      Provider.of<Products>(context,
                                              listen: false)
                                          .spriceRange = priceRange;
                                      Provider.of<Products>(context,
                                              listen: false)
                                          .spage = 1;
                                      Provider.of<Products>(context,
                                              listen: false)
                                          .ssellcase = sellcaseEndpoint;
                                      Provider.of<Products>(context,
                                              listen: false)
                                          .searchBuilder();
                                      Provider.of<Products>(context,
                                              listen: false)
                                          .checkfiltered();

                                      Provider.of<Products>(context,
                                              listen: false)
                                          .searchBuilder();
                                      Provider.of<Products>(context,
                                              listen: false)
                                          .checkfiltered();
                                      Navigator.of(context).pushNamed(
                                          ProductsScreen.routeName,
                                          arguments: 0);
                                    },
                                    child: Icon(Icons.search)),
                              ),
                              Expanded(
                                child: TextFormField(
                                  textInputAction: TextInputAction.search,
                                  onFieldSubmitted: (_) {
                                    Provider.of<Products>(context,
                                            listen: false)
                                        .searchKey = searchTextController.text;
                                    Provider.of<Products>(context,
                                            listen: false)
                                        .searchBuilder();

                                    return Navigator.of(context).pushNamed(
                                        ProductsScreen.routeName,
                                        arguments: 0);
                                  },
                                  controller: searchTextController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(
                                      color: Colors.blue,
                                      fontFamily: 'Iransans',
                                      fontSize: MediaQuery.of(context)
                                              .textScaleFactor *
                                          12.0,
                                    ),
                                    hintText: 'جستجوی محصولات ...',
                                    labelStyle: TextStyle(
                                      color: Colors.blue,
                                      fontFamily: 'Iransans',
                                      fontSize: MediaQuery.of(context)
                                              .textScaleFactor *
                                          10.0,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                    onTap: () {
                                      inSearch = false;
                                      setState(() {});
                                    },
                                    child: Icon(Icons.clear)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            elevation: 8,
            selectedLabelStyle: TextStyle(
                color: AppTheme.secondary,
                fontFamily: 'Iransans',
                fontSize: MediaQuery.of(context).textScaleFactor * 10.0),
            onTap: _selectBNBItem,
            backgroundColor: AppTheme.bg,
            unselectedItemColor: Colors.grey,
            selectedItemColor: AppTheme.secondary,
            currentIndex: _selectedPageIndex,
            items: [
              BottomNavigationBarItem(
                backgroundColor: AppTheme.bg,
                icon: Icon(Icons.home),
                title: Text(
                  Strings.navHome,
                ),
              ),
              BottomNavigationBarItem(
                backgroundColor: AppTheme.bg,
                icon: Icon(Icons.format_list_numbered_rtl),
                title: Text(
                  Strings.navQest,
                ),
              ),
              BottomNavigationBarItem(
                backgroundColor: AppTheme.bg,
                icon: Icon(Icons.favorite),
                title: Text(
                  Strings.naveFavorite,
                ),
              ),
              BottomNavigationBarItem(
                backgroundColor: AppTheme.bg,
                icon: Icon(Icons.account_circle),
                title: Text(
                  Strings.navProfile,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
