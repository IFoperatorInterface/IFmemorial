class Module {
  private int x, y;
  private List<Trigger> triggers;
  private static final int MAX_DURATION = 90;

  private int barH;
  PVector pos, fieldPos;
  int btSize, indx;

  Module(int indx, int x, int y, int barH, PVector fieldPos) {
    this.indx = indx;
    this.x = x;
    this.y = y;
    this.barH = barH;
    this.fieldPos = fieldPos;
    this.triggers = new ArrayList<Trigger>();
    pos = new PVector(x, y);
    if (fieldPos != null)
      btSize = fieldController.btSize;

  }


  public void draw() {
    drawBar();

    if (indx != -1)
      drawLine(color(128, 0, 255, mdata[indx].barPos.mag() * 255), 0, 1);

    Iterator < Trigger > triggersIterator = triggers.iterator();
    while (triggersIterator.hasNext()) {
      Trigger trigger = triggersIterator.next();

      if ((float)(frameCount - trigger.startTime) / MAX_DURATION * 100 > trigger.effect.brightness[3][0])
        triggersIterator.remove();
      else {
        switch (trigger.effect.barMode) {
          case BOUNCE:
            bounce(trigger);
            break;
          case BLINK:
            blink(trigger);
            break;
          case STRETCH:
            stretch(trigger);
            break;
        }
      }
    }
  }


  private void bounce(Trigger trigger) {
    float ratio = getRatio(trigger);

    float size = trigger.effect.size / 100.0;
    float start = (1 - size) * map(ratio, 0, 1, trigger.effect.position[0] / 100.0, trigger.effect.position[1] / 100.0);
    float end = start + size;

    drawLine(color(trigger.effect.colorRGB[0], trigger.effect.colorRGB[1], trigger.effect.colorRGB[2]), start, end);
  }


  private void blink(Trigger trigger) {
    float ratio = getRatio(trigger);

    float start = trigger.effect.position[0] / 100.0;
    float end = trigger.effect.position[1] / 100.0;

    drawLine(color(trigger.effect.colorRGB[0], trigger.effect.colorRGB[1], trigger.effect.colorRGB[2], ratio*255), start, end);
  }


  private void stretch(Trigger trigger) {
    float ratio = getRatio(trigger);

    float start = 0;
    float end = map(ratio, 0, 1, trigger.effect.position[0] / 100.0, trigger.effect.position[1] / 100.0);

    drawLine(color(trigger.effect.colorRGB[0], trigger.effect.colorRGB[1], trigger.effect.colorRGB[2]), start, end);
  }


  private float getRatio(Trigger trigger) {
    float phase = (float)(frameCount - trigger.startTime) / MAX_DURATION * 100;
    float ratio = 100;

    for (int i = 3; i >= 1; i--) {
      if (trigger.effect.brightness[i][0] >= phase)
        ratio = map(
          phase,
          trigger.effect.brightness[i - 1][0],
          trigger.effect.brightness[i][0],
          trigger.effect.brightness[i - 1][1],
          trigger.effect.brightness[i][1]
        );
    }

    return ratio / 100;
  }


  private void drawLine(color strokeColor, float start, float end) {
    int strokeW = (fieldPos == null) ? 4 : 1;
    pushStyle();
    strokeWeight(strokeW);
    stroke(strokeColor);
    line(x, y - end * barH, x, y - start * barH);
    popStyle();

    if (fieldPos == null)
      return;

    pushStyle();
    pushMatrix();
    translate(fieldController.fieldBtsPos[indx].x + btSize, fieldController.fieldBtsPos[indx].y);
    stroke(strokeColor);
    strokeWeight(5);
    line(-4, (1 - start) * btSize, -4, (1 - end) * btSize);
    popMatrix();
    popStyle();
  }


  public void addTrigger(Trigger trigger) {
    triggers.add(trigger);
  }

  void drawBar() {
    if (fieldPos == null)
      return;

    float x = map(mdata[indx].barPos.x, -1, 1, -btSize / 2, btSize / 2);
    float y = map(mdata[indx].barPos.y, -1, 1, -btSize / 2, btSize / 2);

    pushMatrix();
    translate(fieldController.fieldBtsPos[indx].x + btSize / 2, fieldController.fieldBtsPos[indx].y + btSize / 2);
    stroke(255);
    line(0, 0, x, y);
    popMatrix();
  }

}