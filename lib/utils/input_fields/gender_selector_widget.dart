import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constant_string/User.dart';
import 'custom_color.dart';

class OptionSelectorWidget extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final List<String> listItems;
  final Color selectedColor; // Color for the selected option
  final Color unselectedColor; // Color for the unselected option

  OptionSelectorWidget({
    super.key,
    required this.controller,
    required this.label,
    required this.listItems,
    Color? selectedColor, // Default primary color
    this.unselectedColor = const Color(0xffF4F6F8), // Default unselected color
  }) : selectedColor = selectedColor ?? CustomColor.primaryColor;

  @override
  State<OptionSelectorWidget> createState() => _OptionSelectorWidgetState();
}

class _OptionSelectorWidgetState extends State<OptionSelectorWidget> {
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    if (widget.listItems.isNotEmpty) {
      selectedValue = widget.listItems.first;
      widget.controller.text = selectedValue!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 15, bottom: 5),
          child: Text(
            widget.label,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: CustomColor.primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Row(
          children: widget.listItems.map((String value) {
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedValue = value;
                    widget.controller.text = selectedValue!;
                  });
                },
                child: Container(
                  alignment: Alignment.center,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  margin: const EdgeInsets.only(right: 5),
                  decoration: BoxDecoration(
                    color: selectedValue == value
                        ? widget.selectedColor
                        : widget.unselectedColor,
                    borderRadius: BorderRadius.circular(8),
                    // Rounded edges for buttons
                    border: Border.all(
                      color: selectedValue == value
                          ? widget.selectedColor
                          : Color(0xffE3E3E3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    value,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: selectedValue == value
                          ? Colors.white
                          : CustomColor.inputFieldTitleTextColor,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
