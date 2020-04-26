import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';

import '../classes/app_theme.dart';
import '../models/product.dart';
import '../provider/Products.dart';
import '../screens/product_detail_screen.dart';
import 'en_to_ar_number_convertor.dart';

class ProductItemProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var heightDevice = MediaQuery.of(context).size.height;
    var widthDevice = MediaQuery.of(context).size.width;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;
    final product = Provider.of<Product>(context, listen: false);
    var currencyFormat = intl.NumberFormat.decimalPattern();

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
      height: widthDevice * 0.45,
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
              child: Container(
                height: constraints.maxHeight,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FadeInImage(
                            placeholder:
                                AssetImage('assets/images/circle.gif'),
                            image: NetworkImage(product.featured_image),
                            fit: BoxFit.cover,
                          ),
                          Container(
                            height: constraints.maxHeight * 0.08,
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: Colors.white70,
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: product.color.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
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
                                            int.parse(
                                              '0xff' +
                                                  product
                                                      .color[index].color_code
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
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 10,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              product.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: AppTheme.primary,
                                fontFamily: 'Iransans',
                                fontSize: textScaleFactor * 14.0,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                  horizontal: 10,
                                ),
                                child: Image.network(
                                  product.brand[0].brand_img_url,
                                  fit: BoxFit.contain,
                                  height: constraints.maxHeight * 0.25,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 20,
                                ),
                                child: Wrap(
                                  direction: Axis.vertical,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: <Widget>[
                                    FittedBox(child: priceWidget()),
                                    Text(
                                      'تومان',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: AppTheme.accent,
                                        fontFamily: 'Iransans',
                                        fontSize: textScaleFactor * 9.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
