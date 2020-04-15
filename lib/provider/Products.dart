import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/brand.dart';
import '../models/brandc.dart';
import '../models/color_code.dart';
import '../models/gallery.dart';
import '../models/home_page.dart';
import '../models/main_features.dart';
import '../models/meta_data.dart' as meta;
import '../models/product.dart';
import '../models/product_cart.dart';
import '../models/product_main.dart';
import '../models/productm.dart';
import '../models/products_detail.dart';
import 'urls.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];
  List<ProductCart> _cartItems = [];
  List<String> filterTitle = [];

//  List<ProductCart> _cartItems_zero = [ProductCart(id: 0,title: '',)];

  HomePage _homeItems = HomePage(
    brands: [
      Brand(
        id: 0,
        title: '',
        brand_img_url: '',
      ),
    ],
    new_products: [
      Productm(
          id: 0,
          title: '',
          brand: Brand(id: 0, title: '', brand_img_url: ''),
          gallery: [Gallery(id: 0, url: '')],
          price_low: '',
          colors: [ColorCode(id: 0, title: '', color_code: '')],
          status: meta.MetaData(id: 0, title: ''))
    ],
    ads_products: [
      Productm(
          id: 0,
          title: '',
          brand: Brand(id: 0, title: '', brand_img_url: ''),
          gallery: [Gallery(id: 0, url: '')],
          price_low: '',
          colors: [ColorCode(id: 0, title: '', color_code: '')],
          status: meta.MetaData(id: 0, title: ''))
    ],
    discount_products: [
      Productm(
          id: 0,
          title: '',
          brand: Brand(id: 0, title: '', brand_img_url: ''),
          gallery: [Gallery(id: 0, url: '')],
          price_low: '',
          colors: [ColorCode(id: 0, title: '', color_code: '')],
          status: meta.MetaData(id: 0, title: ''))
    ],
  );

  String searchEndPoint = '';

  String searchKey = '';
  var _spage = 1;
  var _sper_page = 10;
  var _sorder = 'desc';
  var _sorderby = 'date';
  var _sbrand;
  var _sproductcat;
  var _ssellcase;
  var _scolor;
  var _sstatus;
  var _spriceRange;
  var _scategory;

  bool _isFiltered = false;

  ProductsDetail _searchDetails = ProductsDetail(max_page: 1, total: 10);

  Product _itemShopp;

  Future<void> checkfiltered() async {
    if (_sbrand == '' &&
        _sproductcat == '' &&
        _ssellcase == '' &&
        _scolor == '' &&
        _sstatus == '' &&
        _spriceRange == ''&&
        _scategory=='') {
      _isFiltered = false;
    } else {
      _isFiltered = true;
    }
  }

  void searchBuilder() {
    if (!(searchKey == '')) {
      searchEndPoint = '';

      searchEndPoint = searchEndPoint + '?search=$searchKey';
      searchEndPoint = searchEndPoint + '&page=$_spage&per_page=$_sper_page';
    } else {
      searchEndPoint = '';

      searchEndPoint = searchEndPoint + '?page=$_spage&per_page=$_sper_page';
    }
    if (!(_sorder == '')) {
      searchEndPoint = searchEndPoint + '&order=$_sorder';
    }
    if (!(_sorderby == '')) {
      searchEndPoint = searchEndPoint + '&orderby=$_sorderby';
    }
    if (!(_sbrand == null || _sbrand == '')) {
      searchEndPoint = searchEndPoint + '&brand=$_sbrand';
    }
    if (!(_sproductcat == '' || _sproductcat == null)) {
      searchEndPoint = searchEndPoint + '&productcat=$_sproductcat';
    }
    if (!(_ssellcase == '' || _ssellcase == null)) {
      searchEndPoint = searchEndPoint + '&sellcase=$_ssellcase';
    }
    if (!(_scolor == '' || _scolor == null)) {
      searchEndPoint = searchEndPoint + '&color=$_scolor';
    }
    if (!(_sstatus == '' || _sstatus == null)) {
      searchEndPoint = searchEndPoint + '&status=$_sstatus';
    }
    if (!(_spriceRange == '' || _spriceRange == null)) {
      searchEndPoint = searchEndPoint + '&price_range=$_spriceRange';
    }
//    if (!(_scategory == '' || _scategory == null)) {
//      searchEndPoint = searchEndPoint + '&price_range=$_spriceRange';
//    }
    print(searchEndPoint);
  }

  static Product _item_zero = Product(
      id: 0,
      title: "",
      price: "",
      price_low: "",
      main_features:
          MainFeatures(screen_inch: "", camera: "0", memory: "", ram: ""),
      content: '',
      gallery: [
        Gallery(
          id: 0,
          url: '',
        ),
      ],
      tags: [
        meta.MetaData(id: null, title: null)
      ],
      brand: [
        Brand(id: 0, title: "", brand_img_url: "")
      ],
      productcat: [
        meta.MetaData(id: 123, title: "")
      ],
      sellcase: [
        meta.MetaData(id: 72, title: "")
      ],
      color: [
        ColorCode(id: 0, title: "", color_code: "")
      ],
      status: [
        meta.MetaData(id: 0, title: '')
      ]);
  Product _item = _item_zero;

  String _token;

  List<Product> get items {
    return [..._items];
  }

  HomePage get homeItems {
    return _homeItems;
  }

  int get cartItemsCount {
    return _cartItems.length;
  }

  Product get item {
    return _item;
  }

  List<ProductCart> get cartItems {
    return [..._cartItems];
  }

  Future<void> addShopCart(
      Product product, ColorCode colorId, int quantity, bool isLogin) async {
    print('addShopCart');
//    print(colorId.toString());
    try {
      if (isLogin) {
        final prefs = await SharedPreferences.getInstance();
        print(product..toString());

        _token = prefs.getString('token');

        final url = Urls.rootUrl +
            Urls.cartEndPoint +
            '?product_id=${product.id}&action=add&color_id=${colorId.id}&how_many=${quantity}';

        final response = await post(url, headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        });

        final extractedData = json.decode(response.body);

        print(extractedData.toString());
//        Product pro = _items.firstWhere((prod) => prod.id == product.id);

        _cartItems.add(ProductCart(
          id: product.id,
          title: product.title,
          price: product.price,
          price_low: product.price_low,
          brand: Brandc(
              id: product.brand[0].id,
              title: product.brand[0].title,
              img_url: product.brand[0].brand_img_url),
          colors: product.color,
          featured_media_url: product.gallery[0].url,
          color_selected: colorId,
          productCount: quantity,
        ));
      } else {
//        Product pro = _items.firstWhere((prod) => prod.id == productId);
//        await retrieveToShoppItem(productId);
//        Product pro = _itemShopp;
        print(product.title.toString());

        _cartItems.add(ProductCart(
            id: product.id,
            title: product.title,
            price: product.price,
            price_low: product.price_low,
            brand: Brandc(
                id: product.brand[0].id,
                title: product.brand[0].title,
                img_url: product.brand[0].brand_img_url),
            colors: product.color,
            featured_media_url: product.gallery[0].url,
            color_selected: colorId,
        productCount:quantity ));
      }
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }

  Future<void> updateShopCart(ProductCart product, ColorCode colorId,
      int quantity, bool isLogin) async {
    print('updateShopCart');
//    print(colorId.toString());
    try {
      if (isLogin) {
        final prefs = await SharedPreferences.getInstance();
        print(product..toString());

        _token = prefs.getString('token');

        final url = Urls.rootUrl +
            Urls.cartEndPoint +
            '?product_id=${product.id}&action=update&color_id=${colorId.id}&how_many=${quantity}';

        final response = await post(url, headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        });

        final extractedData = json.decode(response.body);

        print(extractedData.toString());
//        Product pro = _items.firstWhere((prod) => prod.id == product.id);
        _cartItems
            .remove(_cartItems.firstWhere((prod) => prod.id == product.id));
        _cartItems.add(ProductCart(
          id: product.id,
          title: product.title,
          price: product.price,
          price_low: product.price_low,
          brand: Brandc(
              id: product.brand.id,
              title: product.brand.title,
              img_url: product.brand.img_url),
          colors: product.colors,
          featured_media_url: product.featured_media_url,
          color_selected: colorId,
          productCount: quantity,
        ));
      } else {
//        Product pro = _items.firstWhere((prod) => prod.id == productId);
//        await retrieveToShoppItem(productId);
//        Product pro = _itemShopp;
        print(product.title.toString());
        _cartItems
            .remove(_cartItems.firstWhere((prod) => prod.id == product.id));
        _cartItems.add(ProductCart(
          id: product.id,
          title: product.title,
          price: product.price,
          price_low: product.price_low,
          brand: Brandc(
              id: product.brand.id,
              title: product.brand.title,
              img_url: product.brand.img_url),
          colors: product.colors,
          featured_media_url: product.featured_media_url,
          color_selected: colorId,
          productCount: quantity,
        ));
      }
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }

  Future<void> addShopCartAfterLogin(bool isLogin) async {
    print('addShopCartAfterLogin');
//    print(colorId.toString());
    List<ProductCart> _shoppItems = _cartItems;
    try {
      if (isLogin) {
        final prefs = await SharedPreferences.getInstance();
        _token = prefs.getString('token');

        for (int i = 0; i <= _shoppItems.length; i++) {
          final url = Urls.rootUrl +
              Urls.cartEndPoint +
              '?product_id=${_shoppItems[i].id}&action=add&color_id=${_shoppItems[i].color_selected.id}&how_many=${_shoppItems[i].productCount}';

          final response = await post(url, headers: {
            'Authorization': 'Bearer $_token',
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          });

          final extractedData = json.decode(response.body);
        }
      }
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }

  Future<void> retrieveShopCart() async {
    print('retrieveShopCart');

    final url = Urls.rootUrl + Urls.cartEndPoint;
    final prefs = await SharedPreferences.getInstance();

    _token = prefs.getString('token');

    try {
      final response = await get(url, headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      });

      final extractedData = json.decode(response.body) as List;
      print(extractedData);

      List<ProductCart> cartShop = new List<ProductCart>();

      cartShop = extractedData.map((i) => ProductCart.fromJson(i)).toList();
      print(cartShop.length);

      _cartItems = cartShop;

      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }

  Future<void> removeShopCart(int productId, int colorId) async {
    print('removeShopCart');

    final url = Urls.rootUrl +
        Urls.cartEndPoint +
        '?product_id=$productId&action=remove&color_id=$colorId';
    final prefs = await SharedPreferences.getInstance();

    _token = prefs.getString('token');
    if (_token != '') {
      try {
        final response = await post(url, headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        });
        final extractedData = json.decode(response.body);

        print(extractedData.toString());
        _cartItems
            .remove(_cartItems.firstWhere((prod) => prod.id == productId));
        notifyListeners();
      } catch (error) {
        print(error.toString());
        throw (error);
      }
    } else {
      _cartItems.remove(_cartItems.firstWhere((prod) => prod.id == productId));
      notifyListeners();
    }
  }

  Product findById() {
//    return _items.firstWhere((prod) => prod.id == id);
    return _item;
  }

  Future<void> fetchAndSetHomeData() async {
    print('fetchAndSetHomeData');

    final url = Urls.rootUrl + Urls.homeEndPoint;

    try {
      final response = await get(url, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      });

      final extractedData = json.decode(response.body) as List<dynamic>;
      print(extractedData);

      List<HomePage> homePage =
          extractedData.map((i) => HomePage.fromJson(i)).toList();

      _homeItems = homePage[0];
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }

  Future<void> searchItem() async {
    print('searchItem');

    final url = Urls.rootUrl + Urls.productsEndPoint + '$searchEndPoint';
    print(url);

    try {
      final response = await get(url, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      });
      print(response.statusCode);
      if (response.statusCode == 200) {
        final extractedData = json.decode(response.body);

        ProductMain productMain = ProductMain.fromJson(extractedData);
        print(response.headers.toString());

        _items = productMain.products;
        _searchDetails = productMain.productsDetail;
      } else {
        _items = [];
      }
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }

  Future<void> retrieveItem(int productId) async {
    print('retrieveItem');

    final url = Urls.rootUrl + Urls.productsEndPoint + "/$productId";

    try {
      final response = await get(url, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      });
      final extractedData = json.decode(response.body) as dynamic;
      Product product = Product.fromJson(extractedData);

      _item = product;
    } catch (error) {
      print(error.toString());
      throw (error);
    }
    notifyListeners();
  }

  Future<void> retrieveToShoppItem(int productId) async {
    print('retrieveItem');

    final url = Urls.rootUrl + Urls.productsEndPoint + "/$productId";

    try {
      final response = await get(url, headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      });
      final extractedData = json.decode(response.body) as dynamic;
      Product product = Product.fromJson(extractedData);

      _itemShopp = product;
    } catch (error) {
      print(error.toString());
      throw (error);
    }
    notifyListeners();
  }

  set sper_page(value) {
    _sper_page = value;
  }

  set sorder(value) {
    _sorder = value;
  }

  set sorderby(value) {
    _sorderby = value;
  }

  set sbrand(value) {
    _sbrand = value;
  }

  set sproductcat(value) {
    _sproductcat = value;
  }

  set ssellcase(value) {
    _ssellcase = value;
  }

  set scolor(value) {
    _scolor = value;
  }

  set sstatus(value) {
    _sstatus = value;
  }

  set spage(value) {
    _spage = value;
  }

  set spriceRange(value) {
    _spriceRange = value;
  }

  get ssellcase => _ssellcase;

  bool get isFiltered => _isFiltered;

  ProductsDetail get searchDetails => _searchDetails;

  set item(Product value) {
    _item = value;
  }

  Product get item_zero => _item_zero;
}
