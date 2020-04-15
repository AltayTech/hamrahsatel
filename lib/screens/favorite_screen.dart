import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../classes/app_theme.dart';
import '../provider/Products.dart';
import '../widgets/badge.dart';
import '../widgets/favorite_view.dart';
import '../widgets/main_drawer.dart';
import 'cart_screen.dart';

class FavoriteScreen extends StatefulWidget {
  static const routeName = '/favorite';

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {

  @override
  Widget build(BuildContext context) {

    return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
                appBar: AppBar(
                  backgroundColor: AppTheme.appBarColor,
                  iconTheme: new IconThemeData(color: AppTheme.appBarIconColor),
                  centerTitle: true,
                  actions: <Widget>[
                    Consumer<Products>(
                      builder: (_, products, ch) => Badge(
                        value: products.cartItemsCount.toString(),
                        child: ch,
                      ),
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(CartScreen.routeName);
                        },
                        color: AppTheme.appBarIconColor,
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
                body: FavoriteView()),
          );
  }
}
