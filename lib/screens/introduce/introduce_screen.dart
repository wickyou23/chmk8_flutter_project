import 'dart:math';

import 'package:chkm8_app/screens/auth/auth_screen.dart';
import 'package:chkm8_app/services/local_store_service.dart';
import 'package:chkm8_app/widgets/app_scaffold.dart';
import 'package:chkm8_app/widgets/custom_button_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chkm8_app/screens/introduce/introduce_page.dart';
import 'package:chkm8_app/utils/extension.dart';

class IntroduceScreen extends StatefulWidget {
  static final routeName = '/IntroduceScreen';

  @override
  _IntroduceScreenState createState() => _IntroduceScreenState();
}

class _IntroduceScreenState extends State<IntroduceScreen> {
  PageController _pageController;
  int _currentPageIdx = 0;
  bool _isShowLoginButton = false;

  @override
  void initState() {
    _pageController = PageController(initialPage: _currentPageIdx);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _pageController.addListener(() {
      int crPage = _pageController.page.round();
      if (_currentPageIdx != crPage) {
        setState(() {
          _currentPageIdx = crPage;
          if (_currentPageIdx == 3) {
            _isShowLoginButton = _currentPageIdx == 3;
          }
        });
      }
    });

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            child: PageView(
              controller: _pageController,
              children: <Widget>[
                IntroducePage(
                  image: AssetImage("assets/images/bg_Illustration_1.png"),
                  ratio: 1080 / 925,
                  description:
                      'Simple. Anonymous. Efficient. Fun. With ChkM8, there’s safety in numbers.',
                  title: 'Hi, welcome to ChkM8',
                ),
                IntroducePage(
                  image: AssetImage("assets/images/bg_Illustration_2.png"),
                  ratio: 1080 / 856,
                  description:
                      'Check the Ratings. Make the Ratings. Empower others when you empower yourself.',
                  title: 'ChkM8 Empowers',
                ),
                IntroducePage(
                  image: AssetImage("assets/images/bg_Illustration_3.png"),
                  ratio: 1080 / 778,
                  description:
                      'When you rate someone, they won’t know it’s you. Rate your dates with honesty and confidence.',
                  title: 'ChkM8 is Anonymous',
                ),
                IntroducePage(
                  image: AssetImage("assets/images/bg_Illustration_4.png"),
                  ratio: 1080 / 856,
                  description:
                      'Want to grab someone’s attention? A good Safety Rating shows you’re a safe date. A high Integrity Rating means you are who you say you are. A positive Repeat Date Rating says you’re fun.',
                  title: 'ChkM8 Gets You Noticed',
                ),
              ],
            ),
          ),
          Column(
            children: <Widget>[
              Expanded(child: Container()),
              Container(
                alignment: Alignment.center,
                height: (context.isSmallDevice) ? 20 : 50,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Material(
                          color: (_currentPageIdx == 0)
                              ? context.theme.primaryColor
                              : ColorExt.colorWithHex(0xB0C1DA),
                          type: MaterialType.circle,
                          child: Container(
                            height: 10,
                            width: 10,
                            child: null,
                          ),
                        ),
                        SizedBox(width: 10),
                        Material(
                          color: (_currentPageIdx == 1)
                              ? context.theme.primaryColor
                              : ColorExt.colorWithHex(0xB0C1DA),
                          type: MaterialType.circle,
                          child: Container(
                            height: 10,
                            width: 10,
                            child: null,
                          ),
                        ),
                        SizedBox(width: 10),
                        Material(
                          color: (_currentPageIdx == 2)
                              ? context.theme.primaryColor
                              : ColorExt.colorWithHex(0xB0C1DA),
                          type: MaterialType.circle,
                          child: Container(
                            height: 10,
                            width: 10,
                            child: null,
                          ),
                        ),
                        SizedBox(width: 10),
                        Material(
                          color: (_currentPageIdx == 3)
                              ? context.theme.primaryColor
                              : ColorExt.colorWithHex(0xB0C1DA),
                          type: MaterialType.circle,
                          child: Container(
                            height: 10,
                            width: 10,
                            child: null,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              if (!_isShowLoginButton)
                SizedBox(
                  height: 45,
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: Text(
                      'Skip',
                      style: context.theme.textTheme.headline5.copyWith(
                        fontSize: 18,
                        color: ColorExt.colorWithHex(0x4F4F4F),
                      ),
                    ),
                    onPressed: () {
                      LocalStoreService().isSkipIntroduce = true;
                      context.navigator
                          .pushReplacementNamed(AuthScreen.routeName);
                    },
                  ),
                ),
              if (_isShowLoginButton)
                CustomButtonWidget(
                  title: 'Log in',
                  onPressed: () {
                    LocalStoreService().isSkipIntroduce = true;
                    context.navigator.pushReplacementNamed(
                      AuthScreen.routeName,
                      arguments: false,
                    );
                  },
                ),
              SizedBox(
                height: max(context.media.viewPadding.bottom,
                    (context.isSmallDevice ? 12 : 20)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
