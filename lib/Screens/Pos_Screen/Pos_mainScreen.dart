import 'package:gptbanqbusiness/Models/terminal_trx_model.dart';
import 'package:gptbanqbusiness/Screens/Pos_Screen/Pos_Screen.dart';
import 'package:gptbanqbusiness/Screens/Pos_Screen/bloc/pos_bloc.dart';
import 'package:gptbanqbusiness/cutom_weidget/custom_navigationBar.dart';
import 'package:gptbanqbusiness/utils/validator.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';

import '../../utils/input_fields/custom_color.dart';
import '../../widgets/buttons/custom_floating_action_button.dart';
import '../../widgets/buttons/primary_button_widget.dart';

class PosMainScreen extends StatefulWidget {
  const PosMainScreen({super.key});

  @override
  State<PosMainScreen> createState() => _PosMainScreenState();
}

class _PosMainScreenState extends State<PosMainScreen> {
  SingleValueDropDownController _terminalcontrol =
      new SingleValueDropDownController();
  TextEditingController _dob = TextEditingController();

  SingleValueDropDownController _date = new SingleValueDropDownController();
  PosBloc _posBloc = new PosBloc();
  String terminalid = '';
  String formattedDate = 'Custom Date';

  bool bordershoww = false;
  final _scrollController = ScrollController();

  List<Trx> alltrx = [];

