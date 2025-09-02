import 'package:gptbanqbusiness/Screens/Dashboard_screen/bloc/dashboard_bloc.dart';
import 'package:gptbanqbusiness/cutom_weidget/cutom_progress_bar.dart';
import 'package:gptbanqbusiness/utils/input_fields/custom_color.dart';
import 'package:gptbanqbusiness/utils/user_data_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Models/dashboard/iban_currency_model.dart';
import '../../Models/dashboard/create_iban_list_model.dart';
import '../../constant_string/User.dart';
import '../../cutom_weidget/input_textform.dart';
import '../../utils/custom_style.dart';
import '../../utils/strings.dart';
import '../../widgets/buttons/default_back_button_widget.dart';
import '../../widgets/buttons/primary_button_widget.dart';
import '../../widgets/main/currency_selector_widget.dart';
import '../../widgets/main/iban_selector_widget.dart';
import '../../widgets/toast/toast_util.dart';

class CreateIbanScreen extends StatefulWidget {
  const CreateIbanScreen({super.key});

  @override
  State<CreateIbanScreen> createState() => _CreateIbanScreenState();
}

class _CreateIbanScreenState extends State<CreateIbanScreen> {
  final TextEditingController _currencyController = TextEditingController();
  final TextEditingController _ibanController = TextEditingController();
  final TextEditingController _ibanLabel = TextEditingController();

  String? selectedCurrency;
  String? selectedIban;
  bool showIbanLabel = false;

  List<Currency> currencies = [];
  List<IbanListData> iBans = [];
  bool allowIbanLabel = false;

  final DashboardBloc _dashboardBloc = DashboardBloc();
  final _formKey = GlobalKey<FormState>();
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    User.Screen = 'Create Iban Screen';
    _dashboardBloc.add(GetIbanCurrencyEvent());

    // Add listeners to check form validity
    _currencyController.addListener(_checkFormValidity);
    // _ibanController.addListener(_checkFormValidity);
    _ibanLabel.addListener(_checkFormValidity);
  }

  void _checkFormValidity() {
    setState(() {
      isButtonEnabled =
          _currencyController.text.isNotEmpty && _ibanLabel.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.scaffoldBg,
      body: BlocListener(
        bloc: _dashboardBloc,
        listener: (context, DashboardState state) async {
          if (state.ibanKycCheckModel?.status == 0) {
            CustomToast.showError(
                context, "Sorry!", state.ibanKycCheckModel!.message!);
          }
          if (state.statusModel?.status == 0) {
            CustomToast.showError(
                context, "Sorry!", state.statusModel!.message!);
          }

          if (state.statusModel?.status == 1) {
            CustomToast.showSuccess(
                context, "Hey!", state.statusModel!.message!);
            Navigator.pushNamedAndRemoveUntil(
                context, 'dashboard', (route) => false);
          }

          if (state.ibanKycCheckModel?.status == 1) {
            allowIbanLabel = true;
          }

          if (state.ibanKycCheckModel?.status == 2) {
            UserDataManager().userSumSubTokenSave(
                state.ibanKycCheckModel!.sumsubtoken.toString());
            UserDataManager()
                .statusMessageSave(state.ibanKycCheckModel!.message.toString());

            Navigator.pushNamedAndRemoveUntil(
                context, 'ibanKycScreen', (route) => true);
          }

          if (state.ibanCurrencyModel?.status == 1) {
            currencies = state.ibanCurrencyModel?.currency ?? [];
          }

          if (state.createIbanListModel?.status == 1) {
            iBans = state.createIbanListModel?.iban ?? [];
          }
        },
        child: BlocBuilder(
          bloc: _dashboardBloc,
          builder: (context, DashboardState state) {
            return SafeArea(
              child: ProgressHUD(
                inAsyncCall: state.isloading,
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        appBarSection(context, state),
                        Expanded(
                          child: ListView(
                            children: [
                              Text(
                                User.isWallet == 0
                                    ? 'Create Virtual IBAN'
                                    : 'Create Virtual Account',
                                style: CustomStyle.loginTitleStyle,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Text(
                                    User.isWallet == 0
                                        ? "Easily generate virtual IBANs for seamless international transactions."
                                        : "Easily generate virtual Accounts for seamless international transactions.",
                                    style: CustomStyle.loginSubTitleStyle),
                              ),
                              CurrencySelector(
                                controller: _currencyController,
                                label: "Select Currency",
                                hint: 'Select Currency',
                                currencies: currencies,
                                onChanged: (value) {
                                  if (state.ibanCurrencyModel!.iswallet == 0 &&
                                      _currencyController.text.isNotEmpty) {
                                    iBans.clear();
                                    _ibanController.clear();
                                    _dashboardBloc.add(
                                        getMultipleIbanEvent(currency: value!));
                                    showIbanLabel = true;
                                  } else {
                                    setState(() {
                                      showIbanLabel = true;
                                      isButtonEnabled = true;
                                    });
                                  }
                                },
                              ),
                              if (state.ibanCurrencyModel!.iswallet == 0 &&
                                  iBans.isNotEmpty)
                                IbanSelector(
                                  ibanController: _ibanController,
                                  label: User.isWallet == 0
                                      ? 'Select IBAN'
                                      : 'Select Account',
                                  hint: User.isWallet == 0
                                      ? 'Select IBAN'
                                      : 'Select Account',
                                  ibans: iBans,
                                ),
                              if (showIbanLabel)
                                InputTextCustom(
                                  controller: _ibanLabel,
                                  hint: 'Write label',
                                  label: 'Label',
                                  isEmail: false,
                                  isPassword: false,
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10), // Space before buttons
                        PrimaryButtonWidget(
                          onPressed: isButtonEnabled
                              ? () {
                            _dashboardBloc.add(CreateibanEvent(
                                Label: _ibanLabel.text,
                                currency: _currencyController.text,
                                isWallet:
                                state.ibanCurrencyModel!.iswallet,
                                iban: _ibanController.text));
                          }
                              : null,
                          buttonText: 'Confirm',
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      // bottomNavigationBar: CustomBottomBar(index: 0),
    );
  }

  appBarSection(BuildContext context, state) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DefaultBackButtonWidget(onTap: () {
            Navigator.pushNamedAndRemoveUntil(
                context, 'dashboard', (route) => false);
          }),
          Text(
            User.isWallet == 0 ? 'Create IBAN' : 'Create Account',
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
