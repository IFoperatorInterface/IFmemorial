class Effect {
  private BarMode barMode;
  private boolean[] fieldMode;
  private int[] colorRGB;
  private int[][] brightness;


  Effect() {
    barMode = BarMode.BOUNCE;
    fieldMode = new boolean[5];
    colorRGB = new int[3];
    brightness = new int[4][2];
  }
}
