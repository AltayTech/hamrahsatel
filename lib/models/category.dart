import 'package:flutter/material.dart';

class Category with ChangeNotifier {
  final int term_id;
  final String name;
  final String slug;
  final int term_group;
  final int term_taxonomy_id;
  final String taxonomy;
  final String description;
  final int parent;
  final int count;
  final String filter;
  final int cat_ID;
  final int category_count;
  final String category_description;
  final String cat_name;
  final String category_nicename;
  final int category_parent;
  final String image_url;

  Category(
      {this.term_id,
      this.name,
      this.slug,
      this.term_group,
      this.term_taxonomy_id,
      this.taxonomy,
      this.description,
      this.parent,
      this.count,
      this.filter,
      this.cat_ID,
      this.category_count,
      this.category_description,
      this.cat_name,
      this.category_nicename,
      this.category_parent,
      this.image_url});

  factory Category.fromJson(Map<String, dynamic> parsedJson) {
    return Category(
      term_id: parsedJson['term_id'],
      name: parsedJson['name'],
      slug: parsedJson['slug'],
      term_group: parsedJson['term_group'],
      term_taxonomy_id: parsedJson['term_taxonomy_id'],
      taxonomy: parsedJson['taxonomy'],
      description: parsedJson['description'],
      parent: parsedJson['parent'],
      filter: parsedJson['filter'],
      cat_ID: parsedJson['cat_ID'],
      category_count: parsedJson['category_count'],
      category_description: parsedJson['category_description'],
      cat_name: parsedJson['cat_name'],
      category_nicename: parsedJson['category_nicename'],
      category_parent: parsedJson['category_parent'],
      image_url: parsedJson['image_url'],
    );
  }
}
