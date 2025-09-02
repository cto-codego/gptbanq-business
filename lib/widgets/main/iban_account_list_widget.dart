import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../Models/iban_list/iban_list.dart';



class IbanAccountListWidget extends StatelessWidget {
  IbanAccountListWidget({super.key, required this.ibanInfo, required this.onTapChange});

  List<Ibaninfo> ibanInfo;
  VoidCallback onTapChange;


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Color(0xffF9FAFF),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(11),
          topRight: Radius.circular(11),
        ),
      ),
      child: ListView(
        shrinkWrap: true,
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              alignment: Alignment.centerRight,
              child: Container(
                width: 20,
                height: 20,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.black),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const Icon(
                  Icons.close_rounded,
                  size: 15,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'IBAN Accounts',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontFamily: 'pop',
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    'createIbanScreen',
                        (route) => true,
                  );
                },
                icon: const Icon(
                  Icons.add_box_outlined,
                  color: Color(0xff253BAA),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ListView.builder(
            itemCount: ibanInfo.length ?? 0,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: onTapChange,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xffEEF0F9),
                          borderRadius: BorderRadius.circular(11),
                        ),
                        child: Image.asset('images/Frame.png'),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ibanInfo[index].label!,
                              style: const TextStyle(
                                color: Colors.black,
                                fontFamily: 'pop',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  ibanInfo[index].iban!,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'pop',
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    await Clipboard.setData(
                                      ClipboardData(
                                        text: ibanInfo[index].iban!,
                                      ),
                                    );

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("IBAN number copied"),
                                      ),
                                    );
                                  },
                                  child: const Icon(
                                    Icons.content_copy_rounded,
                                    color: Color(0xff7E8BF0),
                                    size: 15,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  ibanInfo[index].bic!,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'pop',
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    await Clipboard.setData(
                                      ClipboardData(
                                        text: ibanInfo[index].bic!,
                                      ),
                                    );

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("BIC number copied"),
                                      ),
                                    );
                                  },
                                  child: const Icon(
                                    Icons.content_copy_rounded,
                                    color: Color(0xff7E8BF0),
                                    size: 15,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            ibanInfo[index].balance!,
                            style: const TextStyle(
                              color: Color(0xff253BAA),
                              fontFamily: 'pop',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            ibanInfo[index].currency!,
                            style: const TextStyle(
                              color: Color(0xff253BAA),
                              fontFamily: 'pop',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
