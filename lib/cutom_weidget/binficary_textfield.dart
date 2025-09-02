import 'package:gptbanqbusiness/utils/validator.dart';
import 'package:flutter/material.dart';

class Binificarytextinput extends StatefulWidget {
  final TextEditingController controller;
  final String label, hint;

  bool? isconirmpassword = false;

  String? password = '';

  bool isEmail, ispassword;

  bool? ishide = false;

  Binificarytextinput(
      {super.key,
      required this.controller,
      required this.label,
      required this.hint,
      required this.isEmail,
      required this.ispassword,
      this.isconirmpassword,
      this.ishide,
      this.password});

  @override
  State<Binificarytextinput> createState() => _BinificarytextinputState();
}

class _BinificarytextinputState extends State<Binificarytextinput> {
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
    // ignore: avoid_unnecessary_containers
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: TextStyle(
              fontSize: 10,
              fontFamily: 'pop',
              color: myFocusNode.hasFocus || bordershoww
                  ? const Color(0xff10245C)
                  : const Color(0xffC4C4C4),
              fontWeight: FontWeight.w500,
            ),
          ),
          // ignore: avoid_unnecessary_containers
          Container(
            child: TextFormField(
              controller: widget.controller,
              focusNode: myFocusNode,
              obscureText: widget.ishide ?? false,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: widget.isEmail
                  ? null
                  : (value) {
                      return Validator.validateValues(
                          value: value,
                          isEmail: widget.isEmail,
                          isChangePassword: widget.ispassword,
                          isConfirmPassword: widget.isconirmpassword ?? false,
                          password: widget.password ?? '');
                    },
              onChanged: (v) {
                setState(() {
                  v == '' ? bordershoww = false : bordershoww = true;
                });
              },
              style: const TextStyle(
                  fontFamily: 'pop',
                  fontSize: 12,
                  height: 2,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff10245C)),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                hintText: widget.hint,
                hintStyle: const TextStyle(
                    fontFamily: 'pop',
                    fontSize: 12,
                    height: 2,
                    fontWeight: FontWeight.w500,
                    color: Color(0xffC4C4C4)),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: bordershoww
                          ? const Color(0xff10245C)
                          : const Color(0xffC4C4C4),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(11)),
                errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.red,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(11)),
                errorMaxLines: 2,
                focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.red,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(11)),
                errorStyle: const TextStyle(
                    fontFamily: 'pop', fontSize: 10, color: Colors.red),
                focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xff10245C),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(11)),
                border: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xff10245C),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(11)),
                disabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xff10245C),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(11)),
                enabled: true,
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }
}
