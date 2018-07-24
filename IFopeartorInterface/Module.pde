class Module {
  private int x, y;
  private Trigger trigger;

  private int barH = opc.barLength;
  PVector fieldBtsPos;
  int btSize, indx;

  Module(int indx, int x, int y, PVector fieldPos) {
    this.indx = indx;
    this.x = x;
    this.y = y;
    fieldBtsPos = fieldPos;
    btSize = fieldController.btSize;

  }


  public void draw() {
    drawBar();
    // drawLine(64, 0, barH); //TODO: remove this

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

    drawLine(color(trigger.effect.colorRGB[0], trigger.effect.colorRGB[1], trigger.effect.colorRGB[2]), start, end);
  }


  private void blink() {
    int start = 0;
    int end = barH;

    drawLine(color(trigger.effect.colorRGB[0], trigger.effect.colorRGB[1], trigger.effect.colorRGB[2]), start, end);
  }


  private void stretch() {
    float phase = (frameCount - trigger.startTime) / 30.0;
    float ratio = 1 - (phase - 0.5) * (phase - 0.5) * 4;

    int start = 0;
    int end = round(barH * ratio);

    drawLine(color(trigger.effect.colorRGB[0], trigger.effect.colorRGB[1], trigger.effect.colorRGB[2]), start, end);
  }


  private void drawLine(color strokeColor, int start, int end) {
    stroke(strokeColor);
    // line((50+x*130+y*20)/SCALE, (150-end)/SCALE, (50+x*130+y*20)/SCALE, (150-start)/SCALE);
    line(x, y - end, x, y - start);
  }


  public void updateTrigger(Trigger trigger) {
    this.trigger = trigger;
  }
  
  void drawBar() {
    float x = map(mdata[indx].barPos.x, -1, 1, -btSize / 2, btSize / 2);
    float y = map(mdata[indx].barPos.y, -1, 1, -btSize / 2, btSize / 2);

    pushMatrix();
    translate(fieldController.fieldBtsPos[indx].x + btSize / 2, fieldController.fieldBtsPos[indx].y + btSize / 2);
    stroke(255);
    line(0, 0, x, y);
    popMatrix();
  }

}