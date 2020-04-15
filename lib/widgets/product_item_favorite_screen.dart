import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import '../classes/app_theme.dart';
import '../provider/Products.dart';

import '../models/productFavorite.dart';
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
    // TODO: implement didChangeDependencies
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
    var heightDevice = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;
    final product = Provider.of<ProductFavorite>(context, listen: false);
    var currencyFormat = intl.NumberFormat.decimalPattern();

    Widget priceWidget() {
      if (product.price == product.price_low) {
        return Text(
          product.price.isNotEmpty
              ? EnArConvertor().replaceArNumber(
                  currencyFormat.format(double.parse(product.price)).toString())
              : EnArConvertor().replaceArNumber('0'),
          style: TextStyle(
            fontFamily: 'Iransans',
            color: AppTheme.primary,
            fontWeight: FontWeight.w600,
            fontSize: textScaleFactor * 15.0,
          ),
        );
      } else if (product.price == '0' || product.price.isEmpty) {
        return Text(
          product.price_low.isNotEmpty
              ? EnArConvertor().replaceArNumber(currencyFormat
                  .format(double.parse(product.price_low))
                  .toString())
              : EnArConvertor().replaceArNumber('0'),
          style: TextStyle(
            fontFamily: 'Iransans',
            color: AppTheme.primary,
            fontWeight: FontWeight.w600,
            fontSize: textScaleFactor * 15.0,
          ),
        );
      } else if (product.price_low == '0' || product.price_low.isEmpty) {
        return Text(
          product.price.isNotEmpty
              ? EnArConvertor().replaceArNumber(
                  currencyFormat.format(double.parse(product.price)).toString())
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
              product.price.isNotEmpty
                  ? EnArConvertor().replaceArNumber(currencyFormat
                      .format(double.parse(product.price))
                      .toString())
                  : EnArConvertor().replaceArNumber('0'),
              style: TextStyle(
                decoration: TextDecoration.lineThrough,
                fontFamily: 'Iransans',
                color: AppTheme.text,
                fontSize: textScaleFactor * 15.0,
              ),
            ),
            Text(
              product.price_low.isNotEmpty
                  ? EnArConvertor().replaceArNumber(currencyFormat
                      .format(double.parse(product.price_low))
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

    return LayoutBuilder(builder: (ctx, constraints) {
      return Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 0.010,
                    // has the effect of softening the shadow
                    spreadRadius: 0.0510,
                    // has the effect of extending the shadow
                    offset: Offset(
                      0.5, // horizontal, move right 10
                      0.5, // vertical, move down 10
                    ),
                  )
                ],
                borderRadius: BorderRadius.circular(5)),
            child: Stack(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Provider.of<Products>(context).item =
                        Provider.of<Products>(context).item_zero;
                    Navigator.of(context).pushNamed(
                      ProductDetailScreen.routeName,
                      arguments: product.id,
                    );
                  },
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        flex: 5,
                        child: Stack(
                          children: <Widget>[
                            Container(
                              width: double.infinity,
                              child: Hero(
                                tag: product.id,
                                child: FadeInImage(
                                  placeholder:
                                      AssetImage('assets/images/logo.png'),
                                  image: NetworkImage(product.img_url),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              left: 0,
                              child: Directionality(
                                textDirection: TextDirection.ltr,
                                child: Container(
                                  height: 15,
                                  width: 40,
                                  alignment: Alignment.centerLeft,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3),
                                    color: Colors.white70,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: GridView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: product.colors.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Container(
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            width: 8.0,
                                            height: 8.0,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: Colors.black,
                                                  width: 0.2),
                                              color: Color(
                                                int.parse(
                                                  '0xff' +
                                                      product.colors[index]
                                                          .color_code
                                                          .replaceRange(
                                                              0, 1, ''),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 1,
                                        childAspectRatio: 1,
                                        crossAxisSpacing: 1,
                                        mainAxisSpacing: 3,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            product.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,                          style: TextStyle(
                              color: Colors.blueGrey,
                              fontFamily: 'Iransans',
                              fontSize: textScaleFactor * 12.0,
                            ),

                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                flex: 4,
                                child: Container(
                                  height: constraints.maxHeight * 0.08,
                                  alignment: Alignment.centerRight,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(3),
                                    color: Colors.white70,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: GridView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: product.colors.length,
                                      itemBuilder:
                                          (BuildContext context,
                                          int index) {
                                        return Container(
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            width: 10.0,
                                            height: 10.0,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: Colors.black,
                                                  width: 0.2),
                                              color: Color(
                                                int.parse(
                                                  '0xff' +
                                                      product
                                                          .colors[index]
                                                          .color_code
                                                          .replaceRange(
                                                          0, 1, ''),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 1,
                                        childAspectRatio: 1,
                                        crossAxisSpacing: 1,
                                        mainAxisSpacing: 3,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Spacer(),
                              Expanded(
                                flex: 4,
                                child: Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      FittedBox(child: priceWidget()),
                                      Text(
                                        'تومان',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontFamily: 'Iransans',
                                          fontSize:
                                          textScaleFactor * 9.0,
                                        ),
                                      ),
                                    ],
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
          ),
          Positioned(
              top: 0,
              bottom: 0,
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
                                color: index.isEven ? Colors.grey : Colors.grey,
                              ),
                            );
                          },
                        )
                      : Container()))
        ],
      );
    });
  }
}
