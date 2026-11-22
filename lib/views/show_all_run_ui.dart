import 'package:flutter/material.dart';
import 'package:flutter_run_tracker_app/models/run.dart';
import 'package:flutter_run_tracker_app/services/supabase_service.dart';
import 'package:flutter_run_tracker_app/views/add_run_ui.dart';
import 'package:flutter_run_tracker_app/views/update_delete_run_ui.dart';

class ShowAllRunUI extends StatefulWidget {
  const ShowAllRunUI({super.key});

  @override
  State<ShowAllRunUI> createState() => _ShowAllRunUIState();
}

class _ShowAllRunUIState extends State<ShowAllRunUI> {
  //สร้างตัวแปรเก็บข้อมูลการวิ่งที่จะไปดึงมาจาก Supabase
  List<Run>? runs;

  //สร้าง method คำสั่งไปดึงข้อมูลการวิ่งจาก Supabase
  Future<void> fetchAllRuns() async {
    //ไปดึงข้อมูลที่ Supabase
    final data = await SupabaseService().getAllDataFromTableRun();

    //เอาข้อมูลที่ได้มาใส่ในตัวแปร runs ที่สร้างไว้เพื่อเอาไปใช้ที่หน้าจอ
    setState(() {
      runs = data;
    });
  }

  @override
  void initState() {
    // เรียกใช้งานคำสั่งที่ดึงข้อมูลจาก Supabase
    fetchAllRuns();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ส่วนของ appBar
      appBar: AppBar(
        backgroundColor: Colors.tealAccent,
        title: Text(
          'Run Tracker',
        ),
        centerTitle: true,
      ),
      // ส่วนของ floatingActionButton
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          //  เปิดไป AddRunUI() แบบย้อนกลับได้
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddRunUI(),
            ),
          );

          // เรียกใช้งานดึงข้อมูลจาก Supabase มาใหม่
          fetchAllRuns();
        },
        backgroundColor: Colors.tealAccent,
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // ส่วนของ body
      body: Padding(
        padding: EdgeInsets.only(
          left: 30,
          right: 30,
        ),
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Image.asset(
                'assets/images/logo.png',
                width: MediaQuery.of(context).size.width * 0.35,
                height: MediaQuery.of(context).size.width * 0.35,
                fit: BoxFit.cover,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.025,
              ),
              Text(
                'วิ่งกันเถอะ',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.025,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.025,
              ),
              //ส่วนแสดงข้อมูลการวิ่งที่ไปดึงมา
              Expanded(
                child: ListView.builder(
                  itemCount: runs?.length ?? 0,
                  itemBuilder: (context, index) {
                    return Card(
                      color: index % 2 == 0
                          ? Color(0xff98ffe6)
                          : Color(0xffcbfff3),
                      child: ListTile(
                        onTap: () async {
                          //เปิดไปหน้าจอ UpdateDeleteRunUI() แบบย้อนกลับได้ เวลาย้อนกลับมาดึงข้อมูลมาใหม่
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdateDeleteRunUI(
                                runDataShowUD: runs![index],
                              ),
                            ),
                          );
                          // เรียกใช้งานดึงข้อมูลจาก Supabase มาใหม่
                          fetchAllRuns();
                        },
                        title: Text(
                          'วิ่งที่ไหน: ${runs![index].runWhere}',
                        ),
                        subtitle: Text(
                          'วิ่งไปเท่าไหร่ ${runs![index].runDistance} กม.',
                        ),
                        trailing: Icon(
                          Icons.info,
                          color: Colors.redAccent,
                        ),
                        leading: runs![index].runImageUrl == ""
                            ? Image.asset(
                                'assets/images/logo.png',
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                runs![index].runImageUrl!,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
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
