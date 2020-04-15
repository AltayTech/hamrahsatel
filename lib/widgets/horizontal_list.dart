import 'package:flutter/material.dart';
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
              padding: const EdgeInsets.all(4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    listTitle,
                    style: TextStyle(
                      fontFamily: 'Iransans',
                      fontSize: MediaQuery.of(context).textScaleFactor * 12.0,
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
                                .sbrand = brandsEndpoint;
                            Provider.of<Products>(context, listen: false)
                                .scolor = colorsEndpoint;
                            Provider.of<Products>(context, listen: false)
                                .spriceRange = priceRange;
                            Provider.of<Products>(context, listen: false)
                                .spage = 1;
                            Provider.of<Products>(context, listen: false)
                                .ssellcase = sellcaseEndpoint;
                            Provider.of<Products>(context, listen: false)
                                .searchBuilder();
                            Provider.of<Products>(context, listen: false)
                                .checkfiltered();
                            if (isDiscounted) {
                              sellcaseEndpoint = endPointBuilder([73]);

                              Provider.of<Products>(context, listen: false)
                                  .ssellcase = sellcaseEndpoint;
                            }
                            ;

                            Provider.of<Products>(context, listen: false)
                                .searchBuilder();
                            Provider.of<Products>(context, listen: false)
                                .checkfiltered();

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
                                  fontSize:
                                      MediaQuery.of(context).textScaleFactor *
                                          12.0,
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
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