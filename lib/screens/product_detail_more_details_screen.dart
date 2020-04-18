import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';

import '../classes/app_theme.dart';
import '../models/color_code.dart';
import '../models/product.dart';
import '../provider/Products.dart';
import '../provider/auth.dart';
import '../provider/customer_info.dart';
import '../widgets/main_drawer.dart';

class ProductDetailMoreDetailScreen extends StatefulWidget {
  static const routeName = '/productDetailMoreDetailsScreen';

  ColorCode color_selected;

  @override
  _ProductDetailMoreDetailScreenState createState() =>
      _ProductDetailMoreDetailScreenState();
}

class _ProductDetailMoreDetailScreenState
    extends State<ProductDetailMoreDetailScreen> {
  int _current = 0;
  var _isLoading;

  bool _isInit = true;

  final List<Map<String, IconData>> mainSp = [
    {'صفحه نمایش': Icons.photo_size_select_actual},
    {'حافظه': Icons.sd_storage},
    {'دوربین': Icons.camera_alt},
    {'Ram': Icons.memory},
  ];

  final List<Color> colorList = [
    Color(0xffFF6D6B),
    Color(0xff2196F3),
    Color(0xffA67FEC),
    Color(0xffA67FEC),
    Color(0xff255F85),
    Color(0xffED8A19),
  ];
  final List<Color> colors = [Colors.blue, Colors.green];

  Product loadedProduct;
  String _snackBarMessage = '';

  var _selectedColorIndex = 0;
  var _selectedColor;

  bool isLogin;


  @override
  void didChangeDependencies() {
    if (_isInit) {
      searchItems();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> searchItems() async {
    setState(() {
      _isLoading = true;
    });
    loadedProduct = ModalRoute.of(context).settings.arguments as Product;

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> addToShoppingcart(
      Product loadedProduct, var _selectedColor, bool isLogin) async {
    setState(() {
      _isLoading = true;
    });

    await Provider.of<Products>(context, listen: false)
        .addShopCart(loadedProduct, _selectedColor, 1, isLogin);
    print(_isLoading.toString());
    print(_isLoading.toString());

    setState(() {
      _isLoading = false;
      print(_isLoading.toString());
    });
    print(_isLoading.toString());
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;
    var currencyFormat = intl.NumberFormat.decimalPattern();
    _selectedColor = loadedProduct.color[0];

    isLogin = Provider.of<Auth>(context).isAuth;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppTheme.appBarColor,
          iconTheme: new IconThemeData(color: AppTheme.appBarIconColor),
          elevation: 0,
          centerTitle: true,
        ),
        body: Directionality(
          textDirection: TextDirection.ltr,
          child: Align(
            alignment: Alignment.center,
            child: _isLoading
                ? SpinKitFadingCircle(
                    itemBuilder: (BuildContext context, int index) {
                      return DecoratedBox(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: index.isEven ? Colors.grey : Colors.grey,
                        ),
                      );
                    },
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 15.0, right: 15),
                          child: Text(
                            'مشخصات',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppTheme.h1,
                              fontFamily: 'Iransans',
                              fontSize: textScaleFactor * 16.0,
                            ),
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: HtmlWidget(
                              loadedProduct.content,
                              onTapUrl: (url) => showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: Text('onTapUrl'),
                                  content: Text(url),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
        drawer: Theme(
          data: Theme.of(context).copyWith(
            // Set the transparency here
            canvasColor: Colors
                .transparent, //or any other color you want. e.g Colors.blue.withOpacity(0.5)
          ),
          child: MainDrawer(),
        ),
//          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: Builder(
          builder: (context) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              direction: Axis.vertical,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: FloatingActionButton(
                    heroTag: Hero(
                      child: Container(),
                      tag: 'share',
                    ),
                    onPressed: () {},
                    backgroundColor: AppTheme.bg,
                    child: Icon(
                      Icons.share,
                      color: AppTheme.h1,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: FloatingActionButton(
                    heroTag: Hero(
                      child: Container(),
                      tag: 'favorite',
                    ),
                    onPressed: () {
                      Provider.of<CustomerInfo>(context, listen: false)
                          .addFavorite(loadedProduct.id, 'add');
                      _snackBarMessage =
                          'محصول با موفقیت به موارد مورد علاقه اضافه گردید!';
                      SnackBar addToCartSnackBar = SnackBar(
                        content: Text(
                          _snackBarMessage,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Iransans',
                            fontSize: textScaleFactor * 14.0,
                          ),
                        ),
                        action: SnackBarAction(
                          label: 'متوجه شدم',
                          onPressed: () {
                            // Some code to undo the change.
                          },
                        ),
                      );
                      Scaffold.of(context).showSnackBar(addToCartSnackBar);
                    },
                    backgroundColor: AppTheme.bg,
                    child: Icon(
                      Icons.favorite,
                      color: AppTheme.h1,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: FloatingActionButton(
                    heroTag: Hero(
                      child: Container(),
                      tag: 'shoppingCart',
                    ),
                    onPressed: () {
                      setState(() {});
                      if (loadedProduct.price_low.isEmpty) {
                        _snackBarMessage = 'قیمت محصول صفر میباشد';
                      } else {
                        _snackBarMessage =
                            'محصول با موفقیت به سبد اضافه گردید!';
                        _selectedColor == null
                            ? _selectedColor = loadedProduct.color
                            : _selectedColor =
                                loadedProduct.color[_selectedColorIndex];

                        setState(() {
                          _isLoading = true;
                        });

                        Provider.of<Products>(context, listen: false)
                            .addShopCart(
                                loadedProduct, _selectedColor, 1, isLogin)
                            .then((_) {
                          setState(() {
                            _isLoading = false;
                            print(_isLoading.toString());
                          });
                        });
                      }

                      SnackBar addToCartSnackBar = SnackBar(
                        content: Text(
                          _snackBarMessage,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Iransans',
                            fontSize: textScaleFactor * 14.0,
                          ),
                        ),
                        action: SnackBarAction(
                          label: 'متوجه شدم',
                          onPressed: () {
                            // Some code to undo the change.
                          },
                        ),
                      );
                      Scaffold.of(context).showSnackBar(addToCartSnackBar);
                    },
                    backgroundColor: AppTheme.primary,
                    child: Icon(
                      Icons.add_shopping_cart,
                      color: AppTheme.bg,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
