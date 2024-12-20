import 'package:flutter/material.dart';
import '../models/shop.dart';
import '../customer_info.dart';
import 'package:provider/provider.dart';

import '../provider/app_theme.dart';
import '../widgets/main_drawer.dart';

class AboutUsScreen extends StatefulWidget {
  static const routeName = '/AboutUsScreen';

  @override
  _AboutUsScreenState createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  bool _isInit = true;

  Shop shopData;

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      await Provider.of<CustomerInfo>(context, listen: false).fetchShopData();
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;
    shopData = Provider.of<CustomerInfo>(context,
    ).shop;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'درباره ما',
          style: TextStyle(
            color: AppTheme.bg,
            fontFamily: 'Iransans',
            fontSize: textScaleFactor * 18.0,
          ),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        backgroundColor: AppTheme.appBarColor,
        iconTheme: new IconThemeData(color: AppTheme.appBarIconColor),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                      width: deviceWidth * 0.3,
                      height: deviceWidth * 0.3,
                      color: AppTheme.bg,
                      child: FadeInImage(
                        placeholder: AssetImage('assets/images/circle.gif'),
                        image: NetworkImage(shopData.logo),
                        fit: BoxFit.contain,
                        height: deviceWidth * 0.5,
                      )),
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Text(
                      shopData.shop_name,
                      style: TextStyle(
                        color: AppTheme.primary,
                        fontFamily: 'BFarnaz',
                        fontSize: textScaleFactor * 24.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Text(
                      shopData.shop_type,
                      style: TextStyle(
                        color: AppTheme.primary,
                        fontFamily: 'Iransans',
                        fontSize: textScaleFactor * 15.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        shopData.about_shop,
                        style: TextStyle(
                          color: AppTheme.black,
                          fontFamily: 'Iransans',
                          fontSize: textScaleFactor * 15.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Container(
                    height: deviceHeight * 0.7,
                    width: deviceWidth,
                    child: ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: shopData.shop_features.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.arrow_right,color: AppTheme.secondary,),
                              Text(
                                shopData.shop_features[index],
                                style: TextStyle(
                                  color: AppTheme.primary,
                                  fontFamily: 'Iransans',
                                  fontStyle: FontStyle.italic,
                                  fontSize: textScaleFactor * 15.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
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
      endDrawer: Theme(
        data: Theme.of(context).copyWith(
          // Set the transparency here
          canvasColor: Colors
              .transparent, //or any other color you want. e.g Colors.blue.withOpacity(0.5)
        ),
        child: MainDrawer(),
      ),
    );
  }
}
