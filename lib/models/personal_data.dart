import 'package:flutter/foundation.dart';

class PersonalData with ChangeNotifier {
  final int id;
  final String phone;
  final String first_name;
  final String last_name;
  final String gender;
  final String national_code;
  final String credit;
  final String ostan;
  final String city;
  final String address;
  final String postcode;
  final bool personal_data_complete;

  PersonalData(
      {this.id,
      this.phone,
      this.first_name,
      this.last_name,
      this.gender,
      this.national_code,
      this.credit,
      this.ostan,
      this.city,
      this.address,
      this.postcode,
        this.personal_data_complete
      });

  factory PersonalData.fromJson(Map<String, dynamic> parsedJson) {
    return PersonalData(
      id: parsedJson['id'],
      phone: parsedJson['phone'],
      first_name: parsedJson['first_name'],
      last_name: parsedJson['last_name'],
      gender: parsedJson['gender'],
      national_code: parsedJson['national_code'],
      credit: parsedJson['credit'],
      ostan: parsedJson['ostan'],
      city: parsedJson['city'],
      address: parsedJson['address'],
      postcode: parsedJson['postcode'],
      personal_data_complete: parsedJson['personal_data_complete'],

    );
  }
}
