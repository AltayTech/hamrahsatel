import 'package:flutter/material.dart';
import '../provider/app_theme.dart';
import 'package:provider/provider.dart';

import '../models/productm.dart';
import '../provider/Products.dart';
import '../screens/product_screen.dart';
import '../widgets/product_grid.dart';

class HorizontalList extends StatelessWidget {
  final String listTitle;
  final List<Productm> list;
  final bool isAd;
  final bool isNew;
  final bool isDiscounted;

  const HorizontalList({
    @required this.listTitle,
    @required this.list,
    this.isAd,
    this.isNew,
    this.isDiscounted,
  });

  String endPointBuilder(List<dynamic> input) {
    String outPutString = '';
    for (int i = 0; i < input.length; i++) {
      i == 0
          ? outPutString = input[i].toString()
          : outPutString = outPutString + ',' + input[i].toString();
    }
    return outPutString;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 5),
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(top:4.0,bottom: 4,left: 10,right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    listTitle,
                    style: TextStyle(
                      fontFamily: 'Iransans',
                      color: AppTheme.black.withOpacity(0.6),
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).textScaleFactor * 14.0,
                    ),
                  ),
                  isAd
                      ? Container()
                      : InkWell(
                          onTap: () {
                            String brandsEndpoint = '';
                            String colorsEndpoint = '';
                            String sellcaseEndpoint = '';
                            String priceRange = '';
                            Provider.of<Products>(context, listen: false)
                                .filterTitle
                                .clear();

                            Provider.of<Products>(context, listen: false)
                                .searchKey = '';

                            Provider.of<Products>(context, listen: false)
                                .sBrand = brandsEndpoint;
                            Provider.of<Products>(context, listen: false)
                                .sColor = colorsEndpoint;
                            Provider.of<Products>(context, listen: false)
                                .sPriceRange = priceRange;
                            Provider.of<Products>(context, listen: false)
                                .sPage = 1;
                            Provider.of<Products>(context, listen: false)
                                .sSellCase = sellcaseEndpoint;
                            Provider.of<Products>(context, listen: false)
                                .searchBuilder();
                            Provider.of<Products>(context, listen: false)
                                .checkFiltered();
                            if (isDiscounted) {
                              sellcaseEndpoint = endPointBuilder([73]);

                              Provider.of<Products>(context, listen: false)
                                  .sSellCase = sellcaseEndpoint;
                            }
                            ;

                            Provider.of<Products>(context, listen: false)
                                .searchBuilder();
                            Provider.of<Products>(context, listen: false)
                                .checkFiltered();

                            return Navigator.of(context).pushNamed(
                                ProductsScreen.routeName,
                                arguments: 0);
                          },
                          child: Wrap(
                            direction: Axis.horizontal,
                            children: <Widget>[
                              Text(
                                'همه',
                                style: TextStyle(
                                  fontFamily: 'Iransans',
                                  color: AppTheme.h1,

                                  fontSize:
                                      MediaQuery.of(context).textScaleFactor *
                                          12.0,
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: AppTheme.h1,

                                size: 15,
                              ),
                            ],
                          ),
                        ),
                ],
              ),
            ),
          ),
          ProductGrid(
            loadedSalon: list,
          ),
        ],
      ),
    );
  }
}
