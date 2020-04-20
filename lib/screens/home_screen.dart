import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hamrahsatel/classes/flutter_carousel_slider.dart';
import 'package:hamrahsatel/models/gallery.dart';
import 'package:hamrahsatel/models/home_slider.dart';
import 'package:provider/provider.dart';

import '../classes/app_theme.dart';
import '../models/home_page.dart';
import '../models/product_cart.dart';
import '../provider/Products.dart';
import '../provider/auth.dart';
import '../screens/product_screen.dart';
import '../widgets/custom_dialog.dart';
import '../widgets/horizontal_list.dart';

class HomeScreeen extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomeScreeenState createState() => _HomeScreeenState();
}

class _HomeScreeenState extends State<HomeScreeen> {
  bool _isInit = true;
  final searchTextController = TextEditingController();
  int _current = 0;

  List<ProductCart> shoppItems;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<Products>(context, listen: false).fetchAndSetHomeData();
    }
    _isInit = false;
    bool _isFirstLogin = Provider.of<Auth>(context, listen: false).isFirstLogin;
    if (_isFirstLogin) {
      _showLogindialog(context);
    }
    bool _isFirstLogout =
        Provider.of<Auth>(context, listen: false).isFirstLogout;
    if (_isFirstLogout) {
      _showLogindialog_exit(context);
    }

    Provider.of<Auth>(context, listen: false).isFirstLogin = false;
    Provider.of<Auth>(context, listen: false).isFirstLogout = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    searchTextController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  void _showLogindialog(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showDialog<String>(
        context: context,
        builder: (ctx) => CustomDialog(
          title: 'خوش آمدید',
          buttonText: 'تایید',
          description:
              'برای دریافت اطلاعات کاربری به قسمت پروفایل مراجعه فرمایید',
        ),
      );
    });
  }

  void _showLogindialog_exit(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showDialog<String>(
        context: context,
        builder: (ctx) => CustomDialog(
          title: 'کاربر گرامی',
          buttonText: 'تایید',
          description: 'شما با موفقیت از اکانت کاربری خارج شدید',
        ),
      );
    });
  }

  Future<void> cleanFilters(BuildContext context) async {
    String brandsEndpoint = '';
    String colorsEndpoint = '';
    String sellcaseEndpoint = '';
    String priceRange = '';

    Provider.of<Products>(context, listen: false).searchKey = '';
    Provider.of<Products>(context, listen: false).filterTitle.clear();
    Provider.of<Products>(context, listen: false).sproductcat = '';
    Provider.of<Products>(context, listen: false).sbrand = brandsEndpoint;
    Provider.of<Products>(context, listen: false).scolor = colorsEndpoint;
    Provider.of<Products>(context, listen: false).spriceRange = priceRange;
    Provider.of<Products>(context, listen: false).spage = 1;
    Provider.of<Products>(context, listen: false).ssellcase = sellcaseEndpoint;
    Provider.of<Products>(context, listen: false).searchBuilder();
    Provider.of<Products>(context, listen: false).checkfiltered();
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;
    final HomePage loadedHomePage = Provider.of<Products>(context).homeItems;
    print('lenggggggggg' + loadedHomePage.categories.length.toString());
    List<HomeSlider> slider =loadedHomePage.sliders ;
    Provider.of<Auth>(context, listen: false).getToken();

    return SingleChildScrollView(
      child: Container(
        color: AppTheme.bg,
        child: Column(
          children: <Widget>[
            InkWell(
              onTap: () {
                cleanFilters(context);
                Provider.of<Products>(context).ssellcase = '71';

                Navigator.of(context)
                    .pushNamed(ProductsScreen.routeName, arguments: 0);
              },
              child: Container(
                height: deviceHeight * 0.25,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0.0,
                      right: 0.0,
                      child: CarouselSlider(
//                        aspectRatio: 11 / 9,
                        viewportFraction: 1.0,
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        reverse: false,
                        autoPlay: false,
                        autoPlayInterval: Duration(seconds: 3),
                        autoPlayAnimationDuration:
                            Duration(milliseconds: 800),
                        pauseAutoPlayOnTouch: Duration(seconds: 10),
                        enlargeCenterPage: true,
                        scrollDirection: Axis.horizontal,
                        onPageChanged: (index) {
                          _current = index;
                          setState(() {});
                        },
                        items: slider.map((gallery) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                  width: deviceWidth,
//                                  margin: EdgeInsets.symmetric(
//                                      horizontal: 5.0),
                                  child:
                                  Stack(
                                    children: <Widget>[

                                      Positioned.fill(

                                        child: FadeInImage(
                                          placeholder: AssetImage(
                                              'assets/images/circle.gif'),
                                          image: NetworkImage(gallery.featured_image),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
//                                      Center(
//                                        child: Text(
//                                          'جزئیات',
//                                          style: TextStyle(
//                                            color: AppTheme.primary,
//                                            fontFamily: 'Iransans',
//                                            fontWeight:FontWeight.bold,
//                                            fontSize: textScaleFactor * 20.0,
//                                          ),
//                                        ),
//                                      ),
                                    ],
                                  ));
                            },
                          );
                        }).toList(),
                      ),
                    ),
                    Positioned(
                      bottom: 3,
                      left: 0.0,
                      right: 0.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: slider.map<Widget>(
                          (index) {
                            return Container(
                              width: 10.0,
                              height: 10.0,
                              margin: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 2.0),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppTheme.h1),
                                  color: _current == slider.indexOf(index)
                                      ? AppTheme.h1
                                      : AppTheme.bg),
                            );
                          },
                        ).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            HorizontalList(
              list: loadedHomePage.ads_products,
              listTitle: 'موبایل',
              isAd: false,
              isDiscounted: false,
            ),
            HorizontalList(
              list: loadedHomePage.new_products,
              listTitle: 'تبلت',
              isAd: false,
              isDiscounted: false,
            ),
            HorizontalList(
              list: loadedHomePage.discount_products,
              listTitle: 'تجهیزات جانبی',
              isAd: false,
              isDiscounted: true,
            ),
            HorizontalList(
              list: loadedHomePage.discount_products,
              listTitle: 'باورنرکدنی',
              isAd: false,
              isDiscounted: true,
            ),
          ],
        ),
      ),
    );
  }
}
