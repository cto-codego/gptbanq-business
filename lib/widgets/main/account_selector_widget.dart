// import 'package:dropdown_textfield/dropdown_textfield.dart';
// import 'package:flutter/material.dart';
//
// import '../../utils/validator.dart';
//
// class CustomIbanDropdown extends StatefulWidget {
//   final SingleValueDropDownController controller;
//   final ValueSetter<dynamic>? onChanged;
//   final List<DropDownValueModel> dropDownList;
//
//   const CustomIbanDropdown({
//     Key? key,
//     required this.controller,
//     required this.onChanged,
//     required this.dropDownList,
//   }) : super(key: key);
//
//   @override
//   State<CustomIbanDropdown> createState() => _CustomIbanDropdownState();
// }
//
// class _CustomIbanDropdownState extends State<CustomIbanDropdown> {
//   @override
//   Widget build(BuildContext context) {
//
//     bool bordershoww = false;
//
//     return DropDownTextField(
//       controller: widget.controller,
//       clearOption: false,
//       validator: (value) {
//         return Validator.validateValues(value: value);
//       },
//       readOnly: true,
//       textFieldDecoration: InputDecoration(
//         contentPadding: const EdgeInsets.symmetric(horizontal: 20),
//         hintText: 'Select Iban',
//         hintStyle: const TextStyle(
//           fontFamily: 'pop',
//           fontSize: 12,
//           height: 2,
//           fontWeight: FontWeight.w500,
//           color: Color(0xffC4C4C4),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderSide: BorderSide(
//             color: bordershoww ? const Color(0xff10245C) : const Color(0xffC4C4C4),
//             width: 1,
//           ),
//           borderRadius: BorderRadius.circular(11),
//         ),
//         errorBorder: OutlineInputBorder(
//           borderSide: const BorderSide(
//             color: Colors.red,
//             width: 1,
//           ),
//           borderRadius: BorderRadius.circular(11),
//         ),
//         errorMaxLines: 2,
//         focusedErrorBorder: OutlineInputBorder(
//           borderSide: const BorderSide(
//             color: Colors.red,
//             width: 1,
//           ),
//           borderRadius: BorderRadius.circular(11),
//         ),
//         errorStyle: const TextStyle(
//           fontFamily: 'pop',
//           fontSize: 10,
//           color: Colors.red,
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderSide: const BorderSide(
//             color: Color(0xff10245C),
//             width: 1,
//           ),
//           borderRadius: BorderRadius.circular(11),
//         ),
//         border: OutlineInputBorder(
//           borderSide: const BorderSide(
//             color: Color(0xff10245C),
//             width: 1,
//           ),
//           borderRadius: BorderRadius.circular(11),
//         ),
//         disabledBorder: OutlineInputBorder(
//           borderSide: const BorderSide(
//             color: Color(0xff10245C),
//             width: 1,
//           ),
//           borderRadius: BorderRadius.circular(11),
//         ),
//         enabled: true,
//       ),
//       textStyle: const TextStyle(
//         fontFamily: 'pop',
//         fontSize: 12,
//         height: 2,
//         fontWeight: FontWeight.w500,
//         color: Color(0xff10245C),
//       ),
//       autovalidateMode: AutovalidateMode.onUserInteraction,
//       dropDownItemCount: widget.dropDownList.length,
//       dropDownList: widget.dropDownList,
//       onChanged: (val) {
//         print(val.value);
//
//
//         setState(() {
//           val == null
//               ? bordershoww = false
//               : bordershoww = true;
//         });
//       },
//     );
//   }
// }
