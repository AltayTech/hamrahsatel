import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hamrahsatel/models/color_code_product_detail.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import '../customer_info.dart';
import '../models/product.dart';
import '../provider/Products.dart';
import '../provider/app_theme.dart';
import '../provider/auth.dart';
import '../screens/product_detail_more_details_screen.dart';
import '../widgets/badge.dart';
import '../widgets/custom_dialog_select_color.dart';
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

  ColorCodeProductDetail _selectedColor;

  bool isLogin;

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      await searchItems();
      loadedProduct = Provider.of<Products>(context, listen: false).findById();
//      _selectedColor = loadedProduct.color[0];

      isLogin = Provider.of<Auth>(context, listen: false).isAuth;
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
    });
    print(_isLoading.toString());
  }

  Future<void> addToShoppingCart(
      Product loadedProduct, var _selectedColor, bool isLogin) async {
    setState(() {
      _isLoading = true;
    });

    await Provider.of<Products>(context, listen: false)
        .addShopCart(loadedProduct, _selectedColor, 1, isLogin);

    setState(() {
      _isLoading = false;
    });
    print(_isLoading.toString());
  }

  Future<void> addtoshopFromDialogBox(
      ColorCodeProductDetail selectedColor) async {
    setState(() {
      _isLoading = true;
    });

    _snackBarMessage = 'محصول با موفقیت به سبد اضافه گردید!';

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
            color: AppTheme.secondary,
            fontFamily: 'Iransans',
            fontWeight: FontWeight.bold,
            fontSize: textScaleFactor * 16,
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
            color: AppTheme.secondary,
            fontFamily: 'Iransans',
            fontWeight: FontWeight.bold,
            fontSize: textScaleFactor * 16,
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
            color: AppTheme.secondary,
            fontFamily: 'Iransans',
            fontWeight: FontWeight.bold,
            fontSize: textScaleFactor * 16,
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
                decorationThickness: 2,
                color: AppTheme.accent,
                fontFamily: 'Iransans',
                fontSize: textScaleFactor * 14,
              ),
            ),
            Text(
              loadedProduct.price.price.isNotEmpty
                  ? EnArConvertor().replaceArNumber(currencyFormat
                      .format(double.parse(loadedProduct.price.price))
                      .toString())
                  : EnArConvertor().replaceArNumber('0'),
              style: TextStyle(
                color: AppTheme.secondary,
                fontFamily: 'Iransans',
                fontWeight: FontWeight.bold,
                fontSize: textScaleFactor * 16,
              ),
            ),
          ],
        );
      }
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'محصولات',
            style: TextStyle(
              fontFamily: 'Iransans',
            ),
          ),
          backgroundColor: AppTheme.appBarColor,
          iconTheme: new IconThemeData(color: AppTheme.appBarIconColor),
          elevation: 0,
          centerTitle: true,
          actions: <Widget>[
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
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        height: deviceHeight * 0.1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              flex: 3,
                              child: Container(
                                height: double.infinity,
                                decoration: BoxDecoration(
//                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: AppTheme.grey),
                                  color: AppTheme.bg,
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(
                                              bottom: textScaleFactor * 5.0),
                                          child: FittedBox(
                                            child: Text(
                                              'تومان',
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontFamily: 'Iransans',
                                                fontSize:
                                                    textScaleFactor * 10.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                        FittedBox(child: priceWidget()),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 6,
                              child: Container(
                                height: double.infinity,
                                decoration: BoxDecoration(
//                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: AppTheme.grey),
                                  color: AppTheme.bg,
                                ),
                                child: Center(
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text(
                                          loadedProduct.title,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            height: 2,
                                            color: AppTheme.black,
                                            fontFamily: 'Iransans',
                                            fontSize: textScaleFactor * 13.0,
                                          ),
                                          textAlign: TextAlign.right,
                                          textDirection: TextDirection.rtl,
                                        ),
                                      ),
                                      Text(
                                        loadedProduct.brand[0].title,
                                        style: TextStyle(
                                          color: AppTheme.h1,
                                          fontFamily: 'Iransans',
                                          fontSize: textScaleFactor * 14.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                height: double.infinity,
                                decoration: BoxDecoration(
//                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: AppTheme.grey),
                                  color: AppTheme.bg,
                                ),
                                child: Center(
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        ProductDetailMoreDetailScreen.routeName,
                                        arguments: loadedProduct,
                                      );
                                    },
                                    child: Text(
                                      'جزئیات',
                                      style: TextStyle(
                                        color: AppTheme.black,
                                        fontFamily: 'Iransans',
                                        fontSize: textScaleFactor * 16.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: deviceHeight * 0.7,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5)),
                        child: Stack(
                          children: [
                            CarouselSlider(
                              options: CarouselOptions(
                                aspectRatio: 1,
                                viewportFraction: 1.0,
                                initialPage: 0,
                                enableInfiniteScroll: true,
                                reverse: false,
                                autoPlay: false,
                                height: deviceHeight * 0.7,
                                autoPlayInterval: Duration(seconds: 3),
                                autoPlayAnimationDuration:
                                    Duration(milliseconds: 800),
                                enlargeCenterPage: true,
                                scrollDirection: Axis.horizontal,
                                onPageChanged: (index, _) {
                                  _current = index;
                                  setState(() {});
                                },
                              ),
                              items: loadedProduct.gallery.map((gallery) {
                                return Builder(
                                  builder: (BuildContext context) {
                                    return Center(
                                      child: Container(
                                          width: deviceWidth,
                                          height: deviceHeight * 0.7,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 5.0),
                                          child: FadeInImage(
                                            placeholder: AssetImage(
                                                'assets/images/circle.gif'),
                                            image: NetworkImage(gallery),
                                            fit: BoxFit.contain,
                                          )),
                                    );
                                  },
                                );
                              }).toList(),
                            ),
                            Positioned(
                              bottom: 0,
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
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: deviceHeight * 0.035,
                          right: 20,
                        ),
                        child: Container(
                          height: deviceHeight * 0.04,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: loadedProduct.color.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Container(
                                  width: deviceHeight * 0.03,
                                  height: deviceHeight * 0.03,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.black, width: 0.2),
                                    color: Color(
                                      int.parse(
                                        '0xff' +
                                            loadedProduct.color[index].colorCode
                                                .replaceRange(0, 1, ''),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
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
                      Share.share(loadedProduct.url,
                          subject: 'محصول :${loadedProduct.title} ');
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
                      } else {
                        _selectedColor = null;
                        await _showColorSelectiondialog(addtoshopFromDialogBox);
                        if (_selectedColor != null) {
                          _snackBarMessage =
                              'محصول با موفقیت به سبد اضافه گردید!';
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
                        } else {
                          _snackBarMessage = 'محصول به سبد اضافه نگردید!';
                        }
                      }
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
