import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';

import '../models/color_code.dart';
import '../provider/Products.dart';
import '../provider/app_theme.dart';
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
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
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
        return Text(
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
        );
      }
    }

    return Padding(
      padding: EdgeInsets.only(right: deviceWidth * 0.04),
      child: Container(
        width: deviceWidth * 0.45,
        height: deviceHeight * 0.9,
        decoration: BoxDecoration(
          border:
              Border.all(color: AppTheme.primary.withOpacity(0.3), width: 0.1),
          borderRadius: BorderRadius.circular(2),
          color: AppTheme.white,
        ),
        child: LayoutBuilder(
          builder: (ctx, constraints) {
            return InkWell(
                onTap: () {
                  Provider.of<Products>(ctx, listen: false).item =
                      Provider.of<Products>(ctx, listen: false).itemZero;
                  Navigator.of(ctx).pushNamed(
                    ProductDetailScreen.routeName,
                    arguments: id,
                  );
                },
                child: Stack(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Expanded(
                          flex: 20,
                          child: Padding(
                            padding:
                                EdgeInsets.all(constraints.maxWidth * 0.04),
                            child: FadeInImage(
                              placeholder:
                                  AssetImage('assets/images/circle.gif'),
                              image: NetworkImage(
                                  imageUrl != null ? imageUrl : ''),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 5),
                          child: Text(
                            title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppTheme.black,
                              fontFamily: 'Iransans',
                              fontSize: textScaleFactor * 12.0,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: constraints.maxWidth * 0.01,
                            left: constraints.maxWidth * 0.04,
                            right: constraints.maxWidth * 0.08,
                          ),
//                          child: Row(
//                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                            crossAxisAlignment: CrossAxisAlignment.center,
//                            children: <Widget>[
//                              Expanded(
//                                child: Padding(
//                                  padding: const EdgeInsets.symmetric(
//                                    horizontal: 10,
//                                  ),
//                                  child: Image.network(
//                                    brandImageUrl != null ? brandImageUrl : '',
//                                  ),
//                                ),
//                              ),
//                              Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.all(
                                    constraints.maxWidth * 0.014),
                                child: FittedBox(child: priceWidget()),
                              ),
                              FittedBox(
                                child: Text(
                                  'تومان',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppTheme.h1,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Iransans',
                                    fontSize: textScaleFactor * 7.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
//                              ),
//                            ],
//                          ),
                        ),
                        SizedBox(
                          height: constraints.maxHeight * 0.05,
                        )
                      ],
                    ),
//                    Positioned(
//                      left: constraints.maxWidth * 0.03,
//                      top: constraints.maxHeight * 0.03,
//                      child: Container(
//                        height: constraints.maxHeight * 0.10,
//                        alignment: Alignment.centerLeft,
//                        decoration: BoxDecoration(
//                          borderRadius: BorderRadius.circular(3),
//                          color: Colors.white70,
//                        ),
//                        child: Padding(
//                          padding: const EdgeInsets.all(3.0),
//                          child: ListView.builder(
//                            shrinkWrap: true,
//                            scrollDirection: Axis.horizontal,
//                            itemCount: productColor.length,
//                            itemBuilder: (BuildContext context, int index) {
//                              return Padding(
//                                padding: const EdgeInsets.all(1.0),
//                                child: Container(
//                                  width: 10.0,
//                                  height: 10.0,
//                                  decoration: BoxDecoration(
//                                    shape: BoxShape.circle,
//                                    border: Border.all(
//                                        color: Colors.black, width: 0.2),
//                                    color: Color(
//                                      int.parse('0xff' +
//                                          productColor[index]
//                                              .color_code
//                                              .replaceRange(0, 1, '')),
//                                    ),
//                                  ),
//                                ),
//                              );
//                            },
//                          ),
//                        ),
//                      ),
//                    )
                  ],
                ));
          },
        ),
      ),
    );
  }
}
