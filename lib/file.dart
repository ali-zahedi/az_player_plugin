import 'package:az_player_plugin/az_player_plugin.dart';

class File implements InterfaceFile{
  @override
  final num currentTime;

  @override
  final FileStatus fileStatus;

  @override
  final String fileURL;

  @override
  final String imagePath;

  @override
  final int pk;

  @override
  final String title;

  File(this.currentTime, this.fileStatus, this.fileURL, this.imagePath, this.pk, this.title);

  @override
  Map<String, dynamic> toJson() {
    
    Map<String, dynamic> map = Map();
    map['currentTime'] = currentTime;
    map['fileStatus'] = fileStatus.value;
    map['fileURL'] = fileURL;
    map['imagePath'] = imagePath;
    map['pk'] = pk;
    map['title'] = title;
    
    return map;
  }
	
}