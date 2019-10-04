import 'package:az_player_plugin/az_player_plugin.dart';

abstract class InterfaceFile {
  final int pk;
  final String title;
  final num currentTime;
  final String fileURL;
  final String imagePath;
  final FileStatus fileStatus;

  InterfaceFile(this.pk, this.title, this.currentTime, this.fileURL,
      this.imagePath, this.fileStatus);

  Map<String, dynamic> toJson();
}
