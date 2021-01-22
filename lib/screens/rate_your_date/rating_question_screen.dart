import 'dart:math';

import 'package:chkm8_app/bloc/rating/rating_bloc.dart';
import 'package:chkm8_app/bloc/rating/rating_event.dart';
import 'package:chkm8_app/bloc/rating/rating_state.dart';
import 'package:chkm8_app/models/rating_object.dart';
import 'package:chkm8_app/services/notification_service.dart';
import 'package:chkm8_app/utils/constant.dart';
import 'package:chkm8_app/utils/utils.dart';
import 'package:chkm8_app/widgets/app_scaffold.dart';
import 'package:chkm8_app/widgets/custom_button_widget.dart';
import 'package:chkm8_app/widgets/custom_navigation_bar.dart';
import 'package:chkm8_app/widgets/custom_textformfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chkm8_app/utils/extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chkm8_app/enum/rating_type_enum.dart';

import '../home_screen.dart';
import 'rating_screen.dart';
import 'rating_success_screen.dart';

class RatingQuestionScreen extends StatefulWidget {
  static final routeName = '/RatingQuestionScreen';

  @override
  _RatingQuestionScreenState createState() => _RatingQuestionScreenState();
}

class _RatingQuestionScreenState extends State<RatingQuestionScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _otherController = TextEditingController();
  RatingObject _obj;

  @override
  void dispose() {
    _otherController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      scKey: _scaffoldKey,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: BlocConsumer<RatingBloc, RatingState>(
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

            if (!_obj.crQuestion.isSelectedOther()) {
              _otherController.text = '';
            }

            return Stack(
              fit: StackFit.expand,
              children: <Widget>[
                CustomNavigationBar(
                  navTitle: _obj.type.getTitle(),
                  navTitleColor: Constaint.rateYourDateColor,
                ),
                IgnorePointer(
                  ignoring: state is RatingProcessingState,
                  child: Container(
                    margin: EdgeInsets.only(
                      top: CustomNavigationBar.heightNavBar +
                          context.media.viewPadding.top,
                    ),
                    color: Colors.transparent,
                    child: CustomScrollView(
                      key: ValueKey('_CustomScrollView'),
                      physics: BouncingScrollPhysics(
                        parent: ClampingScrollPhysics(),
                      ),
                      scrollDirection: Axis.vertical,
                      slivers: <Widget>[
                        SliverToBoxAdapter(
                          child: Center(
                            child: Container(
                              width: 242,
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: AspectRatio(
                                aspectRatio: 242 / 21,
                                child: Image.asset(
                                  _obj.type.getStepImage(),
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                            child: Text(
                              _obj.crQuestion.question,
                              textAlign: TextAlign.center,
                              style: context.theme.textTheme.headline5.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Constaint.defaultTextColor,
                              ),
                            ),
                          ),
                        ),
                        SliverPadding(
                          padding: const EdgeInsets.only(
                            left: 14,
                            right: 20,
                          ),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (ctx, idx) {
                                String item =
                                    _obj.crQuestion.answersOptional[idx];
                                bool isSelected =
                                    _obj.crQuestion.isSelected(item);
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        alignment: Alignment.center,
                                        child: GestureDetector(
                                          onTap: () {
                                            _obj.crQuestion.addUserAnswer(item);
                                            setState(() {});
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Image.asset(
                                              ((isSelected)
                                                  ? 'assets/images/ic_checked.png'
                                                  : 'assets/images/ic_uncheck.png'),
                                              width: 23,
                                              height: 23,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Flexible(
                                        child: Text(
                                          item,
                                          style: context
                                              .theme.textTheme.headline5
                                              .copyWith(
                                            fontSize: 16,
                                            color:
                                                ColorExt.colorWithHex(0x333333),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              childCount:
                                  _obj.crQuestion.answersOptional.length,
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: CustomTextFormField(
                              key: ValueKey('_OtherTextFieldKey'),
                              controller: _otherController,
                              placeHolder: 'Other reason',
                              fontSize: 14,
                              enabled: _obj.crQuestion.isSelectedOther(),
                              minLine: 1,
                              maxLine: 3,
                              onChanged: (text) {
                                _obj.crQuestion.otherUserAnswer = text;
                                setState(() {});
                              },
                            ),
                          ),
                        ),
                        if (state is RatingProcessingState)
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: Utils.getLoadingWidget(),
                            ),
                          ),
                        if (!(state is RatingProcessingState))
                          SliverToBoxAdapter(
                            child: Container(
                              padding: const EdgeInsets.only(top: 16),
                              alignment: Alignment.center,
                              child: CustomButtonWidget(
                                width: 223,
                                title: 'Submit Rating',
                                btnColor: Constaint.rateYourDateColor,
                                onPressed: _obj.crQuestion
                                        .isEnableSubmitRating()
                                    ? () {
                                        context.bloc<RatingBloc>().add(
                                              RatingSavedEvent(ratingObj: _obj),
                                            );

                                        if (_obj.isCompleted) {
                                          context.bloc<RatingBloc>().add(
                                                RatingCompletionEvent(
                                                    ratingObj: _obj),
                                              );
                                          return;
                                        }

                                        context.navigator.pushReplacement(
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                BlocProvider<RatingBloc>(
                                              create: (_) => RatingBloc(
                                                RatingReadyState(
                                                  crRating: _obj.copyWith(
                                                    type:
                                                        _obj.type.getNextType(),
                                                  ),
                                                ),
                                              ),
                                              child: RatingScreen(),
                                            ),
                                            settings: RouteSettings(
                                                name: RatingScreen.routeName),
                                          ),
                                        );
                                      }
                                    : null,
                              ),
                            ),
                          ),
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Container(
                            alignment: Alignment.bottomCenter,
                            margin: EdgeInsets.only(
                              top: 16,
                              bottom: max(context.media.viewPadding.bottom, 16),
                            ),
                            child: CupertinoButton(
                              padding: EdgeInsets.zero,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  ImageIcon(
                                    AssetImage(
                                      'assets/images/ic_help_circle.png',
                                    ),
                                    size: 24,
                                    color: ColorExt.colorWithHex(0x333333),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'FAQ',
                                    textAlign: TextAlign.center,
                                    style: context.theme.textTheme.headline5
                                        .copyWith(
                                      fontSize: 13,
                                      color: ColorExt.colorWithHex(0x4F4F4F),
                                    ),
                                  ),
                                ],
                              ),
                              onPressed: () {},
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
