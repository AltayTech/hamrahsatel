import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../classes/flutter_carousel_slider.dart';
import '../models/home_slider.dart';
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

  List<HomeSlider> slider = [];

  HomePage loadedHomePage;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      _isInit = false;

      loadedHomePage = Provider.of<Products>(context).homeItems;

      await Provider.of<Products>(context, listen: false).fetchAndSetHomeData();
      loadedHomePage = Provider.of<Products>(context).homeItems;
      slider = loadedHomePage.sliders;
      Provider.of<Auth>(context, listen: false).getToken();

      bool _isFirstLogin =
          Provider.of<Auth>(context, listen: false).isFirstLogin;
      if (_isFirstLogin) {
        _showLogindialog(context);
      }
      bool _isFirstLogout =
          Provider.of<Auth>(context, listen: false).isFirstLogout;
      if (_isFirstLogout) {
        _showLoginDialog_exit(context);
      }

      Provider.of<Auth>(context, listen: false).isFirstLogin = false;
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    searchTextController.dispose();
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

  void _showLoginDialog_exit(BuildContext context) {
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

    return SingleChildScrollView(
      child: Container(
        color: AppTheme.bg,
        child: Column(
          children: <Widget>[
            Container(
              height: deviceWidth * 0.6,
              child: InkWell(
                onTap: () {
                  cleanFilters(context);
                  Provider.of<Products>(context).ssellcase = '71';

                  Navigator.of(context)
                      .pushNamed(ProductsScreen.routeName, arguments: 0);
                },
                child: Stack(
                  children: <Widget>[
                    CarouselSlider(
                      viewportFraction: 1.0,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: true,
                      height: double.infinity,
                      autoPlayInterval: Duration(seconds: 5),
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
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
                              child: FadeInImage(
                                placeholder:
                                    AssetImage('assets/images/circle.gif'),
                                image: NetworkImage(gallery.featured_image),
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        );
                      }).toList(),
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
                                  border: Border.all(
                                      color: AppTheme.h1, width: 0.4),
                                  color: _current == slider.indexOf(index)
                                      ? AppTheme.secondary
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
            InkWell(
              onTap: (){  String brandsEndpoint = '';
              String colorsEndpoint = '';
              String sellcaseEndpoint = '';
              String priceRange = '';
              Provider.of<Products>(context, listen: false)
                  .filterTitle
                  .clear();

              Provider.of<Products>(context, listen: false).searchKey = '';

              Provider.of<Products>(context, listen: false).sbrand =
                  brandsEndpoint;
              Provider.of<Products>(context, listen: false).scolor =
                  colorsEndpoint;
              Provider.of<Products>(context, listen: false).spriceRange =
                  priceRange;
              Provider.of<Products>(context, listen: false).spage = 1;
              Provider.of<Products>(context, listen: false).ssellcase =
                  sellcaseEndpoint;
              Provider.of<Products>(context, listen: false).searchBuilder();
              Provider.of<Products>(context, listen: false).checkfiltered();

              Provider.of<Products>(context, listen: false).searchBuilder();
              Provider.of<Products>(context, listen: false).checkfiltered();
              Navigator.of(context)
                  .pushNamed(ProductsScreen.routeName, arguments: 0);},
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: deviceHeight * 0.08,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 0.0,
                        // has the effect of softening the shadow
                        spreadRadius: 0.0,
                        // has the effect of extending the shadow
                        offset: Offset(
                          1.0, // horizontal, move right 10
                          1.0, // vertical, move down 10
                        ),
                      )
                    ],
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        AppTheme.secondary,
                        AppTheme.primary,
                      ],
                    ),
                    color: AppTheme.secondary,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Center(
                    child: Text(
                      'محصولات',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Iransans',
                        fontWeight: FontWeight.w500,
                        fontSize: textScaleFactor * 17.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
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
              listTitle: 'باورنکردنی',
              isAd: true,
              isDiscounted: true,
            ),
          ],
        ),
      ),
    );
  }
}
