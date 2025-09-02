import 'package:gptbanqbusiness/Screens/transfer_screen/bloc/transfer_bloc.dart';
import 'package:gptbanqbusiness/cutom_weidget/cutom_progress_bar.dart';
import 'package:gptbanqbusiness/cutom_weidget/text_uploadimages.dart';
import 'package:gptbanqbusiness/utils/input_fields/custom_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../Config/bloc/app_respotary.dart';
import '../../Models/base_model.dart';
import '../../Models/country_info_model.dart';
import '../../widgets/buttons/default_back_button_widget.dart';
import '../../widgets/buttons/primary_button_widget.dart';
import '../../widgets/input_fields/defult_input_field_with_title_widget.dart';
import '../../widgets/toast/toast_util.dart';

class AddBeneficiaryScreen extends StatefulWidget {
  const AddBeneficiaryScreen({super.key});

  @override
  State<AddBeneficiaryScreen> createState() => _AddBeneficiaryScreenState();
}

class _AddBeneficiaryScreenState extends State<AddBeneficiaryScreen> {
  final _formkey = GlobalKey<FormState>();

  bool indvidual = true;

  final TextEditingController _ibnan = TextEditingController();
  final TextEditingController _swift = TextEditingController();

  final TextEditingController _firstname = TextEditingController();

  final TextEditingController _lastname = TextEditingController();
  final TextEditingController _email = TextEditingController(text: '');

  final TextEditingController _image = TextEditingController(text: '');
  final TextEditingController _companyname = TextEditingController(text: '');
  final TextEditingController _nationalityController = TextEditingController();
  final TextEditingController _currencyController = TextEditingController();

  XFile? image;

  final TransferBloc _transferBloc = TransferBloc();

  final ImagePicker picker = ImagePicker();
  AppRespo appRepo = AppRespo();

  List<CountryInfoModel> _countryList = [];

  Future<void> _loadCountries() async {
    await appRepo.GetCountries();

    setState(() {
      _countryList = BaseModel.availableCountriesList;
    });
  }

