import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/app_theme.dart';
import '../widgets/commission_calculator.dart';
import '../widgets/main_drawer.dart';
import '../widgets/qest_calculation.dart';

class CalculatorScreen extends StatefulWidget {
  static const routeName = '/calculator';

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {



  @override
  Widget build(BuildContext context) {
    Provider.of<CommissionCalculator>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.appBarColor,
        iconTheme: new IconThemeData(color: AppTheme.appBarIconColor),
      ),
      body: QestCalculation(1000),
      endDrawer: Theme(
        data: Theme.of(context).copyWith(
          // Set the transparency here
          canvasColor: Colors.transparent, //or any other color you want. e.g Colors.blue.withOpacity(0.5)
        ),
        child:Theme(
          data: Theme.of(context).copyWith(
            // Set the transparency here
            canvasColor: Colors
                .transparent, //or any other color you want. e.g Colors.blue.withOpacity(0.5)
          ),
          child: MainDrawer(),
        ),

      ),
    );
  }
}
