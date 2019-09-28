package pro.zahedi.flutter.plugin.player.az_player_plugin;

public class File {

    int pk;
    String title;
    double currentTime;
    String fileURL;
    // image path
    String image;
    FileStatus fileStatus = FileStatus.ready;

    File(int pk, String title, double currentTime, String fileURL, String image, FileStatus fileStatus){
        this.pk = pk;
        this.title = title;
        this.currentTime = currentTime;
        this.fileURL = fileURL;
        this.image = image;
        this.fileStatus = fileStatus;
    }
}
