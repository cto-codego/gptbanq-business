import 'package:gptbanqbusiness/Models/trx_model.dart';
import 'package:gptbanqbusiness/Screens/Pos_Screen/bloc/pos_bloc.dart';
import 'package:gptbanqbusiness/utils/input_fields/custom_color.dart';
import 'package:gptbanqbusiness/utils/validator.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/buttons/default_back_button_widget.dart';


class PosScreen extends StatefulWidget {
  String? date;
  String? tid;
  PosScreen({super.key, this.date, this.tid});

  @override
  State<PosScreen> createState() => _PosScreenState();
}

class _PosScreenState extends State<PosScreen> {
  SingleValueDropDownController _terminalcontrol =
      new SingleValueDropDownController();

  SingleValueDropDownController _statuscontrol =
      new SingleValueDropDownController();
  TextEditingController _dob = TextEditingController();

  PosBloc _posBloc = new PosBloc();
  String terminalid = '';
  String status = '';

  String formattedDate = '';
  final _scrollController = ScrollController();

  List<Trx> alltrx = [];

  int? nextpage, previouspage;

  bool bordershoww = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _posBloc.add(GetterminalEvent());

    _posBloc.add(GettrxlogEvent(date: widget.date, page: 1, trid: widget.tid));

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (nextpage != previouspage) {
          _posBloc.add(GettrxlogEvent(
              date: widget.date, page: nextpage, trid: widget.tid));
        }
        print('a7a');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _posBloc,
      listener: (context, PosState state) {
        if (state.trxlogmodel!.trx!.isNotEmpty) {
          alltrx.addAll(state.trxlogmodel!.trx!);

          nextpage = int.parse(state.trxlogmodel!.nextpage.toString());
          previouspage =
              int.parse(state.trxlogmodel!.previouspage.toString());

          print(alltrx.length);
        }
      },
      child: BlocBuilder(
        bloc: _posBloc,
        builder: (context, PosState state) {
          return Scaffold(
            backgroundColor: CustomColor.scaffoldBg,
            body: SafeArea(
              child: Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                      const EdgeInsets.only(bottom: 30, top: 10),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          DefaultBackButtonWidget(onTap: () {
                            Navigator.pop(context);
                          }),
                          Text(
                            'POS Payment Page',
                            style: GoogleFonts.inter(
                                color: CustomColor.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                          Container(
                            width: 20,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                              Text(
                                'Total Transacted',
                                style: GoogleFonts.inter(
                                    color: CustomColor.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.start,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '€',
                                      style: GoogleFonts.inter(
                                          color: CustomColor.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                       ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        state.trxlogmodel!.totalTransacted!,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.start,
                                        style: GoogleFonts.inter(
                                            color: CustomColor.black,
                                            fontSize: 30,
                                            fontWeight: FontWeight.w600,
                                     ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ])),
                        Expanded(
                            child: Container(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Total Commission',
                                  style: GoogleFonts.inter(
                                      color: CustomColor.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                 ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          state.trxlogmodel!
                                              .totalCommission!,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.end,
                                          style: GoogleFonts.inter(
                                              color: CustomColor.black,
                                              fontSize: 30,
                                              fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ]),
                        ))
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Container(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Total Credit',
                                  style: GoogleFonts.inter(
                                      color: CustomColor.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '€',
                                        style: GoogleFonts.inter(
                                            color: CustomColor.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          state.trxlogmodel!.totalCredit!,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.start,
                                          style: GoogleFonts.inter(
                                              color: CustomColor.black,
                                              fontSize: 30,
                                              fontWeight: FontWeight.w600,
                                            ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ]),
                        )),
                        Expanded(
                            child: Container(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Total Pending',
                                  style: GoogleFonts.inter(
                                      color: CustomColor.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          state.trxlogmodel!.totalPending
                                              .toString(),
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.end,
                                          style: GoogleFonts.inter(
                                              color: Color(0xffDD8E18),
                                              fontSize: 30,
                                              fontWeight: FontWeight.w600,
                                           ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ]),
                        ))
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: DropDownTextField(
                            controller: _terminalcontrol,
                            listTextStyle: TextStyle(
                                fontFamily: 'pop',
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff10245C)),
                            clearOption: false,
                            validator: (value) {
                              return Validator.validateValues(
                                value: value,
                              );
                            },
                            readOnly: true,
                            textFieldDecoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20),
                              hintText: 'Select Terminal',
                              hintStyle: const TextStyle(
                                  fontFamily: 'pop',
                                  fontSize: 14,
                                  height: 2,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xffC8C5C5)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: bordershoww
                                        ? Color(0xff10245C)
                                        : Color(0xffC4C4C4),
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
                                  fontFamily: 'pop',
                                  fontSize: 10,
                                  color: Colors.red),
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
                            textStyle: TextStyle(
                                fontFamily: 'pop',
                                fontSize: 14,
                                height: 2,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff10245C)),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            dropDownItemCount:
                                state.terminalDevicesmodel!.termial!.length,
                            dropDownList: [
                              for (int i = 0;
                                  i <
                                      state.terminalDevicesmodel!.termial!
                                          .length;
                                  i++)
                                DropDownValueModel(
                                    name: state.terminalDevicesmodel!
                                        .termial![i].leagalName!,
                                    value: state.terminalDevicesmodel!
                                        .termial![i].tid!),
                            ],
                            onChanged: (val) {
                              print(val.value);

                              terminalid = val.value.toString();
                              alltrx.clear();

                              _posBloc.add(GettrxlogEvent(
                                  date: '',
                                  page: 1,
                                  trid: terminalid,
                                  status: status));

                              setState(() {
                                val == null
                                    ? bordershoww = false
                                    : bordershoww = true;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: DropDownTextField(
                            controller: _statuscontrol,
                            clearOption: false,
                            validator: (value) {
                              return Validator.validateValues(
                                value: value,
                              );
                            },
                            readOnly: true,
                            textFieldDecoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20),
                              hintText: 'Status',
                              hintStyle: const TextStyle(
                                  fontFamily: 'pop',
                                  fontSize: 14,
                                  height: 2,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xffC8C5C5)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: bordershoww
                                        ? Color(0xff10245C)
                                        : Color(0xffC4C4C4),
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
                                  fontFamily: 'pop',
                                  fontSize: 10,
                                  color: Colors.red),
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
                            textStyle: TextStyle(
                                fontFamily: 'pop',
                                fontSize: 14,
                                height: 2,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff10245C)),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            dropDownItemCount: 3,
                            dropDownList: [
                              DropDownValueModel(
                                  name: 'Completed', value: 'completed'),
                              DropDownValueModel(
                                  name: 'Partial', value: 'partial'),
                              DropDownValueModel(
                                  name: 'pending', value: 'pending'),
                            ],
                            onChanged: (val) {
                              print(val.value);

                              alltrx.clear();

                              status = val.value.toString();

                              _posBloc.add(GettrxlogEvent(
                                  date: '',
                                  page: 1,
                                  trid: terminalid,
                                  status: status));

                              setState(() {
                                val == null
                                    ? bordershoww = false
                                    : bordershoww = true;
                              });
                            },
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        controller: _scrollController,
                        children: [
                          Table(
                            defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,
                            border: TableBorder(
                              horizontalInside: BorderSide(
                                  color: Color(0xffC7C7C7), width: 0.5),
                            ),
                            children: [
                              TableRow(children: [
                                Text(
                                  'TRX Date / Terminal Date Payments',
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.inter(
                                      color: CustomColor.black,

                                      fontSize: 8,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  'TRX Amount Commission',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                      color: CustomColor.black,
                                      fontSize: 8,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  'Credited',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                      color: CustomColor.black,
                                      fontSize: 8,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  'Hold Amount',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                      color: CustomColor.black,
                                      fontSize: 8,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  'Status',
                                  textAlign: TextAlign.end,
                                  style: GoogleFonts.inter(
                                      color: CustomColor.black,
                                      fontSize: 8,
                                      fontWeight: FontWeight.w500),
                                ),
                              ]),
                              for (var i in alltrx)
                                TableRow(children: [
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        i.trxDate!,
                                        style: GoogleFonts.inter(
                                            color: CustomColor.black,
                                            fontSize: 8,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        i.leagalName!,
                                        style: GoogleFonts.inter(
                                            color: CustomColor.black,
                                            fontSize: 8,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        i.datePayment!,
                                        style: GoogleFonts.inter(
                                            color: CustomColor.black,
                                            fontSize: 8,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "€" + i.amount!,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.inter(
                                            color: CustomColor.black,
                                            fontSize: 8,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "€" + i.commision!,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.inter(
                                            color: CustomColor.black,
                                            fontSize: 8,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "€" + i.creditAmount!,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.inter(
                                        color: CustomColor.black,
                                        fontSize: 8,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    "€" + i.holdAmount!,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.inter(
                                        color: CustomColor.black,
                                        fontSize: 8,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Container(
                                    alignment: Alignment.centerRight,
                                    child: Container(
                                      width: 20,
                                      height: 20,
                                      alignment: Alignment.centerRight,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          color: i.status == 'completed'
                                              ? Color(0xff1D802C)
                                              : i.status == 'pending'
                                                  ? Color(0xffD9D9D9)
                                                  : Color(0xffDD8E18)),
                                    ),
                                  ),
                                ])
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
