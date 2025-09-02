import 'package:gptbanqbusiness/Screens/transfer_screen/send_money.dart';
import 'package:gptbanqbusiness/Screens/transfer_screen/bloc/transfer_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Models/binficary_model.dart';
import '../../constant_string/User.dart';
import '../../utils/assets.dart';
import '../../utils/input_fields/custom_color.dart';
import '../../utils/strings.dart';
import '../../widgets/buttons/default_back_button_widget.dart';
import '../../widgets/custom_image_widget.dart';
import '../../widgets/input_fields/search_input_widget.dart';
import '../../widgets/toast/toast_util.dart';
import 'beneficiary_user_details_screen.dart';

class BeneficiaryListScreen extends StatefulWidget {
  const BeneficiaryListScreen({super.key});

  @override
  State<BeneficiaryListScreen> createState() => _BeneficiaryListScreenState();
}

class _BeneficiaryListScreenState extends State<BeneficiaryListScreen> {
  final TransferBloc _transferBloc = TransferBloc();
  TextEditingController _searchController = TextEditingController();
  List<Datum> _filteredBeneficiaries = []; // Store filtered beneficiaries

  @override
  void initState() {
    super.initState();
    User.Screen = 'beneficiary';
    _transferBloc.add(binficarylistEvent(ibanId: User.ibanId));
  }

