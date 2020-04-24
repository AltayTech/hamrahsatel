import 'package:flutter/material.dart';
import 'package:hamrahsatel/models/message.dart';
import 'package:hamrahsatel/provider/auth.dart';
import 'package:hamrahsatel/provider/messages.dart';
import 'package:hamrahsatel/screens/message_detail_screen.dart';
import 'package:hamrahsatel/screens/messages_create_screen.dart';
import 'package:hamrahsatel/widgets/message_item.dart';
import 'package:provider/provider.dart';

import '../classes/app_theme.dart';
import '../widgets/main_drawer.dart';

class MessageScreen extends StatefulWidget {
  static const routeName = '/messageScreen';

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  bool _isInit = true;

  List<Message> messages;

  List<String> aboutInfotitle = [];

  List<String> aboutInfoContent = [];

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      bool isLogin = Provider.of<Auth>(context).isAuth;
      if (isLogin) {
        await Provider.of<Messages>(context, listen: false)
            .getMessages('0', isLogin)
            .then((value) {
          messages = Provider.of<Messages>(context).allMessages;
        });
      }
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'پشتیبانی',
          style: TextStyle(
            color: AppTheme.bg,
            fontFamily: 'Iransans',
            fontSize: textScaleFactor * 18.0,
          ),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        backgroundColor: AppTheme.appBarColor,
        iconTheme: new IconThemeData(color: AppTheme.appBarIconColor),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: deviceHeight * 0.9,
                    width: deviceWidth,
                    child: ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: messages.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, MessageDetailScreen.routeName,
                                  arguments: messages[index],);
                            },
                            child: MessageItem(message: messages[index]));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      endDrawer: Theme(
        data: Theme.of(context).copyWith(
          // Set the transparency here
          canvasColor: Colors
              .transparent, //or any other color you want. e.g Colors.blue.withOpacity(0.5)
        ),
        child: MainDrawer(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, MessageCreateScreen.routeName);
        },
      ),
    );
  }
}
