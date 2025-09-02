import 'package:gptbanqbusiness/utils/user_data_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constant_string/User.dart';
import '../utils/assets.dart';
import '../utils/custom_style.dart';
import '../utils/input_fields/custom_color.dart';
import '../utils/validator.dart';
import '../widgets/buttons/custom_icon_button_widget.dart';

class CardCountryWidget extends StatefulWidget {
  final TextEditingController controller;
  final String label, hint, selectString;
  final bool? nationality;
  final String? variable;
  final List listitems;

  CardCountryWidget({
    Key? key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.listitems,
    required this.selectString,
    this.nationality,
    this.variable,
  }) : super(key: key);

  @override
  State<CardCountryWidget> createState() => _CardCountryWidgetState();
}

class _CardCountryWidgetState extends State<CardCountryWidget> {
  FocusNode myFocusNode = FocusNode();
  bool bordershoww = false;

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
                    builder: (buildContext, StateSetter setStater) {
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
                            const SizedBox(
                              width: 20,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: widget.listitems.length,
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                onTap: () {
                                  print(
                                      'Selected Country: ${widget.listitems[index].countryName}');
                                  print(
                                      'Selected Country code: ${widget.listitems[index].countryCode}');

                                  UserDataManager().userCountySave(widget
                                      .listitems[index].countryCode
                                      .toString());
                                  Navigator.pop(context);

                                  widget.controller.text =
                                      widget.listitems[index].countryName;

                                  widget.nationality == true
                                      ? User.Country =
                                          widget.listitems[index].countryCode
                                      : User.Reciving_country =
                                          widget.listitems[index].countryCode;
                                  User.Reciving_country =
                                      widget.listitems[index].countryCode;

                                  setState(() {
                                    bordershoww = true;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 20,
                                  ),
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: CustomColor
                                            .primaryInputHintBorderColor,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    widget.listitems[index].countryName,
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
                        )
                      ],
                    ),
                  );
                });
              },
            );
          },
          maxLines: 2,
          minLines: 1,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            return Validator.validateValues(
              value: value,
            );
          },
          onChanged: (v) {
            setState(() {
              v == '' ? bordershoww = false : bordershoww = true;
            });
            print('New Value: $v');
          },
          style: const TextStyle(
            fontFamily: 'pop',
            fontSize: 12,
            height: 2,
            fontWeight: FontWeight.w500,
            color: Color(0xff10245C),
          ),
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
                  color: bordershoww
                      ? CustomColor.primaryColor
                      : CustomColor.primaryInputHintBorderColor,
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
                  // width: 10,
                  // height: 10,
                  colorFilter: ColorFilter.mode(
                    CustomColor.black, // Use API-provided color if available, otherwise use default
                    BlendMode.srcIn,
                  ),
                ),
              )),
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }
}