  int? nextpage, previouspage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _posBloc.add(GetterminalEvent());
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (nextpage != previouspage) {
          _posBloc.add(GettransactionsEvent(
              date: formattedDate, page: nextpage, trid: terminalid));
        }
        print('a7a');
      }
    });
    _posBloc.add(
        GettransactionsEvent(date: formattedDate, page: 1, trid: terminalid));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _posBloc,
      listener: (contextPosState, PosState state) {
        if (state.trxmodel!.trx!.isNotEmpty) {
          alltrx.addAll(state.trxmodel!.trx!);

          nextpage = int.parse(state.trxmodel!.nextpage.toString());
          previouspage = int.parse(state.trxmodel!.previouspage.toString());

          print(alltrx.length);
        } else if (state.trxmodel!.trx == []) {
          alltrx.addAll(state.trxmodel!.trx!);
        }
      },
      child: BlocBuilder(
        bloc: _posBloc,
        builder: (context, PosState state) {
          return Scaffold(
              backgroundColor: CustomColor.scaffoldBg,
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              body: SafeArea(
                child: Container(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Amount Today',
                              style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: CustomColor.black),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'POS Dashobard',
                                  style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: CustomColor.black),
                                ),
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '€',
                                        style: GoogleFonts.inter(
                                          color: CustomColor.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        state.trxmodel!.totalAmount!,
                                        style: GoogleFonts.inter(
                                          color: CustomColor.black,
                                          fontSize: 40,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      PrimaryButtonWidget(
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.scale,
                              alignment: Alignment.center,
                              isIos: true,
                              duration: Duration(milliseconds: 200),
                              child:
                                  PosScreen(date: formattedDate, tid: terminalid),
                            ),
                          );
                        },
                        buttonText: 'Status Payment',
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: DropDownTextField(
                              controller: _terminalcontrol,
                              clearOption: false,
                              validator: (value) {
                                return Validator.validateValues(
                                  value: value,
                                );
                              },
                              readOnly: true,
                              textFieldDecoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                hintText: 'Select Terminal',
                                hintStyle: GoogleFonts.inter(
                                    fontSize: 14,
                                    height: 2,
                                    fontWeight: FontWeight.w500,
                                    color: CustomColor.black.withOpacity(0.5)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: CustomColor.black,
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
                                    borderSide: BorderSide(
                                      color: CustomColor.primaryColor,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(11)),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: CustomColor.primaryColor,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(11)),
                                disabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: CustomColor.primaryColor,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(11)),
                                enabled: true,
                              ),
                              textStyle: GoogleFonts.inter(
                                  fontSize: 14,
                                  height: 2,
                                  fontWeight: FontWeight.w500,
                                  color: CustomColor.black),
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

                                if (formattedDate != '') {
                                  _posBloc.add(GettransactionsEvent(
                                      date: formattedDate,
                                      page: 1,
                                      trid: terminalid));
                                }

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
                            controller: _date,
                            clearOption: false,
                            validator: (value) {
                              return Validator.validateValues(
                                value: value,
                              );
                            },
                            readOnly: true,
                            textFieldDecoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              hintText: 'dd/mm/yyyy',
                              hintStyle: GoogleFonts.inter(
                                  fontSize: 14,
                                  height: 2,
                                  fontWeight: FontWeight.w500,
                                  color: CustomColor.black.withOpacity(0.5)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: CustomColor.primaryColor,
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
                                  borderSide: BorderSide(
                                    color: CustomColor.primaryColor,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(11)),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: CustomColor.primaryColor,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(11)),
                              disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: CustomColor.primaryColor,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(11)),
                              enabled: true,
                            ),
                            textStyle: GoogleFonts.inter(
                                fontSize: 14,
                                height: 2,
                                fontWeight: FontWeight.w500,
                                color: CustomColor.black),
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            dropDownItemCount: 6,
                            dropDownList: [
                              DropDownValueModel(name: 'Today', value: 'today'),
                              DropDownValueModel(
                                  name: 'Yesterday', value: 'yesterday'),
                              DropDownValueModel(
                                  name: 'This Week', value: 'this_week'),
                              DropDownValueModel(
                                  name: 'This Month', value: 'this_month'),
                              DropDownValueModel(
                                  name: 'Last Month', value: 'last_month'),
                              DropDownValueModel(
                                  name: 'Custom Date', value: 'Custom'),
                            ],
                            onChanged: (val) async {
                              print(val.value);
                              setState(() {});
                              alltrx.clear();

                              print(alltrx.length);

                              if (val.value == 'Custom') {
                                DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1920),
                                    initialEntryMode:
                                        DatePickerEntryMode.calendarOnly,

                                    //DateTime.now() - not to allow to choose before today.
                                    lastDate: DateTime.now());

                                if (pickedDate != null) {
                                  print(
                                      pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                  //formatted date output using intl package =>  2021-03-16
                                  setState(() {
                                    formattedDate = DateFormat('dd-MM-yyyy')
                                        .format(pickedDate);
                                  });

                                  print(formattedDate);

                                  _posBloc.add(GettransactionsEvent(
                                      date: formattedDate,
                                      page: 1,
                                      trid: terminalid));
                                } else {}
                              } else {
                                formattedDate = val.value;

                                _posBloc.add(GettransactionsEvent(
                                    date: formattedDate,
                                    page: 1,
                                    trid: terminalid));
                              }

                              setState(() {
                                val == null
                                    ? bordershoww = false
                                    : bordershoww = true;
                              });
                            },
                          ))
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text('Transaction History',
                            textAlign: TextAlign.left,
                            style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: CustomColor.black)),
                      ),
                      Expanded(
                        child: alltrx.length > 0
                            ? ListView.builder(
                                controller: _scrollController,
                                padding: EdgeInsets.symmetric(vertical: 10),
                                itemCount: alltrx.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                          context: context,
                                          isDismissible: true,
                                          enableDrag: true,
                                          isScrollControlled: true,
                                          backgroundColor: CustomColor.whiteColor,
                                          barrierColor:
                                              Colors.black.withOpacity(0.7),
                                          useRootNavigator: true,
                                          builder: (context) {
                                            return Container(
                                                padding: EdgeInsets.only(
                                                    top: 10,
                                                    bottom: 25,
                                                    left: 16,
                                                    right: 16),
                                                margin: EdgeInsets.only(
                                                    right: 0, left: 0, bottom: 0),
                                                decoration: BoxDecoration(
                                                  // color: CustomColor.whiteColor,
                                                  borderRadius: BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(11),
                                                      topRight:
                                                          Radius.circular(11)),
                                                ),
                                                child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      ListView(
                                                        shrinkWrap: true,
                                                        scrollDirection:
                                                            Axis.vertical,
                                                        children: [
                                                          SizedBox(
                                                            height: 20,
                                                          ),
                                                          Container(
                                                            width: 100,
                                                            alignment:
                                                                Alignment.center,
                                                            child: Image.asset(
                                                              alltrx[index]
                                                                          .cardBrand!
                                                                          .toLowerCase() ==
                                                                      'mastercard'
                                                                  ? 'images/Mastercard.png'
                                                                  : alltrx[index]
                                                                              .cardBrand!
                                                                              .toLowerCase() ==
                                                                          'visa'
                                                                      ? 'images/visa.png'
                                                                      : 'images/credit.png',
                                                              width: 100,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 20,
                                                          ),
                                                          Container(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  'Legal Name',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style:
                                                                      GoogleFonts
                                                                          .inter(
                                                                    color: Color(
                                                                        0xff10245C),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize: 14,
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child: Text(
                                                                    alltrx[index]
                                                                        .leagalName!,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .end,
                                                                    style:
                                                                        GoogleFonts
                                                                            .inter(
                                                                      color: Color(
                                                                              0xff10245C)
                                                                          .withOpacity(
                                                                              0.8),
                                                                      fontSize:
                                                                          14,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(height: 20),
                                                          Container(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  'Auth code',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style:
                                                                      GoogleFonts
                                                                          .inter(
                                                                    color: Color(
                                                                        0xff10245C),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize: 14,
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child: Text(
                                                                    alltrx[index]
                                                                        .authcode!,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .end,
                                                                    style:
                                                                        GoogleFonts
                                                                            .inter(
                                                                      color: Color(
                                                                              0xff10245C)
                                                                          .withOpacity(
                                                                              0.8),
                                                                      fontSize:
                                                                          14,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(height: 20),
                                                          Container(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  'Amount',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style:
                                                                      GoogleFonts
                                                                          .inter(
                                                                    color: Color(
                                                                        0xff10245C),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize: 14,
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child: Text(
                                                                    '€${alltrx[index].rawAmount!}',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .end,
                                                                    style:
                                                                        GoogleFonts
                                                                            .inter(
                                                                      color: Color(
                                                                              0xff10245C)
                                                                          .withOpacity(
                                                                              0.8),
                                                                      fontSize:
                                                                          14,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(height: 20),
                                                          Container(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  'Commission',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style:
                                                                      GoogleFonts
                                                                          .inter(
                                                                    color: Color(
                                                                        0xff10245C),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize: 14,
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child: Text(
                                                                    '€${alltrx[index].commission!}',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .end,
                                                                    style:
                                                                        GoogleFonts
                                                                            .inter(
                                                                      color: Color(
                                                                              0xff10245C)
                                                                          .withOpacity(
                                                                              0.8),
                                                                      fontSize:
                                                                          14,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(height: 20),
                                                          Container(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  'Non Stand',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style:
                                                                      GoogleFonts
                                                                          .inter(
                                                                    color: Color(
                                                                        0xff10245C),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize: 14,
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child: Text(
                                                                    '€${alltrx[index].nscc!}',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .end,
                                                                    style:
                                                                        GoogleFonts
                                                                            .inter(
                                                                      color: Color(
                                                                              0xff10245C)
                                                                          .withOpacity(
                                                                              0.8),
                                                                      fontSize:
                                                                          14,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(height: 20),
                                                          Container(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  'Card',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style:
                                                                      GoogleFonts
                                                                          .inter(
                                                                    color: Color(
                                                                        0xff10245C),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize: 14,
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child: Text(
                                                                    alltrx[index]
                                                                        .card!,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .end,
                                                                    style:
                                                                        GoogleFonts
                                                                            .inter(
                                                                      color: Color(
                                                                              0xff10245C)
                                                                          .withOpacity(
                                                                              0.8),
                                                                      fontSize:
                                                                          14,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(height: 20),
                                                          Container(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  'Status',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style:
                                                                      GoogleFonts
                                                                          .inter(
                                                                    color: Color(
                                                                        0xff10245C),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize: 14,
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child: Text(
                                                                    alltrx[index]
                                                                        .status!,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .end,
                                                                    style:
                                                                        GoogleFonts
                                                                            .inter(
                                                                      color: Color(
                                                                              0xff10245C)
                                                                          .withOpacity(
                                                                              0.8),
                                                                      fontSize:
                                                                          14,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(height: 20),
                                                          Container(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  'Transaction date',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style:
                                                                      GoogleFonts
                                                                          .inter(
                                                                    color: Color(
                                                                        0xff10245C),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize: 14,
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child: Text(
                                                                    alltrx[index]
                                                                        .transactionDate!,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .end,
                                                                    style:
                                                                        GoogleFonts
                                                                            .inter(
                                                                      color: Color(
                                                                              0xff10245C)
                                                                          .withOpacity(
                                                                              0.8),
                                                                      fontSize:
                                                                          14,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(height: 20),
                                                          Container(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  'Paid date',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style:
                                                                      GoogleFonts
                                                                          .inter(
                                                                    color: Color(
                                                                        0xff10245C),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize: 14,
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child: Text(
                                                                    alltrx[index]
                                                                        .paidDate!,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .end,
                                                                    style:
                                                                        GoogleFonts
                                                                            .inter(
                                                                      color: Color(
                                                                              0xff10245C)
                                                                          .withOpacity(
                                                                              0.8),
                                                                      fontSize:
                                                                          14,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(height: 20),
                                                        ],
                                                      )
                                                    ]));
                                          });
                                    },
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 45,
                                            alignment: Alignment.center,
                                            child: Image.asset(alltrx[index]
                                                        .cardBrand!
                                                        .toLowerCase() ==
                                                    'mastercard'
                                                ? 'images/Mastercard.png'
                                                : alltrx[index]
                                                            .cardBrand!
                                                            .toLowerCase() ==
                                                        'visa'
                                                    ? 'images/visa.png'
                                                    : 'images/credit.png'),
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  alltrx[index].leagalName!,
                                                  style: GoogleFonts.inter(
                                                    fontSize: 10,
                                                    color: Color(0xff26273C),
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 3,
                                                ),
                                                Text(
                                                  alltrx[index].card!,
                                                  style: GoogleFonts.inter(
                                                    fontSize: 14,
                                                    color: Color(0xff26273C),
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 3,
                                                ),
                                                Text(
                                                  'AUTH CODE :${alltrx[index].authcode!} (${alltrx[index].serviceMsg!})',
                                                  style: GoogleFonts.inter(
                                                    fontSize: 10,
                                                    color: Color(0xff26273C),
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                '${alltrx[index].symbol}${alltrx[index].rawAmount.toString()}',
                                                style: GoogleFonts.inter(
                                                  fontSize: 14,
                                                  color: Color(0xff26273C),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Text(
                                                '${alltrx[index].transactionDate} ${alltrx[index].transactionTime}',
                                                style: GoogleFonts.inter(
                                                  fontSize: 10,
                                                  color: Color(0xff26273C),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Center(
                                child: Text(
                                    terminalid == '' || formattedDate == ''
                                        ? 'Select date and Terminal device first'
                                        : 'No Transactions'),
                              ),
                      )
                    ],
                  ),
                ),
              ),
              floatingActionButton: CustomFloatingActionButton());
        },
      ),
    );
  }
}
