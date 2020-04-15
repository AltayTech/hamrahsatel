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

    return Container(
      width: MediaQuery.of(context).size.width * 0.45,
      height: MediaQuery.of(context).size.width * 0.9,
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
            child:  Card(
              child: Stack(
                children: <Widget>[
                  Container(
                    height: constraints.maxHeight,

                    child: Column(
                      children: <Widget>[
                        Expanded(
                          flex: 14,
                          child: Container(
                            child: FadeInImage(
                              placeholder:
                              AssetImage('assets/images/circle.gif'),
                              image: NetworkImage(product.gallery[0].url),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 10,
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                flex: 6,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
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
                              ),
                              Padding(
                                padding: EdgeInsets.all(
                                    constraints.maxWidth * 0.005),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                      child: Wrap(
                                        direction: Axis.vertical,
                                        crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                        children: <Widget>[
//                                          Padding(
//                                            padding: const EdgeInsets.symmetric(
//                                              vertical: 4,
//                                              horizontal: 10,
//                                            ),
//                                            child: Image.network(
//                                              product.brand[0].brand_img_url,
//                                            ),
//                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Wrap(
                                          direction: Axis.vertical,
                                          crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                          children: <Widget>[
                                            FittedBox(child: priceWidget()),
                                            Text(
                                              'تومان',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: AppTheme.text,
                                                fontFamily: 'Iransans',
                                                fontSize: textScaleFactor * 9.0,
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
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    child: Container(
                      height: constraints.maxHeight * 0.08,
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: Colors.white70,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: GridView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: product.color.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              child: Container(
                                padding: EdgeInsets.all(10),
                                width: 10.0,
                                height: 10.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Colors.black, width: 0.2),
                                  color: Color(
                                    int.parse(
                                      '0xff' +
                                          product.color[index]
                                              .color_code
                                              .replaceRange(0, 1, ''),
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
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}