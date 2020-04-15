class ProductsDetail {
  final int total;
  final int max_page;

  ProductsDetail({
    this.total,
    this.max_page,
  });

  factory ProductsDetail.fromJson(Map<String, dynamic> parsedJson) {
    return ProductsDetail(
      total: parsedJson['total'],
      max_page: parsedJson['max_page'],
    );
  }
}
