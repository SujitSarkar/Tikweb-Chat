import '/shared/widgets/card_widget.dart';
import '../../../shared/utils/validations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../core/constants/app_color.dart';

class TextFormFieldWidget extends StatefulWidget {
  const TextFormFieldWidget(
      {super.key,
      required this.controller,
      required this.hintText,
      this.onTap,
      this.obscure = false,
      this.readOnly = false,
      this.required = false,
      this.textInputType,
      this.textCapitalization,
      this.textAlign = TextAlign.left,
      this.prefixIcon,
      this.suffixIcon,
      this.suffixColor,
      this.prefixColor,
      this.maxLine,
      this.minLine,
      this.validationErrorMessage,
      this.maxLength,
      this.suffixOnTap,
      this.prefixOnTap,
      this.onChanged,
      this.onEditingComplete,
      this.contentPadding,
      this.focusNode});

  final TextEditingController controller;
  final String hintText;
  final TextInputType? textInputType;
  final TextCapitalization? textCapitalization;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Color? suffixColor;
  final Color? prefixColor;
  final TextAlign? textAlign;
  final bool obscure;
  final bool required;
  final bool readOnly;
  final int? maxLine;
  final int? minLine;
  final int? maxLength;
  final String? validationErrorMessage;
  final Function()? onTap;
  final Function(String)? onChanged;
  final Function()? onEditingComplete;
  final Function()? suffixOnTap;
  final Function()? prefixOnTap;
  final FocusNode? focusNode;
  final EdgeInsetsGeometry? contentPadding;

  @override
  State<TextFormFieldWidget> createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState extends State<TextFormFieldWidget> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return CardWidget(
      child: TextFormField(
        validator: (value) {
          if (widget.required && value != null && value.isEmpty) {
            return "${widget.hintText} can't be empty";
          } else if (widget.required &&
              value != null &&
              widget.textInputType == TextInputType.emailAddress &&
              !value.isValidEmail) {
            return "Invalid email address";
          } else {
            return null;
          }
        },
        controller: widget.controller,
        onTap: widget.onTap,
        focusNode: widget.focusNode,
        onChanged: (val) {
          if (widget.onChanged != null) {
            widget.onChanged!(val);
          }
        },
        maxLength: widget.maxLength,
        onEditingComplete: widget.onEditingComplete,
        readOnly: widget.readOnly,
        obscureText: widget.obscure ? _obscure : false,
        keyboardType: widget.textInputType ?? TextInputType.text,
        textCapitalization:
            widget.textCapitalization ?? TextCapitalization.none,
        maxLines: widget.maxLine ?? 1,
        minLines: widget.minLine ?? 1,
        textAlign: widget.textAlign!,
        style: TextStyle(
            color: AppColors.textColor,
            fontWeight: FontWeight.w400,
            fontSize: 16),
        decoration: InputDecoration(
            errorText: widget.validationErrorMessage,
            alignLabelWithHint: true,
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                borderSide: BorderSide.none),
            enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                borderSide: BorderSide.none),
            focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                borderSide: BorderSide.none),
            errorBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                borderSide: BorderSide.none),
            isDense: true,
            contentPadding: widget.contentPadding ?? const EdgeInsets.all(16),
            floatingLabelAlignment: FloatingLabelAlignment.start,
            hintText: widget.hintText,
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            hintStyle: const TextStyle(
                color: Color(0xffB5B5B5),
                fontWeight: FontWeight.w400,
                fontSize: 16),
            prefixIcon: widget.prefixIcon != null
                ? InkWell(
                    onTap: widget.prefixOnTap,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8, left: 10),
                      child: Icon(widget.prefixIcon,
                          size: 20, color: widget.prefixColor ?? Colors.grey),
                    ),
                  )
                : null,
            suffixIconConstraints: BoxConstraints.loose(size),
            prefixIconConstraints: BoxConstraints.loose(size),
            suffixIcon: widget.obscure
                ? InkWell(
                    onTap: () => setState(() => _obscure = !_obscure),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Icon(
                          _obscure
                              ? CupertinoIcons.eye_slash
                              : CupertinoIcons.eye,
                          size: 20,
                          color: widget.suffixColor ?? Colors.grey),
                    ),
                  )
                : InkWell(
                    onTap: widget.suffixOnTap,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Icon(widget.suffixIcon, size: 28),
                    ),
                  )),
      ),
    );
  }
}
