import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hamrahsatel/models/color_code.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';

import '../classes/app_theme.dart';
import '../provider/Products.dart';
import '../screens/product_detail_screen.dart';
import 'en_to_ar_number_convertor.dart';

class ProductItem extends StatelessWidget {
  final int id;
  final String title;
  final String brand_title;
  final String price;
  final String price_low;
  final String imageUrl;
  final String brandImageUrl;
  final List<ColorCode> productColor;

  ProductItem({
    this.id,
    this.title,
    this.brand_title,
    this.price,
    this.price_low,
    this.imageUrl,
    this.brandImageUrl,
    this.productColor,
  });

  @override
  Widget build(BuildContext context) {
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;
    var currencyFormat = intl.NumberFormat.decimalPattern();

    Widget priceWidget() {
      if (price == price_low) {
        return Text(
          price.isNotEmpty
              ? EnArConvertor().replaceArNumber(
                  currencyFormat.format(double.parse(price)).toString())
              : EnArConvertor().replaceArNumber('0'),
          style: TextStyle(
            fontFamily: 'Iransans',
            color: AppTheme.primary,
            fontWeight: FontWeight.w600,
            fontSize: textScaleFactor * 15.0,
          ),
        );
      } else if (price == '0' || price.isEmpty) {
        return Text(
          price_low.isNotEmpty
              ? EnArConvertor().replaceArNumber(
                  currencyFormat.format(double.parse(price_low)).toString())
              : EnArConvertor().replaceArNumber('0'),
          style: TextStyle(
            fontFamily: 'Iransans',
            color: AppTheme.primary,
            fontWeight: FontWeight.w600,
            fontSize: textScaleFactor * 15.0,
          ),
        );
      } else if (price_low == '0' || price_low.isEmpty) {
        return Text(
          price.isNotEmpty
              ? EnArConvertor().replaceArNumber(
                  currencyFormat.format(double.parse(price)).toString())
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
              price.isNotEmpty
                  ? EnArConvertor().replaceArNumber(
                      currencyFormat.format(double.parse(price)).toString())
                  : EnArConvertor().replaceArNumber('0'),
              style: TextStyle(
                decoration: TextDecoration.lineThrough,
                fontFamily: 'Iransans',
                color: AppTheme.h1,
                fontSize: textScaleFactor * 15.0,
              ),
            ),
            Text(
              price_low.isNotEmpty
                  ? EnArConvertor().replaceArNumber(
                      currencyFormat.format(double.parse(price_low)).toString())
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
      height: MediaQuery.of(context).size.width * 0.5,
      child: LayoutBuilder(
        builder: (ctx, constraints) {
          return InkWell(
              onTap: () {
                Provider.of<Products>(context).item =
                    Provider.of<Products>(context).item_zero;
                Navigator.of(context).pushNamed(
                  ProductDetailScreen.routeName,
                  arguments: id,
                );
              },
              child: Card(
                child: Stack(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Expanded(
                          flex: 14,
                          child: Container(
                            child: FadeInImage(
                              placeholder:
                                  AssetImage('assets/images/circle.gif'),
                              image: NetworkImage(imageUrl!=null?imageUrl:''),
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
                                    title,
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
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 4,
                                              horizontal: 10,
                                            ),
                                            child: Image.network(
                                              brandImageUrl!=null?brandImageUrl:'',
                                            ),
                                          ),
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
                            itemCount: productColor.length,
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
                                            productColor[index]
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
              ));
        },
      ),
    );
  }
}
