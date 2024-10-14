import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kanaf/global_configs.dart';

class CustomTextField extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final TextInputType keyboardType;
  final TextDirection? textDirection;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final int? maxLength;
  final int? maxLines;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final bool enabled;
  final bool readOnly;
  final Widget? suffixIcon;
  final BoxConstraints? suffixIconConstraints;
  final String initialValue;
  final TextEditingController? controller;
  final FloatingLabelBehavior? floatingLabelBehavior;
  final List<TextInputFormatter>? inputFormatters;
  final String? errorText;

  const CustomTextField({
    this.labelText,
    this.hintText,
    this.keyboardType = TextInputType.text,
    this.textDirection,
    this.textInputAction,
    this.obscureText = false,
    this.maxLength,
    this.maxLines = 1,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.enabled = true,
    this.readOnly = false,
    this.suffixIcon,
    this.suffixIconConstraints,
    this.initialValue = '',
    this.controller,
    this.floatingLabelBehavior,
    this.inputFormatters,
    this.errorText,
    super.key,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    focusNode.addListener((){
      setState(() {});
    });
    if (widget.controller == null) {
      controller = TextEditingController(text: widget.initialValue);
    } else {
      controller = widget.controller!;
    }
    super.initState();
  }

  @override
  void dispose(){
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var themeColors = Theme.of(context).colorScheme;

    return SizedBox(
      height: 50,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        readOnly: widget.readOnly,
        textDirection: widget.textDirection,
        textInputAction: widget.textInputAction,
        obscureText: widget.obscureText,
        obscuringCharacter: '*',
        maxLength: widget.maxLength,
        maxLines: widget.maxLines,
        enabled: widget.enabled,
        keyboardType: widget.keyboardType,
        autocorrect: false,
        inputFormatters: widget.inputFormatters,
        decoration: InputDecoration(
          hintText: widget.hintText,
          errorText: widget.errorText,
          labelText: widget.labelText,
          suffixIcon: widget.suffixIcon,
          focusedBorder: OutlineInputBorder(
            borderRadius: globalBorderRadius,
            borderSide: BorderSide(
              color: themeColors.primary,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: globalBorderRadius,
            borderSide: BorderSide(
              color: themeColors.onPrimary,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: globalBorderRadius,
            borderSide: BorderSide(
              color: themeColors.onSurface.withOpacity(0.5),
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: globalBorderRadius,
            borderSide: BorderSide(
              color: themeColors.error,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: globalBorderRadius,
            borderSide: BorderSide(
              color: themeColors.primary,
            ),
          ),
          labelStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: !widget.enabled ? themeColors.onSurface.withOpacity(0.4) :
                focusNode.hasFocus ? themeColors.primary : themeColors.onPrimary.withOpacity(0.5),
          ),
        ),
      ),
    );
  }
}
