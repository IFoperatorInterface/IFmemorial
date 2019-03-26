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
  public String name;


  Effect() {
    soundMode = SoundMode.CHORD;
    note = 45;
    barMode = BarMode.STRETCH;
    size = 30;
    position = new int[2];
    position[0] = 0;
    position[1] = 30;
    spread = 50;
    fieldMode = new boolean[5];
    fieldMode[FieldMode.LEFT.ordinal()] = true;
    fieldMode[FieldMode.RIGHT.ordinal()] = true;
    direction = null;
    diameter = 50;
    colorRGB = new int[3];
    colorRGB[0] = 240;
    colorRGB[1] = 215;
    colorRGB[2] = 0;
    brightness = new int[4][2];
    brightness[0] = new int[]{0, 0};
    brightness[1] = new int[]{30, 80};
    brightness[2] = new int[]{46, 100};
    brightness[3] = new int[]{80, 0};
    noCenter = false;
    id = -1;
    name = "";
  }


  Effect(String s) {
    String[] words = (s+"/.").split("/");
    this.soundMode = SoundMode.valueOf(words[0]);
    this.note = Integer.parseInt(words[1]);
    this.colorRGB = new int[3];
    this.colorRGB[0] = Integer.parseInt(words[2].substring(1, 3), 16);
    this.colorRGB[1] = Integer.parseInt(words[2].substring(3, 5), 16);
    this.colorRGB[2] = Integer.parseInt(words[2].substring(5, 7), 16);
    this.barMode = BarMode.valueOf(words[3]);
    this.size = Integer.parseInt("0"+words[4]);
    String[] positions = words[5].split("-");
    this.position = new int[2];
    this.position[0] = Integer.parseInt(positions[0]);
    this.position[1] = Integer.parseInt(positions[1]);
    String[] brightnesses = words[6].substring(1, words[6].length()-1).split("\\.|\\)-\\(");
    this.brightness = new int[4][2];
    this.brightness[0][0] = Integer.parseInt(brightnesses[0]);
    this.brightness[0][1] = Integer.parseInt(brightnesses[1]);
    this.brightness[1][0] = Integer.parseInt(brightnesses[2]);
    this.brightness[1][1] = Integer.parseInt(brightnesses[3]);
    this.brightness[2][0] = Integer.parseInt(brightnesses[4]);
    this.brightness[2][1] = Integer.parseInt(brightnesses[5]);
    this.brightness[3][0] = Integer.parseInt(brightnesses[6]);
    this.brightness[3][1] = Integer.parseInt(brightnesses[7]);
    this.spread = Integer.parseInt("0"+words[7]);
    fieldMode = new boolean[5];
    fieldMode[FieldMode.UP.ordinal()] = (words[8].indexOf("U") != -1);
    fieldMode[FieldMode.DOWN.ordinal()] = (words[8].indexOf("D") != -1);
    fieldMode[FieldMode.LEFT.ordinal()] = (words[8].indexOf("L") != -1);
    fieldMode[FieldMode.RIGHT.ordinal()] = (words[8].indexOf("R") != -1);
    fieldMode[FieldMode.ELLIPSE.ordinal()] = (words[8].indexOf("E") != -1);
    this.diameter = Integer.parseInt("0"+words[9]);
    this.id = Integer.parseInt(words[10]);
    this.name = words[11];
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
    newEffect.name = name;

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
    result += (fieldMode[FieldMode.ELLIPSE.ordinal()] ? diameter : "") + "/";
    result += id + "/";
    result += name;

    return result;
  }
}
