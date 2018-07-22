class Effect {
  public BarMode barMode;
  public int size;
  public int[] position;
  public boolean[] fieldMode;
  public int[] colorRGB;
  public int[][] brightness;


  Effect() {
    barMode = BarMode.BOUNCE;
    size = 50;
    position = new int[2];
    position[0] = 0;
    position[1] = 100;
    fieldMode = new boolean[5];
    colorRGB = new int[3];
    colorRGB[0] = 128;
    colorRGB[1] = 0;
    colorRGB[2] = 255;
    brightness = new int[4][2];
  }


  Effect copy() {
    Effect newEffect = new Effect();

    newEffect.barMode = barMode;
    newEffect.size = size;
    newEffect.position[0] = position[0];
    newEffect.position[1] = position[1];
    newEffect.fieldMode = fieldMode;
    newEffect.colorRGB[0] = colorRGB[0];
    newEffect.colorRGB[1] = colorRGB[1];
    newEffect.colorRGB[2] = colorRGB[2];
    newEffect.brightness = brightness;

    return newEffect;
  }
}
