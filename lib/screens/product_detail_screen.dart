import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hamrahsatel/screens/product_detail_more_details_screen.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';

import '../classes/app_theme.dart';
import '../classes/flutter_carousel_slider.dart';
import '../models/color_code.dart';
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

  ColorCode color_selected;

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
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
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      searchItems();
    }
    _isInit = false;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  Future<void> searchItems() async {
    setState(() {
      _isLoading = true;
    });
    final productId = ModalRoute.of(context).settings.arguments as int;

    await Provider.of<Products>(context, listen: false).retrieveItem(productId);
    print(_isLoading.toString());

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
    loadedProduct = Provider.of<Products>(context).findById();
    _selectedColor = loadedProduct.color[0];

    isLogin = Provider.of<Auth>(context).isAuth;

    Widget priceWidget() {
      if (loadedProduct.price == loadedProduct.price_low) {
        return Text(
          loadedProduct.price.isNotEmpty
              ? EnArConvertor().replaceArNumber(currencyFormat
                  .format(double.parse(loadedProduct.price))
                  .toString())
              : EnArConvertor().replaceArNumber('0'),
          style: TextStyle(
            color: AppTheme.primary,
            fontFamily: 'Iransans',
            fontSize: textScaleFactor * 20.0,
          ),
        );
      } else if (loadedProduct.price == '0' || loadedProduct.price.isEmpty) {
        return Text(
          loadedProduct.price_low.isNotEmpty
              ? EnArConvertor().replaceArNumber(currencyFormat
                  .format(double.parse(loadedProduct.price_low))
                  .toString())
              : EnArConvertor().replaceArNumber('0'),
          style: TextStyle(
            color: AppTheme.primary,
            fontFamily: 'Iransans',
            fontSize: textScaleFactor * 20.0,
          ),
        );
      } else if (loadedProduct.price_low == '0' ||
          loadedProduct.price_low.isEmpty) {
        return Text(
          loadedProduct.price.isNotEmpty
              ? EnArConvertor().replaceArNumber(currencyFormat
                  .format(double.parse(loadedProduct.price))
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
              loadedProduct.price.isNotEmpty
                  ? EnArConvertor().replaceArNumber(currencyFormat
                      .format(double.parse(loadedProduct.price))
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
                loadedProduct.price_low.isNotEmpty
                    ? EnArConvertor().replaceArNumber(currencyFormat
                        .format(double.parse(loadedProduct.price_low))
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
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 15.0, right: 15),
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
                                    border:
                                        Border.all(color: AppTheme.secondary),
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
//                                  height: deviceHeight * 0.55,
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
                                  pauseAutoPlayOnTouch:
                                      Duration(seconds: 10),
                                  enlargeCenterPage: true,
                                  scrollDirection: Axis.horizontal,
                                  onPageChanged: (index) {
                                    _current = index;
                                    setState(() {});
                                  },
                                  items:
                                      loadedProduct.gallery.map((gallery) {
                                    return Builder(
                                      builder: (BuildContext context) {
                                        return Container(
                                            width: deviceWidth,
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 5.0),
                                            child: FadeInImage(
                                              placeholder: AssetImage(
                                                  'assets/images/circle.gif'),
                                              image:
                                                  NetworkImage(gallery.url),
                                              fit: BoxFit.cover,
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children:
                                        loadedProduct.gallery.map<Widget>(
                                      (index) {
                                        return Container(
                                          width: 10.0,
                                          height: 10.0,
                                          margin: EdgeInsets.symmetric(
                                              vertical: 10.0,
                                              horizontal: 2.0),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: _current ==
                                                      loadedProduct.gallery
                                                          .indexOf(index)
                                                  ? AppTheme.h1
                                                  : AppTheme.bg),
                                        );
                                      },
                                    ).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: deviceHeight * 0.2,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: loadedProduct.color.length,
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  onTap: () {
                                    _selectedColorIndex = index;
                                    _selectedColor = loadedProduct.color[index];
                                    setState(() {});
                                  },
                                  child: Container(
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Container(
                                          width: 25,
                                          height: 25,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: Colors.black,
                                                width: 0.2),
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