  @override
  void initState() {
    super.initState();
    // _loadCountries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.whiteColor,
      body: BlocListener(
        bloc: _transferBloc,
        listener: (context, TransferState state) {
          if (state.statusModel?.status == 1) {
            Navigator.pushNamedAndRemoveUntil(
                context, 'beneficiaryListScreen', (route) => false);
          } else if (state.statusModel?.status == 0) {
            CustomToast.showError(
                context, "Sorry!", state.statusModel!.message!);
          }
        },
        child: BlocBuilder(
          bloc: _transferBloc,
          builder: (context, TransferState state) {
            return ProgressHUD(
              inAsyncCall: state.isloading,
              child: SafeArea(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              DefaultBackButtonWidget(onTap: () {
                                Navigator.pushNamedAndRemoveUntil(context,
                                    'beneficiaryListScreen', (route) => false);
                              }),
                              Text(
                                'Add Beneficiary',
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
                        Container(
                          height: 50,
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: CustomColor.selectContainerColor,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      indvidual = true;
                                    });
                                  },
                                  child: Container(
                                    height: 42,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: indvidual
                                          ? CustomColor.whiteColor
                                          : CustomColor.selectContainerColor,
                                    ),
                                    child: Text(
                                      'Individual',
                                      style: GoogleFonts.inter(
                                          color: indvidual
                                              ? CustomColor.black
                                              : CustomColor.black
                                                  .withOpacity(0.6),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      indvidual = false;
                                    });
                                  },
                                  child: Container(
                                    height: 42,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: indvidual
                                          ? CustomColor.selectContainerColor
                                          : CustomColor.whiteColor,
                                    ),
                                    child: Text(
                                      'Business',
                                      style: GoogleFonts.inter(
                                          color: indvidual
                                              ? CustomColor.black
                                                  .withOpacity(0.6)
                                              : CustomColor.black,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Expanded(
                            child: Form(
                                key: _formkey,
                                child: ListView(
                                  shrinkWrap: true,
                                  children: [
                                    // InputSelect(
                                    //   controller: _nationalityController,
                                    //   hint: 'Select Country',
                                    //   label: 'Country',
                                    //   nationality: true,
                                    //   listitems: _countryList,
                                    //   selectString: 'Select Country',
                                    //   onCountrySelected: (value) {},
                                    //   appRepo: appRepo,
                                    // ),
                                    // InputSelect(
                                    //   controller: _currencyController,
                                    //   hint: 'Select Currency',
                                    //   label: 'Currency',
                                    //   nationality: true,
                                    //   listitems: _countryList,
                                    //   selectString: 'Select Currency',
                                    //   onCountrySelected: (value) {},
                                    //   appRepo: appRepo,
                                    // ),
                                    DefaultInputFieldWithTitleWidget(
                                      controller: _ibnan,
                                      title: 'IBAN',
                                      hint: ' BE##x####*********',
                                      isEmail: false,
                                      keyboardType: TextInputType.name,
                                      isPassword: false,
                                    ),
                                    Text(
                                      '27 alphanumeric characters. The first two characters are alphabetic, followed by two numbers and letter',
                                      style: GoogleFonts.inter(
                                          fontSize: 10,
                                          color: CustomColor.errorColor),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    DefaultInputFieldWithTitleWidget(
                                      controller: _swift,
                                      title: 'BIC/SWIFT',
                                      hint: 'XXXXXX*****',
                                      isEmail: false,
                                      keyboardType: TextInputType.name,
                                      isPassword: false,
                                    ),
                                    indvidual == true
                                        ? Column(
                                            children: [
                                              DefaultInputFieldWithTitleWidget(
                                                controller: _firstname,
                                                title: 'First and middle names',
                                                hint: 'First and middle names',
                                                isEmail: false,
                                                keyboardType:
                                                    TextInputType.name,
                                                isPassword: false,
                                              ),
                                              DefaultInputFieldWithTitleWidget(
                                                controller: _lastname,
                                                title: 'Last name(S)',
                                                hint: 'Last name',
                                                isEmail: false,
                                                keyboardType:
                                                    TextInputType.name,
                                                isPassword: false,
                                              ),
                                            ],
                                          )
                                        : DefaultInputFieldWithTitleWidget(
                                            controller: _companyname,
                                            title: 'Company name',
                                            hint: 'Company name',
                                            isEmail: false,
                                            keyboardType: TextInputType.name,
                                            isPassword: false,
                                          ),
                                    DefaultInputFieldWithTitleWidget(
                                      controller: _email,
                                      title: 'Email',
                                      hint: 'Email',
                                      isEmail: false,
                                      keyboardType: TextInputType.emailAddress,
                                      isPassword: false,
                                    ),
                                    Inputuploadimage(
                                      controller: _image,
                                      hint: 'Upload image',
                                      isEmail: false,
                                      ispassword: false,
                                      label: 'Beneficiary image',
                                      ontap: () async {
                                        image = await picker.pickImage(
                                            source: ImageSource.gallery);

                                        if (image != null) {
                                          setState(() {
                                            _image.text = image!.name;
                                          });
                                        } else {
                                          // Optional: Handle the case where no image was selected
                                          print("No image selected");
                                        }
                                      },
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: PrimaryButtonWidget(
                                        onPressed: () {
                                          if (_formkey.currentState!
                                              .validate()) {
                                            _transferBloc.add(
                                                AddExternalbenficaryEvent(
                                                    firstname: _firstname.text,
                                                    lastname: _lastname.text,
                                                    bic: _swift.text,
                                                    companyname:
                                                        _companyname.text,
                                                    email: _email.text,
                                                    iban: _ibnan.text,
                                                    image: image?.path == null
                                                        ? ''
                                                        : image!.path,
                                                    type: indvidual
                                                        ? 'Personal'
                                                        : 'Business'));
                                          }
                                        },
                                        buttonText: 'Continue',
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    )
                                  ],
                                ))),
                      ],
                    ),
                  )),
            );
          },
        ),
      ),
      // bottomNavigationBar: CustomBottomBar(index: 0),
    );
  }
}
