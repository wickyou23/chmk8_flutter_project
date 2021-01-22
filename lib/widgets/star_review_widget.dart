import 'package:chkm8_app/enum/rating_type_enum.dart';
import 'package:chkm8_app/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:chkm8_app/utils/extension.dart';

class StarReviewWidget extends StatelessWidget {
  final RatingType type;

  StarReviewWidget({@required this.type});

  @override
  Widget build(BuildContext context) {
    List<String> starDesc = this.type.getStarDesc();

    return Container(
      child: Column(
        children: <Widget>[
          _buildCell(
            context,
            'assets/images/ic_group_five_star.png',
            'assets/images/ic_extremely_safe.png',
            starDesc[0],
          ),
          SizedBox(height: context.isSmallDevice ? 10 : 15),
          _buildCell(
            context,
            'assets/images/ic_group_four_star.png',
            'assets/images/ic_safe.png',
            starDesc[1],
          ),
          SizedBox(height: context.isSmallDevice ? 10 : 15),
          _buildCell(
            context,
            'assets/images/ic_group_three_star.png',
            'assets/images/ic_neutral.png',
            starDesc[2],
          ),
          SizedBox(height: context.isSmallDevice ? 10 : 15),
          _buildCell(
            context,
            'assets/images/ic_group_two_star.png',
            'assets/images/ic_unsafe.png',
            starDesc[3],
          ),
          SizedBox(height: context.isSmallDevice ? 10 : 15),
          _buildCell(
            context,
            'assets/images/ic_group_one_star.png',
            'assets/images/ic_extremely_unsafe.png',
            starDesc[4],
          ),
        ],
      ),
    );
  }

  Widget _buildCell(
    BuildContext context,
    String starImage,
    String emojiImage,
    String desc,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          flex: 4,
          child: Image.asset(
            starImage,
            fit: BoxFit.fitWidth,
          ),
        ),
        Flexible(
          flex: 1,
          child: Text(
            '=',
            textAlign: TextAlign.center,
            style: context.theme.textTheme.headline5.copyWith(
              fontSize: 16,
              color: Constaint.defaultTextColor,
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: Image.asset(
            emojiImage,
            fit: BoxFit.fitWidth,
            height: 25,
          ),
        ),
        Expanded(
          flex: 4,
          child: Text(
            desc,
            textAlign: TextAlign.start,
            style: context.theme.textTheme.headline5.copyWith(
              fontSize: 16,
              color: Constaint.defaultTextColor,
            ),
          ),
        ),
      ],
    );
  }
}
