import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:recap_maps/src/model/shop_model.dart';
import 'package:recap_maps/src/pages/shop/shop_edit_detail.dart';
import 'package:recap_maps/src/widgets/button/rcm_button.dart';

class ShopDetail extends StatefulWidget {
  final ShopModel shop;
  final String myUid;
  const ShopDetail({
    Key? key,
    required this.shop,
    this.myUid = "",
  }) : super(key: key);

  @override
  State<ShopDetail> createState() => _ShopDetailState();
}

class _ShopDetailState extends State<ShopDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("รายละเอียดร้านปะยาง"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              const SizedBox(height: 50),
              Text(
                "ร้าน ${widget.shop.shopName}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Text("ชื่อเจ้าของร้าน : ${widget.shop.shopOwner}"),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("เบอร์โทรติดต่อ : ${widget.shop.shopPhone}"),
                  const SizedBox(width: 10),
                  InkWell(
                    onTap: () async {
                      // Clipboard.setData(
                      //   ClipboardData(text: widget.shop.shopPhone),
                      // );
                      // const snackBar = SnackBar(
                      //   content: Text('คัดลอกเบอร์โทรแล้ว'),
                      // );
                      // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      await FlutterPhoneDirectCaller.callNumber(
                        widget.shop.shopPhone!,
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blue,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            "ติดต่อช่าง",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text("เวลาเปิด-ปิด : ${widget.shop.open} - ${widget.shop.close}"),
              const SizedBox(height: 50),
              Visibility(
                visible: widget.myUid == widget.shop.uid,
                child: RCMButton(
                  title: "แก้ไขรายละเอียดราย",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ShopEditDetail(
                          shop: widget.shop,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
