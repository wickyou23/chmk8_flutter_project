import 'package:chkm8_app/bloc/rating/rating_bloc.dart';
import 'package:chkm8_app/bloc/rating/rating_state.dart';
import 'package:chkm8_app/bloc/schedule_mutual/schedule_mutual_bloc.dart';
import 'package:chkm8_app/bloc/schedule_mutual/schedule_mutual_event.dart';
import 'package:chkm8_app/bloc/schedule_mutual/schedule_mutual_state.dart';
import 'package:chkm8_app/data/repository/rating_repository.dart';
import 'package:chkm8_app/models/history_rating_object.dart';
import 'package:chkm8_app/screens/rate_your_date/overall_rating_screen.dart';
import 'package:chkm8_app/utils/constant.dart';
import 'package:chkm8_app/utils/utils.dart';
import 'package:chkm8_app/widgets/app_scaffold.dart';
import 'package:chkm8_app/widgets/custom_button_widget.dart';
import 'package:chkm8_app/widgets/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:chkm8_app/utils/extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StartRatingIntroScreen extends StatefulWidget {
  static final routeName = '/StartRatingIntroScreen';

  final HistoryRatingObject ratingObj;

  StartRatingIntroScreen({this.ratingObj});

  @override
  _StartRatingIntroScreenState createState() => _StartRatingIntroScreenState();
}

class _StartRatingIntroScreenState extends State<StartRatingIntroScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isRated;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      scKey: _scaffoldKey,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          CustomNavigationBar(
            navTitle: 'Rate Your Date',
            navTitleColor: Constaint.rateYourDateColor,
          ),
          BlocConsumer<ScheduleMutualBloc, ScheduleMutualState>(
            listener: (ctx, state) {
              if (state is ScheduleMutualCheckRateSuccessState) {
                _isRated = state.isRated;
                if (state.isRated) {
                  _scaffoldKey.currentState
                      .showCSSnackBar('This schedule is rated.');
                } else {
                  _beginOverallRating();
                }
              } else if (state is ScheduleMutualCheckRateFailedState) {
                _scaffoldKey.currentState
                    .showCSSnackBar(state.failedState.errorMessage);
              }
            },
            builder: (ctx, state) {
              return Container(
                padding: EdgeInsets.only(
                  top: CustomNavigationBar.heightNavBar +
                      context.media.viewPadding.top,
                ),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 60),
                    Text(
                      'How was ${this.widget.ratingObj.nickName}?',
                      style: context.theme.textTheme.headline5.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Constaint.defaultTextColor,
                      ),
                    ),
                    SizedBox(height: 27),
                    if (state is ScheduleMutualProcessingState)
                      Utils.getLoadingWidget(),
                    if (!(state is ScheduleMutualProcessingState))
                      CustomButtonWidget(
                        title: 'Start Rating',
                        btnColor: Constaint.rateYourDateColor,
                        onPressed: () {
                          RatingRepository().clean();
                          if (_isRated == null) {
                            context.bloc<ScheduleMutualBloc>().add(
                                  ScheduleMutualCheckRatedEvent(
                                    scheduleId:
                                        this.widget.ratingObj.scheduleId,
                                  ),
                                );
                          } else {
                            if (_isRated) {
                              _scaffoldKey.currentState
                                  .showCSSnackBar('This schedule is rated.');
                            } else {
                              _beginOverallRating();
                            }
                          }
                        },
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _beginOverallRating() {
    context.navigator.push(
      MaterialPageRoute(
        builder: (_) => BlocProvider<RatingBloc>(
          create: (_) => RatingBloc(
            OverallRatingReadyState(historyRating: this.widget.ratingObj),
          ),
          child: OverallRatingScreen(),
        ),
        settings: RouteSettings(name: OverallRatingScreen.routeName),
      ),
    );
  }
}
