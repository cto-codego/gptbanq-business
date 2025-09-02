import 'dart:async';

import 'package:gptbanqbusiness/Screens/Dashboard_screen/bloc/dashboard_bloc.dart';
import 'package:gptbanqbusiness/constant_string/User.dart';
import 'package:gptbanqbusiness/cutom_weidget/cutom_progress_bar.dart';
import 'package:gptbanqbusiness/utils/input_fields/custom_color.dart';
import 'package:gptbanqbusiness/utils/user_data_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../utils/assets.dart';
import '../../utils/custom_date_picker.dart';
import '../../widgets/buttons/default_back_button_widget.dart';
import '../../widgets/custom_image_widget.dart';
import '../../widgets/main/swift_transaction_details_widget.dart';
import '../../widgets/main/transaction_card_widget.dart';
import '../../widgets/main/transaction_details_widget.dart';
import '../../widgets/toast/toast_util.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  final _formkey = GlobalKey<FormState>();
  bool _successToastShown = false; // Flag to track success toast

  DateTime? _fromDate;
  DateTime? _toDate;
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    DateTime initialDate = DateTime.now();
    if (isFromDate && _fromDate != null) {
      initialDate = _fromDate!;
    } else if (!isFromDate && _toDate != null) {
      initialDate = _toDate!;
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isFromDate) {
          _fromDate = picked;
          _fromDateController.text = _dateFormat.format(picked);
        } else {
          _toDate = picked;
          _toDateController.text = _dateFormat.format(picked);
        }
      });
    }
  }

  void _export() {
    if (_fromDate != null && _toDate != null) {
      final String fromDate = _dateFormat.format(_fromDate!);
      final String toDate = _dateFormat.format(_toDate!);
      // Add your export logic here
      print('Exporting data from $fromDate to $toDate');
    } else {
      // Handle empty fields
      print('Please select both dates.');
    }
  }

  void _onDateSelected(DateTime date) {
    // Add your logic when a date is selected, if needed
    print('Selected date: $date');
  }

  final TextEditingController _fromDateController = TextEditingController();
  final TextEditingController _toDateController = TextEditingController();

  String trx_uniquid = '';

  final DashboardBloc _dashboardBloc = DashboardBloc();

  @override
  void initState() {
    super.initState();
    User.Screen = 'Transaction Screen';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.whiteColor,
      body: BlocListener(
          bloc: _dashboardBloc,
          listener: (context, DashboardState state) async {
            if (state.transactionListModel?.status == 0) {
              CustomToast.showError(
                  context, "Sorry!", state.transactionListModel!.message!);
            } else if (state.transactionListModel?.status == 1 &&
                !_successToastShown) {
              CustomToast.showSuccess(
                  context, "Thank You!", state.transactionListModel!.message!);
              _successToastShown = true;
            }

            if (state.transactiondetailsmodel?.status == 1) {
              if (state.transactiondetailsmodel?.trxdata!.paymentMode ==
                  "sepa") {
                showModalBottomSheet(
                    context: context,
                    isDismissible: true,
                    enableDrag: true,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    barrierColor: Colors.black.withOpacity(0.7),
                    useRootNavigator: true,
                    builder: (context) {
                      var data = state.transactiondetailsmodel!.trxdata!;
                      return TransactionDetailsWidget(
                        trxDataMode: data.mode!,
                        amount: data.amount!,
                        beneficiaryName: data.beneficiaryName!,
                        transactionDate: data.transactionDate!,
                        fee: data.fee!,
                        accountHolder: data.accountHolder!,
                        afterBalance: data.afterBalance!,
                        beneficiaryCurrency: data.beneficiaryCurrency!,
                        beforeBalance: data.beforeBalance!,
                        currency: data.currency!,
                        label: data.label!,
                        receiverBic: data.receiverBic!,
                        receiverIban: data.receiverIban!,
                        reference: data.reference!,
                        status: data.status!,
                        transactionId: data.transactionId!,
                        paymentMode: data.paymentMode!,
                        transactionType: data.mode!,
                        onTap: () {
                          _dashboardBloc
                              .add(DawnloadEvent(uniqueId: trx_uniquid));

                          Navigator.pop(context);
                        },
                      );
                    });
              } else {
                showModalBottomSheet(
                    context: context,
                    isDismissible: true,
                    enableDrag: true,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    barrierColor: Colors.black.withOpacity(0.7),
                    useRootNavigator: true,
                    builder: (context) {
                      var data = state.transactiondetailsmodel!.trxdata!;
                      return SwiftTransactionDetailsWidget(
                        recipientGets: data.receiptGet!,
                        convertAmount: data.convertAmount!,
                        note: data.note ?? "",
                        trxMode: data.trxMode!,
                        trxDataMode: data.mode!,
                        amount: data.amount!,
                        beneficiaryName: data.beneficiaryName!,
                        transactionDate: data.transactionDate!,
                        fee: data.fees!,
                        accountHolder: data.accountHolder!,
                        afterBalance: data.afterBalance!,
                        beneficiaryCurrency: data.beneficiaryCurrency!,
                        beforeBalance: data.beforeBalance!,
                        currency: data.currency!,
                        label: data.label!,
                        receiverBic: data.receiverBic!,
                        receiverIban: data.receiverIban!,
                        reference: data.reference!,
                        status: data.status!,
                        exchangeAmount: data.exchangeAmount!,
                        exchangeRate: data.exchangeRate!,
                        yourTotal: data.totalPay!,
                        exchangeFee: data.exchangeFee!,
                        internationFee: data.internationFee!,
                        transactionId: data.transactionId!,
                        transactionType: data.mode!,
                        paymentMode: data.paymentMode!,
                        receiverAccountHolder: data.beneficiaryName!,
                        onTap: () {
                          _dashboardBloc
                              .add(DawnloadEvent(uniqueId: trx_uniquid));

                          Navigator.pop(context);
                        },
                      );
                    });
              }
            }
          },
          child: BlocBuilder(
              bloc: _dashboardBloc,
              builder: (context, DashboardState state) {
                return SafeArea(
                  child: ProgressHUD(
                    inAsyncCall: state.isloading,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          appBarSection(context, state),
                          SizedBox(
                            height: 150,
                            child: Form(
                              key: _formkey,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: CustomDatePicker(
                                          controller: _fromDateController,
                                          label: 'From',
                                          hint: 'YYYY-MM-DD',
                                          onDateSelected: (date) {
                                            setState(() {
                                              _fromDate = date;
                                              _fromDateController.text =
                                                  _dateFormat.format(date);
                                            });
                                            _onDateSelected(date);
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: CustomDatePicker(
                                          controller: _toDateController,
                                          label: 'To',
                                          hint: 'YYYY-MM-DD',
                                          onDateSelected: (date) {
                                            setState(() {
                                              _toDate = date;
                                              _toDateController.text =
                                                  _dateFormat.format(date);
                                            });
                                            _onDateSelected(date);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          height: 48,
                                          margin:
                                              const EdgeInsets.only(top: 20),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              if (_formkey.currentState!
                                                  .validate()) {
                                                if (_fromDate != null &&
                                                    _toDate != null) {
                                                  final String fromDate =
                                                      _dateFormat
                                                          .format(_fromDate!);
                                                  final String toDate =
                                                      _dateFormat
                                                          .format(_toDate!);

                                                  UserDataManager()
                                                      .setFromDateSave(
                                                          fromDate);
                                                  UserDataManager()
                                                      .setToDateSave(toDate);

                                                  _dashboardBloc.add(
                                                      DownloadTransactionStatementEvent());

                                                  // Add your search logic here
                                                  print(
                                                      'Searching from $fromDate to $toDate');
                                                } else {
                                                  // Handle empty fields
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                          'Please select both dates.'),
                                                    ),
                                                  );
                                                }
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              foregroundColor:
                                                  CustomColor.primaryColor,
                                              backgroundColor:
                                                  CustomColor.primaryColor,
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(48),
                                              ),
                                            ),
                                            child: Text(
                                              'Send Statement To Email',
                                              style: GoogleFonts.inter(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: CustomColor.whiteColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 10),
                            child: Text(
                              "Transactions",
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: CustomColor.black,
                              ),
                            ),
                          ),
                          if (state.transactionListModel!.transaction!.past!
                                  .isEmpty &&
                              state.transactionListModel!.transaction!
                                  .yesterday!.isEmpty &&
                              state.transactionListModel!.transaction!.today!
                                  .isEmpty)
                            Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Column(
                                children: [
                                  CustomImageWidget(
                                    imagePath: StaticAssets.noTransaction,
                                    imageType: 'svg',
                                    height: 130,
                                  ),
                                  Text(
                                    "No Transaction",
                                    style: GoogleFonts.inter(
                                      color: CustomColor.black.withOpacity(0.6),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else
                            // Expanded(
                            //   child: Column(
                            //     // shrinkWrap: true,
                            //     // physics:
                            //     //     NeverScrollableScrollPhysics(),
                            //     // padding:
                            //     //     const EdgeInsets.all(0),
                            //     children: [
                            //       //today list
                            //       if (state.transactionListModel!.transaction!
                            //           .today!.isNotEmpty)
                            //         ListView.builder(
                            //           itemCount: state.transactionListModel!
                            //               .transaction!.today!.length,
                            //           shrinkWrap: true,
                            //           physics: NeverScrollableScrollPhysics(),
                            //           itemBuilder:
                            //               (BuildContext context, int index) {
                            //             var today = state.transactionListModel!
                            //                 .transaction!.today![index];
                            //             return TransactionCardWidget(
                            //               uniqueId: today.uniqueId!,
                            //               image: today.image,
                            //               beneficiaryName: today.beneficiaryName!,
                            //               reasonPayment: today.reasonPayment!,
                            //               created: today.created!,
                            //               amount: today.amount!,
                            //               status: today.status!,
                            //               type: today.type!,
                            //               onTap: () {
                            //                 trx_uniquid = today.uniqueId!;
                            //                 _dashboardBloc.add(
                            //                     transactiondetailsEvent(
                            //                         uniqueId: trx_uniquid));
                            //               },
                            //             );
                            //           },
                            //         )
                            //       else
                            //         Container(),
                            //
                            //       //yesterday list
                            //       if (state.transactionListModel!.transaction!
                            //           .yesterday!.isNotEmpty)
                            //         ListView.builder(
                            //           itemCount: state.transactionListModel!
                            //               .transaction!.yesterday!.length,
                            //           shrinkWrap: true,
                            //           physics:
                            //               const NeverScrollableScrollPhysics(),
                            //           itemBuilder:
                            //               (BuildContext context, int index) {
                            //             var yesterdayList = state
                            //                 .transactionListModel!
                            //                 .transaction!
                            //                 .yesterday![index];
                            //             return TransactionCardWidget(
                            //               uniqueId: yesterdayList.uniqueId!,
                            //               image: yesterdayList.image,
                            //               beneficiaryName:
                            //                   yesterdayList.beneficiaryName!,
                            //               reasonPayment:
                            //                   yesterdayList.reasonPayment!,
                            //               created: yesterdayList.created!,
                            //               amount: yesterdayList.amount!,
                            //               status: yesterdayList.status!,
                            //               type: yesterdayList.type!,
                            //               onTap: () {
                            //                 trx_uniquid = yesterdayList.uniqueId!;
                            //                 _dashboardBloc.add(
                            //                     transactiondetailsEvent(
                            //                         uniqueId: trx_uniquid));
                            //               },
                            //             );
                            //           },
                            //         )
                            //       else
                            //         Container(),
                            //       Expanded(
                            //         child: ListView.builder(
                            //           itemCount: state.transactionListModel!
                            //               .transaction!.past!.length,
                            //           shrinkWrap: true,
                            //           physics: const NeverScrollableScrollPhysics(),
                            //           itemBuilder:
                            //               (BuildContext context, int index) {
                            //             var pastList = state.transactionListModel!
                            //                 .transaction!.past![index];
                            //             return TransactionCardWidget(
                            //               uniqueId: pastList.uniqueId!,
                            //               image: pastList.image,
                            //               beneficiaryName:
                            //                   pastList.beneficiaryName!,
                            //               reasonPayment: pastList.reasonPayment!,
                            //               created: pastList.created!,
                            //               amount: pastList.amount!,
                            //               status: pastList.status!,
                            //               type: pastList.type!,
                            //               onTap: () {
                            //                 trx_uniquid = pastList.uniqueId!;
                            //                 _dashboardBloc.add(
                            //                     transactiondetailsEvent(
                            //                         uniqueId: trx_uniquid));
                            //               },
                            //             );
                            //           },
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            Expanded(
                              child: ListView(
                                children: [
                                  // Today's List
                                  if (state.transactionListModel!.transaction!
                                      .today!.isNotEmpty)
                                    ...state.transactionListModel!.transaction!
                                        .today!
                                        .map((today) {
                                      return TransactionCardWidget(
                                        uniqueId: today.uniqueId!,
                                        image: today.image,
                                        beneficiaryName: today.beneficiaryName!,
                                        reasonPayment: today.reasonPayment!,
                                        created: today.created!,
                                        amount:
                                            "${today.amount!} ${today.currency!.toUpperCase()}",
                                        status: today.status!,
                                        type: today.type!,
                                        onTap: () {
                                          trx_uniquid = today.uniqueId!;
                                          _dashboardBloc.add(
                                              transactiondetailsEvent(
                                                  uniqueId: trx_uniquid));
                                        },
                                      );
                                    }).toList(),

                                  // Yesterday's List
                                  if (state.transactionListModel!.transaction!
                                      .yesterday!.isNotEmpty)
                                    ...state.transactionListModel!.transaction!
                                        .yesterday!
                                        .map((yesterday) {
                                      return TransactionCardWidget(
                                        uniqueId: yesterday.uniqueId!,
                                        image: yesterday.image,
                                        beneficiaryName:
                                            yesterday.beneficiaryName!,
                                        reasonPayment: yesterday.reasonPayment!,
                                        created: yesterday.created!,
                                        amount:
                                            "${yesterday.amount!} ${yesterday.currency!.toUpperCase()}",
                                        status: yesterday.status!,
                                        type: yesterday.type!,
                                        onTap: () {
                                          trx_uniquid = yesterday.uniqueId!;
                                          _dashboardBloc.add(
                                              transactiondetailsEvent(
                                                  uniqueId: trx_uniquid));
                                        },
                                      );
                                    }).toList(),

                                  // Past List
                                  ...state
                                      .transactionListModel!.transaction!.past!
                                      .map((past) {
                                    return TransactionCardWidget(
                                      uniqueId: past.uniqueId!,
                                      image: past.image,
                                      beneficiaryName: past.beneficiaryName!,
                                      reasonPayment: past.reasonPayment!,
                                      created: past.created!,
                                      amount:
                                          "${past.amount!} ${past.currency!.toUpperCase()}",
                                      status: past.status!,
                                      type: past.type!,
                                      onTap: () {
                                        trx_uniquid = past.uniqueId!;
                                        _dashboardBloc.add(
                                            transactiondetailsEvent(
                                                uniqueId: trx_uniquid));
                                      },
                                    );
                                  }).toList(),
                                ],
                              ),
                            )
                        ],
                      ),
                    ),
                  ),
                );
              })),
      // bottomNavigationBar: CustomBottomBar(index: 0),
    );
  }

  appBarSection(BuildContext context, state) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DefaultBackButtonWidget(
            onTap: () {
              Navigator.pop(context);
            },
          ),
          Text(
            'Export PDF',
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
    );
  }
}
