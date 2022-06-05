import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recap_maps/src/model/shop_model.dart';
import 'package:recap_maps/src/widgets/button/rcm_button.dart';
import 'package:recap_maps/src/widgets/textfield/rcm_textfield.dart';

class ShopEditDetail extends StatefulWidget {
  final ShopModel shop;
  const ShopEditDetail({
    Key? key,
    required this.shop,
  }) : super(key: key);

  @override
  State<ShopEditDetail> createState() => _ShopEditDetailState();
}

class _ShopEditDetailState extends State<ShopEditDetail> {
  TextEditingController shopName = TextEditingController();
  TextEditingController shopOwner = TextEditingController();
  TextEditingController shopPhone = TextEditingController();
  TextEditingController open = TextEditingController();
  TextEditingController close = TextEditingController();
  bool edit = false;
  bool loading = false;

  @override
  void initState() {
    shopName.text = widget.shop.shopName!;
    shopOwner.text = widget.shop.shopOwner!;
    shopPhone.text = widget.shop.shopPhone!;
    open.text = widget.shop.open!;
    close.text = widget.shop.close!;
    super.initState();
  }

  @override
  void dispose() {
    shopName.dispose();
    shopOwner.dispose();
    shopPhone.dispose();
    open.dispose();
    close.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("แก้ไขข้อมูลร้าน"),
        centerTitle: true,
        actions: [
          Visibility(
            visible: !edit,
            child: Center(
              child: InkWell(
                onTap: () {
                  setState(() {
                    edit = true;
                  });
                },
                child: const SizedBox(
                  width: 50,
                  height: 50,
                  child: Center(
                    child: Text("แก้ไข"),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    RCMTextfield(
                      controller: shopName,
                      enabled: edit,
                      hintText: "ชื่อร้าน",
                    ),
                    const SizedBox(height: 20),
                    RCMTextfield(
                      controller: shopOwner,
                      enabled: edit,
                      hintText: "ชื่อเจ้าของร้าน",
                    ),
                    const SizedBox(height: 20),
                    RCMTextfield(
                      controller: shopPhone,
                      enabled: edit,
                      maxLength: 10,
                      keyboardType: TextInputType.number,
                      hintText: "เบอร์โทรศัพท์",
                    ),
                    const SizedBox(height: 20),
                    RCMTextfield(
                      controller: open,
                      enabled: edit,
                      hintText: "เวลาเปิด",
                    ),
                    const SizedBox(height: 20),
                    RCMTextfield(
                      controller: close,
                      enabled: edit,
                      hintText: "เวลาปิด",
                    ),
                    const SizedBox(height: 50),
                    Visibility(
                      visible: edit,
                      child: RCMButton(
                        onTap: updateData,
                        title: "บันทึก",
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: loading,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void updateData() async {
    setState(() {
      loading = true;
    });
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore.collection("Shop").doc(widget.shop.uid).update({
      "shopName": shopName.text,
      "shopOwner": shopOwner.text,
      "shopPhone": shopPhone.text,
      "open": open.text,
      "close": close.text
    }).then((value) {
      const snackBar = SnackBar(
        content: Text('แก้ไขข้อมูลร้านเรียบร้อยแล้ว'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {
        edit = false;
        loading = false;
      });
    });
  }
}
