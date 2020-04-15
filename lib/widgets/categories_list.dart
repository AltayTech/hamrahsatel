import 'package:flutter/material.dart';
import '../models/category.dart';
import '../widgets/categories_grid.dart';

import 'en_to_ar_number_convertor.dart';

class CategoriesList extends StatelessWidget {
  const CategoriesList({
    @required this.listTitle,
    @required this.list,
  });

  final String listTitle;
  final List<Category> list;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(listTitle),
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
        ),
        CategoryGrid(),
      ],
    );
  }
}
