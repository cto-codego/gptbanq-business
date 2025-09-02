import 'package:gptbanqbusiness/utils/validator.dart';
import 'package:flutter/material.dart';

class BinificarySelectinput extends StatefulWidget {
  final TextEditingController controller;
  final String label, hint, selectString;

  final List listitems;

  BinificarySelectinput(
      {super.key,
      required this.controller,
      required this.label,
      required this.hint,
      required this.listitems,
      required this.selectString});
  @override
  State<BinificarySelectinput> createState() => _BinificarySelectinputState();
}

class _BinificarySelectinputState extends State<BinificarySelectinput> {
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
    return Container(
      child: Column(
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
          Container(
            child: TextFormField(
              controller: widget.controller,
              focusNode: myFocusNode,
              readOnly: true,
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    isDismissible: true,
                    enableDrag: true,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    barrierColor: Colors.black.withOpacity(0.7),
                    useRootNavigator: true,
                    builder: (context) {
                      return StatefulBuilder(builder: (buildContext,
                          StateSetter setStater /*You can rename this!*/) {
                        return Container(
                            height: MediaQuery.of(context).size.height / 2,
                            padding: EdgeInsets.only(
                                top: 10,
                                right: 10,
                                left: 10,
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            margin: const EdgeInsets.only(
                                right: 10, left: 10, bottom: 0),
                            decoration: const BoxDecoration(
                              color: Color(0xffC4C4C4),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(11),
                                  topRight: Radius.circular(11)),
                            ),
                            child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    child: Container(
                                      width: 130,
                                      color: const Color(0xff10245C),
                                      height: 2,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    child: Text(
                                      widget.selectString,
                                      style: const TextStyle(
                                        color: Color(0xff10245C),
                                        fontFamily: 'pop',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: widget.listitems.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return InkWell(
                                          onTap: () {
                                            Navigator.pop(context);

                                            widget.controller.text =
                                                widget.listitems[index];

                                            bordershoww = true;
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 20),
                                            decoration: const BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                                        color: Colors.white,
                                                        width: 1))),
                                            child: Text(
                                              widget.listitems[index],
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'pop',
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                ]));
                      });
                    });
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
                errorMaxLines: 1,
                focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.red,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(11)),
                errorStyle: const TextStyle(
                    fontFamily: 'pop', fontSize: 12, color: Colors.red),
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
