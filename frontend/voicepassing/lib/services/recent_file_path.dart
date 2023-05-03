import 'dart:async';
import 'dart:io';

Future<String?> recentFilePath(Directory recordDir) async {
  String? target;
  await Future.delayed(const Duration(seconds: 1));
  if (await recordDir.exists()) {
    List<FileSystemEntity> files = await recordDir.list().toList();
    files
        .sort((a, b) => b.statSync().modified.compareTo(a.statSync().modified));
    target = files.first.path;
  } else {
    target = null;
  }
  return target;
}
