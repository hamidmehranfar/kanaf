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
  final BuildContext parentContext;
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
    required this.parentContext,
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

    return TextField(
      controller: controller,
      focusNode: focusNode,
      readOnly: widget.readOnly,
      textDirection: widget.textDirection,
      textInputAction: widget.textInputAction,
      obscureText: widget.obscureText,
      obscuringCharacter: '*',
      maxLength: widget.maxLength,
      maxLines: widget.maxLines,
      keyboardType: widget.keyboardType,
      autocorrect: false,
      inputFormatters: widget.inputFormatters,
      style: TextStyle(color: themeColors.onSurface),
      decoration: InputDecoration(
        hintText: widget.hintText,
        errorText: widget.errorText,
        labelText: widget.labelText,
        suffixIcon: widget.suffixIcon,
        enabledBorder: OutlineInputBorder(
          borderRadius: globalBorderRadius * 2,
          borderSide: BorderSide(
            width: 1.0,
            color: themeColors.outlineVariant,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: globalBorderRadius * 1.5,
          borderSide: BorderSide(
            width: 1.0,
            color: themeColors.onSurface.withOpacity(0.12),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: globalBorderRadius * 1.5,
          borderSide: BorderSide(
            width: 1.0,
            color: themeColors.error,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: globalBorderRadius * 1.5,
          borderSide: BorderSide(
            width: 1.0,
            color: themeColors.error,
          ),
        ),
        labelStyle: Theme.of(context).textTheme.bodyLarge!,
      ),
    );
  }
}
