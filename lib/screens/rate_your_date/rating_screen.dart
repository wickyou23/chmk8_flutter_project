import 'dart:math';
import 'package:chkm8_app/bloc/rating/rating_bloc.dart';
import 'package:chkm8_app/bloc/rating/rating_event.dart';
import 'package:chkm8_app/bloc/rating/rating_state.dart';
import 'package:chkm8_app/models/rating_object.dart';
import 'package:chkm8_app/screens/rate_your_date/rating_question_screen.dart';
import 'package:chkm8_app/services/notification_service.dart';
import 'package:chkm8_app/utils/constant.dart';
import 'package:chkm8_app/utils/utils.dart';
import 'package:chkm8_app/widgets/app_scaffold.dart';
import 'package:chkm8_app/widgets/custom_button_widget.dart';
import 'package:chkm8_app/widgets/custom_navigation_bar.dart';
import 'package:chkm8_app/widgets/helping_popup_widget.dart';
import 'package:chkm8_app/widgets/star_rating_widget.dart';
import 'package:chkm8_app/widgets/star_review_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chkm8_app/utils/extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chkm8_app/enum/rating_type_enum.dart';

import '../home_screen.dart';
import 'rating_success_screen.dart';

class RatingScreen extends StatefulWidget {
  static final routeName = '/RatingScreenState';

  @override
  _RatingScreenState createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  RatingObject _obj;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RatingBloc, RatingState>(
      listener: (ctx, state) {
        if (state is RatingCompletionSuccessState) {
          NotificationService().add(NotificationName.NEED_TO_RELOAD_NOTIFICATION);
          context.navigator.pushNamedAndRemoveUntil(
            RatingSuccessScreen.routeName,
            (route) => route.settings.name == HomeScreen.routeName,
          );
        } else if (state is RatingCompletionFailedState) {
          _scaffoldKey.currentState
              .showCSSnackBar(state.failedState.errorMessage);
        }
      },
      builder: (ctx, state) {
        if (state is RatingReadyState) {
          _obj = state.crRating;
        }

        return AppScaffold(
          scKey: _scaffoldKey,
          body: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              CustomNavigationBar(
                navTitle: _obj.type.getTitle(),
                navTitleColor: Constaint.rateYourDateColor,
              ),
              IgnorePointer(
                ignoring: state is RatingProcessingState,
                child: Container(
                  padding: EdgeInsets.only(
                    top: CustomNavigationBar.heightNavBar +
                        context.media.viewPadding.top,
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 8),
                      Container(
                        width: 242,
                        child: AspectRatio(
                          aspectRatio: 242 / 21,
                          child: Image.asset(
                            _obj.type.getStepImage(),
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                      SizedBox(height: context.isSmallDevice ? 20 : 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          _obj.type.getDesc(),
                          textAlign: TextAlign.center,
                          style: context.theme.textTheme.headline5.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Constaint.defaultTextColor,
                          ),
                        ),
                      ),
                      SizedBox(height: context.isSmallDevice ? 20 : 33),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: StarRatingWidget(
                          onRating: (star) {
                            _obj.star = star;
                            if (star < 3) {
                              _obj.cleanUserAnswer();
                              context.navigator.push(
                                MaterialPageRoute(
                                  builder: (ctx) {
                                    return BlocProvider<RatingBloc>.value(
                                      value: context.bloc<RatingBloc>(),
                                      child: RatingQuestionScreen(),
                                    );
                                  },
                                  settings: RouteSettings(
                                    name: RatingQuestionScreen.routeName,
                                  ),
                                ),
                              );
                            } else {
                              context.bloc<RatingBloc>().add(
                                    RatingSavedEvent(ratingObj: _obj),
                                  );

                              if (_obj.isCompleted) {
                                setState(() {});
                                return;
                              }

                              context.navigator.push(
                                MaterialPageRoute(
                                  builder: (_) => BlocProvider<RatingBloc>(
                                    create: (_) => RatingBloc(
                                      RatingReadyState(
                                        crRating: _obj.copyWith(
                                            type: _obj.type.getNextType()),
                                      ),
                                    ),
                                    child: RatingScreen(),
                                  ),
                                  settings: RouteSettings(
                                      name: RatingScreen.routeName),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      if (_obj.isCompleted && state is RatingProcessingState)
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: (context.isSmallDevice) ? 18 : 38),
                          child: Utils.getLoadingWidget(),
                        ),
                      if (_obj.isCompleted && !(state is RatingProcessingState))
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: (context.isSmallDevice) ? 18 : 38),
                          child: CustomButtonWidget(
                            width: 223,
                            title: 'Submit Rating',
                            btnColor: Constaint.rateYourDateColor,
                            onPressed: _obj.star > 2
                                ? () {
                                    context.bloc<RatingBloc>().add(
                                          RatingCompletionEvent(
                                              ratingObj: _obj),
                                        );
                                  }
                                : null,
                          ),
                        ),
                      if (!_obj.isCompleted)
                        SizedBox(
                          height: context.isSmallDevice ? 81 : 121,
                        ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20.0,
                          right: 5.0,
                        ),
                        child: StarReviewWidget(
                          type: _obj.type,
                        ),
                      ),
                      SizedBox(height: context.isSmallDevice ? 15 : 30),
                      Expanded(child: Container()),
                      CupertinoButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ImageIcon(
                              AssetImage('assets/images/ic_help_circle.png'),
                              size: 24,
                              color: ColorExt.colorWithHex(0x333333),
                            ),
                            SizedBox(width: 8),
                            Text(
                              _obj.type.getFAQTitle(),
                              textAlign: TextAlign.center,
                              style: context.theme.textTheme.headline5.copyWith(
                                fontSize: 13,
                                color: ColorExt.colorWithHex(0x4F4F4F),
                              ),
                            ),
                          ],
                        ),
                        onPressed: () {
                          context.showPopup(
                            child: HelpingPopupWidget(
                              titles: [_obj.type.getFAQTitle()],
                              messages: [_obj.type.getRatingFAQAns()],
                              btnColor: Constaint.rateYourDateColor,
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        height: max(context.media.viewPadding.bottom, 10),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
