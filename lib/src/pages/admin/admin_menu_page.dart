import 'package:flutter/material.dart';
import 'package:recap_maps/src/pages/admin/approve_page.dart';
import 'package:recap_maps/src/pages/admin/shop_list.dart';
import 'package:recap_maps/src/widgets/button/rcm_button.dart';

class AdminMenuPage extends StatefulWidget {
  const AdminMenuPage({Key? key}) : super(key: key);

  @override
  State<AdminMenuPage> createState() => _AdminMenuPageState();
}

class _AdminMenuPageState extends State<AdminMenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ADMIN PAGE"),
        centerTitle: true,
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RCMButton(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ApprovePage(),
                  ),
                );
              },
              title: "รายชื่อที่ยังไม่ได้รับการยืนยัน",
            ),
            const SizedBox(height: 20),
            RCMButton(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ShopListPage(),
                  ),
                );
              },
              title: "รายชื่อร้านปะยาง",
            ),
          ],
        ),
      ),
    );
  }
}
