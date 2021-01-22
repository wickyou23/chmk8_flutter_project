import 'dart:math';
import 'package:chkm8_app/bloc/rating/rating_bloc.dart';
import 'package:chkm8_app/bloc/rating/rating_event.dart';
import 'package:chkm8_app/bloc/rating/rating_state.dart';
import 'package:chkm8_app/enum/rating_type_enum.dart';
import 'package:chkm8_app/frameworks/flutter_tag/item_tags.dart';
import 'package:chkm8_app/frameworks/flutter_tag/tags.dart';
import 'package:chkm8_app/models/history_rating_object.dart';
import 'package:chkm8_app/models/rating_object.dart';
import 'package:chkm8_app/screens/rate_your_date/overall_rating_not_happen.dart';
import 'package:chkm8_app/screens/rate_your_date/rating_screen.dart';
import 'package:chkm8_app/services/notification_service.dart';
import 'package:chkm8_app/utils/common_key.dart';
import 'package:chkm8_app/utils/constant.dart';
import 'package:chkm8_app/widgets/app_scaffold.dart';
import 'package:chkm8_app/widgets/custom_button_widget.dart';
import 'package:chkm8_app/widgets/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:chkm8_app/utils/extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chkm8_app/utils/utils.dart';

class OverallRatingScreen extends StatefulWidget {
  static final routeName = '/OverallRatingScreen';

  @override
  _OverallRatingScreenState createState() => _OverallRatingScreenState();
}

