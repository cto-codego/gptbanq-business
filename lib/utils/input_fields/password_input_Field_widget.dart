import 'package:flutter/material.dart';

class PasswordInputFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool readOnly;
  final Function() onChange;
  final String? Function(String?)? validator; // Allows passing custom validator

  const PasswordInputFieldWidget({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.readOnly = false,
    required this.onChange,
    this.validator, // Custom validator passed when creating this widget
  });

  @override
  State<PasswordInputFieldWidget> createState() => _PasswordInputFieldWidgetState();
}

class _PasswordInputFieldWidgetState extends State<PasswordInputFieldWidget> {
  FocusNode myFocusNode = FocusNode();
  bool bordershoww = false;
  bool isHidden = true;

  @override
  void initState() {
    super.initState();
    myFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontSize: 12,
            fontFamily: 'pop',
            color: myFocusNode.hasFocus || bordershoww
                ? const Color(0xff10245C)
                : const Color(0xffC4C4C4),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
          controller: widget.controller,
          focusNode: myFocusNode,
          obscureText: isHidden,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: widget.validator ?? _defaultPasswordValidator, // Use passed validator if available
          onChanged: (v) {
            setState(() {
              bordershoww = v.isNotEmpty;
            });
            widget.onChange();
          },
          readOnly: widget.readOnly,
          style: const TextStyle(
            fontFamily: 'pop',
            fontSize: 12,
            height: 2,
            fontWeight: FontWeight.w500,
            color: Color(0xff10245C),
          ),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(20),
            hintText: widget.hint,
            hintStyle: const TextStyle(
              fontFamily: 'pop',
              fontSize: 12,
              height: 2,
              fontWeight: FontWeight.w500,
              color: Color(0xffC4C4C4),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                isHidden ? Icons.visibility_off : Icons.visibility,
                color: const Color(0xffC4C4C4),
              ),
              onPressed: () {
                setState(() {
                  isHidden = !isHidden;
                });
              },
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: bordershoww
                    ? const Color(0xff10245C)
                    : const Color(0xffC4C4C4),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(11),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.red,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(11),
            ),
            errorMaxLines: 2,
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.red,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(11),
            ),
            errorStyle: const TextStyle(
              fontFamily: 'pop',
              fontSize: 10,
              color: Colors.red,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color(0xff10245C),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(11),
            ),
            border: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color(0xff10245C),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(11),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color(0xff10245C),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(11),
            ),
            enabled: true,
          ),
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }

  String? _defaultPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least 1 uppercase letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least 1 digit';
    }
    if (!RegExp(r'[!@#\$&*~]').hasMatch(value)) {
      return 'Password must contain at least 1 special character';
    }
    return null;
  }
}
