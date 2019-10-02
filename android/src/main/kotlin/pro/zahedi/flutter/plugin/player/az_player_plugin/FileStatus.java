package pro.zahedi.flutter.plugin.player.az_player_plugin;

public enum  FileStatus {

    undefined, playing, pause, stop, ready;

    public static FileStatus fromRawValue(int rawValue){
        switch (rawValue){
            case 0:{
                return FileStatus.undefined;
            }case 1:{
                return FileStatus.playing;
            }case 2:{
                return FileStatus.pause;
            }case 3:{
                return FileStatus.stop;
            }case 4:{
                return FileStatus.ready;
            }
        }
        return FileStatus.undefined;
    }

}
