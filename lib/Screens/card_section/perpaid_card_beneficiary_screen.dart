import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:gptbanqbusiness/utils/user_data_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constant_string/User.dart';
import '../../cutom_weidget/cutom_progress_bar.dart';
import '../../cutom_weidget/input_textform.dart';
import '../../utils/assets.dart';
import '../../utils/input_fields/custom_color.dart';
import '../../utils/strings.dart';
import '../../widgets/buttons/default_back_button_widget.dart';
import '../../widgets/buttons/primary_button_widget.dart';
import '../../widgets/custom_image_widget.dart';
import '../../widgets/input_fields/search_input_widget.dart';
import '../../widgets/toast/toast_util.dart';
import '../Dashboard_screen/bloc/dashboard_bloc.dart';
import 'package:gptbanqbusiness/Models/card/card_beneficiary_list_model.dart';

class PrepaidCardBeneficiaryScreen extends StatefulWidget {
  const PrepaidCardBeneficiaryScreen({super.key});

  @override
  State<PrepaidCardBeneficiaryScreen> createState() =>
      _PrepaidCardBeneficiaryScreenState();
}

class _PrepaidCardBeneficiaryScreenState
    extends State<PrepaidCardBeneficiaryScreen> {
  final TextEditingController _searchController = TextEditingController();

  final DashboardBloc _cardBeneficiaryBloc = DashboardBloc();
  List<Datum> _filteredBeneficiaries = [];

  @override
  void initState() {
    super.initState();
    User.Screen = 'virtual card beneficiary';
    _cardBeneficiaryBloc.add(CardDetailsEvent());
    _cardBeneficiaryBloc.add(CardBeneficiaryListEvent());
  }

  void _filterBeneficiaries(String query) {
    if (query.isEmpty) {
      setState(() {
        debugPrint("no data found");
        _filteredBeneficiaries =
            _cardBeneficiaryBloc.state.cardBeneficiaryListModel!.data!;
      });
    } else {
      setState(() {
        _filteredBeneficiaries = _cardBeneficiaryBloc
            .state.cardBeneficiaryListModel!.data!
            .where((beneficiary) =>
                beneficiary.name!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.scaffoldBg,
      body: SafeArea(
          child: BlocListener(
              bloc: _cardBeneficiaryBloc,
              listener: (context, DashboardState state) {
                if (state.statusModel?.status == 0) {
                  CustomToast.showError(
                      context, "Sorry!", state.statusModel!.message!);
                }

                if (state.deleteCardBeneficiaryModel?.status == 1) {
                  CustomToast.showSuccess(context, "Hey!",
                      state.deleteCardBeneficiaryModel!.message!);
                  Navigator.pushNamedAndRemoveUntil(
                      context, 'prepaidCardBeneficiaryScreen', (route) => true);
                }
              },
              child: BlocBuilder(
                bloc: _cardBeneficiaryBloc,
                builder: (context, DashboardState state) {
                  if (_filteredBeneficiaries.isEmpty &&
                      state.cardBeneficiaryListModel != null) {
                    _filteredBeneficiaries =
                        state.cardBeneficiaryListModel!.data!;
                  }
                  return ProgressHUD(
                    inAsyncCall: state.isloading,
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              left: 16, right: 16, top: 20, bottom: 70),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 0, vertical: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      DefaultBackButtonWidget(onTap: () {
                                        Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            'debitCardScreen',
                                            (route) => false);
                                      }),
                                      Text(
                                        "Card Beneficiary",
                                        style: GoogleFonts.inter(
                                            color: CustomColor.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                    ],
                                  )),
                              _filteredBeneficiaries.isNotEmpty
                                  ? SearchInputWidget(
                                      controller: _searchController,
                                      hintText: "Search",
                                      onSearchChanged: (value) {
                                        _filterBeneficiaries(value);
                                      },
                                    )
                                  : SizedBox(),
                              const SizedBox(
                                height: 10,
                              ),
                              Expanded(
                                child: _filteredBeneficiaries.isNotEmpty
                                    ? ListView.builder(
                                        itemCount:
                                            _filteredBeneficiaries.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Slidable(
                                            endActionPane: ActionPane(
                                                motion: const ScrollMotion(),
                                                children: [
                                                  SlidableAction(
                                                    label: 'Delete',
                                                    backgroundColor: Colors.red,
                                                    icon: Icons.delete,
                                                    onPressed: ((context) {
                                                      UserDataManager()
                                                          .cardBeneficiaryIdSave(
                                                              _filteredBeneficiaries[
                                                                      index]
                                                                  .cbeneficaryId!);
                                                      _cardBeneficiaryBloc.add(
                                                          DeleteCardBeneficiaryEvent());
                                                    }),
                                                  ),
                                                ]),
                                            child: InkWell(
                                              onTap: () {
                                                UserDataManager()
                                                    .cardBeneficiaryIdSave(
                                                        _filteredBeneficiaries[
                                                                index]
                                                            .cbeneficaryId!);
                                                showModalBottomSheet(
                                                  context: context,
                                                  isDismissible: true,
                                                  enableDrag: true,
                                                  isScrollControlled: true,
                                                  backgroundColor:
                                                      CustomColor.whiteColor,
                                                  barrierColor: CustomColor
                                                      .black
                                                      .withOpacity(0.2),
                                                  builder: (context) {
                                                    return const SendMoneyBottomSheet();
                                                  },
                                                );
                                              },
                                              child: Container(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 0, vertical: 5),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 12),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Color(0x1F000000),
                                                      offset: Offset(0, 2),
                                                      blurRadius: 8,
                                                      spreadRadius: -4,
                                                    ),
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      width: 44,
                                                      height: 44,
                                                      margin: EdgeInsets.only(
                                                          right: 7),
                                                      alignment:
                                                          Alignment.center,
                                                      child: Image.network(state
                                                          .userCardDetailsModel!
                                                          .userCardDetails!
                                                          .cardImage
                                                          .toString()),
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          _filteredBeneficiaries[
                                                                  index]
                                                              .name!,
                                                          style: GoogleFonts.inter(
                                                              color: CustomColor
                                                                  .black,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                        Text(
                                                          "XXXX XXXX XXXX ${_filteredBeneficiaries[index].card!}",
                                                          style: GoogleFonts.inter(
                                                              color: CustomColor
                                                                  .black
                                                                  .withOpacity(
                                                                      0.4),
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                    : Container(
                                        alignment: Alignment.center,
                                        padding:
                                            EdgeInsets.symmetric(vertical: 20),
                                        child: Column(
                                          children: [
                                            CustomImageWidget(
                                              imagePath:
                                                  StaticAssets.noTransaction,
                                              imageType: 'svg',
                                              height: 130,
                                            ),
                                            Text(
                                              'No Beneficiary',
                                              style: GoogleFonts.inter(
                                                color: CustomColor.black
                                                    .withOpacity(0.6),
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                              )
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          child: InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: CustomColor.whiteColor,
                                barrierColor:
                                    CustomColor.black.withOpacity(0.2),
                                builder: (context) {
                                  return const AddBeneficiaryBottomSheet();
                                },
                              );
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width * 0.85,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16),
                              margin: EdgeInsets.symmetric(vertical: 20),
                              decoration: BoxDecoration(
                                color: CustomColor.primaryColor,
                                borderRadius: BorderRadius.circular(48),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: Icon(
                                      Icons.add,
                                      size: 20,
                                      color: CustomColor.whiteColor,
                                    ),
                                  ),
                                  Text(
                                    Strings.addBeneficiary,
                                    style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        color: CustomColor.whiteColor),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ))),
    );
  }
}

class AddBeneficiaryBottomSheet extends StatefulWidget {
  const AddBeneficiaryBottomSheet({super.key});

  @override
  State<AddBeneficiaryBottomSheet> createState() =>
      _AddBeneficiaryBottomSheetState();
}

class _AddBeneficiaryBottomSheetState extends State<AddBeneficiaryBottomSheet> {
  final DashboardBloc _addCardBeneficiaryBloc = DashboardBloc();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _addCardBeneficiaryBloc,
      listener: (context, DashboardState state) {
        if (state.statusModel?.status == 0) {
          CustomToast.showError(context, "Sorry!", state.statusModel!.message!);
        }

        if (state.statusModel?.status == 1) {
          CustomToast.showSuccess(context, "Hey!", state.statusModel!.message!);
          Navigator.pushNamedAndRemoveUntil(
              context, 'prepaidCardBeneficiaryScreen', (route) => true);
        }
      },
      child: BlocBuilder(
          bloc: _addCardBeneficiaryBloc,
          builder: (context, DashboardState state) {
            return Material(
              color: CustomColor.scaffoldBg,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
              child: ProgressHUD(
                inAsyncCall: state.isloading,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.topLeft,
                                child: InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: CustomImageWidget(
                                      imagePath: StaticAssets.xClose,
                                      imageType: 'svg',
                                      height: 24,
                                    )),
                              ),
                              Container(
                                alignment: Alignment.center,
                                child: Text(
                                  "Add Beneficiary",
                                  style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: CustomColor.black),
                                ),
                              ),
                              Container(
                                width: 30,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          InputTextCustom(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              hint: 'Email Address',
                              label: 'Email Address',
                              autofocus: true,
                              isEmail: true,
                              isPassword: false,
                              onChanged: () {}),
                          InputTextCustom(
                              controller: _cardNumberController,
                              keyboardType: TextInputType.number,
                              hint: 'Card Number',
                              label: 'Card Number (Last 4 Digit)',
                              isEmail: false,
                              isPassword: false,
                              onChanged: () {}),
                          const SizedBox(
                            height: 20,
                          ),
                          PrimaryButtonWidget(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                UserDataManager().addCardBeneficiaryEmailSave(
                                    _emailController.text);
                                UserDataManager().addCardBeneficiaryCardSave(
                                    _cardNumberController.text);

                                _addCardBeneficiaryBloc
                                    .add(AddCardBeneficiaryEvent());
                              }
                            },
                            buttonText: 'Submit',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}

class SendMoneyBottomSheet extends StatefulWidget {
  const SendMoneyBottomSheet({super.key});

  @override
  State<SendMoneyBottomSheet> createState() => _SendMoneyBottomSheetState();
}

class _SendMoneyBottomSheetState extends State<SendMoneyBottomSheet> {
  final DashboardBloc _cardToCardTransferBloc = DashboardBloc();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _cardToCardTransferBloc,
      listener: (context, DashboardState state) {
        if (state.statusModel?.status == 0) {
          CustomToast.showError(context, "Sorry!", state.statusModel!.message!);
        }

        if (state.cardToCardTransferFeeModel?.status == 1) {
          showModalBottomSheet(
            context: context,
            isDismissible: true,
            enableDrag: true,
            isScrollControlled: true,
            backgroundColor: CustomColor.whiteColor,
            barrierColor: CustomColor.black.withOpacity(0.2),
            builder: (context) {
              return const SendMoneyDetailsBottomSheet();
            },
          );
        }
      },
      child: BlocBuilder(
          bloc: _cardToCardTransferBloc,
          builder: (context, DashboardState state) {
            return Material(
              color: CustomColor.scaffoldBg,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.7,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: ProgressHUD(
                  inAsyncCall: state.isloading,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: CustomImageWidget(
                                    imagePath: StaticAssets.xClose,
                                    imageType: 'svg',
                                    height: 24,
                                  )),
                              Container(
                                alignment: Alignment.center,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Load Card",
                                    style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: CustomColor.black),
                                  ),
                                ),
                              ),
                              SizedBox(width: 30)
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          InputTextCustom(
                              controller: _amountController,
                              keyboardType: TextInputType.number,
                              hint: 'Amount',
                              label: 'Amount',
                              autofocus: true,
                              isEmail: false,
                              isPassword: false,
                              onChanged: () {}),
                          const SizedBox(
                            height: 10,
                          ),
                          PrimaryButtonWidget(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                UserDataManager().cardToCardTransferAmountSave(
                                    _amountController.text);

                                _cardToCardTransferBloc
                                    .add(CardToCardTransferFeesEvent());
                              }
                            },
                            buttonText: 'Pay',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}

class SendMoneyDetailsBottomSheet extends StatefulWidget {
  const SendMoneyDetailsBottomSheet({super.key});

  @override
  State<SendMoneyDetailsBottomSheet> createState() =>
      _SendMoneyDetailsBottomSheetState();
}

class _SendMoneyDetailsBottomSheetState
    extends State<SendMoneyDetailsBottomSheet> {
  final DashboardBloc _cardToCardTransferFeeBloc = DashboardBloc();

  @override
  void initState() {
    super.initState();
    _cardToCardTransferFeeBloc.add(CardToCardTransferFeesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _cardToCardTransferFeeBloc,
      listener: (context, DashboardState state) {
        if (state.statusModel?.status == 0) {
          CustomToast.showError(context, "Sorry!", state.statusModel!.message!);
        }

        if (state.statusModel?.status == 1) {
          CustomToast.showSuccess(context, "Hey!", state.statusModel!.message!);
          Navigator.pushNamedAndRemoveUntil(
              context, 'debitCardScreen', (route) => false);
        }
      },
      child: BlocBuilder(
          bloc: _cardToCardTransferFeeBloc,
          builder: (context, DashboardState state) {
            String currency =
                state.cardToCardTransferFeeModel!.currecny.toString();
            // String amount =
            //     state.cardToCardTransferFeeModel!.loadCardFee.toString();
            String fee =
                state.cardToCardTransferFeeModel!.loadCardFee.toString();
            String totalPay =
                state.cardToCardTransferFeeModel!.totalPay.toString();

            return Material(
              color: Colors.white,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.6,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                width: MediaQuery.of(context).size.width,
                child: ProgressHUD(
                  inAsyncCall: state.isloading,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              alignment: Alignment.topLeft,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: CustomImageWidget(
                                  imagePath: StaticAssets.xClose,
                                  imageType: 'svg',
                                  height: 24,
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "Card To Card Fee",
                                  style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: CustomColor.black),
                                ),
                              ),
                            ),
                            Container(
                              width: 30,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              color: CustomColor.hubContainerBgColor,
                              borderRadius: BorderRadius.circular(16)),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Fee',
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.inter(
                                      color: CustomColor.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    "$currency $fee",
                                    textAlign: TextAlign.right,
                                    style: GoogleFonts.inter(
                                      color: CustomColor.black.withOpacity(0.7),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Total Pay',
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.inter(
                                      color: CustomColor.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    "$currency $totalPay",
                                    style: GoogleFonts.inter(
                                      color: CustomColor.black.withOpacity(0.7),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        PrimaryButtonWidget(
                          onPressed: () {
                            _cardToCardTransferFeeBloc
                                .add(CardToCardTransferConfirmEvent());
                          },
                          buttonText: 'Confirm',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
