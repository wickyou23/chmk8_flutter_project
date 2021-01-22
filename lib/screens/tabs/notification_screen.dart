import 'dart:async';
import 'package:chkm8_app/bloc/notification/notification_bloc.dart';
import 'package:chkm8_app/bloc/notification/notification_event.dart';
import 'package:chkm8_app/bloc/notification/notification_state.dart';
import 'package:chkm8_app/models/history_rating_object.dart';
import 'package:chkm8_app/models/notification_object.dart';
import 'package:chkm8_app/screens/rate_your_date/start_rating_intro_screen.dart';
import 'package:chkm8_app/utils/constant.dart';
import 'package:chkm8_app/utils/extension.dart';
import 'package:chkm8_app/utils/utils.dart';
import 'package:chkm8_app/widgets/custom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationScreen extends StatefulWidget {
  static final routeName = '/NotificationScreen';

  const NotificationScreen({Key key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<NotificationObject> _notiList = [];
  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();
  Completer<void> _refreshCompleter;

  @override
  void initState() {
    _refreshCompleter = Completer<void>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var crState = context.bloc<NotificationBloc>().state;
      if (crState is NotificationInitializeState ||
          (crState is NotificationListReadyState && _notiList.isEmpty)) {
        context.bloc<NotificationBloc>().add(NotificationGetNotiListEvent());
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    appPrint('NotificationScreen dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bg_home.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: <Widget>[
          CustomNavigationBar(
            navTitle: 'Notification',
            isShowBack: false,
          ),
          Container(
            padding: EdgeInsets.only(
              top: CustomNavigationBar.heightNavBar +
                  context.media.viewPadding.top,
            ),
            child: BlocConsumer<NotificationBloc, NotificationState>(
              listener: (ctx, state) {
                if (state is NotificationGetNotiListSuccessState) {
                  if (!_refreshCompleter.isCompleted) {
                    _refreshCompleter.complete();
                  }
                } else if (state is NotificationGetNotiListFailedState) {
                  if (!_refreshCompleter.isCompleted) {
                    _refreshCompleter.complete();
                  }

                  Scaffold.of(ctx)
                      .showCSSnackBar(state.failedState.errorMessage);
                }
              },
              builder: (ctx, state) {
                String emptyString = '';
                if (state is NotificationListReadyState) {
                  _notiList = state.notiObjs;
                  if (_notiList.isEmpty) {
                    emptyString = 'No notification.';
                  }
                }

                if ((state is NotificationProcessingState) &&
                    _notiList.isEmpty) {
                  return Center(
                    child: Utils.getLoadingWidget(),
                  );
                }

                return RefreshIndicator(
                  key: _refreshKey,
                  child: (emptyString.isNotEmpty)
                      ? Center(
                          child: Text(
                            emptyString,
                            style: context.theme.textTheme.headline5.copyWith(
                              fontSize: 25,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[300],
                            ),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.only(
                            bottom: 80,
                          ),
                          itemBuilder: (ctx, idx) {
                            return _buildRateCell(_notiList[idx]);
                          },
                          separatorBuilder: (ctx, idx) {
                            return Divider(
                              height: 0.5,
                              color: ColorExt.colorWithHex(0xE0E0E0),
                            );
                          },
                          itemCount: _notiList.length,
                        ),
                  onRefresh: () async {
                    context
                        .bloc<NotificationBloc>()
                        .add(NotificationGetNotiListEvent());
                    return _refreshCompleter.future;
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRateCell(NotificationObject obj) {
    return Container(
      key: ValueKey(obj.id),
      color: Colors.white,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      constraints: BoxConstraints(
        minHeight: 90,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            obj.timeAgo,
            textAlign: TextAlign.right,
            style: context.theme.textTheme.headline5.copyWith(
              fontSize: 13,
              color: ColorExt.colorWithHex(0x828282),
            ),
          ),
          SizedBox(height: 8),
          RichText(
            text: TextSpan(
              text: 'How was ${obj.nickName}? ',
              style: context.theme.textTheme.headline5.copyWith(
                fontSize: 16,
                color: ColorExt.colorWithHex(0x333333),
                fontWeight:
                    obj.status == 0 ? FontWeight.bold : FontWeight.normal,
              ),
              children: [
                TextSpan(
                  text: 'Give it a Rating.',
                  style: context.theme.textTheme.headline5.copyWith(
                    fontSize: 16,
                    color: Constaint.mainColor,
                    decoration: TextDecoration.underline,
                    fontWeight:
                        obj.status == 0 ? FontWeight.bold : FontWeight.normal,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      var ratingObj = HistoryRatingObject(
                        nickName: obj.nickName,
                        scheduleId: obj.objId,
                      );

                      context.navigator.pushNamed(
                        StartRatingIntroScreen.routeName,
                        arguments: ratingObj,
                      );
                    },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
