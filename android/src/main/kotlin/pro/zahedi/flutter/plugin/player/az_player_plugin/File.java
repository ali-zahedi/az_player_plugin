package pro.zahedi.flutter.plugin.player.az_player_plugin;

import java.util.Map;

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

    public static File fromJson(Map<String, Object> model)
    {
       FileStatus fileStatus = FileStatus.ready;
       return new File((int) model.get("pk"),
               (String) model.get("title"),
               Double.parseDouble(model.get("currentTime").toString()),
               (String) model.get("fileURL"),
               (String) model.get("image"),
               fileStatus.fromRawValue((Integer) model.get("fileStatus")));
    }
}
