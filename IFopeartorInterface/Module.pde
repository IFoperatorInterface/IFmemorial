class Module {
  private int x, y;
  private Trigger trigger;
  private int barH = opc.barLength;
  Integer indx;
  Boolean isJumped, isStanding;
  float[] pressures = new float[4];
  PVector barPos;

  Module(int indx, int x, int y) {
    this.indx = indx;
    this.x = x;
    this.y = y;

    isJumped = false;
    isStanding = false;

    for (float prss: pressures) {
      prss = 0.0;
    }

    barPos = new PVector(0, 0);
  }
  
  public void draw() {
    drawLine(64, 0, barH);

    if (trigger != null) {
      switch (trigger.effect.barMode) {
        case BOUNCE:
          bounce();
          break;
        case BLINK:
          blink();
          break;
        case STRETCH:
          stretch();
          break;
      }

      if (frameCount - trigger.startTime >= 30)
        trigger = null;
    }
  }


  private void bounce() {
    float phase = (frameCount - trigger.startTime) / 30.0;
    float ratio = 1 - (phase - 0.5) * (phase - 0.5) * 4;

    int start = round(80 * ratio);
    int end = start + 20;

    drawLine(255, start, end);
  }


  private void blink() {
    int start = 0;
    int end = barH;

    drawLine(255, start, end);
  }


  private void stretch() {
    float phase = (frameCount - trigger.startTime) / 30.0;

    int start = 0;
    int end = round(barH * phase);

    drawLine(255, start, end);
  }


  private void drawLine(int strokeColor, int start, int end) {
    stroke(strokeColor);
    // line((50+x*130+y*20)/SCALE, (150-end)/SCALE, (50+x*130+y*20)/SCALE, (150-start)/SCALE);
    line(x, y - end, x, y + start);
  }


  public void updateTrigger(Trigger trigger) {
    this.trigger = trigger;
  }
}