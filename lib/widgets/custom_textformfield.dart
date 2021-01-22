import 'package:chkm8_app/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:chkm8_app/enum/text_field_enum.dart';
import 'package:chkm8_app/utils/extension.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatefulWidget {
  final Key key;
  final String title;
  final String placeHolder;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget suffixIcon;
  final TextEditingController controller;
  final CustomTextFormFieldType textFieldStyle;
  final bool readOnly;
  final bool enabled;
  final int maxLine;
  final int minLine;
  final VoidCallback onTap;
  final FocusNode focusNode;
  final TextInputAction textInputAction;
  final Function(String) onFieldSubmitted;
  final String initialValue;
  final Function(String) onChanged;
  final double fontSize;
  final String Function(String) onValidator;
  final int maxLength;
  final List<TextInputFormatter> inputFormatters;
  final TextCapitalization textCapitalization;

  CustomTextFormField({
    this.key,
    this.title,
    this.placeHolder,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.controller,
    this.textFieldStyle = CustomTextFormFieldType.normalStyle,
    this.readOnly = false,
    this.enabled = true,
    this.maxLine = 1,
    this.onTap,
    this.focusNode,
    this.textInputAction,
    this.onFieldSubmitted,
    this.initialValue,
    this.onChanged,
    this.fontSize,
    this.onValidator,
    this.minLine = 1,
    this.maxLength,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
  }) : super(key: key);

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _hasError = false;
  String _errorString = '';
  int _counterText = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (this.widget.title != null ||
            this.widget.title?.isNotEmpty == false) ...[
          Text(
            this.widget.title,
            textAlign: TextAlign.left,
            style: context.theme.textTheme.headline6.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: this.widget.textFieldStyle.titleColor,
            ),
          ),
          SizedBox(height: 6)
        ],
        Container(
          constraints: BoxConstraints(minHeight: 50),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            border: Border.fromBorderSide(
              _hasError
                  ? BorderSide(
                      color: ColorExt.colorWithHex(0xEB5757),
                      width: 1.0,
                    )
                  : BorderSide.none,
            ),
          ),
          child: TextFormField(
            obscureText: this.widget.obscureText,
            cursorColor: Constaint.mainColor,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: this.widget.keyboardType,
            readOnly: this.widget.readOnly,
            enabled: this.widget.enabled,
            maxLines: this.widget.maxLine,
            minLines: this.widget.minLine,
            focusNode: this.widget.focusNode,
            textInputAction: this.widget.textInputAction,
            onFieldSubmitted: this.widget.onFieldSubmitted,
            initialValue: this.widget.initialValue,
            controller: this.widget.controller,
            maxLength: this.widget.maxLength,
            inputFormatters: this.widget.inputFormatters,
            textCapitalization: this.widget.textCapitalization,
            onChanged: (text) {
              if (_hasError) {
                _hasError = false;
                _errorString = '';
              }

              _counterText = text.length ?? 0;
              setState(() {});

              if (this.widget.onChanged != null) {
                this.widget.onChanged(text);
              }
            },
            style: context.theme.textTheme.headline5.copyWith(
              fontSize: this.widget.fontSize ?? 17,
              color: this.widget.textFieldStyle.textColor,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: ColorExt.colorWithHex(0xF2F2F2).withPercentAlpha(0.8),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 25,
                vertical: 15,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28),
                borderSide: BorderSide.none,
              ),
              hintText: this.widget.placeHolder,
              hintStyle: context.theme.textTheme.headline5.copyWith(
                fontSize: this.widget.fontSize ?? 17,
                color: this.widget.textFieldStyle.placeHolderColor,
              ),
              suffixIcon: this.widget.suffixIcon,
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28),
                borderSide: BorderSide.none,
              ),
              errorStyle: TextStyle(height: 0),
              counterStyle: TextStyle(height: 0),
              counterText: '',
            ),
            onTap: this.widget.onTap,
            validator: (text) {
              var errorString = this.widget.onValidator(text);
              if (errorString == null) {
                return null;
              } else {
                _hasError = true;
                _errorString = errorString;
                setState(() {});
                return '';
              }
            },
          ),
        ),
        SizedBox(height: 4),
        if (this.widget.maxLength != null && !_hasError)
          Text(
            '$_counterText/${this.widget.maxLength}',
            textAlign: TextAlign.right,
            style: context.theme.textTheme.headline5.copyWith(
              fontSize: 13,
              color: ColorExt.colorWithHex(0x828282),
            ),
          ),
        if (_hasError)
          Text(
            _errorString,
            style: context.theme.textTheme.headline5.copyWith(
              fontSize: 16,
              color: ColorExt.colorWithHex(0xEB5757),
            ),
          ),
      ],
    );
  }
}
