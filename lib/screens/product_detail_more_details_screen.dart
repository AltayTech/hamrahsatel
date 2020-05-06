import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:intl/intl.dart' as intl;

import '../provider/app_theme.dart';
import '../models/product.dart';
import '../widgets/main_drawer.dart';

class ProductDetailMoreDetailScreen extends StatefulWidget {
  static const routeName = '/productDetailMoreDetailsScreen';

  @override
  _ProductDetailMoreDetailScreenState createState() =>
      _ProductDetailMoreDetailScreenState();
}

class _ProductDetailMoreDetailScreenState
    extends State<ProductDetailMoreDetailScreen> {
  bool _isInit = true;

  Product loadedProduct;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      loadedProduct = ModalRoute.of(context).settings.arguments as Product;
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;
    var currencyFormat = intl.NumberFormat.decimalPattern();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppTheme.appBarColor,
          iconTheme: new IconThemeData(color: AppTheme.appBarIconColor),
          elevation: 0,
          title: Text(
            'مشخصات',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppTheme.bg,
              fontFamily: 'Iransans',
              fontSize: textScaleFactor * 16.0,
            ),
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: HtmlWidget(
              loadedProduct.description,
              onTapUrl: (url) => showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text('onTapUrl'),
                  content: Text(url),
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
      ),
    );
  }
}
