import 'package:flutter/material.dart';

import '../models/brand.dart';
import '../widgets/brands_grid.dart';
import 'en_to_ar_number_convertor.dart';

class BrandsList extends StatelessWidget {
  const BrandsList({
    @required this.listTitle,
    @required this.list,
  });

  final String listTitle;
  final List<Brand> list;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(listTitle),
            Spacer(),
            Text(
              'تعداد: ' +
                  EnArConvertor().replaceArNumber((list.length).toString()),
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.grey,
                fontFamily: 'Iransans',
                fontSize: MediaQuery.of(context).textScaleFactor * 14.0,
              ),
            ),
          ],
        ),
        BrandGrid(),
      ],
    );
  }
}
