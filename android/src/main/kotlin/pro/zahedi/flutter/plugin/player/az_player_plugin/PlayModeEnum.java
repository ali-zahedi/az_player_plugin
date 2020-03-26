package pro.zahedi.flutter.plugin.player.az_player_plugin;

public enum PlayModeEnum {

    SHUFFLE("SHUFFLE"),
    REPEAT_ALL("REPEAT_ALL"),
    REPEAT_ONE("REPEAT_ONE"),
    OFF("OFF");

    String mode;

    PlayModeEnum(String mode) {
        this.mode = mode;
    }

    public static PlayModeEnum mode(String label) {
        for (PlayModeEnum e : values()) {
            if (e.mode.equals(label)) {
                return e;
            }
        }
        return null;
    }
}
