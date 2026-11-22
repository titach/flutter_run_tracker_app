import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_run_tracker_app/models/run.dart';
import 'package:flutter_run_tracker_app/services/supabase_service.dart';
import 'package:image_picker/image_picker.dart';

class AddRunUI extends StatefulWidget {
  const AddRunUI({super.key});

  @override
  State<AddRunUI> createState() => _AddRunUIState();
}

class _AddRunUIState extends State<AddRunUI> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      // ส่วนของ appBar
      appBar: AppBar(
        backgroundColor: Colors.tealAccent,
        title: Text(
          'Run Tracker (เพิ่ม)',
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
                // ternary op _ ? _ : _
                xFile == null
                    ? InkWell(
                        onTap: () {
                          // เปิดกล้องเพื่อถ่ายูป/เปิด gallery เพื่อเลือกภาพ
                          showModalBottomSheet(
                            backgroundColor: Colors.tealAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(0),
                              ),
                            ),
                            context: context,
                            builder: (context) => Wrap(
                              children: [
                                ListTile(
                                  leading: Icon(
                                    Icons.camera_alt,
                                  ),
                                  title: Text(
                                    'เปิดกล้อง',
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);
                                    openCameraAndTakePicture();
                                  },
                                ),
                                ListTile(
                                  leading: Icon(
                                    Icons.photo_library,
                                  ),
                                  title: Text(
                                    'แกลอรี่',
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);
                                    openGalleryAndSelectPicture();
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                        child: Icon(
                          Icons.add_a_photo_rounded,
                          size: MediaQuery.of(context).size.width * 0.35,
                          color: Colors.grey,
                        ),
                      )
                    : InkWell(
                        onTap: () {
                          // เปิดกล้องเพื่อถ่ายูป/เปิด gallery เพื่อเลือกภาพ
                          showModalBottomSheet(
                            backgroundColor: Colors.tealAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(0),
                              ),
                            ),
                            context: context,
                            builder: (context) => Wrap(
                              children: [
                                ListTile(
                                  leading: Icon(
                                    Icons.camera_alt,
                                  ),
                                  title: Text(
                                    'เปิดกล้อง',
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);
                                    openCameraAndTakePicture();
                                  },
                                ),
                                ListTile(
                                  leading: Icon(
                                    Icons.photo_library,
                                  ),
                                  title: Text(
                                    'แกลอรี่',
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);
                                    openGalleryAndSelectPicture();
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                        child: Image.memory(
                          imageByte!,
                          width: MediaQuery.of(context).size.width * 0.35,
                          height: MediaQuery.of(context).size.width * 0.35,
                          fit: BoxFit.cover,
                        ),
                      ),
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
                    hintText: 'เช่น สวนสาธารณะ, สนามกีฬา, ...',
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
                    hintText: 'เช่น เพื่อน, ครอบครัว, ...',
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
                    hintText: 'เช่น 1, 5, ...',
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
                      imageUrl =
                          await SupabaseService().uploadFileToBucketRun(xFile!);
                    }

                    // บันทึกข้อมูลลง Table
                    Run run = Run(
                      runWhere: runWhereCtrl.text,
                      runPerson: runPersonCtrl.text,
                      runDistance: int.parse(runDistanceCtrl.text),
                      runImageUrl: imageUrl,
                    );

                    // ส่งข้อมูลที่แพ็กไว้ไปบันทึก
                    await SupabaseService().insertDataToTableRun(run);

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
                    'บันทึกข้อมูล',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    // เคลียร์ข้อมูลบนหน้าจอ
                    setState(() {
                      runWhereCtrl.text = '';
                      runPersonCtrl.text = '';
                      runDistanceCtrl.text = '';
                    });
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
                    'ยกเลิก',
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
