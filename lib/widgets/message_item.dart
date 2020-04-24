import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hamrahsatel/classes/app_theme.dart';
import 'package:hamrahsatel/models/message.dart';
import 'package:hamrahsatel/widgets/en_to_ar_number_convertor.dart';
import 'package:shamsi_date/shamsi_date.dart';

class MessageItem extends StatelessWidget {
  const MessageItem({
    Key key,
    @required this.message,
  }) : super(key: key);

  final Message message;

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    var textScaleFactor = MediaQuery.of(context).textScaleFactor;
    return Container(
      height: deviceHeight * 0.25,
      width: deviceWidth * 0.8,
      child: LayoutBuilder(
        builder: (ctx, constraints) => Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: constraints.maxHeight * 0.17,
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        message.comment_author,
                        style: TextStyle(
                          color: AppTheme.primary,
                          fontFamily: 'Iransans',
                          fontSize: textScaleFactor * 12.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        EnArConvertor().replaceArNumber(Jalali.fromDateTime(
                          DateTime.parse(
                            message.comment_date,
                          ),
                        ).toString()),
                        style: TextStyle(
                          color: AppTheme.primary,
                          fontFamily: 'Iransans',
                          fontSize: textScaleFactor * 12.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                height: constraints.maxHeight * 0.02,
              ),
              Container(
                height: constraints.maxHeight * 0.17,
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(
                    message.subject,
                    style: TextStyle(
                      color: AppTheme.primary,
                      fontFamily: 'Iransans',
                      fontSize: textScaleFactor * 13.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Divider(
                height: constraints.maxHeight * 0.02,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: constraints.maxHeight * 0.45,
                  width: constraints.maxWidth * 0.9,
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Text(
                      message.comment_content,
                      overflow: TextOverflow.fade,
                      style: TextStyle(
                        color: AppTheme.primary,
                        fontFamily: 'Iransans',
                        fontSize: textScaleFactor * 15.0,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}