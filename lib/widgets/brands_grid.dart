import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/brand.dart';
import '../provider/Products.dart';
import '../screens/product_screen.dart';

class BrandGrid extends StatefulWidget {
  @override
  _BrandGridState createState() => _BrandGridState();
}

class _BrandGridState extends State<BrandGrid> {
  @override
  Widget build(BuildContext context) {
    final homeData = Provider.of<Products>(context).homeItems;
    final brands = homeData.brands;
    return Container(
      height: MediaQuery.of(context).size.height * 0.25,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 0.0,
            // has the effect of softening the shadow
            spreadRadius: 0,
            // has the effect of extending the shadow
            offset: Offset(
              0.0, // horizontal, move right 10
              0.0, // vertical, move down 10
            ),
          )
        ],
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: brands.length,
        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
          value: brands[i],
          child: BrandItem(),
        ),
      ),
    );
  }
}

class BrandItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final brand = Provider.of<Brand>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Container(
        width: MediaQuery.of(context).size.height * 0.200,
        height: MediaQuery.of(context).size.height * 0.20,
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 24,
              child: InkWell(
                onTap: () {
                  String brandsEndpoint = '';
                  String colorsEndpoint = '';
                  String sellcaseEndpoint = '';
                  String priceRange = '';
                  Provider.of<Products>(context, listen: false)
                      .filterTitle
                      .clear();

                  Provider.of<Products>(context, listen: false).searchKey = '';

                  Provider.of<Products>(context, listen: false).sBrand =
                      brandsEndpoint;
                  Provider.of<Products>(context, listen: false).sColor =
                      colorsEndpoint;
                  Provider.of<Products>(context, listen: false).sPriceRange =
                      priceRange;
                  Provider.of<Products>(context, listen: false).sPage = 1;
                  Provider.of<Products>(context, listen: false).sSellCase =
                      sellcaseEndpoint;
                  Provider.of<Products>(context, listen: false).searchBuilder();
                  Provider.of<Products>(context, listen: false).checkFiltered();
                  Provider.of<Products>(context, listen: false).sBrand =
                      brand.id.toString();

                  Provider.of<Products>(context, listen: false)
                      .filterTitle
                      .add(brand.title);

                  Navigator.of(context)
                      .pushNamed(ProductsScreen.routeName, arguments: 0);
                },
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xff8ABAD9)),
                      borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: EdgeInsets.all(3),
                    child: FadeInImage(
                      placeholder: AssetImage('assets/images/circle2.gif'),
                      image: NetworkImage(brand.brand_img_url),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
            Spacer(
              flex: 1,
            ),
            Expanded(
              flex: 10,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: Text(
                  brand.title,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontFamily: 'Iransans',
                    color: Colors.blueGrey,
                    fontSize: MediaQuery.of(context).textScaleFactor * 14.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
