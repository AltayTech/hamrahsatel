import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hamrahsatel/models/message.dart';
import 'package:hamrahsatel/provider/auth.dart';
import 'package:hamrahsatel/provider/messages.dart';
import 'package:provider/provider.dart';

import '../classes/app_theme.dart';
import '../widgets/main_drawer.dart';

class MessageCreateScreen extends StatefulWidget {
  static const routeName = '/messageCreateScreen';

  @override
  _MessageCreateScreenState createState() => _MessageCreateScreenState();
}

class _MessageCreateScreenState extends State<MessageCreateScreen> {
  var _isLoading = false;
  var _isInit = true;

  List<Message> messages;

  List<String> aboutInfotitle = [];

  List<String> aboutInfoContent = [];

  final contentTextController = TextEditingController();
  final subjectTextController = TextEditingController();

  bool isLogin;

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      contentTextController.text = '';
      subjectTextController.text = '';

      isLogin = Provider.of<Auth>(context).isAuth;
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
  void dispose() {
    contentTextController.dispose();
    subjectTextController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'درباره ما',
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
      body: Builder(
        builder: (context) => Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            height: deviceHeight * 0.9,
            child: Stack(
              children: <Widget>[
                Container(
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 35),
                            child: Container(
                              color: Colors.white,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    height: deviceHeight * 0.1,
                                    child: TextFormField(
                                      maxLines: 10,
                                      controller: subjectTextController,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        labelStyle: TextStyle(
                                          color: Colors.grey,
                                          fontFamily: 'Iransans',
                                          fontSize: textScaleFactor * 15.0,
                                        ),
                                        labelText: 'عنوان',
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: deviceHeight * 0.3,
                                    child: TextFormField(
                                      maxLines: 10,
                                      controller: contentTextController,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        labelStyle: TextStyle(
                                          color: Colors.grey,
                                          fontFamily: 'Iransans',
                                          fontSize: textScaleFactor * 15.0,
                                        ),
                                        labelText:
                                            'نظر خود را در اینجا بنویسید',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Align(
                      alignment: Alignment.center,
                      child: _isLoading
                          ? SpinKitFadingCircle(
                              itemBuilder: (BuildContext context, int index) {
                                return DecoratedBox(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: index.isEven
                                        ? AppTheme.h1
                                        : AppTheme.h1,
                                  ),
                                );
                              },
                            )
                          : Container()),
                ),
                Positioned(
                  bottom: 18,
                  left: 18,
                  child: FloatingActionButton(
                    onPressed: () async {
                      await Provider.of<Messages>(context, listen: false)
                          .createMessage(
                        subjectTextController.text,
                        contentTextController.text,
                        isLogin,
                      )
                          .then((value) {
                        Navigator.of(context).pop();
                      });
                    },
                    backgroundColor: Color(0xff3F9B12),
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
      endDrawer: Theme(
        data: Theme.of(context).copyWith(
          // Set the transparency here
          canvasColor: Colors
              .transparent, //or any other color you want. e.g Colors.blue.withOpacity(0.5)
        ),
        child: MainDrawer(),
      ),
    );
  }
}
