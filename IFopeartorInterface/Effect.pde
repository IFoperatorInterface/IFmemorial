class Effect {
  public SoundMode soundMode;
  public int note;
  public BarMode barMode;
  public int size;
  public int[] position;
  public int spread;
  public boolean[] fieldMode;
  public PVector direction;
  public int diameter;
  public int[] colorRGB;
  public int[][] brightness;
  public boolean noCenter;
  public int id;


  Effect() {
    soundMode = SoundMode.SINGLE;
    note = 60;
    barMode = BarMode.BOUNCE;
    size = 30;
    position = new int[2];
    position[0] = 10;
    position[1] = 90;
    spread = 50;
    fieldMode = new boolean[5];
    direction = null;
    diameter = 50;
    colorRGB = new int[3];
    colorRGB[0] = 128;
    colorRGB[1] = 0;
    colorRGB[2] = 255;
    brightness = new int[4][2];
    brightness[0] = new int[]{0, 0};
    brightness[1] = new int[]{30, 100};
    brightness[2] = new int[]{60, 100};
    brightness[3] = new int[]{90, 0};
    noCenter = false;
    id = -1;
  }


  Effect copy() {
    Effect newEffect = new Effect();

    newEffect.soundMode = soundMode;
    newEffect.note = note;
    newEffect.barMode = barMode;
    newEffect.size = size;
    newEffect.position[0] = position[0];
    newEffect.position[1] = position[1];
    newEffect.spread = spread;
    newEffect.fieldMode[0] = fieldMode[0];
    newEffect.fieldMode[1] = fieldMode[1];
    newEffect.fieldMode[2] = fieldMode[2];
    newEffect.fieldMode[3] = fieldMode[3];
    newEffect.fieldMode[4] = fieldMode[4];
    newEffect.direction = direction;
    newEffect.diameter = diameter;
    newEffect.colorRGB[0] = colorRGB[0];
    newEffect.colorRGB[1] = colorRGB[1];
    newEffect.colorRGB[2] = colorRGB[2];
    newEffect.brightness[0][0] = brightness[0][0];
    newEffect.brightness[0][1] = brightness[0][1];
    newEffect.brightness[1][0] = brightness[1][0];
    newEffect.brightness[1][1] = brightness[1][1];
    newEffect.brightness[2][0] = brightness[2][0];
    newEffect.brightness[2][1] = brightness[2][1];
    newEffect.brightness[3][0] = brightness[3][0];
    newEffect.brightness[3][1] = brightness[3][1];
    newEffect.noCenter = noCenter;
    newEffect.id = id;

    return newEffect;
  }


  public String toString() {
    String result = "";
    result += soundMode + "/";
    result += (soundMode!=SoundMode.RANDOM ? note : "") + "/";
    result += String.format("#%02X%02X%02X", colorRGB[0], colorRGB[1], colorRGB[2]) + "/";
    result += barMode + "/";
    result += (barMode==BarMode.BOUNCE ? size : "") + "/";
    result += String.format("%d-%d", position[0], position[1]) + "/";
    result += String.format("(%d.%d)-(%d.%d)-(%d.%d)-(%d.%d)", brightness[0][0], brightness[0][1], brightness[1][0], brightness[1][1], brightness[2][0], brightness[2][1], brightness[3][0], brightness[3][1]) + "/";
    result += (fieldMode[0]||fieldMode[1]||fieldMode[2]||fieldMode[3]||fieldMode[4] ? spread : "") + "/";
    result += (fieldMode[FieldMode.UP.ordinal()] ? "U" : "");
    result += (fieldMode[FieldMode.DOWN.ordinal()] ? "D" : "");
    result += (fieldMode[FieldMode.LEFT.ordinal()] ? "L" : "");
    result += (fieldMode[FieldMode.RIGHT.ordinal()] ? "R" : "");
    result += (fieldMode[FieldMode.ELLIPSE.ordinal()] ? "E" : "") + "/";
    result += (fieldMode[FieldMode.ELLIPSE.ordinal()] ? diameter : "");

    return result;
  }
}
