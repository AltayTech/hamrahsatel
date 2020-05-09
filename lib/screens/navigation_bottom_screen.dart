import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/Products.dart';
import '../provider/app_theme.dart';
import '../screens/cart_screen.dart';
import '../widgets/badge.dart';
import '../widgets/main_drawer.dart';
import 'home_screen.dart';
import 'product_screen.dart';

class NavigationBottomScreen extends StatefulWidget {
  static const routeName = '/NBS';

  @override
  _NavigationBottomScreenState createState() => _NavigationBottomScreenState();
}

class _NavigationBottomScreenState extends State<NavigationBottomScreen>
    with SingleTickerProviderStateMixin {
  bool isLogin;
  int _selectedPageIndex = 0;
  final searchTextController = TextEditingController();
  AnimationController _controller;
  Animation<Offset> _slideAnimation;
  Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 600,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(-0.9, -3),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.ease,
      ),
    );
    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.ease,
      ),
    );
  }

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
    _controller.dispose();

    super.dispose();
  }

//  final List<Map<String, Object>> _pages = [
//    {
//      'page': HomeScreeen(),
//      'title': Strings.navHome,
//    },
//    {
//      'page': QestCalculation(0.toString()),
//      'title': Strings.navQest,
//    },
//    {
//      'page': FavoriteView(),
//      'title': Strings.naveFavorite,
//    },
//    {
//      'page': ProfileView(),
//      'title': Strings.navProfile,
//    }
//  ];

//  void _selectBNBItem(int index) {
//    setState(
//      () {
//        _selectedPageIndex = index;
//      },
//    );
//  }

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
            title: Text(
              'همراه ساتل',
              style: TextStyle(
                fontFamily: 'Iransans',
              ),
            ),
            backgroundColor: AppTheme.appBarColor,
            iconTheme: new IconThemeData(color: AppTheme.appBarIconColor),
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                onPressed: () {
                  _controller.forward();

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
                onVerticalDragDown: (_) async {
                  _controller.reverse();
                  FocusScope.of(context).requestFocus(new FocusNode());

                  setState(() {});
                },
                onTap: () async {
                  _controller.reverse();
                  FocusScope.of(context).requestFocus(new FocusNode());

                  setState(() {});
                },
//                child: _pages[_selectedPageIndex]['page'],
                child: HomeScreen(),
              ),

              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: AnimatedContainer(
                  duration: _controller.duration,
                  curve: Curves.easeIn,
                  child: ScaleTransition(
                    scale: _opacityAnimation,
                    child: FadeTransition(
                      opacity: _opacityAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: Center(
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
                                          FocusScope.of(context).requestFocus(new FocusNode());

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
                                              .sBrand = brandsEndpoint;
                                          Provider.of<Products>(context,
                                              listen: false)
                                              .sColor = colorsEndpoint;
                                          Provider.of<Products>(context,
                                              listen: false)
                                              .sPriceRange = priceRange;
                                          Provider.of<Products>(context,
                                              listen: false)
                                              .sPage = 1;
                                          Provider.of<Products>(context,
                                              listen: false)
                                              .sSellCase = sellcaseEndpoint;
                                          Provider.of<Products>(context,
                                              listen: false)
                                              .searchBuilder();
                                          Provider.of<Products>(context,
                                              listen: false)
                                              .checkFiltered();

                                          Provider.of<Products>(context,
                                              listen: false)
                                              .searchBuilder();
                                          Provider.of<Products>(context,
                                              listen: false)
                                              .checkFiltered();
                                          Navigator.of(context).pushNamed(
                                              ProductsScreen.routeName,
                                              arguments: 0);
                                        },
                                        child: Icon(
                                          Icons.search,
                                          color: AppTheme.primary,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: TextFormField(
                                        textInputAction: TextInputAction.search,
                                        onFieldSubmitted: (_) {
                                          Provider.of<Products>(context,
                                              listen: false)
                                              .searchKey =
                                              searchTextController.text;
                                          Provider.of<Products>(context,
                                              listen: false)
                                              .searchBuilder();

                                          return Navigator.of(context)
                                              .pushNamed(
                                              ProductsScreen.routeName,
                                              arguments: 0);
                                        },
                                        controller: searchTextController,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintStyle: TextStyle(
                                            color: AppTheme.secondary,
                                            fontFamily: 'Iransans',
                                            fontSize: MediaQuery.of(context)
                                                .textScaleFactor *
                                                12.0,
                                          ),
                                          hintText: 'جستجوی محصولات ...',
                                          labelStyle: TextStyle(
                                            color: AppTheme.secondary,
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
                                            _controller.reverse();
                                            FocusScope.of(context).requestFocus(new FocusNode());

                                            setState(() {});
                                          },
                                          child: Icon(Icons.clear)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            ],
          ),
//          bottomNavigationBar: BottomNavigationBar(
//            elevation: 8,
//            selectedLabelStyle: TextStyle(
//                color: AppTheme.secondary,
//                fontFamily: 'Iransans',
//                fontSize: MediaQuery.of(context).textScaleFactor * 10.0),
//            onTap: _selectBNBItem,
//            backgroundColor: AppTheme.bg,
//            unselectedItemColor: Colors.grey,
//            selectedItemColor: AppTheme.secondary,
//            currentIndex: _selectedPageIndex,
//            items: [
//              BottomNavigationBarItem(
//                backgroundColor: AppTheme.bg,
//                icon: Icon(Icons.home),
//                title: Text(
//                  Strings.navHome,
//                ),
//              ),
//              BottomNavigationBarItem(
//                backgroundColor: AppTheme.bg,
//                icon: Icon(Icons.format_list_numbered_rtl),
//                title: Text(
//                  Strings.navQest,
//                ),
//              ),
//              BottomNavigationBarItem(
//                backgroundColor: AppTheme.bg,
//                icon: Icon(Icons.favorite),
//                title: Text(
//                  Strings.naveFavorite,
//                ),
//              ),
//              BottomNavigationBarItem(
//                backgroundColor: AppTheme.bg,
//                icon: Icon(Icons.account_circle),
//                title: Text(
//                  Strings.navProfile,
//                ),
//              ),
//            ],
//          ),
        ),
      ),
    );
  }
}
