import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

import '../../constant_string/User.dart';
import '../../cutom_weidget/custom_navigationBar.dart';
import '../../cutom_weidget/cutom_progress_bar.dart';
import '../Dashboard_screen/bloc/dashboard_bloc.dart';
import '../Profile_screen/Profile_screen.dart';

class PrepaidCardActivatedScreen extends StatefulWidget {
  const PrepaidCardActivatedScreen({super.key});

  @override
  State<PrepaidCardActivatedScreen> createState() =>
      _PrepaidCardActivatedScreenState();
}

class _PrepaidCardActivatedScreenState
    extends State<PrepaidCardActivatedScreen> {
  bool active = false;
  bool showNumber = false;
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _transactions = []; // Initially empty
  List<Map<String, dynamic>> _filteredTransactions = [];

  final DashboardBloc _dashboardBloc = new DashboardBloc();

  Future<void> _onRefresh() async {
    debugPrint('_onRefresh');

    _dashboardBloc.add(DashboarddataEvent());
  }

  @override
  void initState() {
    super.initState();
    User.Screen = 'prepaidCardActivatedScreen';

    _dashboardBloc.add(DashboarddataEvent());
    // Simulating loading data from API
    _loadDataFromApi();
    _searchController.addListener(_onSearchChanged);
  }

  void _loadDataFromApi() {
    // Simulated API data
    List<Map<String, dynamic>> apiData = [
      {
        'name': 'Martin Jason',
        'paymentMethod': 'Card Payment',
        'amount': '-400,00 €',
        'status': 'Complete',
      },
      {
        'name': 'John Doe',
        'paymentMethod': 'Online Payment',
        'amount': '-200,00 €',
        'status': 'Pending',
      },
      // Add more transactions as needed
    ];
    setState(() {
      _transactions = apiData;
      _filteredTransactions = _transactions;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    String query = _searchController.text;
    setState(() {
      if (query.isEmpty) {
        _filteredTransactions = _transactions;
      } else {
        _filteredTransactions = _transactions
            .where((transaction) =>
        transaction['name']
            .toLowerCase()
            .contains(query.toLowerCase()) ||
            transaction['paymentMethod']
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            transaction['amount']
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            transaction['status']
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
            statusBarColor: Color(0xffFAFAFA),
            systemNavigationBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: Color(0xffFAFAFA)),
        child: Scaffold(
          backgroundColor: const Color(0xffFAFAFA),
          body: BlocListener(
              bloc: _dashboardBloc,
              listener: (context, DashboardState state) {},
              child: BlocBuilder(
                  bloc: _dashboardBloc,
                  builder: (context, DashboardState state) {
                    return SafeArea(
                      child: ProgressHUD(
                        inAsyncCall: state.isloading,
                        child: RefreshIndicator(
                          onRefresh: _onRefresh,
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                appBarSection(context, state),
                                cardSection(context),
                                // waitingToBeAssigned(context),
                                const SizedBox(height: 20),
                                topUpWidget(context),
                                cardDetailsSection(context),
                                transaction(context),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  })),
          bottomNavigationBar: CustomBottomBar(index: 3),
        ));
  }

  appBarSection(BuildContext context, state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'DASHBOARD CARDS',
                style: TextStyle(
                    color: Color(0xffC4C4C4),
                    fontFamily: 'pop',
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Container(
            alignment: Alignment.centerRight,
            height: 90,
            width: 80,
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      PageTransition(
                        type: PageTransitionType.scale,
                        alignment: Alignment.center,
                        isIos: true,
                        duration: const Duration(microseconds: 500),
                        child: const ProfileScreen(),
                      ),
                    );
                  },
                  child: Container(
                    width: 70,
                    height: 70,
                    alignment: Alignment.centerRight,
                    child: CircleAvatar(
                      backgroundImage:
                          NetworkImage(state.dashboardModel!.profileimage!),
                      radius: 35,
                    ),
                  ),
                ),
                Container(
                  width: 80,
                  alignment: Alignment.topLeft,
                  child: Image.asset('images/message-question.png'),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  cardSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, 'cardScreen', (route) => false);
            },
            child: Image.asset(
              "images/backarrow.png",
              color: const Color(0xff373737),
              height: 24,
              width: 24,
            ),
          ),
          Center(
              child: Image.asset(
            "images/card/prepaid_card.png",
            width: MediaQuery.of(context).size.width * 0.65,
          )),
          GestureDetector(
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, 'cardSettingsScreen', (route) => true);
            },
            child: Image.asset(
              "images/settings.png",
              color: const Color(0xff090B78),
              height: 35,
              width: 35,
            ),
          ),
        ],
      ),
    );
  }

  waitingToBeAssigned(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xffF1EDED),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Text(
              'Your card has been ordered and waiting to be assigned, you will see your card details here once assigned',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color(0xFF686868),
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  height: 1),
            ),
          ),
          Container(
            // width: 263,
            height: 37,
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(11),
              color: const Color.fromRGBO(172, 172, 172, 1),
              border: Border.all(
                color: const Color.fromRGBO(196, 196, 196, 1),
                width: 1,
              ),
            ),
            child: const Text(
              'waiting to be assigned',
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                  height: 1),
            ),
          )
        ],
      ),
    );
  }

  topUpWidget(BuildContext context) {
    return Container(
      height: 55,
      margin: const EdgeInsets.symmetric(horizontal: 30),
      padding: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        color: const Color(0xffEDEBEB),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset("images/card/prepaid_card.png"),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: GestureDetector(
                  onTap: () {},
                  child: Image.asset(
                    "images/add_square_new.png",
                    height: 24,
                    width: 24,
                  ),
                ),
              ),
              const Text(
                'Topup',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(top: 3),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Balance',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      fontWeight: FontWeight.w700),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '€',
                      // textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '2.10040',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Poppins',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  cardDetailsSection(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xffEDEBEB),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Number',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      height: 1),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: showNumber
                          ? const Text(
                              '1234 5678 9012 3456', // Your full number here
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Poppins',
                                fontSize: 10,
                                fontWeight: FontWeight.normal,
                                height: 1,
                              ),
                            )
                          : const Text(
                              '*******3456', // Masked number
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Poppins',
                                fontSize: 10,
                                fontWeight: FontWeight.normal,
                                height: 1,
                              ),
                            ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          showNumber = !showNumber;
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: 57,
                        height: 28,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(11),
                          color: const Color(0xff1C3C79),
                          border: Border.all(
                            color: const Color(0xffC4C4C4),
                            width: 1,
                          ),
                        ),
                        child: const Text(
                          'Show',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              height: 1),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 10),
              child: const Divider(
                color: Color(0xffB6B6B6),
                height: 1,
              ),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Expiry',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      height: 1),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Text(
                    '10/27',
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Poppins',
                        fontSize: 10,
                        fontWeight: FontWeight.normal,
                        height: 1),
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 10),
              child: const Divider(
                color: Color(0xffB6B6B6),
                height: 1,
              ),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'CVV',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      height: 1),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Text(
                    '222',
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Poppins',
                        fontSize: 10,
                        fontWeight: FontWeight.normal,
                        height: 1),
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 10),
              child: const Divider(
                color: Color(0xffB6B6B6),
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  transaction(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 30),
          child: const Text(
            'Transactions',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.black,
                fontFamily: 'Poppins',
                fontSize: 12,
                fontWeight: FontWeight.normal,
                height: 1),
          ),
        ),
        Container(
          height: 42,
          margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xFFEEF0F9),
          ),
          child: TextField(
            controller: _searchController,
            cursorColor: const Color(0xff888888),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(10),
              hintText: 'search transaction...',
              hintStyle: const TextStyle(
                color: Color(0xffB2B1B1),
                fontSize: 15,
                fontFamily: 'pop',
                fontWeight: FontWeight.w500,
              ),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                  borderSide: const BorderSide(
                    width: 1,
                    color: Color(0xff888888),
                  )),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                  borderSide: const BorderSide(
                    width: 1.2,
                    color: Color(0xff888888),
                  )),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                  borderSide: const BorderSide(
                    width: 1.2,
                    color: Color(0xff888888),
                  )),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
          child: const Text(
            'Today',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.black,
                fontFamily: 'Poppins',
                fontSize: 12,
                fontWeight: FontWeight.normal,
                height: 1),
          ),
        ),
        SizedBox(
          height: 300,
          child: ListView.builder(
            itemCount: _filteredTransactions.length,
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  height: 65,
                                  width: 65,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(11),
                                    border: Border.all(
                                      width: 1,
                                      color: const Color(0xffE3E3E3),
                                      // color: Colors.black,
                                    ),
                                  ),
                                  child: const CircleAvatar(
                                    child: Icon(
                                      Icons.swap_horiz_rounded,
                                      color: Color(0xff10245C),
                                      size: 30,
                                    ),
                                  )),
                              const SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      _filteredTransactions[index]['name'],
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: 'pop',
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black),
                                    ),
                                    Text(
                                      _filteredTransactions[index]
                                      ['paymentMethod'],
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontFamily: 'pop',
                                          color: Colors.black),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              _filteredTransactions[index]['amount'],
                              style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'pop',
                                  fontWeight: FontWeight.w500,
                                  color: Colors.red),
                            ),
                            Text(
                              _filteredTransactions[index]['status'],
                              style: TextStyle(
                                  fontSize: 10,
                                  fontFamily: 'pop',
                                  color: _filteredTransactions[index]
                                  ['status'] ==
                                      "Complete"
                                      ? Colors.green
                                      : Colors.red),
                            )
                          ],
                        )
                      ],
                    ),
                  ));
            },
          ),
        )
      ],
    );
  }
}
