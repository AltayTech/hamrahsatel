import 'package:flutter/material.dart';
import 'package:hamrahsatel/classes/app_theme.dart';
import 'package:hamrahsatel/models/product.dart';
import 'package:intl/intl.dart' as intl;

import '../screens/customer_info/profile_screen.dart';
import 'en_to_ar_number_convertor.dart';

class CustomDialogSelectColor extends StatefulWidget {
  final Product product;
  final Function function;

  CustomDialogSelectColor({
    @required this.product,
    @required this.function,
  });

  @override
  _CustomDialogSelectColorState createState() =>
      _CustomDialogSelectColorState();
}

class _CustomDialogSelectColorState extends State<CustomDialogSelectColor> {
  var _selectedColorIndex;

  var _selectedColor;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;
    var currencyFormat = intl.NumberFormat.decimalPattern();
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            top: Consts.avatarRadius + Consts.padding,
            bottom: Consts.padding,
            left: Consts.padding,
            right: Consts.padding,
          ),
          margin: EdgeInsets.only(top: Consts.avatarRadius),
          decoration: new BoxDecoration(
            color: AppTheme.bg,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(Consts.padding),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              Container(
                  height: deviceHeight * 0.2,
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  child: FadeInImage(
                    placeholder: AssetImage('assets/images/circle.gif'),
                    image: NetworkImage(widget.product.featured_image),
                    fit: BoxFit.contain,
                  )),
              Text(
                widget.product.title,
                style: TextStyle(
                  color: AppTheme.primary,
                  fontSize: MediaQuery.of(context).textScaleFactor * 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'رنگ محصول را انتخاب نمایید',
                style: TextStyle(
                  color: Color(0xff0197F6),
                  fontSize: MediaQuery.of(context).textScaleFactor * 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Container(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: widget.product.color.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        _selectedColorIndex = index;
                        _selectedColor = widget.product.color[index];
                        setState(() {});
                      },
                      child: Container(
                        decoration: _selectedColorIndex == index
                            ? BoxDecoration(
                                border:
                                    Border.all(color: Colors.black, width: 0.2),
                                borderRadius: BorderRadius.circular(5),
                                color: AppTheme.secondary.withOpacity(0.15),
                              )
                            : BoxDecoration(
                                color: AppTheme.bg,
                              ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                widget.product.color[index].price.isNotEmpty
                                    ? EnArConvertor().replaceArNumber(
                                        currencyFormat
                                            .format(double.parse(widget
                                                .product.color[index].price))
                                            .toString())
                                    : EnArConvertor().replaceArNumber('0'),
                                style: TextStyle(
                                  color: AppTheme.primary,
                                  fontFamily: 'Iransans',
                                  fontSize: textScaleFactor * 20.0,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                widget.product.color[index].title,
                                style: TextStyle(
                                  color: AppTheme.primary,
                                  fontFamily: 'Iransans',
                                  fontSize:
                                      MediaQuery.of(context).textScaleFactor *
                                          16,
                                ),
                              ),
                            ),
                            Padding(
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
                                          widget.product.color[index].color_code
                                              .replaceRange(0, 1, ''),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Builder(
                    builder: (context) => ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: InkWell(
                            onTap: () {
                              widget.function(_selectedColor);
                              Navigator.pop(context);
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.06,
                              width: MediaQuery.of(context).size.width * 0.4,
                              decoration: BoxDecoration(
                                color: _selectedColorIndex != null
                                    ? AppTheme.primary
                                    : Colors.grey,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Center(
                                child: Text(
                                  'افزودن به سبد خرید',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Iransans',
                                    fontSize:
                                        MediaQuery.of(context).textScaleFactor *
                                            16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 10;
}
