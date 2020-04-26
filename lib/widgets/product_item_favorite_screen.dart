import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';

import '../classes/app_theme.dart';
import '../models/productFavorite.dart';
import '../provider/Products.dart';
import '../provider/customer_info.dart';
import '../screens/product_detail_screen.dart';
import 'en_to_ar_number_convertor.dart';

class ProductItemFavoriteScreen extends StatefulWidget {
  @override
  _ProductItemFavoriteScreenState createState() =>
      _ProductItemFavoriteScreenState();
}

class _ProductItemFavoriteScreenState extends State<ProductItemFavoriteScreen> {
  bool _isInit = true;

  var _isLoading = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _isLoading = false;
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> removeItem(int id) async {
    setState(() {
      _isLoading = true;
    });
    await Provider.of<CustomerInfo>(context, listen: false)
        .addFavorite(id, 'remove');

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
    final product = Provider.of<ProductFavorite>(context, listen: false);

    Widget priceWidget() {
      if (product.price.price == product.price.price) {
        return Text(
          product.price.price.isNotEmpty
              ? EnArConvertor().replaceArNumber(currencyFormat
                  .format(double.parse(product.price.price))
                  .toString())
              : EnArConvertor().replaceArNumber('0'),
          style: TextStyle(
            fontFamily: 'Iransans',
            color: AppTheme.primary,
            fontWeight: FontWeight.w600,
            fontSize: textScaleFactor * 15.0,
          ),
        );
      } else if (product.price.price == '0' || product.price.price.isEmpty) {
        return Text(
          product.price.price.isNotEmpty
              ? EnArConvertor().replaceArNumber(currencyFormat
                  .format(double.parse(product.price.price))
                  .toString())
              : EnArConvertor().replaceArNumber('0'),
          style: TextStyle(
            fontFamily: 'Iransans',
            color: AppTheme.primary,
            fontWeight: FontWeight.w600,
            fontSize: textScaleFactor * 15.0,
          ),
        );
      } else if (product.price.price == '0' || product.price.price.isEmpty) {
        return Text(
          product.price.price.isNotEmpty
              ? EnArConvertor().replaceArNumber(currencyFormat
                  .format(double.parse(product.price.price))
                  .toString())
              : EnArConvertor().replaceArNumber('0'),
          style: TextStyle(
            fontFamily: 'Iransans',
            color: AppTheme.primary,
            fontWeight: FontWeight.w600,
            fontSize: textScaleFactor * 15.0,
          ),
        );
      } else {
        return Wrap(
          direction: Axis.vertical,
          children: <Widget>[
            Text(
              product.price.price.isNotEmpty
                  ? EnArConvertor().replaceArNumber(currencyFormat
                      .format(double.parse(product.price.price))
                      .toString())
                  : EnArConvertor().replaceArNumber('0'),
              style: TextStyle(
                decoration: TextDecoration.lineThrough,
                fontFamily: 'Iransans',
                color: AppTheme.accent,
                fontSize: textScaleFactor * 15.0,
              ),
            ),
            Text(
              product.price.price.isNotEmpty
                  ? EnArConvertor().replaceArNumber(currencyFormat
                      .format(double.parse(product.price.price))
                      .toString())
                  : EnArConvertor().replaceArNumber('0'),
              style: TextStyle(
                fontFamily: 'Iransans',
                fontWeight: FontWeight.w600,
                color: AppTheme.primary,
                fontSize: textScaleFactor * 15.0,
              ),
            )
          ],
        );
      }
    }

    return Container(
      width: deviceWidth * 0.45,
      height: deviceHeight * 0.6,
      child: LayoutBuilder(
        builder: (ctx, constraints) {
          return InkWell(
              onTap: () {
                Provider.of<Products>(context).item =
                    Provider.of<Products>(context).item_zero;
                Navigator.of(context).pushNamed(
                  ProductDetailScreen.routeName,
                  arguments: product.id,
                );
              },
              child: Card(
                child: Stack(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Expanded(
                          flex: 14,
                          child: Padding(
                            padding:
                                EdgeInsets.all(constraints.maxWidth * 0.04),
                            child: FadeInImage(
                              placeholder:
                                  AssetImage('assets/images/circle.gif'),
                              image: NetworkImage(product.featured_image != null
                                  ? product.featured_image
                                  : ''),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 5),
                          child: Text(
                            product.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: AppTheme.primary,
                              fontFamily: 'Iransans',
                              fontSize: textScaleFactor * 12.0,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(constraints.maxWidth * 0.005),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      FittedBox(child: priceWidget()),
                                      FittedBox(
                                        child: Text(
                                          'تومان',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: AppTheme.h1,
                                            fontFamily: 'Iransans',
                                            fontSize: textScaleFactor * 9.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      left: 2,
                      top: 2,
                      child: Container(
                        height: constraints.maxHeight * 0.08,
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: Colors.white70,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: product.colors.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: Container(
                                  width: 10.0,
                                  height: 10.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.black, width: 0.2),
                                    color: Color(
                                      int.parse('0xff' +
                                          product.colors[index].color_code
                                              .replaceRange(0, 1, '')),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      height: deviceWidth * 0.07,
                      width: deviceWidth * 0.07,
                      child: InkWell(
                        onTap: () {
                          removeItem(product.id);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: Colors.white70,
                          ),
                          child: Icon(
                            Icons.close,
                            color: AppTheme.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ));
        },
      ),
    );
  }
}
