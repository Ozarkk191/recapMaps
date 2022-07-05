import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recap_maps/src/model/shop_model.dart';
import 'package:recap_maps/src/widgets/button/rcm_button.dart';

class ApprovePage extends StatefulWidget {
  const ApprovePage({Key? key}) : super(key: key);

  @override
  State<ApprovePage> createState() => _ApprovePageState();
}

class _ApprovePageState extends State<ApprovePage> {
  List<ShopModel> shopList = [];
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  void getStore() async {
    await firestore
        .collection("Shop")
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        ShopModel shop = ShopModel.fromJson(jsonDecode(jsonEncode(doc.data())));
        if (shop.role == "Shop") {
          if (!shop.approve!) {
            shopList.add(shop);
          }
        }
      }
    });
    setState(() {});
  }

  void onUpdate({
    required String uid,
    required int index,
  }) async {
    await firestore
        .collection("Shop")
        .doc(uid)
        .update({"approve": true}).then((value) {
      shopList.removeAt(index);
      SnackBar snackBar = SnackBar(
        backgroundColor: Colors.blue.shade300,
        content: const Text('ยืนยันรายการสำเร็จ'),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {});
    });
  }

  @override
  void initState() {
    getStore();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("รายชื่อร้านปะยางทั้งหมด"),
        centerTitle: true,
      ),
      body: shopList.isNotEmpty
          ? SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: shopList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Colors.blue,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  textRich(
                                    context,
                                    title: "ชื่อร้าน",
                                    value: "${shopList[index].shopName}",
                                  ),
                                  textRich(
                                    context,
                                    title: "ชื่อเจ้าของร้าน",
                                    value: "${shopList[index].shopOwner}",
                                  ),
                                  textRich(
                                    context,
                                    title: "อีเมล",
                                    value: "${shopList[index].email}",
                                  ),
                                  textRich(
                                    context,
                                    title: "เบอร์โทร",
                                    value: "${shopList[index].shopPhone}",
                                  ),
                                ],
                              ),
                            ),
                            RCMButton(
                              width: 100,
                              height: 40,
                              onTap: () {
                                onUpdate(
                                  uid: shopList[index].uid!,
                                  index: index,
                                );
                              },
                              title: "อนุญาติ",
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            )
          : const Center(
              child: Text("ไม่มีร้านปะยาง"),
            ),
    );
  }

  RichText textRich(
    BuildContext context, {
    required String title,
    required String value,
  }) {
    return RichText(
      text: TextSpan(
        text: title,
        style: DefaultTextStyle.of(context).style,
        children: <TextSpan>[
          const TextSpan(text: '  :  '),
          TextSpan(
              text: value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
