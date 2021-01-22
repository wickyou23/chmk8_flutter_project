import 'package:chkm8_app/widgets/app_scaffold.dart';
import 'package:chkm8_app/widgets/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:chkm8_app/utils/extension.dart';

class TermsOfServiceScreen extends StatelessWidget {
  static final routeName = '/TermsOfServiceScreen';

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Stack(
        children: <Widget>[
          CustomNavigationBar(
            navTitle: 'Terms of Service',
          ),
          Container(
            padding: EdgeInsets.only(
              top: CustomNavigationBar.heightNavBar +
                  context.media.viewPadding.top,
            ),
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: context.media.size.height -
                      (CustomNavigationBar.heightNavBar +
                          context.media.viewPadding.top),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 16,
                    left: 20,
                    right: 20,
                    bottom: 50,
                  ),
                  child: Text(
                    'Et ea aliquip aliqua eiusmod tempor nisi velit id exercitation consectetur magna laborum fugiat aliquip. Qui aliqua commodo voluptate veniam est amet dolore do reprehenderit voluptate excepteur. Dolore minim aliquip ullamco amet laboris minim proident eiusmod ipsum. Nisi Lorem exercitation officia reprehenderit commodo laboris adipisicing. Anim cillum nulla ut voluptate nostrud irure tempor aliqua anim ad minim. Est enim cillum nulla et magna et sint tempor ut nostrud consectetur reprehenderit. Exercitation do consequat id occaecat labore amet aute aliqua sint commodo aliquip anim non. Fugiat aliqua veniam irure sint et irure ex nostrud dolore cupidatat nulla magna.',
                    style: context.theme.textTheme.headline5.copyWith(
                      fontSize: 18,
                      color: ColorExt.colorWithHex(0x333333),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
