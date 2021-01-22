import 'package:chkm8_app/bloc/auth/auth_bloc.dart';
import 'package:chkm8_app/bloc/auth/auth_event.dart';
import 'package:chkm8_app/bloc/auth/auth_state.dart';
import 'package:chkm8_app/enum/rating_type_enum.dart';
import 'package:chkm8_app/models/auth_user.dart';
import 'package:chkm8_app/screens/privacy/policy_privacy_screen.dart';
import 'package:chkm8_app/screens/privacy/terms_of_service_screen.dart';
import 'package:chkm8_app/screens/profile/my_rating_inform_screen.dart';
import 'package:chkm8_app/screens/profile/my_rating_screen.dart';
import 'package:chkm8_app/utils/constant.dart';
import 'package:chkm8_app/widgets/custom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chkm8_app/utils/extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyProfileScreen extends StatefulWidget {
  static final routeName = '/MyProfileScreen';

  const MyProfileScreen({Key key}) : super(key: key);

  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  String _myPhone = '';
  AuthUser _crUser;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.bloc<AuthBloc>().add(AuthGetMyRatingEvent());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (ctx, state) {
          if (state is AuthReadyState) {
            _crUser = state.crUser;
            if (_myPhone.isEmpty) {
              _crUser.getMyProfilePhoneDisplay().then((value) {
                _myPhone = value;
                setState(() {});
              });
            }
          }

          return Stack(
            children: <Widget>[
              CustomNavigationBar(
                navTitle: 'My Profile',
                isShowBack: false,
              ),
              Container(
                padding: EdgeInsets.only(
                  top: CustomNavigationBar.heightNavBar +
                      context.media.viewPadding.top,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            _myPhone,
                            style: context.theme.textTheme.headline5.copyWith(
                              fontSize: 21,
                              color: Constaint.defaultTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            flex: 1,
                            child: Container(
                              height: 120,
                              padding: const EdgeInsets.symmetric(vertical: 25),
                              decoration: BoxDecoration(
                                color: ColorExt.colorWithHex(0xEFFAF5),
                                borderRadius: BorderRadius.circular(17),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Text(
                                    'Ratings received',
                                    textAlign: TextAlign.center,
                                    style: context.theme.textTheme.headline5
                                        .copyWith(
                                      fontSize: 16,
                                      color: Constaint.defaultTextColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    _crUser.ratingReceived.toString(),
                                    textAlign: TextAlign.center,
                                    style: context.theme.textTheme.headline5
                                        .copyWith(
                                      fontSize: 27,
                                      color: Constaint.mainColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 25),
                          Flexible(
                            flex: 1,
                            child: Container(
                              height: 120,
                              padding: const EdgeInsets.symmetric(vertical: 25),
                              decoration: BoxDecoration(
                                color: ColorExt.colorWithHex(0xEFFAF5),
                                borderRadius: BorderRadius.circular(17),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Text(
                                    'Ratings given',
                                    textAlign: TextAlign.center,
                                    style: context.theme.textTheme.headline5
                                        .copyWith(
                                      fontSize: 16,
                                      color: Constaint.defaultTextColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    _crUser.ratingGiven.toString(),
                                    textAlign: TextAlign.center,
                                    style: context.theme.textTheme.headline5
                                        .copyWith(
                                      fontSize: 27,
                                      color: Constaint.mainColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: _buildListItem(context),
                    )
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Widget _buildListItem(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(
        top: 20,
        bottom: 30,
      ),
      children: <Widget>[
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          title: Text(
            'My Safety Rating',
            style: context.theme.textTheme.headline5.copyWith(
              fontSize: 16,
              color: ColorExt.colorWithHex(0x333333),
            ),
          ),
          trailing: const ImageIcon(
            AssetImage('assets/images/ic_arrow_right.png'),
            size: 27,
          ),
          onTap: () {
            _gotoMySafetyRating();
          },
        ),
        Divider(
          height: 0.5,
          color: ColorExt.colorWithHex(0xE0E0E0),
        ),
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          title: Text(
            'My Integrity Rating',
            style: context.theme.textTheme.headline5.copyWith(
              fontSize: 16,
              color: ColorExt.colorWithHex(0x333333),
            ),
          ),
          trailing: const ImageIcon(
            AssetImage('assets/images/ic_arrow_right.png'),
            size: 27,
          ),
          onTap: () {
            _gotoMyIntegrityRating();
          },
        ),
        Divider(
          height: 0.5,
          color: ColorExt.colorWithHex(0xE0E0E0),
        ),
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          title: Text(
            'My Repeat Rating',
            style: context.theme.textTheme.headline5.copyWith(
              fontSize: 16,
              color: ColorExt.colorWithHex(0x333333),
            ),
          ),
          trailing: const ImageIcon(
            AssetImage('assets/images/ic_arrow_right.png'),
            size: 27,
          ),
          onTap: () {
            _gotoMyRepeatRating();
          },
        ),
        Divider(
          height: 0.5,
          color: ColorExt.colorWithHex(0xE0E0E0),
        ),
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          title: Text(
            'Terms of Service',
            style: context.theme.textTheme.headline5.copyWith(
              fontSize: 16,
              color: ColorExt.colorWithHex(0x333333),
            ),
          ),
          trailing: const ImageIcon(
            AssetImage('assets/images/ic_arrow_right.png'),
            size: 27,
          ),
          onTap: () {
            context.navigator.pushNamed(TermsOfServiceScreen.routeName);
          },
        ),
        Divider(
          height: 0.5,
          color: ColorExt.colorWithHex(0xE0E0E0),
        ),
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          title: Text(
            'Privacy Policy',
            style: context.theme.textTheme.headline5.copyWith(
              fontSize: 16,
              color: ColorExt.colorWithHex(0x333333),
            ),
          ),
          trailing: const ImageIcon(
            AssetImage('assets/images/ic_arrow_right.png'),
            size: 27,
          ),
          onTap: () {
            context.navigator.pushNamed(PolicyPrivacyScreen.routeName);
          },
        ),
      ],
    );
  }

  void _gotoMySafetyRating() {
    if (_crUser.safetyRating == null) {
      context.navigator.pushNamed(
        MyRatingInformScreen.routeName,
        arguments: RatingType.safety,
      );
    } else {
      if (_crUser.safetyRating.baseON < 3) {
        context.navigator.pushNamed(
          MyRatingInformScreen.routeName,
          arguments: RatingType.safety,
        );
      } else {
        context.navigator.push(MaterialPageRoute(
          builder: (ctx) => MyRatingScreen(
            ratingReviewObj: _crUser.safetyRating,
          ),
          settings: RouteSettings(
            name: MyRatingScreen.routeName,
          ),
        ));
      }
    }
  }

  void _gotoMyIntegrityRating() {
    if (_crUser.integrityRating == null) {
      context.navigator.pushNamed(
        MyRatingInformScreen.routeName,
        arguments: RatingType.integrity,
      );
    } else {
      if (_crUser.integrityRating.baseON < 3) {
        context.navigator.pushNamed(
          MyRatingInformScreen.routeName,
          arguments: RatingType.integrity,
        );
      } else {
        context.navigator.push(MaterialPageRoute(
          builder: (ctx) => MyRatingScreen(
            ratingReviewObj: _crUser.integrityRating,
          ),
          settings: RouteSettings(
            name: MyRatingScreen.routeName,
          ),
        ));
      }
    }
  }

  void _gotoMyRepeatRating() {
    if (_crUser.repeatRating == null) {
      context.navigator.pushNamed(
        MyRatingInformScreen.routeName,
        arguments: RatingType.repeat,
      );
    } else {
      if (_crUser.repeatRating.baseON < 3) {
        context.navigator.pushNamed(
          MyRatingInformScreen.routeName,
          arguments: RatingType.repeat,
        );
      } else {
        context.navigator.push(MaterialPageRoute(
          builder: (ctx) => MyRatingScreen(
            ratingReviewObj: _crUser.repeatRating,
          ),
          settings: RouteSettings(
            name: MyRatingScreen.routeName,
          ),
        ));
      }
    }
  }
}
