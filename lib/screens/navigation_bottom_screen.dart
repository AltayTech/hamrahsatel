import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hamrahsatel/screens/product_screen.dart';
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

class NavigationBottomScreen extends StatefulWidget {
  static const routeName = '/NBS';

  @override
  _NavigationBottomScreenState createState() => _NavigationBottomScreenState();
}

class _NavigationBottomScreenState extends State<NavigationBottomScreen> {
  bool isLogin;
  int _selectedPageIndex = 0;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
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
//              SafeArea(
//                child: SearchBar<Post>(
//                  searchBarPadding: EdgeInsets.symmetric(horizontal: 10),
//                  headerPadding: EdgeInsets.symmetric(horizontal: 10),
//                  listPadding: EdgeInsets.symmetric(horizontal: 10),
//                  onSearch: _getALlPosts,
//                  searchBarController: _searchBarController,
//                  placeHolder: Text("placeholder"),
//                  cancellationWidget: Text("Cancel"),
//                  emptyWidget: Text("empty"),
//                  indexedScaledTileBuilder: (int index) => ScaledTile.count(1, index.isEven ? 2 : 1),
//                  header: Row(
//                    children: <Widget>[
//                      RaisedButton(
//                        child: Text("sort"),
//                        onPressed: () {
//                          _searchBarController.sortList((Post a, Post b) {
//                            return a.body.compareTo(b.body);
//                          });
//                        },
//                      ),
//                      RaisedButton(
//                        child: Text("Desort"),
//                        onPressed: () {
//                          _searchBarController.removeSort();
//                        },
//                      ),
//                      RaisedButton(
//                        child: Text("Replay"),
//                        onPressed: () {
//                          isReplay = !isReplay;
//                          _searchBarController.replayLastSearch();
//                        },
//                      ),
//                    ],
//                  ),
//                  onCancelled: () {
//                    print("Cancelled triggered");
//                  },
//                  mainAxisSpacing: 10,
//                  crossAxisSpacing: 10,
//                  crossAxisCount: 2,
//                  onItemFound: (Post post, int index) {
//                    return Container(
//                      color: Colors.lightBlue,
//                      child: ListTile(
//                        title: Text(post.title),
//                        isThreeLine: true,
//                        subtitle: Text(post.body),
//                        onTap: () {
//                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => Detail()));
//                        },
//                      ),
//                    );
//                  },
//                ),
//              ),
              IconButton(
                onPressed: () {
                  String brandsEndpoint = '';
                  String colorsEndpoint = '';
                  String sellcaseEndpoint = '';
                  String priceRange = '';
                  Provider.of<Products>(context, listen: false)
                      .filterTitle
                      .clear();

                  Provider.of<Products>(context, listen: false).searchKey = '';

                  Provider.of<Products>(context, listen: false).sbrand =
                      brandsEndpoint;
                  Provider.of<Products>(context, listen: false).scolor =
                      colorsEndpoint;
                  Provider.of<Products>(context, listen: false).spriceRange =
                      priceRange;
                  Provider.of<Products>(context, listen: false).spage = 1;
                  Provider.of<Products>(context, listen: false).ssellcase =
                      sellcaseEndpoint;
                  Provider.of<Products>(context, listen: false).searchBuilder();
                  Provider.of<Products>(context, listen: false).checkfiltered();

                  Provider.of<Products>(context, listen: false).searchBuilder();
                  Provider.of<Products>(context, listen: false).checkfiltered();
                  Navigator.of(context)
                      .pushNamed(ProductsScreen.routeName, arguments: 0);
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
          body: _pages[_selectedPageIndex]['page'],
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
