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

    float start = 0.8 * ratio;
    float end = start + 0.2;

    drawLine(color(trigger.effect.colorRGB[0], trigger.effect.colorRGB[1], trigger.effect.colorRGB[2]), start, end);
  }


  private void blink() {
    float start = 0;
    float end = 1;

    drawLine(color(trigger.effect.colorRGB[0], trigger.effect.colorRGB[1], trigger.effect.colorRGB[2]), start, end);
  }


  private void stretch() {
    float phase = (frameCount - trigger.startTime) / 30.0;
    float ratio = 1 - (phase - 0.5) * (phase - 0.5) * 4;

    float start = 0;
    float end = ratio;

    drawLine(color(trigger.effect.colorRGB[0], trigger.effect.colorRGB[1], trigger.effect.colorRGB[2]), start, end);
  }


  private void drawLine(color strokeColor, float start, float end) {
    stroke(strokeColor);
    // line((50+x*130+y*20)/SCALE, (150-end)/SCALE, (50+x*130+y*20)/SCALE, (150-start)/SCALE);
    line(x, y - end * barH, x, y - start * barH);
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