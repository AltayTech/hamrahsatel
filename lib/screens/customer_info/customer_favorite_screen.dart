import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../provider/app_theme.dart';
import '../../models/customer.dart';
import '../../widgets/favorite_view.dart';
import '../../widgets/main_drawer.dart';

class CustomerFavoriteScreen extends StatefulWidget {
  static const routeName = '/customer_favorite_screen';
  final Customer customer;

  CustomerFavoriteScreen({this.customer});

  @override
  _CustomerFavoriteScreenState createState() => _CustomerFavoriteScreenState();
}

class _CustomerFavoriteScreenState extends State<CustomerFavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppTheme.appBarColor,
        iconTheme: new IconThemeData(color: AppTheme.appBarIconColor),
      ),

      endDrawer: Theme(
        data: Theme.of(context).copyWith(
          // Set the transparency here
          canvasColor: Colors
              .transparent, //or any other color you want. e.g Colors.blue.withOpacity(0.5)
        ),
        child: MainDrawer(),
      ), // resizeToAvoidBottomInset: false,
      body: FavoriteView(),
    );
  }
}
