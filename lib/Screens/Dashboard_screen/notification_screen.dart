import 'package:gptbanqbusiness/Screens/Dashboard_screen/bloc/dashboard_bloc.dart';
import 'package:gptbanqbusiness/constant_string/User.dart';
import 'package:gptbanqbusiness/cutom_weidget/cutom_progress_bar.dart';
import 'package:gptbanqbusiness/utils/input_fields/custom_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/assets.dart';
import '../../widgets/buttons/default_back_button_widget.dart';
import '../../widgets/custom_image_widget.dart';
import '../../widgets/toast/custom_dialog_widget.dart';
import '../../widgets/toast/toast_util.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final DashboardBloc _dashboardBloc = DashboardBloc();

  @override
  void initState() {
    super.initState();
    _dashboardBloc.add(DashboarddataEvent());
    User.Screen = 'Notification Screen';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.notificationBgColor,
      body: BlocListener(
          bloc: _dashboardBloc,
          listener: (context, DashboardState state) async {
            if (state.statusModel?.status == 0) {
              CustomToast.showError(
                  context, "Sorry!", state.statusModel!.message!);
            }
          },
          child: BlocBuilder(
              bloc: _dashboardBloc,
              builder: (context, DashboardState state) {
                return SafeArea(
                  child: ProgressHUD(
                    inAsyncCall: state.isloading,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        appBarSection(context, state),
                        state.dashboardModel!.notifications!.isEmpty
                            ? Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: Column(
                                  children: [
                                    CustomImageWidget(
                                      imagePath: StaticAssets.noNotification,
                                      imageType: 'svg',
                                      height: 130,
                                    ),
                                    Text(
                                      "No Notification",
                                      style: GoogleFonts.inter(
                                        color:
                                            CustomColor.black.withOpacity(0.6),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Expanded(
                                child: ListView.builder(
                                  itemCount: state
                                      .dashboardModel!.notifications!.length,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 10),
                                  itemBuilder: (context, index) {
                                    var notification = state
                                        .dashboardModel!.notifications![index];
                                    return Dismissible(
                                      key: Key(notification.id.toString()),
                                      // Use a unique key for each notification
                                      direction: DismissDirection.endToStart,
                                      // Swipe from right to left
                                      background: Container(
                                        alignment: Alignment.centerRight,
                                        margin:
                                            const EdgeInsets.only(bottom: 12),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0,
                                        ),
                                        color: CustomColor.errorColor,
                                        child: const Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                        ),
                                      ),
                                      onDismissed: (direction) {
                                        _dashboardBloc.add(
                                            closenotificationEvent(
                                                notifId: state.dashboardModel!
                                                    .notifications![index].id));

                                        setState(() {
                                          state.dashboardModel!.notifications!
                                              .removeAt(index);
                                        });

                                        // Optionally, show a confirmation snackbar
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Notification has been removed'),
                                          ),
                                        );
                                      },
                                      child: InkWell(
                                        onTap: () {
                                          CustomDialogWidget.showWarningDialog(
                                              context: context,
                                              title: state.dashboardModel!
                                                  .notifications![index].title!,
                                              subTitle: state
                                                  .dashboardModel!
                                                  .notifications![index]
                                                  .description!,
                                              btnOkText: 'Ok');
                                        },
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 12),
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: CustomColor.whiteColor,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.08),
                                                offset: const Offset(0, 1),
                                                blurRadius: 8,
                                                spreadRadius: -2,
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(16),
                                                margin: const EdgeInsets.only(
                                                    right: 10),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: CustomColor
                                                      .notificationBellBgColor,
                                                ),
                                                child: CustomImageWidget(
                                                  imagePath: StaticAssets
                                                      .notificationBell,
                                                  imageType: 'svg',
                                                  height: 24,
                                                ),
                                              ),
                                              Expanded(
                                                // Use Expanded to prevent overflow
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      state
                                                          .dashboardModel!
                                                          .notifications![index]
                                                          .title!,
                                                      style: GoogleFonts.inter(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color:
                                                            CustomColor.black,
                                                      ),
                                                    ),
                                                    Text(
                                                      state
                                                          .dashboardModel!
                                                          .notifications![index]
                                                          .description!,
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: GoogleFonts.inter(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: CustomColor
                                                            .subtitleTextColor,
                                                      ),
                                                    ),  Text(
                                                      state
                                                          .dashboardModel!
                                                          .notifications![index]
                                                          .date!,
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: GoogleFonts.inter(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: CustomColor
                                                            .subtitleTextColor,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                      ],
                    ),
                  ),
                );
              })),
    );
  }

  appBarSection(BuildContext context, state) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DefaultBackButtonWidget(
            onTap: () {
              Navigator.pop(context);
            },
          ),
          Text(
            'Notification',
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
