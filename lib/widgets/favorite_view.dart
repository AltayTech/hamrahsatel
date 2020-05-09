import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../provider/app_theme.dart';
import 'package:provider/provider.dart';

import '../models/productFavorite.dart';
import '../provider/auth.dart';
import '../customer_info.dart';
import '../screens/customer_info/login_screen.dart';
import 'product_item_favorite_screen.dart';

class FavoriteView extends StatefulWidget {
  static const routeName = '/favorite_view';

  @override
  _FavoriteViewState createState() => _FavoriteViewState();
}

class _FavoriteViewState extends State<FavoriteView> {
  var _isLoading;

  bool _isInit = true;

  List<ProductFavorite> loadedProducts = [];

  @override
  void didChangeDependencies() {
    if (_isInit) {
      getFavProducts();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> getFavProducts() async {
    setState(() {
      _isLoading = true;
    });

    await Provider.of<CustomerInfo>(context, listen: false).getFavorite();
    loadedProducts = Provider.of<CustomerInfo>(context,listen:false).favoriteProducts;
    setState(() {
      _isLoading = false;
      print(_isLoading.toString());
    });
    print(_isLoading.toString());
  }

  @override
  Widget build(BuildContext context) {
    bool isLogin = Provider.of<Auth>(context).isAuth;
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    return !isLogin
        ? Container(
            child: Center(
              child: Wrap(
                direction: Axis.vertical,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('شما وارد نشده اید'),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(LoginScreen.routeName);
                    },
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          'ورود به اکانت کاربری',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      decoration: BoxDecoration(
                          color: AppTheme.primary,
                          borderRadius: BorderRadius.circular(5)),
                    ),
                  )
                ],
              ),
            ),
          )
        : Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: deviceHeight * 0.9,
                  child: GridView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: loadedProducts.length,
                    itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                      value: loadedProducts[i],
                      child: ProductItemFavoriteScreen(),
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.65,
                      crossAxisSpacing: 3,
                      mainAxisSpacing: 5,
                    ),
                  ),
                ),
              ),
              Positioned(
                height: deviceHeight * 0.8,
                left: 0,
                right: 0,
                child: Align(
                    alignment: Alignment.center,
                    child: _isLoading
                        ? SpinKitFadingCircle(
                            itemBuilder: (BuildContext context, int index) {
                              return DecoratedBox(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      index.isEven ? Colors.grey : Colors.grey,
                                ),
                              );
                            },
                          )
                        : Container()),
              ),
            ],
          );
  }
}