  void _filterBeneficiaries(String query) {
    if (query.isEmpty) {
      // Show the original list when search input is empty
      setState(() {
        debugPrint("no data found");
        _filteredBeneficiaries = _transferBloc.state.binficaryModel!.data!;
      });
    } else {
      // Filter beneficiaries based on the search query
      setState(() {
        _filteredBeneficiaries = _transferBloc.state.binficaryModel!.data!
            .where((beneficiary) =>
            beneficiary.name!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.whiteColor,
      resizeToAvoidBottomInset: false, // Prevent the scaffold from resizing
      body: SafeArea(
          child: BlocListener(
              bloc: _transferBloc,
              listener: (context, TransferState state) {
                if (state.statusModel?.status == 1) {
                  _transferBloc.add(binficarylistEvent(ibanId: User.ibanId));
                } else if (state.statusModel?.status == 0) {
                  CustomToast.showError(
                      context, "Sorry!", state.statusModel!.message!);
                }
              },
              child: BlocBuilder<TransferBloc, TransferState>(
                bloc: _transferBloc,
                builder: (context, TransferState state) {
                  // Initialize the filtered beneficiaries if the state is loaded
                  if (_filteredBeneficiaries.isEmpty &&
                      state.binficaryModel != null) {
                    _filteredBeneficiaries = state.binficaryModel!.data!;
                    // print(state.binficaryModel?.isPaymentPurposeCodes);
                  }

                  return Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            left: 16, right: 16, top: 20, bottom: 70),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            appBarSection(context, state),
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
                            _filteredBeneficiaries.isNotEmpty
                                ? Expanded(
                              child: ListView.builder(
                                itemCount: _filteredBeneficiaries.length,
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
                                              _transferBloc.add(
                                                  DeleteBeneficiaryEvent(
                                                      uniqueId:
                                                      _filteredBeneficiaries[
                                                      index]
                                                          .uniqueId));
                                            }),
                                          ),
                                        ]),
                                    child: InkWell(
                                      onTap: () {
                                        print(
                                            '${_filteredBeneficiaries[index].profileimage}');

                                        if (_filteredBeneficiaries[index]
                                            .beneficaryStatus ==
                                            1) {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (context) =>
                                                      SendMoneyScreen(
                                                        name: _filteredBeneficiaries[
                                                        index]
                                                            .name,
                                                        account: _filteredBeneficiaries[
                                                        index]
                                                            .account,
                                                        image: _filteredBeneficiaries[
                                                        index]
                                                            .profileimage,
                                                        id: _filteredBeneficiaries[
                                                        index]
                                                            .uniqueId!,
                                                        accountType:
                                                        _filteredBeneficiaries[
                                                        index]
                                                            .accountType,
                                                        symbol: _filteredBeneficiaries[
                                                        index]
                                                            .currency,
                                                      )));
                                        } else if (_filteredBeneficiaries[
                                        index]
                                            .beneficaryStatus ==
                                            0) {
                                          CustomToast.showError(
                                              context,
                                              "Sorry!",
                                              _filteredBeneficiaries[
                                              index]
                                                  .beneficaryMsg!);
                                        }

                                        // Navigator.pushReplacement(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //         builder: (context) =>
                                        //             BeneficiaryUserDetailsScreen(
                                        //               userId:
                                        //                   _filteredBeneficiaries[
                                        //                           index]
                                        //                       .uniqueId!,
                                        //             )));
                                      },
                                      child: Container(
                                        margin:
                                        const EdgeInsets.symmetric(
                                            vertical: 10),
                                        padding:
                                        const EdgeInsets.symmetric(
                                            vertical: 8,
                                            horizontal: 0),
                                        decoration: BoxDecoration(
                                          color: CustomColor.whiteColor,
                                          borderRadius:
                                          BorderRadius.circular(16),
                                          boxShadow: [
                                            BoxShadow(
                                              color: CustomColor.black
                                                  .withOpacity(0.3),
                                              offset: Offset(0, 2),
                                              blurRadius: 8,
                                              spreadRadius: -4,
                                            ),
                                          ],
                                        ),
                                        child: Padding(
                                          padding:
                                          const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceBetween,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    width: 44,
                                                    height: 44,
                                                    margin:
                                                    EdgeInsets.only(
                                                        right: 7),
                                                    alignment:
                                                    Alignment.center,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape
                                                            .circle,
                                                        image: DecorationImage(
                                                            image: NetworkImage(
                                                                _filteredBeneficiaries[
                                                                index]
                                                                    .profileimage!),
                                                            fit: BoxFit
                                                                .cover)),
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
                                                        style: GoogleFonts
                                                            .inter(
                                                          color: _filteredBeneficiaries[index]
                                                              .beneficaryStatus ==
                                                              1
                                                              ? CustomColor
                                                              .black
                                                              : CustomColor
                                                              .black
                                                              .withOpacity(
                                                              0.2),
                                                          fontSize: 15,
                                                          fontWeight:
                                                          FontWeight
                                                              .w500,
                                                        ),
                                                      ),
                                                      Text(
                                                        "Account Type: ${_filteredBeneficiaries[index].accountType!}",
                                                        style: GoogleFonts
                                                            .inter(
                                                          color: _filteredBeneficiaries[index]
                                                              .beneficaryStatus ==
                                                              1
                                                              ? CustomColor
                                                              .black
                                                              .withOpacity(
                                                              0.6)
                                                              : CustomColor
                                                              .black
                                                              .withOpacity(
                                                              0.2),
                                                          // Faded transparent black
                                                          fontSize: 11,
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                              Container(
                                                height: 25,
                                                width: 25,
                                                alignment:
                                                Alignment.center,
                                                margin:
                                                EdgeInsets.symmetric(
                                                    horizontal: 5),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                    image: NetworkImage(
                                                        _filteredBeneficiaries[
                                                        index]
                                                            .flag!),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              // Container(
                                              //   width: 100,
                                              //   alignment:
                                              //       Alignment.center,
                                              //   child: Text(
                                              //     _filteredBeneficiaries[
                                              //             index]
                                              //         .created!,
                                              //     overflow: TextOverflow
                                              //         .ellipsis,
                                              //     textAlign:
                                              //         TextAlign.right,
                                              //     maxLines: 2,
                                              //     style:
                                              //         GoogleFonts.inter(
                                              //             color: Color(
                                              //                 0xffC4C4C4),
                                              //             fontSize: 12,
                                              //             fontWeight:
                                              //                 FontWeight
                                              //                     .w500),
                                              //   ),
                                              // )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                                : Center(
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  CustomImageWidget(
                                    imagePath: StaticAssets.noTransaction,
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
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamedAndRemoveUntil(
                                context,
                                'dynamicAddBeneficiaryScreen',
                                    (route) => false);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width * 0.85,
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            margin: EdgeInsets.only(bottom: 16),
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
                  );
                },
              ))),
      // bottomNavigationBar: CustomBottomBar(index: 0),
    );
  }

  appBarSection(BuildContext context, state) {
    return Container(
      padding: EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DefaultBackButtonWidget(
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, 'dashboard', (route) => false);
            },
          ),
          Text(
            'Beneficiary List',
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
