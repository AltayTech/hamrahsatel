import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/customer.dart';
import '../provider/customer_info.dart';
import '../screens/customer_info/customer_detail_info_screen.dart';
import '../screens/customer_info/customer_detail_notification_screen.dart';
import '../screens/customer_info/customer_detail_order_screen.dart';

class SalonDetailTabBar extends StatefulWidget {
  final Customer customer;

  SalonDetailTabBar({
    this.customer,
  });

  @override
  _SalonDetailTabBarState createState() => _SalonDetailTabBarState();
}

class _SalonDetailTabBarState extends State<SalonDetailTabBar>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
    _tabController.addListener(_handleTabSelection);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    Provider.of<CustomerInfo>(context, listen: false).getCustomer();
  }

  void _handleTabSelection() {
    setState(() {});
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    final List<Tab> myTabs = <Tab>[
      Tab(
        text: 'اطلاعات کاربر',
        icon: Icon(
          Icons.info,
          color:
              _tabController.index == 0 ? Colors.blue : Colors.deepOrangeAccent,
          size: deviceSize.width*0.11,
        ),
      ),
      Tab(
        text: 'سفارشات',
        icon: Icon(
          Icons.shop,
          color: _tabController.index == 1 ? Colors.blue : Colors.blueAccent,
          size: deviceSize.width*0.11,
        ),
      ),
      Tab(
        text: 'اعلانات',
        icon: Icon(
          Icons.notification_important,
          color: _tabController.index == 2 ? Colors.blue : Colors.redAccent,
          size: deviceSize.width*0.11,
        ),
      ),
    ];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: TabBar(
          indicatorColor: Colors.blue,
          indicatorWeight: 3,
          unselectedLabelColor: Colors.black54,
          labelColor: Colors.blue,
          labelStyle: TextStyle(
            fontFamily: 'Iransans',
            fontSize: MediaQuery.of(context).textScaleFactor * 10.0,
          ),
          unselectedLabelStyle: TextStyle(
            fontFamily: 'Iransans',
            fontSize: MediaQuery.of(context).textScaleFactor * 10.0,
          ),
          controller: _tabController,
          tabs: myTabs,
        ),
        body: TabBarView(
          controller: _tabController,
          children: myTabs.map((Tab tab) {
            if (_tabController.index == 0) {
              return CustomerDetailInfoScreen(
                customer: widget.customer,
              );
            } else if (_tabController.index == 1) {
              return CustomerDetailOrderScreen(
                customer: widget.customer,
              );
            } else {
              return CustomerDetailNotificationScreen(
                customer: widget.customer,
              );
            }
          }).toList(),
        ),
      ),
    );
  }
}
