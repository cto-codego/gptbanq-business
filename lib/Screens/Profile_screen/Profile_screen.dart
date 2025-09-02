import 'package:gptbanqbusiness/Screens/Profile_screen/bloc/profile_bloc.dart';
import 'package:gptbanqbusiness/constant_string/User.dart';
import 'package:gptbanqbusiness/cutom_weidget/cutom_progress_bar.dart';
import 'package:gptbanqbusiness/utils/assets.dart';
import 'package:gptbanqbusiness/utils/input_fields/custom_color.dart';
import 'package:gptbanqbusiness/widgets/custom_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

import '../../Models/profile_info.dart';
import '../../utils/webview_screen.dart';
import '../../widgets/buttons/custom_floating_action_button.dart';
import '../../widgets/toast/toast_util.dart';
import '../Dashboard_screen/deposit_screen.dart';

// You can keep the existing BottomSheetContentStep4 and CustomActionButton
// as they are already well-structured.

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileBloc _profileBloc = ProfileBloc();

  @override
  void initState() {
    super.initState();
    _profileBloc.add(getprofileEvent());
  }

  @override
  void dispose() {
    _profileBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.notificationBgColor,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: BlocProvider(
        create: (context) => _profileBloc,
        child: BlocListener<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state.statusModel?.status == 0) {
              CustomToast.showError(
                  context, "Sorry!", state.statusModel!.message!);
            }
            if (state.payWithModel?.status == 0) {
              CustomToast.showError(
                  context, "Sorry!", state.payWithModel!.message!);
            }
            if (state.logoutModel?.status == 1) {
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            }
          },
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              final profileModel = state.profileModel;
              final isLoading = state.isloading;

              if (profileModel == null) {
                return const Center(child: CircularProgressIndicator());
              }

              return ProgressHUD(
                inAsyncCall: isLoading,
                child: SafeArea(
                  child: Container(
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, top: 10, bottom: 60),
                    child: ListView(
                      children: [
                        _buildHeader(),
                        _buildProfileCard(context, profileModel),
                        _buildMyAddressSection(context, profileModel),
                        if (profileModel.sof?.sourceOfWealth == 1)
                          _buildSofCard(profileModel.sof!.label!,
                              profileModel.sof!.sourceOfWealthMsg!, 'Step4'),
                        if (profileModel.sof?.sourceOfWealth == 2)
                          _buildSofCard(profileModel.sof!.label!,
                              profileModel.sof!.sourceOfWealthMsg!, 'Step4'),
                        _buildDetailsSection(state),
                        if (profileModel.hide_cdg_fee == 1)
                          _buildFeePaySection(context, state),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: CustomFloatingActionButton(),
    );
  }

  Widget _buildHeader() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(bottom: 15, top: 10),
      child: Text(
        'Profile',
        textAlign: TextAlign.center,
        style: GoogleFonts.inter(
          color: CustomColor.black,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, ProfileModel profileModel) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: CustomColor.whiteColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            offset: Offset(0, 2),
            blurRadius: 4,
            spreadRadius: -2,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 96,
                height: 96,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: CustomColor.profileImageContainerColor,
                    width: 5,
                  ),
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(profileModel.profileimage!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: CustomColor.primaryColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle_outline,
                        color: Colors.white,
                        size: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 3),
                        child: Text(
                          profileModel.accountStatus!,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: CustomColor.profileImageContainerColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xffE3FFEA).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xffAEEBBD)),
                    ),
                    child: Text(
                      profileModel.planName!,
                      style: GoogleFonts.inter(
                        color: const Color(0xff34C759),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      CustomImageWidget(
                        imagePath: StaticAssets.wallet,
                        imageType: 'svg',
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          'My Balance',
                          style: GoogleFonts.inter(
                            color: CustomColor.black.withOpacity(0.5),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "€ ${profileModel.balance!}",
                        style: GoogleFonts.inter(
                          color: CustomColor.black,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      profileModel.email!,
                      style: GoogleFonts.inter(
                        color: CustomColor.black,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  if (profileModel.needShowUpgrade == 1) ...[
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: () {
                        User.planpage = 1;
                        User.planlink = profileModel.planurl;
                        Navigator.pushNamed(context, 'planscreen');
                      },
                      child: Text(
                        'Upgrade Plan',
                        style: GoogleFonts.inter(
                          color: CustomColor.green,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyAddressSection(
      BuildContext context, ProfileModel profileModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 8),
          child: Text(
            "My Address",
            style: GoogleFonts.inter(
              color: CustomColor.black,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        InkWell(
          onTap: () {
            var ibanId = User.ibanId;
            Navigator.push(
              context,
              PageTransition(
                child: DashboardDepositScreen(ibanId: ibanId),
                type: PageTransitionType.rightToLeft,
                alignment: Alignment.center,
                duration: const Duration(milliseconds: 300),
                reverseDuration: const Duration(milliseconds: 200),
              ),
            );
          },
          child: Container(
            width: double.infinity,
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: CustomColor.whiteColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0D000000),
                  offset: Offset(0, 2),
                  blurRadius: 4,
                  spreadRadius: -2,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 5),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0A52E1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: CustomImageWidget(
                          imagePath: StaticAssets.location,
                          imageType: 'svg',
                          height: 20,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width:
                                  MediaQuery.of(context).size.width * 0.25,
                                  child: Text(
                                    "${profileModel.name!} ${profileModel.surname!}",
                                    style: GoogleFonts.inter(
                                      color: CustomColor.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 5),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0A52E1)
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    "Main Address",
                                    style: GoogleFonts.inter(
                                      color: CustomColor.primaryColor,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "IBAN Account: ${profileModel.iban!}",
                              style: GoogleFonts.inter(
                                color: CustomColor.black.withOpacity(0.7),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                CustomImageWidget(
                  imagePath: StaticAssets.arrowRight,
                  imageType: 'svg',
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSofCard(String label, String message, String routeName) {
    return InkWell(
      onTap: () {
        Navigator.pushNamedAndRemoveUntil(context, routeName, (route) => true);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xffFFFCF0),
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D000000),
              offset: Offset(0, 2),
              blurRadius: 4,
              spreadRadius: -2,
            ),
          ],
        ),
        child: Row(
          children: [
            CustomImageWidget(
              imagePath: StaticAssets.timeRewind,
              imageType: 'svg',
              height: 21,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.inter(
                      color: CustomColor.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    message,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    style: GoogleFonts.inter(
                      color: CustomColor.black.withOpacity(0.7),
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsSection(ProfileState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5, left: 5),
          child: Text(
            'Details',
            style: GoogleFonts.inter(
              color: CustomColor.black.withOpacity(0.3),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: CustomColor.whiteColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: CustomColor.primaryInputHintBorderColor),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0D000000),
                offset: Offset(0, 2),
                blurRadius: 4,
                spreadRadius: -2,
              ),
            ],
          ),
          child: Column(
            children: [
              CustomActionButton(
                icon: StaticAssets.lock,
                label: 'Change Password',
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, 'changePasswordScreen', (route) => true);
                },
              ),
              Divider(color: CustomColor.black.withOpacity(0.2)),
              CustomActionButton(
                icon: StaticAssets.contactUs,
                label: 'Contact Us',
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          WebViewScreen(url: state.profileModel!.contactUs!),
                    ),
                  );
                },
              ),
              Divider(color: CustomColor.black.withOpacity(0.2)),
              CustomActionButton(
                icon: StaticAssets.info,
                label: 'Help & FAQs',
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          WebViewScreen(url: state.profileModel!.helpFaq!),
                    ),
                  );
                },
              ),
              Divider(color: CustomColor.black.withOpacity(0.2)),
              InkWell(
                onTap: () {
                  _profileBloc.add(LogoutEvent());
                },
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          CustomImageWidget(
                            imagePath: StaticAssets.logout,
                            imageType: 'svg',
                            height: 25,
                          ),
                          const SizedBox(width: 15),
                          Text(
                            "Log Out",
                            style: GoogleFonts.inter(
                              color: CustomColor.errorColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Container(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeePaySection(BuildContext context, ProfileState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5, left: 5),
          child: Text(
            'Settings',
            style: GoogleFonts.inter(
              color: CustomColor.black.withOpacity(0.3),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xffFFFCF0),
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0D000000),
                offset: Offset(0, 2),
                blurRadius: 4,
                spreadRadius: -2,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        CustomImageWidget(
                          imagePath: StaticAssets.paymentImage,
                          imageType: 'png',
                          height: 25,
                          width: 25,
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Fee Pay",
                                style: GoogleFonts.inter(
                                  color: CustomColor.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: Text(
                                  state.profileModel!.cdg_message!,
                                  style: GoogleFonts.inter(
                                    color: CustomColor.black,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (state.profileModel!.paywith!.isNotEmpty)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: CustomColor.primaryColor,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          _buildPayWithButton(
                              context,
                              'EUR',
                              state.profileModel!.paywith == '0',
                                  () => _updatePayWith(context, 0)),
                          _buildPayWithButton(
                              context,
                              'CDG',
                              state.profileModel!.paywith == '1',
                                  () => _updatePayWith(context, 1)),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPayWithButton(
      BuildContext context, String text, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? CustomColor.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : CustomColor.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _updatePayWith(BuildContext context, int value) {
    if (value == 1 &&
        (double.tryParse(
            context.read<ProfileBloc>().state.profileModel!.cdg!) ??
            0) <=
            0) {
      CustomToast.showError(
          context, "Sorry!", "You don't have enough Balance!");
    } else {
      context.read<ProfileBloc>().add(PayWithEvent(payWith: value));
      context.read<ProfileBloc>().add(getprofileEvent());
    }
  }
}

class CustomActionButton extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;

  const CustomActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                children: [
                  CustomImageWidget(
                    imagePath: icon,
                    imageType: 'svg',
                    height: 18,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    label,
                    style: GoogleFonts.inter(
                        color: CustomColor.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            CustomImageWidget(
              imagePath: StaticAssets.arrowRight,
              imageType: 'svg',
              height: 24,
            ),
          ],
        ),
      ),
    );
  }
}
