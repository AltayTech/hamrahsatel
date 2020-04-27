import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hamrahsatel/models/brand.dart';
import 'package:hamrahsatel/models/color_code.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';

import '../classes/app_theme.dart';
import '../models/home_page.dart';
import '../models/product.dart';
import '../models/products_detail.dart';
import '../provider/Products.dart';
import '../widgets/badge.dart';
import '../widgets/en_to_ar_number_convertor.dart';
import '../widgets/filter_drawer.dart';
import '../widgets/main_drawer.dart';
import '../widgets/product_item_product_screeen.dart';
import 'cart_screen.dart';

class ProductsScreen extends StatefulWidget {
  static const routeName = '/productScreen';

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen>
    with SingleTickerProviderStateMixin {
  bool _isInit = true;

  final searchTextController = TextEditingController();
  ScrollController _scrollController = new ScrollController();

  var _isLoading;

  var scaffoldKey;
  int page = 1;

  ProductsDetail productsDetail;

  List<String> filterList = [];

  HomePage loadedHomePage;

  var sortValue = 'جدیدترین';
  List<String> sortValueList = ['جدیدترین', 'گرانترین', 'ارزانترین'];

  List<int> _selectedCategoryIndexs = [];
  int _selectedCategoryId = 0;
  List<String> _selectedCategoryTitle = [];

  var colorValue;
  List<String> colorValueList = [];
  List<ColorCode> colorList = [];
  ColorCode selectedColor;

  var brandValue;
  List<String> brandValueList = [];
  List<Brand> brandList = [];
  Brand selectedBrand;

  @override
  void initState() {
    Provider.of<Products>(context, listen: false).spage = 1;

    Provider.of<Products>(context, listen: false).searchBuilder();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        page = page + 1;
        Provider.of<Products>(context, listen: false).spage = page;

        searchItems();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      int tabIndex = ModalRoute.of(context).settings.arguments as int;
      print(_isLoading.toString());

      loadedHomePage = Provider.of<Products>(context).homeItems;
      print(_isLoading.toString());

      Provider.of<Products>(context, listen: false).searchBuilder();
      print(_isLoading.toString());

      Provider.of<Products>(context, listen: false).checkfiltered();
      print(_isLoading.toString());

      brandList = loadedHomePage.brands;
      for (int i = 0; i < brandList.length; i++) {
        print(i.toString());
        brandValueList.add(brandList[i].title);
      }
      print('brand');

      colorList = loadedHomePage.colors;
      for (int i = 0; i < colorList.length; i++) {
        print(i.toString());
        colorValueList.add(colorList[i].title);
      }
      print('color');

      searchItems();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  List<Product> loadedProducts = [];
  List<Product> loadedProductstolist = [];

  Future<void> _submit() async {
    loadedProducts.clear();
    loadedProducts = await Provider.of<Products>(context).items;
    loadedProductstolist.addAll(loadedProducts);
  }

  Future<void> filterItems() async {
    loadedProductstolist.clear();
    await searchItems();
  }

  Future<void> searchItems() async {
    setState(() {
      _isLoading = true;
    });
    print(_isLoading.toString());

    Provider.of<Products>(context, listen: false).searchBuilder();
    await Provider.of<Products>(context, listen: false).searchItem();
    productsDetail = Provider.of<Products>(context).searchDetails;
    filterList = Provider.of<Products>(context).filterTitle;

    print(_isLoading.toString());
    print(_isLoading.toString());
    _submit();

    setState(() {
      _isLoading = false;
      print(_isLoading.toString());
    });
    print(_isLoading.toString());
  }

  Future<void> changeCat(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    print(_isLoading.toString());

    String brandsEndpoint = '';
    String colorsEndpoint = '';
    String sellcaseEndpoint = '';
    String priceRange = '';

    Provider.of<Products>(context, listen: false).filterTitle.clear();

    Provider.of<Products>(context, listen: false).searchKey = '';

    Provider.of<Products>(context, listen: false).sbrand = brandsEndpoint;
    Provider.of<Products>(context, listen: false).scolor = colorsEndpoint;
    Provider.of<Products>(context, listen: false).spriceRange = priceRange;
    Provider.of<Products>(context, listen: false).spage = 1;
    Provider.of<Products>(context, listen: false).ssellcase = sellcaseEndpoint;

    Provider.of<Products>(context, listen: false).searchBuilder();
    Provider.of<Products>(context, listen: false).checkfiltered();

    addToFilterList(_selectedCategoryTitle);

    String categoriesEndpoint =
        _selectedCategoryId != 0 ? '$_selectedCategoryId' : '';
    Provider.of<Products>(context, listen: false).scategory =
        categoriesEndpoint;

    Provider.of<Products>(context, listen: false).searchBuilder();
    Provider.of<Products>(context, listen: false).checkfiltered();
    loadedProductstolist.clear();

    await searchItems();

    setState(() {
      _isLoading = false;
      print(_isLoading.toString());
    });
  }

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
    var deviceAspectRatio = MediaQuery.of(context).size.aspectRatio;

    var currencyFormat = intl.NumberFormat.decimalPattern();
    loadedHomePage = Provider.of<Products>(context).homeItems;
    print('category length ' + loadedHomePage.categories.length.toString());
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Color(0xffF9F9F9),
        appBar: AppBar(
          backgroundColor: AppTheme.appBarColor,
          iconTheme: new IconThemeData(color: AppTheme.appBarIconColor),
          elevation: 0,
          centerTitle: true,
          actions: <Widget>[
            Consumer<Products>(
              builder: (_, products, ch) => Badge(
                color: products.cartItemsCount == 0
                    ? AppTheme.accent
                    : AppTheme.secondary,
                value: products.cartItemsCount.toString(),
                child: ch,
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
                color: AppTheme.bg,
                icon: Icon(
                  Icons.shopping_cart,
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: deviceHeight * 0.0, horizontal: deviceWidth * 0.03),
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                      child: Container(
                        height: deviceHeight * 0.05,
                        width: deviceWidth,
                        child: Row(
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                _selectedCategoryIndexs.clear();
                                _selectedCategoryTitle.clear();

                                _selectedCategoryIndexs.add(-1);
                                _selectedCategoryId = 0;
                                _selectedCategoryTitle.add('همه');

                                filterList = [];

                                colorValue = null;

                                brandValue = null;

                                changeCat(context);
                              },
                              child: Container(
                                decoration: _selectedCategoryId == 0
                                    ? BoxDecoration(
                                        color: AppTheme.bg,
                                        border: Border(
                                          bottom: BorderSide(
                                              color: AppTheme.primary,
                                              width: 3),
                                        ),
                                      )
                                    : BoxDecoration(
                                        color: Colors.transparent,
                                      ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(
                                      'همه',
                                      style: TextStyle(
                                        color: _selectedCategoryId == 0
                                            ? AppTheme.primary
                                            : AppTheme.h1,
                                        fontFamily: 'Iransans',
                                        fontSize: textScaleFactor * 14.0,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: loadedHomePage.categories.length,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  child: InkWell(
                                    onTap: () {
                                      _selectedCategoryIndexs.clear();
                                      _selectedCategoryTitle.clear();

                                      _selectedCategoryIndexs.add(index);
                                      _selectedCategoryId = loadedHomePage
                                          .categories[index].cat_ID;
                                      _selectedCategoryTitle.add(loadedHomePage
                                          .categories[index].name);
                                      colorValue = null;

                                      brandValue = null;

                                      changeCat(context);
                                    },
                                    child: Container(
                                      decoration: _selectedCategoryIndexs
                                              .contains(index)
                                          ? BoxDecoration(
                                              color: AppTheme.bg,
                                              border: Border(
                                                bottom: BorderSide(
                                                    color: AppTheme.primary,
                                                    width: 3),
                                              ),
                                            )
                                          : BoxDecoration(
                                              color: Colors.transparent,
                                            ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: Text(
                                            loadedHomePage.categories[index]
                                                        .name !=
                                                    null
                                                ? loadedHomePage
                                                    .categories[index].name
                                                : 'n',
                                            style: TextStyle(
                                              color: loadedHomePage
                                                          .categories[index]
                                                          .cat_ID ==
                                                      _selectedCategoryId
                                                  ? AppTheme.primary
                                                  : AppTheme.h1,
                                              fontFamily: 'Iransans',
                                              fontSize: textScaleFactor * 14.0,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Builder(builder: (context) {
                              return InkWell(
                                onTap: () {
                                  Scaffold.of(context).openEndDrawer();
                                },
                                child: Container(
                                  height: deviceHeight * 0.045,
                                  width: deviceHeight * 0.05,
                                  decoration: BoxDecoration(
                                    color: AppTheme.h1,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.filter_list,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              );
                            }),
                            Directionality(
                              textDirection: TextDirection.ltr,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  decoration: BoxDecoration(
                                      color: AppTheme.white,
                                      border: Border.all(
                                          color: AppTheme.h1, width: 0.2)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        right: 8.0, left: 8, top: 6),
                                    child: DropdownButton<String>(
                                      value: sortValue,
                                      icon: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10.0),
                                        child: Icon(
                                          Icons.arrow_drop_down,
                                          color: AppTheme.black,
                                          size: 20,
                                        ),
                                      ),
                                      style: TextStyle(
                                        color: AppTheme.black,
                                        fontFamily: 'Iransans',
                                        fontSize: textScaleFactor * 13.0,
                                      ),
                                      isDense: true,
                                      onChanged: (newValue) {
                                        setState(() {
                                          sortValue = newValue;

                                          if (sortValue == 'گرانترین') {
                                            Provider.of<Products>(context,
                                                    listen: false)
                                                .sorder = 'desc';
                                            Provider.of<Products>(context,
                                                    listen: false)
                                                .sorderby = 'price';
                                            page = 1;
                                            Provider.of<Products>(context,
                                                    listen: false)
                                                .spage = page;
                                            loadedProductstolist.clear();

                                            searchItems();
                                          } else if (sortValue == 'ارزانترین') {
                                            Provider.of<Products>(context,
                                                    listen: false)
                                                .sorder = 'asc';
                                            Provider.of<Products>(context,
                                                    listen: false)
                                                .sorderby = 'price';

                                            page = 1;
                                            Provider.of<Products>(context,
                                                    listen: false)
                                                .spage = page;
                                            loadedProductstolist.clear();

                                            searchItems();
                                          } else {
                                            Provider.of<Products>(context,
                                                    listen: false)
                                                .sorder = 'desc';
                                            Provider.of<Products>(context,
                                                    listen: false)
                                                .sorderby = 'date';
                                            page = 1;
                                            Provider.of<Products>(context,
                                                    listen: false)
                                                .spage = page;
                                            loadedProductstolist.clear();

                                            searchItems();
                                          }
                                        });
                                      },
                                      items: sortValueList
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 3.0),
                                            child: Text(
                                              value,
                                              style: TextStyle(
                                                color: AppTheme.black,
                                                fontFamily: 'Iransans',
                                                fontSize:
                                                    textScaleFactor * 13.0,
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Spacer(),
                            Directionality(
                              textDirection: TextDirection.ltr,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  decoration: BoxDecoration(
                                      color: AppTheme.white,
                                      border: Border.all(
                                          color: AppTheme.h1, width: 0.2)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        right: 8.0, left: 8, top: 6),
                                    child: DropdownButton<String>(
                                      hint: Text(
                                        'برندها',
                                        style: TextStyle(
                                          color: AppTheme.black,
                                          fontFamily: 'Iransans',
                                          fontSize: textScaleFactor * 13.0,
                                        ),
                                      ),
                                      value: brandValue,
                                      icon: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10.0),
                                        child: Icon(
                                          Icons.arrow_drop_down,
                                          color: AppTheme.black,
                                          size: 20,
                                        ),
                                      ),
                                      dropdownColor: AppTheme.white,
                                      style: TextStyle(
                                        color: AppTheme.black,
                                        fontFamily: 'Iransans',
                                        fontSize: textScaleFactor * 13.0,
                                      ),
                                      isDense: true,
                                      onChanged: (newValue) {
                                        setState(() {
                                          brandValue = newValue;
                                          selectedBrand = brandList[
                                              brandValueList
                                                  .lastIndexOf(newValue)];

                                          String brandsEndpoint =
                                              '${selectedBrand.id}';

                                          Provider.of<Products>(context,
                                                  listen: false)
                                              .sbrand = brandsEndpoint;

                                          Provider.of<Products>(context,
                                                  listen: false)
                                              .spage = 1;

                                          Provider.of<Products>(context,
                                                  listen: false)
                                              .searchBuilder();
                                          Provider.of<Products>(context,
                                                  listen: false)
                                              .checkfiltered();
                                          loadedProductstolist.clear();

                                          searchItems();
                                        });
                                      },
                                      items: brandValueList
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 3.0),
                                            child: Text(
                                              value,
                                              style: TextStyle(
                                                color: AppTheme.black,
                                                fontFamily: 'Iransans',
                                                fontSize:
                                                    textScaleFactor * 13.0,
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Directionality(
                              textDirection: TextDirection.ltr,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  decoration: BoxDecoration(
                                      color: AppTheme.white,
                                      border: Border.all(
                                          color: AppTheme.h1, width: 0.2)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      right: 8.0,
                                      left: 8,
                                      top: 6,
                                    ),
                                    child: DropdownButton<String>(
                                      hint: Center(
                                        child: Text(
                                          'رنگها',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: AppTheme.black,
                                            fontFamily: 'Iransans',
                                            fontSize: textScaleFactor * 13.0,
                                          ),
                                        ),
                                      ),
                                      value: colorValue,
                                      icon: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10.0),
                                        child: Icon(
                                          Icons.arrow_drop_down,
                                          color: AppTheme.black,
                                          size: 24,
                                        ),
                                      ),
                                      dropdownColor: AppTheme.white,
                                      iconSize: 24,
                                      style: TextStyle(
                                        color: AppTheme.black,
                                        fontFamily: 'Iransans',
                                        fontSize: textScaleFactor * 13.0,
                                      ),
                                      isDense: true,
                                      onChanged: (newValue) {
                                        setState(() {
                                          colorValue = newValue;

                                          selectedColor = colorList[
                                              colorValueList
                                                  .lastIndexOf(newValue)];

                                          String colorsEndpoint =
                                              '${selectedColor.id}';

                                          Provider.of<Products>(context,
                                                  listen: false)
                                              .scolor = colorsEndpoint;

                                          Provider.of<Products>(context,
                                                  listen: false)
                                              .spage = 1;

                                          Provider.of<Products>(context,
                                                  listen: false)
                                              .searchBuilder();
                                          Provider.of<Products>(context,
                                                  listen: false)
                                              .checkfiltered();
                                          loadedProductstolist.clear();

                                          searchItems();
                                        });
                                      },
                                      items: colorValueList
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 3.0),
                                            child: Text(
                                              value,
                                              style: TextStyle(
                                                color: AppTheme.black,
                                                fontFamily: 'Iransans',
                                                fontSize:
                                                    textScaleFactor * 13.0,
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider(thickness: 1, color: AppTheme.h1),
                        Consumer<Products>(builder: (_, products, ch) {
                          return Container(
                            width: double.infinity,
                            child: Wrap(
                                alignment: WrapAlignment.start,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                direction: Axis.horizontal,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 3, vertical: 5),
                                    child: Text(
                                      'تعداد:',
                                      style: TextStyle(
                                        fontFamily: 'Iransans',
                                        fontSize: textScaleFactor * 12.0,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 4.0, left: 6),
                                    child: Text(
                                      productsDetail != null
                                          ? EnArConvertor().replaceArNumber(
                                              productsDetail.total.toString())
                                          : EnArConvertor()
                                              .replaceArNumber('0'),
                                      style: TextStyle(
                                        fontFamily: 'Iransans',
                                        fontSize: textScaleFactor * 13.0,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 3, vertical: 5),
                                    child: Text(
                                      filterList.length == 0 ? '' : 'فیلتر',
                                      style: TextStyle(
                                        fontFamily: 'Iransans',
                                        fontSize: textScaleFactor * 12.0,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: deviceWidth * 0.65,
                                    height: deviceHeight * 0.06,
                                    child: filterList.length == 0
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 3, vertical: 5),
                                            child: Container(
                                              child: Text(
                                                '',
                                                style: TextStyle(
                                                  fontFamily: 'Iransans',
                                                  fontSize:
                                                      textScaleFactor * 12.0,
                                                ),
                                              ),
                                              alignment: Alignment.centerRight,
                                            ),
                                          )
                                        : ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: filterList.length,
                                            itemBuilder: (ctx, i) => Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: Chip(
                                                label: Text(
                                                  filterList[i],
                                                  style: TextStyle(
                                                    fontFamily: 'Iransans',
                                                    fontSize:
                                                        textScaleFactor * 12.0,
                                                  ),
                                                ),
                                                padding: EdgeInsets.all(0),
                                                backgroundColor: Colors.black12,
                                              ),
                                            ),
                                          ),
                                  ),
                                ]),
                          );
                        }),
                        Container(
                          width: double.infinity,
                          height: deviceHeight * 0.68,
                          child: ListView.builder(
                            controller: _scrollController,
                            scrollDirection: Axis.vertical,
                            itemCount: loadedProductstolist.length,
                            itemBuilder: (ctx, i) =>
                                ChangeNotifierProvider.value(
                              value: loadedProductstolist[i],
                              child: ProductItemProductScreen(),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
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
                            : Container(
                                child: loadedProductstolist.isEmpty
                                    ? Center(
                                        child: Text(
                                        'محصولی وجود ندارد',
                                        style: TextStyle(
                                          fontFamily: 'Iransans',
                                          fontSize: textScaleFactor * 15.0,
                                        ),
                                      ))
                                    : Container())))
              ],
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
        endDrawer: FilterDrawer(filterItems),
      ),
    );
  }
}
