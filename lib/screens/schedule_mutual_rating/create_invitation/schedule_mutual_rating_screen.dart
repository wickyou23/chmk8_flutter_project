import 'package:chkm8_app/bloc/schedule_mutual/schedule_mutual_bloc.dart';
import 'package:chkm8_app/bloc/schedule_mutual/schedule_mutual_state.dart';
import 'package:chkm8_app/enum/schedule_type_enum.dart';
import 'package:chkm8_app/frameworks/flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:chkm8_app/models/schedule_mutual_object.dart';
import 'package:chkm8_app/screens/home_screen.dart';
import 'package:chkm8_app/screens/schedule_mutual_rating/create_invitation/schedule_create_nickname_screen.dart';
import 'package:chkm8_app/utils/constant.dart';
import 'package:chkm8_app/widgets/app_scaffold.dart';
import 'package:chkm8_app/widgets/custom_button_widget.dart';
import 'package:chkm8_app/widgets/custom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chkm8_app/utils/extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScheduleMutualRatingScreen extends StatefulWidget {
  static final routeName = '/ScheduleMutualRatingScreen';

  @override
  _ScheduleMutualRatingScreenState createState() =>
      _ScheduleMutualRatingScreenState();
}

class _ScheduleMutualRatingScreenState
    extends State<ScheduleMutualRatingScreen> {
  DateTime _currentDate = DateTime.now().add(Duration(days: 1));

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          CustomNavigationBar(
            navTitle: 'Select a day',
            navTitleColor: Constaint.scheduleRatingColor,
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(
              top: CustomNavigationBar.heightNavBar +
                  context.media.viewPadding.top -
                  (context.isSmallDevice ? 8 : 0),
            ),
            child: Column(
              children: <Widget>[
                Container(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: _buildCalendar(),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey[200],
                          blurRadius: 5.0,
                          offset: Offset(0, 6))
                    ],
                  ),
                ),
                SizedBox(height: context.isSmallDevice ? 16 : 27),
                CustomButtonWidget(
                  wTitle: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Next',
                        style: context.theme.textTheme.headline5.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 5),
                      ImageIcon(
                        AssetImage('assets/images/ic_arrow_right.png'),
                        size: 24,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  btnColor: Constaint.scheduleRatingColor,
                  onPressed: () {
                    context.navigator.push(MaterialPageRoute(
                      builder: (_) {
                        return BlocProvider<ScheduleMutualBloc>(
                          create: (_) => ScheduleMutualBloc(
                            ScheduleMutualInitializeState(
                              scheduleObj: ScheduleMutualObject(
                                type: SchedulePickerTypeEnum.onALaterDate,
                                pickDate: _currentDate,
                              ),
                            ),
                          ),
                          child: ScheduleCreateNicknameScreen(),
                        );
                      },
                      settings: RouteSettings(
                        name: ScheduleCreateNicknameScreen.routeName,
                      ),
                    ));
                  },
                ),
                SizedBox(height: (context.isSmallDevice) ? 8 : 16),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: Text(
                    'Cancel',
                    style: context.theme.textTheme.headline5.copyWith(
                      fontSize: 18,
                      color: Constaint.defaultTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    context.navigator.popUntil(
                      (route) => route.settings.name == HomeScreen.routeName,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return CalendarCarousel(
      weekFormat: false,
      height: context.isSmallDevice ? 380 : 410,
      selectedDateTime: _currentDate,
      showIconBehindDayText: true,
      customGridViewPhysics: NeverScrollableScrollPhysics(),
      markedDateShowIcon: true,
      markedDateIconMaxShown: 2,
      minSelectedDate: _currentDate.subtract(Duration(days: 1)),
      maxSelectedDate: _currentDate.add(Duration(days: 360)),
      selectedDayButtonColor: Constaint.scheduleRatingColor,
      markedDateMoreShowTotal: true,
      showOnlyCurrentMonthDate: true,
      weekDayFormat: WeekdayFormat.narrow,
      todayButtonColor: Colors.transparent,
      headerMargin: EdgeInsets.only(
        top: 6,
        bottom: context.isSmallDevice ? 8 : 16,
      ),
      leftButtonIcon: Icon(
        Icons.arrow_back_ios,
        size: 13,
        color: ColorExt.colorWithHex(0x828282),
      ),
      rightButtonIcon: Icon(
        Icons.arrow_forward_ios,
        size: 13,
        color: ColorExt.colorWithHex(0x828282),
      ),
      inactiveDaysTextStyle: context.theme.textTheme.headline5.copyWith(
        color: ColorExt.colorWithHex(0x828282).withPercentAlpha(0.3),
        fontSize: 13,
      ),
      inactiveWeekendTextStyle: context.theme.textTheme.headline5.copyWith(
        color: ColorExt.colorWithHex(0x828282).withPercentAlpha(0.3),
        fontSize: 13,
      ),
      daysTextStyle: context.theme.textTheme.headline5.copyWith(
        color: ColorExt.colorWithHex(0x828282),
        fontSize: 13,
      ),
      weekendTextStyle: context.theme.textTheme.headline5.copyWith(
        color: ColorExt.colorWithHex(0x828282),
        fontSize: 13,
      ),
      selectedDayTextStyle: context.theme.textTheme.headline5.copyWith(
        color: Colors.white,
        fontSize: 13,
      ),
      weekdayTextStyle: context.theme.textTheme.headline5.copyWith(
        color: Colors.black,
        fontSize: 13,
        fontWeight: FontWeight.bold,
      ),
      headerTextStyle: TextStyle(
        fontFamily: 'Sarabun',
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: ColorExt.colorWithHex(0x333333),
      ),
      todayTextStyle: context.theme.textTheme.headline5.copyWith(
        color: Constaint.scheduleRatingColor,
        fontSize: 13,
      ),
      onDayPressed: (DateTime date, _) {
        this.setState(() => _currentDate = date);
      },
    );
  }
}
