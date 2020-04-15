import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';

import '../models/home_page.dart';
import '../provider/Products.dart';
import 'en_to_ar_number_convertor.dart';

class FilterDrawer extends StatefulWidget {
  final Function callback;

  FilterDrawer(this.callback);

  @override
  _FilterDrawerState createState() => _FilterDrawerState();
}

class _FilterDrawerState extends State<FilterDrawer> {
  var _value = 10;

  double startValue = 0;

  double endValue = 30000000;

  var _isPrice = false;
  bool isQesti = false;
  bool isDiscounted = false;
  bool isSpSell = false;

  Widget buildListTile(String title, IconData icon, Function tapHandler) {
    return ListTile(
      leading: Icon(
        icon,
        size: 26,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: tapHandler,
    );
  }

  double _minPriceValueC = 0;
  double _maxPriceValueC = 30000000;
  List<int> _selectedColorIndexs = [];
  List<int> _selectedColorId = [];
  List<String> _selectedColorTitle = [];
  List<int> _selectedBrandIndexs = [];
  List<int> _selectedBrandId = [];
  List<String> _selectedBrandTitle = [];
  List<int> _selectedSellCaseId = [];
  List<String> _selectedSellcaseTitle = [];

  String endPointBuilder(List<dynamic> input) {
    String outPutString = '';
    for (int i = 0; i < input.length; i++) {
      i == 0
          ? outPutString = input[i].toString()
          : outPutString = outPutString + ',' + input[i].toString();
    }
    return outPutString;
  }

  void addToFilterList(List<dynamic> input) {
    for (int i = 0; i < input.length; i++) {
      Provider.of<Products>(context, listen: false).filterTitle.add(input[i]);
    }
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;
    final HomePage loadedHomePage = Provider.of<Products>(context).homeItems;

    var currencyFormat = intl.NumberFormat.decimalPattern();

    return Drawer(
      child: SingleChildScrollView(
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: ListTile(
                title: Text(
                  'برندها: ' +
                      EnArConvertor().replaceArNumber(currencyFormat
                          .format(loadedHomePage.brands.length)
                          .toString()),
                  style: TextStyle(
                    fontFamily: "Iransans",
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.right,
                ),
                onTap: () {
                  Navigator.of(context).pushReplacementNamed('/');
                },
              ),
            ),
            Container(
              height: deviceHeight * 0.1,
              child: GridView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: loadedHomePage.brands.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    highlightColor: Colors.deepOrange,
                    focusColor: Colors.deepOrange,
                    splashColor: Colors.purpleAccent,
                    onTap: () {
                      if (_selectedBrandIndexs.contains(index)) {
                        _selectedBrandIndexs.remove(index);
                        _selectedBrandId
                            .remove(loadedHomePage.brands[index].id);
                        _selectedBrandTitle
                            .remove(loadedHomePage.brands[index].title);
                      } else {
                        _selectedBrandIndexs.add(index);
                        _selectedBrandId.add(loadedHomePage.brands[index].id);
                        _selectedBrandTitle
                            .add(loadedHomePage.brands[index].title);
                      }

                      setState(() {});
                    },
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: _selectedBrandIndexs.contains(index)
                          ? BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                left:
                                    BorderSide(color: Colors.grey, width: 0.5),
                                right:
                                    BorderSide(color: Colors.grey, width: 0.5),
                                bottom:
                                    BorderSide(color: Colors.grey, width: 0.5),
                                top:
                                    BorderSide(color: Colors.black87, width: 3),
                              ),
                            )
                          : BoxDecoration(
                              color: Colors.transparent,
                            ),
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(3),
                                width: 80.0,
                                height: 80.0,
                                child: FadeInImage(
                                  placeholder:
                                      AssetImage('assets/images/logo.png'),
                                  image: NetworkImage(loadedHomePage
                                      .brands[index].brand_img_url),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  loadedHomePage.brands[index].title,
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontFamily: 'Iransans',
                                    fontSize: textScaleFactor * 10.0,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  childAspectRatio: 1.6,
                  crossAxisSpacing: 1,
                  mainAxisSpacing: 3,
                ),
              ),
            ),
            Divider(
              height: 1,
              color: Colors.grey.withOpacity(0.6),
            ),
            ListTile(
              title: Text(
                'رنگها: ' +
                    EnArConvertor().replaceArNumber(currencyFormat
                        .format(loadedHomePage.colors.length)
                        .toString()),
                style: TextStyle(
                  fontFamily: "Iransans",
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.right,
              ),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/');
              },
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Container(
                height: deviceHeight * 0.09,
                child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: loadedHomePage.colors.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      highlightColor: Colors.deepOrange,
                      focusColor: Colors.deepOrange,
                      splashColor: Colors.purpleAccent,
                      onTap: () {
                        if (_selectedColorIndexs.contains(index)) {
                          _selectedColorIndexs.remove(index);
                          _selectedColorId
                              .remove(loadedHomePage.colors[index].id);
                          _selectedColorTitle
                              .remove(loadedHomePage.colors[index].title);
                        } else {
                          _selectedColorIndexs.add(index);
                          _selectedColorId.add(loadedHomePage.colors[index].id);
                          _selectedColorTitle
                              .add(loadedHomePage.colors[index].title);
                        }
                        setState(() {});
                      },
                      child: Container(
                        width: 30,
                        height: 50,
                        decoration: _selectedColorIndexs.contains(index)
                            ? BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                  left: BorderSide(
                                      color: Colors.grey, width: 0.5),
                                  right: BorderSide(
                                      color: Colors.grey, width: 0.5),
                                  bottom: BorderSide(
                                      color: Colors.grey, width: 0.5),
                                  top: BorderSide(
                                      color: Colors.black87, width: 3),
                                ),
                              )
                            : BoxDecoration(
                                color: Colors.transparent,
                              ),
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(3),
                                  width: 20.0,
                                  height: 20.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(
                                      int.parse(
                                        '0xff' +
                                            loadedHomePage
                                                .colors[index].color_code
                                                .replaceRange(0, 1, ''),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Text(
                                    loadedHomePage.colors[index].title,
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontFamily: 'Iransans',
                                      fontSize: textScaleFactor * 10.0,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: 1.6,
                    crossAxisSpacing: 1,
                    mainAxisSpacing: 3,
                  ),
                ),
              ),
            ),
            Divider(
              height: 1,
              color: Colors.grey.withOpacity(0.6),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Switch(
                    value: isQesti,
                    onChanged: (value) {
                      if (value) {
                        _selectedSellCaseId.add(72);
                        _selectedSellcaseTitle.remove('قسطی');

                        _selectedSellcaseTitle.add('قسطی');
                      } else {
                        _selectedSellCaseId.remove(72);
                        _selectedSellcaseTitle.remove('قسطی');
                      }
                      setState(() {
                        isQesti = value;
                      });
                    },
                    activeTrackColor: Colors.lightGreenAccent,
                    activeColor: Colors.green,
                  ),
                  Text(
                    'فقط اقساطی',
                    style: TextStyle(
                      fontFamily: "Iransans",
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Switch(
                    value: isDiscounted,
                    onChanged: (value) {
                      if (value) {
                        _selectedSellCaseId.add(73);
                        _selectedSellcaseTitle.remove('تخفیف دار');

                        _selectedSellcaseTitle.add('تخفیف دار');
                      } else {
                        _selectedSellCaseId.remove(73);
                        _selectedSellcaseTitle.remove('تخفیف دار');
                      }

                      setState(() {
                        isDiscounted = value;
                      });
                    },
                    activeTrackColor: Colors.lightGreenAccent,
                    activeColor: Colors.green,
                  ),
                  Text(
                    'محصولات تخفیف دار',
                    style: TextStyle(
                      fontFamily: "Iransans",
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Switch(
                    value: isSpSell,
                    onChanged: (value) {
                      if (value) {
                        _selectedSellCaseId.add(71);
                        _selectedSellcaseTitle.remove('فروش ویژه');

                        _selectedSellcaseTitle.add('فروش ویژه');
                      } else {
                        _selectedSellCaseId.remove(71);
                        _selectedSellcaseTitle.remove('فروش ویژه');
                      }

                      setState(() {
                        isSpSell = value;
                      });
                    },
                    activeTrackColor: Colors.lightGreenAccent,
                    activeColor: Colors.green,
                  ),
                  Text(
                    'فروش ویژه',
                    style: TextStyle(
                      fontFamily: "Iransans",
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 1,
              color: Colors.grey.withOpacity(0.6),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Wrap(
                direction: Axis.horizontal,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  Text(
                    'محدوده قیمت',
                    style: TextStyle(
                      fontFamily: "Iransans",
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  Checkbox(
                    onChanged: (value) {
                      _isPrice ? _isPrice = false : _isPrice = true;
                      setState(() {});
                    },
                    value: _isPrice,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          child: Text(
                            EnArConvertor().replaceArNumber(currencyFormat
                                .format((_minPriceValueC))
                                .toString()),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: _isPrice ? Colors.blue : Colors.grey,
                              fontFamily: 'Iransans',
                              fontSize: textScaleFactor * 15.0,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Container(
                          child: Text(
                            'تومان',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey,
                              fontFamily: 'Iransans',
                              fontSize: textScaleFactor * 12.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          child: Text(
                            EnArConvertor().replaceArNumber(currencyFormat
                                .format((_maxPriceValueC))
                                .toString()),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: _isPrice ? Colors.blue : Colors.grey,
                              fontFamily: 'Iransans',
                              fontSize: textScaleFactor * 15.0,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Container(
                          child: Text(
                            'تومان',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey,
                              fontFamily: 'Iransans',
                              fontSize: textScaleFactor * 12.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            RangeSlider(
              labels: RangeLabels(
                  EnArConvertor().replaceArNumber(
                      currencyFormat.format((startValue)).toString()),
                  EnArConvertor().replaceArNumber(
                      currencyFormat.format((endValue)).toString())),
              onChanged: (value) {
                startValue = value.start;
                endValue = value.end;
                _minPriceValueC = value.start;
                _maxPriceValueC = value.end;
                print(_minPriceValueC);
                print(_maxPriceValueC);
                setState(() {});
              },
              divisions: 30000,
              values: RangeValues(startValue, endValue),
              min: 0,
              max: 30000000,
              activeColor: _isPrice ? Colors.blue : Colors.grey,
              inactiveColor: Colors.grey,
            ),
            Divider(
              height: 1,
              color: Colors.grey.withOpacity(0.6),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
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

                          Provider.of<Products>(context, listen: false).sbrand =
                              brandsEndpoint;
                          Provider.of<Products>(context, listen: false).scolor =
                              colorsEndpoint;
                          Provider.of<Products>(context, listen: false)
                              .spriceRange = priceRange;
                          Provider.of<Products>(context, listen: false).spage =
                              1;
                          Provider.of<Products>(context, listen: false)
                              .ssellcase = sellcaseEndpoint;
                          Provider.of<Products>(context, listen: false)
                              .searchBuilder();
                          Provider.of<Products>(context, listen: false)
                              .checkfiltered();

                          brandsEndpoint = endPointBuilder(_selectedBrandId);
                          addToFilterList(_selectedColorTitle);
                          addToFilterList(_selectedBrandTitle);
                          addToFilterList(_selectedSellcaseTitle);

                          colorsEndpoint = endPointBuilder(_selectedColorId);
                          sellcaseEndpoint =
                              endPointBuilder(_selectedSellCaseId);
                          priceRange = '$startValue,$endValue';

                          Provider.of<Products>(context, listen: false).sbrand =
                              brandsEndpoint;
                          Provider.of<Products>(context, listen: false).scolor =
                              colorsEndpoint;
                          _isPrice
                              ? Provider.of<Products>(context, listen: false)
                                  .spriceRange = priceRange
                              : Provider.of<Products>(context, listen: false)
                                  .spriceRange = '';
                          Provider.of<Products>(context, listen: false)
                              .ssellcase = sellcaseEndpoint;
                          Provider.of<Products>(context, listen: false)
                              .searchBuilder();
                          Provider.of<Products>(context, listen: false)
                              .checkfiltered();

                          widget.callback();
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: deviceHeight * 0.06,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 15.0, right: 15, top: 4),
                              child: Text(
                                'اعمال فیلتر',
                                style: TextStyle(
                                  fontFamily: "Iransans",
                                  fontSize: textScaleFactor * 16,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          String brandsEndpoint = '';
                          String colorsEndpoint = '';
                          String sellcaseEndpoint = '';
                          String priceRange = '';

                          Provider.of<Products>(context, listen: false)
                              .searchKey = '';
                          Provider.of<Products>(context, listen: false)
                              .filterTitle
                              .clear();

                          Provider.of<Products>(context, listen: false).sbrand =
                              brandsEndpoint;
                          Provider.of<Products>(context, listen: false).spage =
                              1;
                          Provider.of<Products>(context, listen: false).scolor =
                              colorsEndpoint;
                          Provider.of<Products>(context, listen: false)
                              .spriceRange = priceRange;
                          Provider.of<Products>(context, listen: false).spage =
                              1;
                          Provider.of<Products>(context, listen: false)
                              .ssellcase = sellcaseEndpoint;
                          Provider.of<Products>(context, listen: false)
                              .sproductcat = '';
                          Provider.of<Products>(context, listen: false)
                              .searchBuilder();
                          Provider.of<Products>(context, listen: false)
                              .checkfiltered();

                          widget.callback();
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: deviceHeight * 0.06,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: Colors.grey,
                            ),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 15.0, right: 15, top: 4),
                              child: Text(
                                'حذف فیلتر',
                                style: TextStyle(
                                  fontFamily: "Iransans",
                                  fontSize: textScaleFactor * 16,
                                  color: Colors.blue,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
