import 'package:gptbanqbusiness/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Models/sourceoffund.dart';
import '../utils/assets.dart';
import '../utils/custom_style.dart';
import '../utils/input_fields/custom_color.dart';
import '../widgets/buttons/custom_icon_button_widget.dart';

class InputSelectFunds extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final String selectString;
  final List<String> listItems;
  final String? variable;

  const InputSelectFunds({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.listItems,
    required this.selectString,
    this.variable,
  });

  @override
  State<InputSelectFunds> createState() => _InputSelectFundsState();
}

class _InputSelectFundsState extends State<InputSelectFunds> {
  FocusNode myFocusNode = FocusNode();
  bool showBorder = false;

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
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 5),
          child: Text(
            widget.label,
            style: GoogleFonts.inter(
              color: myFocusNode.hasFocus
                  ? CustomColor.primaryColor
                  : CustomColor.inputFieldTitleTextColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        TextFormField(
          controller: widget.controller,
          focusNode: myFocusNode,
          readOnly: true,
          onTap: () {
            showModalBottomSheet(
              context: context,
              isDismissible: true,
              enableDrag: true,
              isScrollControlled: true,
              backgroundColor: CustomColor.whiteColor,
              barrierColor: Colors.black.withOpacity(0.2),
              useRootNavigator: true,
              builder: (context) {
                return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.7,
                      padding: EdgeInsets.only(
                        top: 20,
                        right: 16,
                        left: 16,
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomIconButtonWidget(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                svgAssetPath: StaticAssets.xClose,
                              ),
                              Text(
                                widget.selectString,
                                style: GoogleFonts.inter(
                                  color: CustomColor.primaryColor,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                             SizedBox(width: 25,)
                            ],
                          ),
                          const SizedBox(height: 20),
                          Expanded(
                            child: ListView.builder(
                              itemCount: widget.listItems.length,
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                    widget.controller.text = widget.listItems[index];
                                    showBorder = true;
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 20,
                                    ),
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: CustomColor.primaryInputHintBorderColor,
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      widget.listItems[index],
                                      style: GoogleFonts.inter(
                                        color: CustomColor.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
          maxLines: 2,
          minLines: 1,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) => Validator.validateValues(value: value),
          onChanged: (v) {
            setState(() {
              showBorder = v.isNotEmpty;
            });
          },
          style: CustomStyle.loginInputTextStyle,
          decoration: InputDecoration(
              errorStyle: TextStyle(color: CustomColor.errorColor),
              contentPadding: const EdgeInsets.all(16),
              hintText: widget.hint,
              hintStyle: CustomStyle.loginInputTextHintStyle,
              filled: true,
              fillColor: myFocusNode.hasFocus
                  ? CustomColor.whiteColor
                  : CustomColor.primaryInputHintColor,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: showBorder ? CustomColor.primaryColor : CustomColor.primaryInputHintBorderColor,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(11),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: CustomColor.errorColor,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(11),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: CustomColor.errorColor,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(11),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:  BorderSide(
                  color: CustomColor.primaryColor,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(11),
              ),
              border: OutlineInputBorder(
                borderSide:  BorderSide(
                  color: CustomColor.primaryColor,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(11),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide:  BorderSide(
                  color: CustomColor.primaryColor,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(11),
              ),
              enabled: true,
              suffixIcon: Padding(
                padding: const EdgeInsets.all(15.0),
                child: SvgPicture.asset(
                  StaticAssets.chevronDown,
                  colorFilter: ColorFilter.mode(
                    CustomColor.black,
                    BlendMode.srcIn,
                  ),
                ),
              )),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
