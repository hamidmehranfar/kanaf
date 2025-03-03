import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/global_configs.dart';

class CustomTextField extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final TextInputType keyboardType;
  final TextDirection? textDirection;
  final TextInputAction? textInputAction;
  final TextAlign textAlign;
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
  final EdgeInsets? scrollPadding;

  const CustomTextField({
    this.labelText,
    this.hintText,
    this.keyboardType = TextInputType.text,
    this.textDirection,
    this.textInputAction,
    this.textAlign = TextAlign.start,
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
    this.scrollPadding,
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
    focusNode.addListener(() {
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
  void dispose() {
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
        textAlign: widget.textAlign,
        textDirection: widget.textDirection,
        textInputAction: widget.textInputAction,
        obscureText: widget.obscureText,
        obscuringCharacter: '*',
        maxLength: widget.maxLength,
        maxLines: widget.maxLines,
        keyboardType: widget.keyboardType,
        autocorrect: false,
        scrollPadding: widget.scrollPadding ?? const EdgeInsets.all(20),
        inputFormatters: widget.inputFormatters,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          hintText: widget.hintText,
          labelText: widget.labelText,
          errorText: widget.errorText,
          suffixIcon: widget.suffixIcon,
          fillColor: themeColors.tertiary.withValues(alpha: 0.21),
          filled: true,
          focusedBorder: OutlineInputBorder(
            borderRadius: globalBorderRadius * 3,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: globalBorderRadius * 3,
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: globalBorderRadius * 3,
            borderSide: BorderSide(
              color: themeColors.inverseSurface.withValues(alpha: 0.7),
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: globalBorderRadius * 3,
            borderSide: BorderSide(
              color: themeColors.error,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: globalBorderRadius * 3,
          ),
          hintStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: themeColors.onSecondary.withValues(alpha: 0.5),
              ),
          labelStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: !widget.enabled
                    ? themeColors.inverseSurface.withValues(alpha: 0.7)
                    : focusNode.hasFocus
                        ? themeColors.primary
                        : themeColors.onSurface,
              ),
        ),
      ),
    );
  }
}
