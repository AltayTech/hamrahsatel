import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';

import '../classes/app_theme.dart';
import '../models/product_cart.dart';
import '../provider/Products.dart';
import '../provider/auth.dart';
import '../screens/product_detail_screen.dart';
import 'en_to_ar_number_convertor.dart';

class CardItem extends StatefulWidget {
  final int index;
  List<ProductCart> shoppItems;

  CardItem({
    this.index,
    this.shoppItems,
  });

  @override
  _CardItemState createState() => _CardItemState();
}

class _CardItemState extends State<CardItem> {
  bool _isInit = true;

  var _isLoading = true;

  bool isLogin;

  int productCount = 0;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _isLoading = false;

      productCount = widget.shoppItems[widget.index].productCount;
      print('productCount' + productCount.toString());
    }
    _isInit = false;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  Future<void> removeItem() async {
    setState(() {
      _isLoading = true;
    });
    await Provider.of<Products>(context, listen: false).removeShopCart(
        widget.shoppItems[widget.index].id,
        widget.shoppItems[widget.index].color_selected.id);

    setState(() {
      _isLoading = false;
      print(_isLoading.toString());
    });
    print(_isLoading.toString());
  }

  @override
  Widget build(BuildContext context) {
    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;
    var currencyFormat = intl.NumberFormat.decimalPattern();
    isLogin = Provider.of<Auth>(context).isAuth;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: AppTheme.h1, width: 0.5),
            borderRadius: BorderRadius.circular(5)),
        height: deviceWidth * 0.55,
        child: InkWell(
          onTap: () {
            Provider.of<Products>(context).item =
                Provider.of<Products>(context).item_zero;
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: widget.shoppItems[widget.index].id,
            );
          },
          child: Stack(
            children: <Widget>[
              Container(
                width: deviceWidth,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 7,
                      child: Container(
                        width: double.infinity,
                        child: FadeInImage(
                          placeholder: AssetImage('assets/images/logo.png'),
                          image: NetworkImage(widget
                              .shoppItems[widget.index].featured_media_url),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    flex: 6,
                                    child: Text(
                                      widget.shoppItems[widget.index].title !=
                                              null
                                          ? widget
                                              .shoppItems[widget.index].title
                                          : 'ندارد',
                                      style: TextStyle(
                                        color: AppTheme.secondary,
                                        fontFamily: 'Iransans',
                                        fontSize: textScaleFactor * 12,
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  Expanded(
                                    flex: 4,
                                    child: Container(
//
                                      child: Container(
                                        height: deviceHeight * 0.2,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          shrinkWrap: true,
                                          itemCount: widget
                                              .shoppItems[widget.index]
                                              .colors
                                              .length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Container(
                                              width: 30,
                                              height: 30,
                                              child: Center(
                                                child: Container(
                                                  width: 20,
                                                  height: 20,
                                                  decoration: widget
                                                              .shoppItems[
                                                                  widget.index]
                                                              .colors[index]
                                                              .id ==
                                                          widget
                                                              .shoppItems[
                                                                  widget.index]
                                                              .color_selected
                                                              .id
                                                      ? BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      0.3),
                                                              blurRadius: 1.10,
                                                              // has the effect of softening the shadow
                                                              spreadRadius:
                                                                  5.510,
                                                              // has the effect of extending the shadow
                                                              offset: Offset(
                                                                0,
                                                                // horizontal, move right 10
                                                                0, // vertical, move down 10
                                                              ),
                                                            )
                                                          ],
                                                          border: Border.all(
                                                              color:
                                                                  Colors.white,
                                                              width: 0.2),
                                                        )
                                                      : BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          border: Border.all(
                                                              color:
                                                                  Colors.white,
                                                              width: 0),
                                                        ),
                                                  child: Container(
                                                    width: 5,
                                                    height: 5,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                          color: Colors.black,
                                                          width: 0.2),
                                                      color: Color(
                                                        int.parse(
                                                          '0xff' +
                                                              widget
                                                                  .shoppItems[
                                                                      widget
                                                                          .index]
                                                                  .colors[index]
                                                                  .color_code
                                                                  .replaceRange(
                                                                      0, 1, ''),
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
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 3,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border: Border.all(
                                                color: AppTheme.h1, width: 0.2),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Expanded(
                                                  child: InkWell(
                                                onTap: () {
                                                  productCount =
                                                      productCount + 1;
                                                  print('productCount' +
                                                      productCount.toString());

                                                  Provider.of<Products>(context,
                                                          listen: false)
                                                      .updateShopCart(
                                                          widget.shoppItems[
                                                              widget.index],
                                                          widget
                                                              .shoppItems[
                                                                  widget.index]
                                                              .color_selected,
                                                          productCount,
                                                          isLogin)
                                                      .then((_) {
                                                    setState(() {
                                                      _isLoading = false;
                                                      print(_isLoading
                                                          .toString());
                                                    });
                                                  });
                                                },
                                                child: Container(
                                                    color: AppTheme.text,
                                                    child: Icon(
                                                      Icons.add,
                                                      color: AppTheme.primary,
                                                    )),
                                              )),
                                              Expanded(
                                                child: Text(
                                                  EnArConvertor()
                                                      .replaceArNumber(widget
                                                          .shoppItems[
                                                              widget.index]
                                                          .productCount
                                                          .toString())
                                                      .toString(),
                                                  style: TextStyle(
                                                    color: AppTheme.secondary,
                                                    fontFamily: 'Iransans',
                                                    fontSize:
                                                        textScaleFactor * 14,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              Expanded(
                                                  child: InkWell(
                                                onTap: () {
                                                  productCount =
                                                      productCount - 1;
                                                  print('productCount' +
                                                      productCount.toString());

                                                  Provider.of<Products>(context,
                                                          listen: false)
                                                      .updateShopCart(
                                                          widget.shoppItems[
                                                              widget.index],
                                                          widget
                                                              .shoppItems[
                                                                  widget.index]
                                                              .color_selected,
                                                          productCount,
                                                          isLogin)
                                                      .then((_) {
                                                    setState(() {
                                                      _isLoading = false;
                                                      print(_isLoading
                                                          .toString());
                                                    });
                                                  });
                                                },
                                                child: Container(
                                                    color: AppTheme.text,
                                                    child: Icon(
                                                      Icons.remove,
                                                      color: AppTheme.primary,
                                                    )),
                                              )),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    Expanded(
                                      flex: 5,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          Text(
                                            widget.shoppItems[widget.index]
                                                    .price_low.isNotEmpty
                                                ? EnArConvertor().replaceArNumber(
                                                    currencyFormat
                                                        .format(double.parse(widget
                                                            .shoppItems[
                                                                widget.index]
                                                            .price_low))
                                                        .toString())
                                                : widget
                                                        .shoppItems[
                                                            widget.index]
                                                        .price
                                                        .isNotEmpty
                                                    ? EnArConvertor().replaceArNumber(currencyFormat
                                                        .format(double.parse(widget
                                                            .shoppItems[widget.index]
                                                            .price))
                                                        .toString())
                                                    : EnArConvertor().replaceArNumber('0'),
                                            style: TextStyle(
                                              color: AppTheme.primary,
                                              fontFamily: 'Iransans',
                                              fontSize: textScaleFactor * 19,
                                            ),
                                          ),
                                          Text(
                                            '  تومان ',
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontFamily: 'Iransans',
                                              fontSize: textScaleFactor * 12,
                                            ),
                                          ),
                                        ],
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
                child: Container(
                  height: deviceWidth * 0.060,
                  width: deviceWidth * 0.06,
                  decoration: BoxDecoration(
                      color: AppTheme.primary,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(5),
                      )),
                  child: InkWell(
                    onTap: () {
                      return removeItem();
                    },
                    child: Icon(
                      Icons.close,
                      size: 20,
                      color: AppTheme.bg,
                    ),
                  ),
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
                                    color: index.isEven
                                        ? Colors.grey
                                        : Colors.grey,
                                  ),
                                );
                              },
                            )
                          : Container()))
            ],
          ),
        ),
      ),
    );
  }
}
