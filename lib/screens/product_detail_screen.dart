import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hamrahsatel/models/color_code.dart';
import 'package:hamrahsatel/screens/product_detail_more_details_screen.dart';
import 'package:hamrahsatel/widgets/custom_dialog_select_color.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../classes/app_theme.dart';
import '../classes/flutter_carousel_slider.dart';
import '../models/product.dart';
import '../provider/Products.dart';
import '../provider/auth.dart';
import '../provider/customer_info.dart';
import '../widgets/badge.dart';
import '../widgets/en_to_ar_number_convertor.dart';
import '../widgets/main_drawer.dart';
import 'cart_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  static const routeName = '/productDetailScreen';

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _current = 0;
  var _isLoading;

  bool _isInit = true;

  Product loadedProduct;
  String _snackBarMessage = '';

  var _selectedColorIndex = 0;
  var _selectedColor;

  bool isLogin;

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      await searchItems();
      loadedProduct = Provider.of<Products>(context).findById();
      _selectedColor = loadedProduct.color[0];

      isLogin = Provider.of<Auth>(context).isAuth;
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> searchItems() async {
    setState(() {
      _isLoading = true;
    });
    final productId = ModalRoute.of(context).settings.arguments as int;
    await Provider.of<Products>(context, listen: false).retrieveItem(productId);

    setState(() {
      _isLoading = false;
      print(_isLoading.toString());
    });
    print(_isLoading.toString());
  }

  Future<void> addToShoppingcart(
      Product loadedProduct, var _selectedColor, bool isLogin) async {
    setState(() {
      _isLoading = true;
    });

    await Provider.of<Products>(context, listen: false)
        .addShopCart(loadedProduct, _selectedColor, 1, isLogin);

    setState(() {
      _isLoading = false;
      print(_isLoading.toString());
    });
    print(_isLoading.toString());
  }

  Future<void> addtoshopFromDialogBox(ColorCode selectedColor) async {
    setState(() {
      _isLoading = true;
    });

    _snackBarMessage = 'محصول با موفقیت به سبد اضافه گردید!';
//    _selectedColor == null
//        ? _selectedColor = loadedProduct.color
//        : _selectedColor =
//    loadedProduct.color[_selectedColorIndex];
    _selectedColor = selectedColor;
    setState(() {
      _isLoading = true;
    });

    Provider.of<Products>(context, listen: false)
        .addShopCart(loadedProduct, _selectedColor, 1, isLogin)
        .then((_) {
      setState(() {
        _isLoading = false;
        print(_isLoading.toString());
      });
    });

    setState(() {
      _isLoading = false;
      print(_isLoading.toString());
    });
    print(_isLoading.toString());
  }

  Future<void> _showColorSelectiondialog(Function addToCart) {
    return showDialog(
      context: context,
      builder: (ctx) => CustomDialogSelectColor(
        product: loadedProduct,
        function: addToCart,
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;
    var currencyFormat = intl.NumberFormat.decimalPattern();

    Widget priceWidget() {
      if (loadedProduct.price.price_without_discount ==
          loadedProduct.price.price) {
        return Text(
          loadedProduct.price.price_without_discount.isNotEmpty
              ? EnArConvertor().replaceArNumber(currencyFormat
                  .format(
                      double.parse(loadedProduct.price.price_without_discount))
                  .toString())
              : EnArConvertor().replaceArNumber('0'),
          style: TextStyle(
            color: AppTheme.primary,
            fontFamily: 'Iransans',
            fontSize: textScaleFactor * 20.0,
          ),
        );
      } else if (loadedProduct.price.price_without_discount == '0' ||
          loadedProduct.price.price_without_discount.isEmpty) {
        return Text(
          loadedProduct.price.price.isNotEmpty
              ? EnArConvertor().replaceArNumber(currencyFormat
                  .format(double.parse(loadedProduct.price.price))
                  .toString())
              : EnArConvertor().replaceArNumber('0'),
          style: TextStyle(
            color: AppTheme.primary,
            fontFamily: 'Iransans',
            fontSize: textScaleFactor * 20.0,
          ),
        );
      } else if (loadedProduct.price.price == '0' ||
          loadedProduct.price.price.isEmpty) {
        return Text(
          loadedProduct.price.price_without_discount.isNotEmpty
              ? EnArConvertor().replaceArNumber(currencyFormat
                  .format(
                      double.parse(loadedProduct.price.price_without_discount))
                  .toString())
              : EnArConvertor().replaceArNumber('0'),
          style: TextStyle(
            color: AppTheme.primary,
            fontFamily: 'Iransans',
            fontSize: textScaleFactor * 20.0,
          ),
        );
      } else {
        return Wrap(
          direction: Axis.vertical,
          children: <Widget>[
            Text(
              loadedProduct.price.price_without_discount.isNotEmpty
                  ? EnArConvertor().replaceArNumber(currencyFormat
                      .format(double.parse(
                          loadedProduct.price.price_without_discount))
                      .toString())
                  : EnArConvertor().replaceArNumber('0'),
              style: TextStyle(
                decoration: TextDecoration.lineThrough,
                color: AppTheme.text,
                fontFamily: 'Iransans',
                fontSize: textScaleFactor * 16.0,
              ),
            ),
            Text(
                loadedProduct.price.price.isNotEmpty
                    ? EnArConvertor().replaceArNumber(currencyFormat
                        .format(double.parse(loadedProduct.price.price))
                        .toString())
                    : EnArConvertor().replaceArNumber('0'),
                style: TextStyle(
                  color: AppTheme.primary,
                  fontFamily: 'Iransans',
                  fontSize: textScaleFactor * 20.0,
                ))
          ],
        );
      }
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppTheme.appBarColor,
          iconTheme: new IconThemeData(color: AppTheme.appBarIconColor),
          elevation: 0,
          centerTitle: true,
          actions: <Widget>[
            Consumer<Products>(
              builder: (_, products, ch) => Badge(
                color: products.cartItemsCount == 0
                    ? AppTheme.text
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
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0, right: 15),
                          child: Text(
                            loadedProduct.title,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    'تومان',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontFamily: 'Iransans',
                                      fontSize: textScaleFactor * 16.0,
                                    ),
                                  ),
                                  priceWidget(),
                                ],
                              ),
                            ),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                loadedProduct.brand[0].title,
                                style: TextStyle(
                                  color: AppTheme.primary,
                                  fontFamily: 'Iransans',
                                  fontSize: textScaleFactor * 16.0,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  ProductDetailMoreDetailScreen.routeName,
                                  arguments: loadedProduct,
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: AppTheme.secondary),
                                  color: AppTheme.bg,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 8.0,
                                    bottom: 4,
                                    left: 15,
                                    right: 15,
                                  ),
                                  child: Text(
                                    'جزئیات',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontFamily: 'Iransans',
                                      fontSize: textScaleFactor * 16.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: double.infinity,
                          height: deviceHeight * 0.55,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5)),
                          child: Stack(
                            children: [
                              CarouselSlider(
                                aspectRatio: 11 / 9,
                                viewportFraction: 1.0,
                                initialPage: 0,
                                enableInfiniteScroll: true,
                                reverse: false,
                                autoPlay: false,
                                autoPlayInterval: Duration(seconds: 3),
                                autoPlayAnimationDuration:
                                    Duration(milliseconds: 800),
                                pauseAutoPlayOnTouch: Duration(seconds: 10),
                                enlargeCenterPage: true,
                                scrollDirection: Axis.horizontal,
                                onPageChanged: (index) {
                                  _current = index;
                                  setState(() {});
                                },
                                items: loadedProduct.gallery.map((gallery) {
                                  return Builder(
                                    builder: (BuildContext context) {
                                      return Container(
                                          width: deviceWidth,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 5.0),
                                          child: FadeInImage(
                                            placeholder: AssetImage(
                                                'assets/images/circle.gif'),
                                            image: NetworkImage(gallery),
                                            fit: BoxFit.contain,
                                          ));
                                    },
                                  );
                                }).toList(),
                              ),
                              Positioned(
                                bottom: -10.0,
                                left: 0.0,
                                right: 0.0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: loadedProduct.gallery.map<Widget>(
                                    (index) {
                                      return Container(
                                        width: 10.0,
                                        height: 10.0,
                                        margin: EdgeInsets.symmetric(
                                            vertical: 10.0, horizontal: 2.0),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: AppTheme.h1, width: 0.4),
                                            color: _current ==
                                                    loadedProduct.gallery
                                                        .indexOf(index)
                                                ? AppTheme.secondary
                                                : AppTheme.bg),
                                      );
                                    },
                                  ).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        Container(
                          height: deviceHeight * 0.1,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: loadedProduct.color.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Container(
                                      width: 25,
                                      height: 25,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Colors.black, width: 0.2),
                                        color: Color(
                                          int.parse(
                                            '0xff' +
                                                loadedProduct
                                                    .color[index].color_code
                                                    .replaceRange(0, 1, ''),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
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
                    onPressed: () {
                      _launchURL(loadedProduct.url);
                    },
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
                    onPressed: () async {
                      setState(() {});
                      if (loadedProduct.price.price.isEmpty) {
                        _snackBarMessage = 'قیمت محصول صفر میباشد';
                      } else {
                        await _showColorSelectiondialog(addtoshopFromDialogBox);
                        _snackBarMessage =
                            'محصول با موفقیت به سبد اضافه گردید!';
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
