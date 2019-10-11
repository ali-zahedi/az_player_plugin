import 'package:az_player_plugin/az_player_plugin.dart';

class File implements InterfaceFile{
  @override
  final num currentTime;

  @override
  final FileStatus fileStatus;

  @override
  final String fileURL;

  @override
  final String image;

  @override
  final int pk;

  @override
  final String title;

  File(this.pk, this.fileURL, this.title, this.currentTime, this.fileStatus, this.image);

  @override
  Map<String, dynamic> toJson() {
    
    Map<String, dynamic> map = Map();
    map['currentTime'] = currentTime;
    map['fileStatus'] = fileStatus.value;
    map['fileURL'] = fileURL;
    map['image'] = image;
    map['pk'] = pk;
    map['title'] = title;
    
    return map;
  }
	
}