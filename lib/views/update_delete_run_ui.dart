import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_run_tracker_app/models/run.dart';
import 'package:flutter_run_tracker_app/services/supabase_service.dart';
import 'package:image_picker/image_picker.dart';

class UpdateDeleteRunUI extends StatefulWidget {
  //สร้างตัวแปรรับข้อมูลวิ่งที่ส่งมา
  Run? runDataShowUD;

  //เอาตัวแปรที่สร้างไว้มารับค่าที่ส่งมา
  UpdateDeleteRunUI({super.key, this.runDataShowUD});

  @override
  State<UpdateDeleteRunUI> createState() => _UpdateDeleteRunUIState();
}

class _UpdateDeleteRunUIState extends State<UpdateDeleteRunUI> {
  // คำสั่งส่วนของการเปิดกล้อง+แกลอรี่
  Uint8List? imageByte; //เก็บรูปที่จะใช้แสดงบน ui
  XFile? xFile; //เก็บรูปที่จะใช้อัปโหลดไป supabase

  // method เปิดกล้อง
  Future<void> openCameraAndTakePicture() async {
    final pickImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    // เอารูปที่ถ่ายไปกำหนดให้กับตัวแปรด้านบนที่สร้างไว้
    if (pickImage != null) {
      final bytes = await pickImage.readAsBytes();
      setState(() {
        imageByte = bytes;
        xFile = pickImage;
      });
    }
  }

  // method เปิดแกลอรี่
  Future<void> openGalleryAndSelectPicture() async {
    final pickImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    // เอารูปที่ถ่ายไปกำหนดให้กับตัวแปรด้านบนที่สร้างไว้
    if (pickImage != null) {
      final bytes = await pickImage.readAsBytes();
      setState(() {
        imageByte = bytes;
        xFile = pickImage;
      });
    }
  }

  // ตัวควบคุม Textfield
  TextEditingController runWhereCtrl = TextEditingController();
  TextEditingController runPersonCtrl = TextEditingController();
  TextEditingController runDistanceCtrl = TextEditingController();

