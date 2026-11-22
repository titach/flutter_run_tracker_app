import 'package:flutter/material.dart';
import 'package:flutter_run_tracker_app/views/show_all_run_ui.dart';

class SplashScreenUI extends StatefulWidget {
  const SplashScreenUI({super.key});

  @override
  State<SplashScreenUI> createState() => _SplashScreenUIState();
}

class _SplashScreenUIState extends State<SplashScreenUI> {
  @override
  void initState() {
    // delay หน้าจอ 3 วิ แล้วเปิดไป ShowAllRunUI() แบบย้อนกลับไม่ได้
    Future.delayed(
      // เวลา
      Duration(
        seconds: 3,
      ),
      // ครบ 3 วิ
      () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ShowAllRunUI(),
          ),
        );
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.tealAccent,
      body: Stack(
        children: [
          //  ชั้นแรก รูปโลโก้ ชื่อแอป
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.width * 0.5,
                  fit: BoxFit.cover,
                ),
                Text(
                  'RUN TRACKER',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.height * 0.035,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                CircularProgressIndicator(
                  color: Colors.black,
                ),
              ],
            ),
          ),
          // ชั้นที่ 2 ข้อความด้านล่าง
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '© 2026 RUN TRACKER',
                  style: TextStyle(
                    color: Colors.blueGrey,
                  ),
                ),
                Text(
                  'Create by Tita SAU TEAM',
                  style: TextStyle(
                    color: Colors.blueGrey,
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
