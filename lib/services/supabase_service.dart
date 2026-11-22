import 'package:flutter_run_tracker_app/models/run.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  //*** ก่อนจะทำงานใดๆ อย่าลืมสร้าง instance/object/ตัวแทน ของ Supabase เพื่อที่จะทำงานใดๆ ***
  final supabase = Supabase.instance.client;

  //1. เมธอดอัปโหลดรูปไปยัง Bucket: run_bk -----------------------------
  Future<String> uploadFileToBucketRun(XFile xFile) async {
    //คำสั่งเปลี่ยนชื่อไฟล์
    final newFileName =
        '${DateTime.now().millisecondsSinceEpoch}_${xFile.name}';

    //คำสั่งอัปโหลดไฟล์
    await supabase.storage.from('run_bk').uploadBinary(
          newFileName,
          await xFile.readAsBytes(),
          fileOptions: FileOptions(contentType: xFile.mimeType),
        );

    //คำสั่งส่งที่อยู่ไฟล์บน Supabase ของไฟล์ที่อัปโหลดไป
    return supabase.storage.from('run_bk').getPublicUrl(newFileName);
  }

  //2. เมธอดเพิ่มข้อมูลไปยัง Table:run_tb --------------------------------
  Future<void> insertDataToTableRun(Run run) async {
    await supabase.from('run_tb').insert(run.toJson());
  }

  //3. เมธอดดึงข้อมูลทั้งหมดจาก Table:run_tb -----------------------------
  Future<List<Run>> getAllDataFromTableRun() async {
    final response = await supabase.from('run_tb').select('*');
    return response.map((e) => Run.fromJson(e)).toList();
  }

  //4. เมธอดลบรูปออกจาก Bucket: run_bk --------------------------------
  Future<void> deleteFileFromBucketRun(String fileName) async {
    await supabase.storage.from('run_bk').remove([fileName]);
  }

  //5. เมธอดแก้ไขข้อมูลใน Table:run_tb ----------------------------------
  Future<void> updateDataToTableRun(Run run, String id) async {
    await supabase.from('run_tb').update(run.toJson()).eq('id', id);
  }

  //6. เมธอดลบข้อมูลออกจาก Table:run_tb --------------------------------
  Future<void> deleteDataFromTableRun(String id) async {
    await supabase.from('run_tb').delete().eq('id', id);
  }
}
