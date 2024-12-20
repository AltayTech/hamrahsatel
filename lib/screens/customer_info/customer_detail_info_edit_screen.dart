import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/app_theme.dart';
import '../../models/customer.dart';
import '../../customer_info.dart';
import '../../widgets/main_drawer.dart';
import 'customer_user_info_screen.dart';

class CustomerDetailInfoEditScreen extends StatefulWidget {
  static const routeName = '/customerDetailInfoEditScreen';

  @override
  _CustomerDetailInfoEditScreenState createState() =>
      _CustomerDetailInfoEditScreenState();
}

class _CustomerDetailInfoEditScreenState
    extends State<CustomerDetailInfoEditScreen> {
  final nameController = TextEditingController();
  final familyController = TextEditingController();

  final emailController = TextEditingController();
  final ostanController = TextEditingController();
  final cityController = TextEditingController();
  final addressController = TextEditingController();
  final postCodeController = TextEditingController();

  @override
  void initState() {
    Customer customer =
        Provider.of<CustomerInfo>(context, listen: false).customer;
    nameController.text = customer.personal_data.first_name;
    familyController.text = customer.personal_data.last_name;

    emailController.text = customer.personal_data.email;
    ostanController.text = customer.personal_data.ostan;
    cityController.text = customer.personal_data.city;
    addressController.text = customer.personal_data.address;
    postCodeController.text = customer.personal_data.postcode;

    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    familyController.dispose();
    cityController.dispose();
    ostanController.dispose();
    emailController.dispose();
    postCodeController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppTheme.appBarColor,
          iconTheme: new IconThemeData(color: AppTheme.appBarIconColor),
        ),

        drawer: Theme(
          data: Theme.of(context).copyWith(
            // Set the transparency here
            canvasColor: Colors
                .transparent, //or any other color you want. e.g Colors.blue.withOpacity(0.5)
          ),
          child: MainDrawer(),
        ), // resizeToAvoidBottomInset: false,
        body: Builder(
          builder: (context) => Directionality(
            textDirection: TextDirection.rtl,
            child: Stack(
              children: <Widget>[
                Container(
                  color: AppTheme.bg,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'اطلاعات شخص',
                            style: TextStyle(
                              color: AppTheme.primary,
                              fontFamily: 'Iransans',
                              fontSize: textScaleFactor * 14.0,
                            ),
                            textAlign: TextAlign.right,
                          ),
                          Container(
                            child: ListView(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              children: <Widget>[
                                InfoEditItem(
                                  title: 'نام',
                                  controller: nameController,
                                  bgColor: AppTheme.bg,
                                  iconColor: Color(0xffA67FEC),
                                  keybordType: TextInputType.text,
                                ),
                                InfoEditItem(
                                  title: 'نام خانوادگی',
                                  controller: familyController,
                                  bgColor: AppTheme.bg,
                                  iconColor: Color(0xffA67FEC),
                                  keybordType: TextInputType.text,
                                ),
                                InfoEditItem(
                                  title: 'ایمیل',
                                  controller: emailController,
                                  bgColor: AppTheme.bg,
                                  iconColor: Color(0xffA67FEC),
                                  keybordType: TextInputType.text,
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            color: Colors.grey,
                          ),
                          Text(
                            'اطلاعات تماس',
                            textAlign: TextAlign.right,
                          ),
                          Container(
                            color: AppTheme.bg,
                            child: ListView(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              children: <Widget>[
                                InfoEditItem(
                                  title: 'استان',
                                  controller: ostanController,
                                  bgColor: AppTheme.bg,
                                  iconColor: Color(0xff4392F1),
                                  keybordType: TextInputType.text,
                                ),
                                InfoEditItem(
                                  title: 'شهر',
                                  controller: cityController,
                                  bgColor: AppTheme.bg,
                                  iconColor: Color(0xff4392F1),
                                  keybordType: TextInputType.text,
                                ),
                                InfoEditItem(
                                  title: 'کدپستی',
                                  controller: postCodeController,
                                  bgColor: AppTheme.bg,
                                  iconColor: Color(0xff4392F1),
                                  keybordType: TextInputType.number,
                                ),
                                InfoEditItem(
                                  title: 'آدرس',
                                  controller: addressController,
                                  bgColor: AppTheme.bg,
                                  iconColor: Color(0xff4392F1),
                                  keybordType: TextInputType.text,
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            color: Colors.grey,
                          ),
                          SizedBox(
                            height: deviceHeight * 0.02,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 18,
                  left: 18,
                  child: FloatingActionButton(
                    onPressed: () {
                      setState(() {});
                      var _snackBarMessage = 'اطلاعات ویرایش شد.';
                      final addToCartSnackBar = SnackBar(
                        content: Text(
                          _snackBarMessage,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Iransans',
                            fontSize: textScaleFactor * 14.0,
                          ),
                        ),
                      );

                      Provider.of<CustomerInfo>(context, listen: false).first_name =
                          nameController.text;
                      Provider.of<CustomerInfo>(context, listen: false).last_name =
                          familyController.text;

                      Provider.of<CustomerInfo>(context, listen: false).email =
                          emailController.text;
                      Provider.of<CustomerInfo>(context, listen: false).ostan =
                          ostanController.text;
                      Provider.of<CustomerInfo>(context, listen: false).city =
                          cityController.text;
                      Provider.of<CustomerInfo>(context, listen: false).address =
                          addressController.text;
                      Provider.of<CustomerInfo>(context, listen: false).postcode =
                          postCodeController.text;
                      Provider.of<CustomerInfo>(context, listen: false)
                          .sendCustomer()
                          .then((v) {
                        Scaffold.of(context).showSnackBar(addToCartSnackBar);
                        Navigator.of(context)
                            .popAndPushNamed(CustomerUserInfoScreen.routeName);
                      });
                    },
                    backgroundColor: AppTheme.primary,
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InfoEditItem extends StatelessWidget {
  const InfoEditItem({
    Key key,
    @required this.title,
    @required this.controller,
    @required this.keybordType,
    @required this.bgColor,
    @required this.iconColor,
  }) : super(key: key);

  final String title;
  final TextEditingController controller;
  final TextInputType keybordType;

  final Color bgColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: deviceWidth * 0.8,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '$title : ',
                  style: TextStyle(
                    color: AppTheme.h1,
                    fontFamily: 'Iransans',
                    fontSize: textScaleFactor * 14.0,
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: Form(
                    child: Container(
                      height: deviceHeight * 0.05,
                      child: TextFormField(
                        keyboardType: keybordType,

                        onEditingComplete: () {},
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'لطفا مقداری را وارد نمایید';
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.none,
//                    focusNode: FocusNode(),
                        controller: controller,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(
                                width: 0,
                                color: Colors.white,
                              )),

//                        border: InputBorder.none,
                          labelStyle: TextStyle(
                            color: Colors.blue,
                            fontFamily: 'Iransans',
                            fontSize: textScaleFactor * 10.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
