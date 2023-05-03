import 'dart:async';
import 'dart:io';

Future<FileSystemEntity?> recentFile(Directory recordDir) async {
  FileSystemEntity? target;
  await Future.delayed(const Duration(seconds: 1));
  if (await recordDir.exists()) {
    List<FileSystemEntity> files = await recordDir.list().toList();
    files
        .sort((a, b) => b.statSync().modified.compareTo(a.statSync().modified));
    target = files.first;
  } else {
    target = null;
  }
  return target;
}
