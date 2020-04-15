import 'package:flutter/material.dart';

import '../models/productm.dart';
import '../widgets/product_item.dart';

class ProductGrid extends StatelessWidget {
  ProductGrid({this.loadedSalon});

  final List<Productm> loadedSalon;

  @override
  Widget build(BuildContext context) {
    var deviceAspectRatio = MediaQuery.of(context).size.aspectRatio;
    print(MediaQuery.of(context).devicePixelRatio);
    return Container(
      height: MediaQuery.of(context).size.width * 0.6,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: loadedSalon.length,
        itemBuilder: (ctx, i) {
          return ProductItem(
            id: loadedSalon[i].id,
            title: loadedSalon[i].title,
            brand_title: loadedSalon[i].brand.title,
            price: loadedSalon[i].price.toString(),
            price_low: loadedSalon[i].price_low.toString(),
            imageUrl: loadedSalon[i].gallery[0].url,
            brandImageUrl: loadedSalon[i].brand.brand_img_url,
            productColor: loadedSalon[i].colors,
          );
        },
      ),
    );
  }
}
