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
    brightness = new int[4][2];
  }
}