  @override
  void initState() {
    // เอาข้อมูล
    runWhereCtrl.text = widget.runDataShowUD!.runWhere!;
    runPersonCtrl.text = widget.runDataShowUD!.runPerson!;
    runDistanceCtrl.text = widget.runDataShowUD!.runDistance!.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ส่วนของ appBar
      appBar: AppBar(
        backgroundColor: Colors.tealAccent,
        title: Text(
          'Run Tracker (แก้ไข/ลบ)',
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
          ),
        ),
      ),
      // ส่วนของ body
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: 50,
            left: 40,
            right: 40,
          ),
          child: Center(
            child: Column(
              children: [
                //------------------------------
                xFile != null
                    ? InkWell(
                        onTap: () {
                          openCameraAndTakePicture();
                        },
                        child: Image.memory(
                          imageByte!,
                          width: MediaQuery.of(context).size.width * 0.30,
                          height: MediaQuery.of(context).size.width * 0.30,
                          fit: BoxFit.cover,
                        ),
                      )
                    : widget.runDataShowUD!.runImageUrl! != ''
                        ? InkWell(
                            onTap: () {
                              openCameraAndTakePicture();
                            },
                            child: Image.network(
                              widget.runDataShowUD!.runImageUrl!,
                              width: MediaQuery.of(context).size.width * 0.30,
                              height: MediaQuery.of(context).size.width * 0.30,
                              fit: BoxFit.cover,
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              openCameraAndTakePicture();
                            },
                            child: Image.asset(
                              'assets/images/logo.png',
                              width: MediaQuery.of(context).size.width * 0.30,
                            ),
                          ),
                //------------------------------
                SizedBox(
                  height: 30,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'วิ่งที่ไหน',
                  ),
                ),
                TextField(
                  controller: runWhereCtrl,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'วิ่งกับใคร',
                  ),
                ),
                TextField(
                  controller: runPersonCtrl,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'ระยะทาง (kg)',
                  ),
                ),
                TextField(
                  controller: runDistanceCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                ElevatedButton(
                  onPressed: () async {
                    // Validate UI
                    if (runWhereCtrl.text.isEmpty ||
                        runPersonCtrl.text.isEmpty ||
                        runDistanceCtrl.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('กรุณาป้อนข้อมูลให้ครบ'),
                          backgroundColor: Colors.redAccent,
                          duration: Duration(seconds: 2),
                        ),
                      );

                      return; //ห้ามลืมใส่!!!
                    }
                    //upload file ไป Bucket และบันทึกข้อมูลลง Table
                    // ตรวจสอบก่อนว่าได้ถ่ายหรือเลือกรูปมั้ย
                    String imageUrl = '';
                    if (xFile != null) {
                      // แปลว่ามีรูป ก็จะทำการอัปโหลด
                      //ก่อน upload รูปใหม่ ตรวจสอบก่อนว่ามีรูปมั้ย ถ้ามีต้องลบทิ้ง
                      if (widget.runDataShowUD!.runImageUrl! != '') {
                        //ลบไฟล์ออกจาก Bucket ใน Storage
                        await SupabaseService().deleteFileFromBucketRun(
                          widget.runDataShowUD!.runImageUrl!.split('/').last,
                        );
                      }

                      imageUrl =
                          await SupabaseService().uploadFileToBucketRun(xFile!);
                    } else {
                      //กรณี xFile ไม่เท่ากับ null แปลว่าเขาไม่ได้แก้ไขรูป
                      imageUrl = widget.runDataShowUD!.runImageUrl!;
                    }

                    // บันทึกข้อมูลลง Table
                    Run run = Run(
                      runWhere: runWhereCtrl.text,
                      runPerson: runPersonCtrl.text,
                      runDistance: int.parse(runDistanceCtrl.text),
                      runImageUrl: imageUrl,
                    );

                    // ส่งข้อมูลที่แพ็กไว้ไปบันทึก
                    await SupabaseService()
                        .updateDataToTableRun(run, widget.runDataShowUD!.id!);

                    // บันทึกเสร็จแสดงข้อความแจ้ง
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('บันทึกข้อมูลเสร็จสิ้น'),
                        backgroundColor: Colors.greenAccent,
                        duration: Duration(seconds: 2),
                      ),
                    );

                    // กลับไปหน้าหลัก
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(
                      MediaQuery.of(context).size.width,
                      MediaQuery.of(context).size.width * 0.12,
                    ),
                    backgroundColor: Colors.greenAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'บันทึกแก้ไขข้อมูล',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () async {
                    //ปุ่มลบข้อมูลออกจาก Table ใน Database บน Supabase
                    //แต่หากข้อมูลนั้นมีไฟล์ใน Bucket ใน Storage ต้องลบด้วย
                    // ตรวจสอบว่ามีไฟล์ใน Bucket หรือไม่ ถ้ามีให้ลบไปด้วย
                    if (widget.runDataShowUD!.runImageUrl! != '') {
                      //ลบไฟล์ออกจาก Bucket ใน Storage
                      await SupabaseService().deleteFileFromBucketRun(
                        widget.runDataShowUD!.runImageUrl!.split('/').last,
                      );
                    }

                    //ลบข้อมูลออกจาก Table ใน Database บน Supabase
                    await SupabaseService()
                        .deleteDataFromTableRun(widget.runDataShowUD!.id!);

                    //แสดงข้อความแจ้งเตือนว่าลบข้อมูลเสร็จสิ้นด้วย SnackBar
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'ลบข้อมูลเสร็จสิ้น',
                        ),
                        backgroundColor: Colors.greenAccent,
                        duration: Duration(seconds: 2),
                      ),
                    );

                    //กลับไปหน้าหลัก
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(
                      MediaQuery.of(context).size.width,
                      MediaQuery.of(context).size.width * 0.12,
                    ),
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'ลบข้อมูล',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