class _OverallRatingScreenState extends State<OverallRatingScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();

  HistoryRatingObject _ratingObj;
  bool _isGreat;
  bool _isSelectHappen = false;
  bool _isShowSubmit = false;
  List<String> _answers = [
    'We rescheduled',
    'We canceled it',
    'My date didn\'t show up',
    'Something unexpected',
  ];
  String _userAnsers = '';

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      scKey: _scaffoldKey,
      body: Stack(
        children: [
          CustomNavigationBar(
            navTitle: 'Overall Rating',
            navTitleColor: Constaint.rateYourDateColor,
          ),
          BlocConsumer<RatingBloc, RatingState>(
            listener: (ctx, state) {
              if (state is OverallRatingCompletionState) {
                context.navigator.push(
                  MaterialPageRoute(
                    builder: (_) => BlocProvider<RatingBloc>(
                      create: (_) => RatingBloc(
                        RatingReadyState(
                          crRating: RatingObject(
                            type: RatingType.safety,
                            scheduleId: _ratingObj.scheduleId,
                            nickName: _ratingObj.nickName,
                          ),
                        ),
                      ),
                      child: RatingScreen(),
                    ),
                    settings: RouteSettings(name: RatingScreen.routeName),
                  ),
                );
              } else if (state is RatingCompletionSuccessState) {
                NotificationService().add(NotificationName.NEED_TO_RELOAD_NOTIFICATION);
                context.navigator.pushNamed(OverallRatingNotHappen.routeName);
              } else if (state is RatingCompletionFailedState) {
                _scaffoldKey.currentState
                    .showCSSnackBar('Rating failed. Please try again.');
              }
            },
            builder: (ctx, state) {
              if (state is OverallRatingReadyState) {
                _ratingObj = state.historyRating;
              }

              return Container(
                margin: EdgeInsets.only(
                  top: CustomNavigationBar.heightNavBar +
                      context.media.viewPadding.top,
                  left: 20,
                  right: 20,
                ),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      SizedBox(height: 50),
                      Text(
                        'How was ${_ratingObj.nickName}?',
                        style: context.theme.textTheme.headline5.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Constaint.defaultTextColor,
                        ),
                      ),
                      SizedBox(height: 35),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildGreatButton(),
                          _buildNotGreatButton(),
                        ],
                      ),
                      SizedBox(height: 35),
                      if (_isGreat == null)
                        _buildHappenButton(onPressed: () {
                          _isSelectHappen = !_isSelectHappen;
                          if (!_isSelectHappen) {
                            _isShowSubmit = false;
                            _userAnsers = '';
                          }

                          setState(() {});
                        }),
                      ..._buildMiddleContent(),
                      SizedBox(height: 35),
                      if (_isShowSubmit && state is RatingProcessingState)
                        Utils.getLoadingWidget(),
                      if (_isShowSubmit && !(state is RatingProcessingState))
                        CustomButtonWidget(
                          title: 'Submit',
                          btnColor: Constaint.rateYourDateColor,
                          onPressed: () {
                            _beginRating();
                          },
                        ),
                      SizedBox(
                          height: max(context.media.viewPadding.bottom, 20)),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGreatButton() {
    bool isSelected = _isGreat ?? false;
    return Column(
      key: ValueKey('great'),
      children: [
        Card(
          clipBehavior: Clip.hardEdge,
          elevation: 3.0,
          shadowColor: Colors.grey[200],
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          child: InkWell(
            onTap: () {
              _isSelectHappen = false;
              _userAnsers = '';
              if (_isGreat != null) {
                if (_isGreat) {
                  _isGreat = null;
                  _isShowSubmit = false;
                  setState(() {});
                  return;
                }
              }

              _isGreat = true;
              _isShowSubmit = true;
              setState(() {});
            },
            child: Container(
              width: 80,
              height: 80,
              alignment: Alignment.center,
              color: isSelected
                  ? ColorExt.colorWithHex(0xEFFAF5)
                  : Colors.transparent,
              child: ImageIcon(
                AssetImage('assets/images/ic_great.png'),
                size: 33,
                color: isSelected
                    ? Constaint.mainColor
                    : ColorExt.colorWithHex(0x828282),
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Great!',
          style: context.theme.textTheme.headline5.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isSelected
                ? Constaint.mainColor
                : ColorExt.colorWithHex(0x828282),
          ),
        )
      ],
    );
  }

  Widget _buildNotGreatButton() {
    bool isSelected = _isGreat ?? true;
    return Column(
      key: ValueKey('not_great'),
      children: [
        Card(
          clipBehavior: Clip.hardEdge,
          elevation: 3.0,
          shadowColor: Colors.grey[200],
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          child: InkWell(
            highlightColor: Constaint.rateYourDateColor.withPercentAlpha(0.2),
            splashColor: Constaint.rateYourDateColor.withPercentAlpha(0.3),
            onTap: () {
              _isSelectHappen = false;
              _userAnsers = '';
              if (_isGreat != null) {
                if (!_isGreat) {
                  _isGreat = null;
                  _isShowSubmit = false;
                  setState(() {});
                  return;
                }
              }

              _isGreat = false;
              _isShowSubmit = true;
              setState(() {});
            },
            child: Container(
              width: 80,
              height: 80,
              alignment: Alignment.center,
              color: isSelected == false
                  ? ColorExt.colorWithHex(0xFFEBD9)
                  : Colors.transparent,
              child: ImageIcon(
                AssetImage('assets/images/ic_not_great.png'),
                size: 33,
                color: isSelected == false
                    ? Constaint.rateYourDateColor
                    : ColorExt.colorWithHex(0x828282),
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Not great...',
          style: context.theme.textTheme.headline5.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isSelected == false
                ? Constaint.rateYourDateColor
                : ColorExt.colorWithHex(0x828282),
          ),
        )
      ],
    );
  }

  Widget _buildHappenButton({Function onPressed}) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: _isSelectHappen ? ColorExt.colorWithHex(0xFFEBD9) : Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[200],
            blurRadius: 4.0,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: FlatButton(
          padding: EdgeInsets.zero,
          onPressed: onPressed,
          highlightColor: Constaint.rateYourDateColor.withPercentAlpha(0.2),
          splashColor: Constaint.rateYourDateColor.withPercentAlpha(0.3),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'It didn\'t happen',
                  style: context.theme.textTheme.headline5.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _isSelectHappen
                        ? Constaint.rateYourDateColor
                        : ColorExt.colorWithHex(0x828282),
                  ),
                ),
                SizedBox(width: 5),
                ImageIcon(
                  AssetImage('assets/images/ic_not_calendar.png'),
                  size: 25,
                  color: _isSelectHappen
                      ? Constaint.rateYourDateColor
                      : ColorExt.colorWithHex(0x828282),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildMiddleContent() {
    if (_isGreat == null && _isSelectHappen) {
      return [
        SizedBox(height: 27),
        Text(
          'Ah, how so?',
          style: context.theme.textTheme.headline5.copyWith(
            fontSize: 18,
            color: ColorExt.colorWithHex(0x333333),
          ),
        ),
        SizedBox(height: 27),
        Tags(
          itemCount: _answers.length,
          alignment: WrapAlignment.center,
          runSpacing: 10,
          spacing: 8,
          itemBuilder: (int index) {
            final item = _answers[index];
            return ItemTags(
              index: index,
              title: item,
              singleItem: true,
              elevation: 0,
              color: Colors.transparent,
              activeColor: ColorExt.colorWithHex(0xFFEBD9),
              textColor: Constaint.rateYourDateColor,
              textActiveColor: Constaint.rateYourDateColor,
              highlightColor: Constaint.rateYourDateColor.withPercentAlpha(0.2),
              splashColor: Constaint.rateYourDateColor.withPercentAlpha(0.3),
              padding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 16,
              ),
              textStyle: context.theme.textTheme.headline5.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              border: Border.fromBorderSide(BorderSide(
                width: 0.5,
                color: Constaint.rateYourDateColor,
              )),
              onPressed: (_) {
                _userAnsers = item;
                _isShowSubmit = _userAnsers.isNotEmpty && _isSelectHappen;
                setState(() {});
                
                Future.delayed(Duration(milliseconds: 200), () {
                  _scrollController
                      .jumpTo(_scrollController.position.maxScrollExtent);
                });
              },
            );
          },
        ),
      ];
    } else if (_isGreat != null) {
      if (_isGreat) {
        return [
          SizedBox(height: 9),
          Text(
            'Glad it went well!',
            style: context.theme.textTheme.headline5
                .copyWith(fontSize: 18, color: ColorExt.colorWithHex(0x333333)),
          ),
        ];
      } else {
        return [
          SizedBox(height: 9),
          Text(
            'Sorry to hear...!',
            style: context.theme.textTheme.headline5
                .copyWith(fontSize: 18, color: ColorExt.colorWithHex(0x333333)),
          ),
        ];
      }
    }

    return [Container()];
  }

  void _beginRating() {
    if (_isGreat != null) {
      context.bloc<RatingBloc>().add(
            OverrallRatingEvent(
              scheduleId: _ratingObj.scheduleId,
              overallKey: _isGreat ? CommonKey.IS_GREAT : CommonKey.NOT_GREAT,
              overallReason: '',
            ),
          );
    } else if (_isSelectHappen) {
      context.bloc<RatingBloc>().add(
            OverrallRatingEvent(
              scheduleId: _ratingObj.scheduleId,
              overallKey: CommonKey.NOT_HAPPEN,
              overallReason: _userAnsers,
            ),
          );
    }
  }
}
