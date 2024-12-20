import 'package:flutter/material.dart';
import './provider/messages.dart';
import './screens/messages_create_screen.dart';
import 'package:provider/provider.dart';

import './provider/auth.dart';
import 'customer_info.dart';
import './screens/about_us_screen.dart';
import './screens/calculator_screen.dart';
import './screens/cart_screen.dart';
import './screens/cash_payment_screen.dart';
import './screens/contact_with_us_screen.dart';
import './screens/credit_payment_screen.dart';
import './screens/customer_info/customer_favorite_screen.dart';
import './screens/customer_info/customer_notification_screen.dart';
import './screens/customer_info/customer_orders_screen.dart';
import './screens/customer_info/customer_user_info_screen.dart';
import './screens/home_screen.dart';
import './screens/navigation_bottom_screen.dart';
import 'classes/strings.dart';
import 'provider/Products.dart';
import 'screens/customer_info/customer_detail_info_edit_screen.dart';
import 'screens/customer_info/login_screen.dart';
import 'screens/customer_info/profile_screen.dart';
import 'screens/enter_cheque_screen.dart';
import 'screens/favorite_screen.dart';
import 'screens/guide_screen.dart';
import 'screens/message_detail_screen.dart';
import 'screens/messages_create_reply_screen.dart';
import 'screens/messages_screen.dart';
import 'screens/order_view_screen.dart';
import 'screens/product_detail_more_details_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/product_screen.dart';
import 'screens/splash_Screen.dart';
import 'widgets/commission_calculator.dart';
import 'widgets/favorite_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Products(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        ChangeNotifierProvider(
          create: (context) => CustomerInfo(),
        ),
        ChangeNotifierProvider(
          create: (context) => CommissionCalculator(),
        ),
        ChangeNotifierProvider(
          create: (context) => Messages(),
        ),
      ],
      child: MaterialApp(
        title: Strings.appTitle,
        theme: ThemeData(
          primarySwatch: Colors.green,
          accentColor: Colors.amber,
          textTheme: ThemeData.light().textTheme.copyWith(
                bodyText1: TextStyle(
                  fontFamily: 'Iransans',
                  color: Color.fromRGBO(20, 51, 51, 1),
                ),
                bodyText2: TextStyle(
                  fontFamily: 'Iransans',
                  color: Color.fromRGBO(20, 51, 51, 1),
                ),
                headline1: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Iransans',
                  fontWeight: FontWeight.bold,
                ),
              ),
        ),
        // home: CategoriesScreen(),

        home: Directionality(
          child: SplashScreens(),
          textDirection: TextDirection.rtl, // setting rtl
        ),
        routes: {
          HomeScreen.routeName: (ctx) => HomeScreen(),
          FavoriteScreen.routeName: (ctx) => FavoriteScreen(),
          FavoriteView.routeName: (ctx) => FavoriteView(),
          ProfileScreen.routeName: (ctx) => ProfileScreen(),
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
          LoginScreen.routeName: (ctx) => LoginScreen(),
          CalculatorScreen.routeName: (ctx) => CalculatorScreen(),
          ProductsScreen.routeName: (ctx) => ProductsScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          CashPaymentScreen.routeName: (ctx) => CashPaymentScreen(),
          CreditPaymentScreen.routeName: (ctx) => CreditPaymentScreen(),
          OrderViewScreen.routeName: (ctx) => OrderViewScreen(),
          EnterChequeScreen.routeName: (ctx) => EnterChequeScreen(),
          AboutUsScreen.routeName: (ctx) => AboutUsScreen(),
          ContactWithUs.routeName: (ctx) => ContactWithUs(),
          CustomerDetailInfoEditScreen.routeName: (ctx) =>
              CustomerDetailInfoEditScreen(),
          NavigationBottomScreen.routeName: (ctx) => NavigationBottomScreen(),
          CustomerOrdersScreen.routeName: (ctx) => CustomerOrdersScreen(),
          CustomerUserInfoScreen.routeName: (ctx) => CustomerUserInfoScreen(),
          CustomerFavoriteScreen.routeName: (ctx) => CustomerFavoriteScreen(),
          CustomerNotificationScreen.routeName: (ctx) =>
              CustomerNotificationScreen(),
          ProductDetailMoreDetailScreen.routeName: (ctx) =>
              ProductDetailMoreDetailScreen(),
          GuideScreen.routeName: (ctx) => GuideScreen(),
          MessageScreen.routeName: (ctx) => MessageScreen(),
          MessageCreateScreen.routeName: (ctx) => MessageCreateScreen(),
          MessageCreateReplyScreen.routeName: (ctx) => MessageCreateReplyScreen(),
          MessageDetailScreen.routeName: (ctx) => MessageDetailScreen(),
        },
      ),
    );
  }
}
