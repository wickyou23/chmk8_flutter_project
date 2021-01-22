import 'package:chkm8_app/utils/constant.dart';
import 'package:chkm8_app/widgets/custom_button_widget.dart';
import 'package:flutter/material.dart';
import '../extension/color_ext.dart';

extension BuildContextExt on BuildContext {
  ThemeData get theme {
    return Theme.of(this);
  }

  MediaQueryData get media {
    return MediaQuery.of(this);
  }

  NavigatorState get navigator {
    return Navigator.of(this);
  }

  ModalRoute get route {
    return ModalRoute.of(this);
  }

  Object get routeArg {
    return this.route.settings.arguments;
  }

  bool get isSmallDevice {
    return this.media.size.height < 670;
  }

  double get scaleDevice {
    return this.isSmallDevice ? 0.8 : 1.0;
  }

  FocusScopeNode get focus {
    return FocusScope.of(this);
  }

  Future<bool> showAlertConfirm({String message}) {
    return showDialog<bool>(
      barrierDismissible: false,
      context: this,
      builder: (ctx) {
        return AlertDialog(
          title: Container(
            height: 50,
            width: this.media.size.width,
            color: Colors.redAccent,
            alignment: AlignmentDirectional.centerStart,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.warning,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  'Confirm',
                  style: this.theme.textTheme.headline6.copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                ),
              ],
            ),
          ),
          titlePadding: EdgeInsets.zero,
          content: Text(
            message ?? 'Do you to remove this item?',
            style: this.theme.textTheme.headline6.copyWith(
                  fontSize: 20,
                ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'CANCEL',
                style: this.theme.textTheme.headline6.copyWith(
                      fontSize: 15,
                      color: this.theme.primaryColor,
                    ),
              ),
              onPressed: () {
                this.navigator.pop(false);
              },
            ),
            RaisedButton(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              color: Colors.redAccent,
              child: Text(
                'DELETE',
                style: this.theme.textTheme.headline6.copyWith(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              onPressed: () {
                this.navigator.pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> showLoadingAlert({String message}) {
    return showDialog<bool>(
      barrierDismissible: false,
      context: this,
      builder: (ctx) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: AlertDialog(
            contentPadding: const EdgeInsets.only(top: 20, bottom: 16),
            titlePadding: EdgeInsets.zero,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 50,
                  width: 50,
                  child: CircularProgressIndicator(),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  message,
                  style: this.theme.textTheme.headline6.copyWith(
                        fontSize: 17,
                      ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<T> showBottomSheet<T>(
    List<String> data,
    String selectedData,
    Function(String) completed,
  ) {
    return showModalBottomSheet<T>(
      context: this,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),
      builder: (BuildContext ctx) {
        return Container(
          height: (data.length.toDouble() * 50) + 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: ListView.separated(
            itemBuilder: (ctx, idx) {
              var item = data[idx];
              return Container(
                height: 50,
                child: ListTile(
                  key: ValueKey(item),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 25),
                  title: Text(
                    item,
                    style: ctx.theme.textTheme.headline5.copyWith(
                      fontSize: 17,
                      color: ColorExt.myBlack,
                    ),
                  ),
                  trailing: (selectedData == item)
                      ? Icon(
                          Icons.check,
                          color: ColorExt.mainColor,
                          size: 20,
                        )
                      : Container(
                          width: 1,
                        ),
                  onTap: () {
                    completed(item);
                    this.navigator.pop();
                  },
                ),
              );
            },
            separatorBuilder: (_, idx) {
              return Divider(
                height: 0.5,
                color: Colors.grey[400],
                indent: 25,
                endIndent: 25,
              );
            },
            itemCount: data.length,
          ),
        );
      },
    );
  }

  Future<T> showPopup<T>({Widget child}) {
    return showDialog<T>(
      barrierDismissible: true,
      context: this,
      builder: (ctx) {
        return AlertDialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 0,
            vertical: 24,
          ),
          contentPadding: EdgeInsets.zero,
          titlePadding: EdgeInsets.zero,
          content: child,
          backgroundColor: Colors.transparent,
        );
      },
    );
  }

  Future<bool> showAlert({
    String message,
    bool barrierDismissible = true,
  }) {
    return showDialog<bool>(
      barrierDismissible: barrierDismissible,
      context: this,
      builder: (ctx) {
        return AlertDialog(
          titlePadding: EdgeInsets.zero,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 30,
          ),
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 24,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message,
                textAlign: TextAlign.center,
                style: this.theme.textTheme.headline6.copyWith(
                      fontSize: 16,
                      color: Constaint.defaultTextColor,
                    ),
              ),
              SizedBox(height: 25),
              CustomButtonWidget(
                title: 'OK',
                onPressed: () {
                  this.navigator.pop(true);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
