import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../classes/app_theme.dart';
import '../models/category.dart';
import '../provider/Products.dart';
import '../screens/product_screen.dart';

class CategoryGrid extends StatefulWidget {
  @override
  _CategoryGridState createState() => _CategoryGridState();
}

class _CategoryGridState extends State<CategoryGrid> {
  @override
  Widget build(BuildContext context) {
    final homeData = Provider.of<Products>(context).homeItems;
    final categories = homeData.categories;
    return Container(
      height: MediaQuery.of(context).size.height * 0.25,
      decoration: BoxDecoration(
        color: AppTheme.bg,
//        borderRadius: BorderRadius.circular(5),
//        boxShadow: [
//          BoxShadow(
//            color: Colors.black38,
//            blurRadius: 0.0,
//            // has the effect of softening the shadow
//            spreadRadius: 0,
//            // has the effect of extending the shadow
//            offset: Offset(
//              0.0, // horizontal, move right 10
//              0.0, // vertical, move down 10
//            ),
//          )
//        ],
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
          value: categories[i],
          child: CategoryItem(),
        ),
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final category = Provider.of<Category>(context, listen: false);
    print(category.image_url);
    return Container(
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

                Provider.of<Products>(context, listen: false)
                    .filterTitle
                    .add(category.name);

                Navigator.of(context)
                    .pushNamed(ProductsScreen.routeName, arguments: 0);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
//                child: Container(
//                  decoration: BoxDecoration(
//                    border: Border.all(
//                      color: Color(0xff8ABAD9),
//                    ),
//                    borderRadius: BorderRadius.circular(15),
//                  ),
                child: FadeInImage(
                  placeholder: AssetImage(
                    'assets/images/circle2.gif',
                  ),
                  image: NetworkImage(
                      category.image_url != null ? category.image_url : ''),
                  fit: BoxFit.cover,
                ),
//                ),
              ),
            ),
          ),
          Spacer(
            flex: 1,
          ),
          Expanded(
            flex: 7,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1),
              child: Text(
                category.name,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontFamily: 'Iransans',
                  color: AppTheme.h1,
                  fontSize: MediaQuery.of(context).textScaleFactor * 16.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
