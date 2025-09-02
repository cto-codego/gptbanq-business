import 'package:gptbanqbusiness/utils/assets.dart';
import 'package:gptbanqbusiness/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'input_fields/custom_color.dart';

class CustomDatePicker extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final Function(DateTime) onDateSelected;
  final bool readOnly;

  const CustomDatePicker({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.onDateSelected,
    this.readOnly = false,
  });

  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  FocusNode myFocusNode = FocusNode();
  bool bordershoww = false;
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    myFocusNode.addListener(() {
      setState(() {});
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate = DateTime.now();
    if (widget.controller.text.isNotEmpty) {
      initialDate = _dateFormat.parse(widget.controller.text);
    }
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        widget.controller.text = _dateFormat.format(picked);
        widget.onDateSelected(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: myFocusNode.hasFocus || bordershoww
                  ? CustomColor.primaryColor
                  : CustomColor.primaryTextHintColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          GestureDetector(
            onTap: () {
              if (!widget.readOnly) {
                _selectDate(context);
              }
            },
            child: AbsorbPointer(
              child: TextFormField(
                controller: widget.controller,
                focusNode: myFocusNode,
                readOnly: true,

                style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: CustomColor.primaryColor),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: CustomColor.primaryInputHintColor,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 16,
                  ),
                  hintText: widget.hint,
                  hintStyle: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: CustomColor.primaryTextHintColor
                  ),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
                    child: CustomImageWidget(
                      imagePath: StaticAssets.calendar,
                      imageType: 'svg',
                      height: 12,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: bordershoww
                          ? CustomColor.primaryColor
                          : CustomColor.dashboardProfileBorderColor,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:  BorderSide(
                      color: CustomColor.primaryColor,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }
}
