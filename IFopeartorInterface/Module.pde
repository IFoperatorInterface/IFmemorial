class Module {
  private int x, y, btSize;
  private Trigger trigger;
  private int barH = opc.barLength;
  Integer indx;
  Boolean isJumped, isStanding;
  float[] pressures = new float[4];
  PVector barPos;
  PVector fieldBtsPos;

  Module(int indx, int x, int y, PVector fieldPos, int btSize) {
    this.indx = indx;
    this.x = x;
    this.y = y;
    this.btSize = btSize;
    fieldBtsPos = fieldPos;

    isJumped = false;
    isStanding = false;

    for (float prss: pressures) {
      prss = 0.0;
    }

    barPos = new PVector(0, 0);
  }

  public void draw() {

    drawLine(64, 0, barH); //TODO: remove this

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

  public void drawBar() {
    float x = map(barPos.x, 0, 1, 0, btSize / 2);
    float y = map(barPos.y, 0, 1, 0, btSize / 2);
    pushMatrix();
    translate(fieldBtsPos.x + btSize / 2, fieldBtsPos.y + btSize / 2);
    stroke(100);
    line(0, 0, x, y);
    popMatrix();
  }
}