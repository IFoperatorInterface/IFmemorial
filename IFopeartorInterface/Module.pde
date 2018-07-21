class Module {
  private int x, y;
  private Trigger trigger;


  Module(int x, int y) {
    this.x = x;
    this.y = y;
  }


  public void draw() {
    drawLine(64, 0, 100);

    if (trigger != null) {
      drawLine(255, trigger.effect.position[0], trigger.effect.position[1]);
    }
  }


  private void drawLine(int strokeColor, int start, int end) {
    stroke(strokeColor);
    line((50+x*130+y*20)/SCALE, (50+start)/SCALE, (50+x*130+y*20)/SCALE, (50+end)/SCALE);
  }


  public void updateTrigger(Trigger trigger) {
    this.trigger = trigger;
    println("updateTrigger");
  }
}
