import 'package:flutter/material.dart';
import 'package:flutter/src/services/text_formatter.dart';


class TextFiledWidget extends StatefulWidget {


  const TextFiledWidget(
      {super.key,
        required this.controller,
        required this.labelText,
        this.obscureText,
        this.validator,
        this.suffixIcon,  this. keyboardType, this.maxLength,
        this.focusNode,
        this.nextFocusNode, this.textInputAction, this.autofocus, this.maxLines, this.contentPadding, this.inputFormatters, this.decoration, this.counterText,this.counterStyle, this.maxLengthEnforcement });

  final bool? obscureText;
  final TextEditingController controller;
  final String labelText;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final TextInputType?keyboardType;
  final int ? maxLength;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final TextInputAction?textInputAction;
final bool ?autofocus;
final int?maxLines;
final EdgeInsetsGeometry? contentPadding;
final List<TextInputFormatter>?inputFormatters;
final InputDecoration? decoration;
final String? counterText;
final TextStyle? counterStyle;
final MaxLengthEnforcement? maxLengthEnforcement;
  @override
  State<TextFiledWidget> createState() => _TextFiledWidgetState();




}

class _TextFiledWidgetState extends State<TextFiledWidget> {
  late TextEditingController _controller;



  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: TextFormField(
        inputFormatters:widget.inputFormatters,
        maxLength: widget.maxLength,
        maxLines: widget.maxLines,
        controller: widget.controller,
        keyboardType:widget.keyboardType,
        focusNode: widget.focusNode,
        autofocus: true,
        maxLengthEnforcement: widget.maxLengthEnforcement,
        textInputAction: widget.nextFocusNode != null
            ? TextInputAction.next
            : TextInputAction.done,
          onFieldSubmitted: (_) {
            if (widget.nextFocusNode != null) {
              FocusScope.of(context).requestFocus(widget.nextFocusNode);
            } else {
              widget.focusNode?.unfocus();
            }
          },
        decoration: InputDecoration(

          counterText: widget.counterText ,
          counterStyle: widget.counterStyle,
          contentPadding: widget.contentPadding,

          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelText: widget.labelText,

          suffixIcon: widget.suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        validator: widget.validator,
        obscureText: widget.obscureText ?? false,
      ),
    );
  }
}