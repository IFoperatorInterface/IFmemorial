class Module {
  private static final float BASE_LEVEL_DEFAULT = 0.05;
  private static final float BASE_LEVEL_MAX = 0.6;
  private static final float BASE_LEVEL_INCREASE_RATE_LOW = 0.84;
  private static final float BASE_LEVEL_INCREASE_RATE_HIGH = 0.94;
  private static final float BASE_LEVEL_DECREASE_RATE = 0.998;

  private static final int WAVE_OPACITY = 70;
  private static final int BLINK_OPACITY = 70;
  private static final int PARTICLE_OPACITY_MAX = (int)(240/1.2);

  private static final float BASE_LEVEL_INCREASE_PULLED = 0.2;
  private static final int PULL_MAX_TIME = 11;
  private static final int WAVE_TIME_DISTANCE = 12;
  private static final int OPACITY_PULLED = 90;

  private static final int NOTE_MIN = 45;
  private static final int NOTE_MAX = 65;

  private int x, y;
  private List<Trigger> triggers;
  private static final int MAX_DURATION = 90;
  private float alpha;
  private float maxSize;

  private int barH;
  PVector pos, fieldPos;
  int btSize, indx;
  private float baseLevel;
  private boolean isPulled;
  private int note;
  private int pullStartTime;

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
    this.baseLevel = BASE_LEVEL_DEFAULT;
    this.isPulled = false;
  }


  public void draw() {
    drawBar();
    Effect effect = effectController.getEffect();
    if (!isPulled)
      drawLine(color(effect.colorRGB[0], effect.colorRGB[1], effect.colorRGB[2]), 0, baseLevel);
    else {
      float baseLevelIncrease = constrain(map(frameCount-pullStartTime, 0, PULL_MAX_TIME, 0, BASE_LEVEL_INCREASE_PULLED), 0, BASE_LEVEL_INCREASE_PULLED);
      drawLine(color(effect.colorRGB[0], effect.colorRGB[1], effect.colorRGB[2]), 0, baseLevel+baseLevelIncrease);
    }
    //if (isPulled) {
      //float opacity = constrain(map(frameCount-pullStartTime, 0, PULL_MAX_TIME, 0, OPACITY_PULLED), 0, OPACITY_PULLED);
      //drawLine(color(effect.colorRGB[0], effect.colorRGB[1], effect.colorRGB[2], opacity), 0, 1);
    //}

    Iterator < Trigger > triggersIterator = triggers.iterator();
    while (triggersIterator.hasNext()) {
      Trigger trigger = triggersIterator.next();

      if ((float)(frameCount - trigger.startTime - WAVE_TIME_DISTANCE) / MAX_DURATION * 100 > trigger.effect.brightness[3][0])
        triggersIterator.remove();
      else {
        switch (trigger.effect.barMode) {
          case BOUNCE:
            if (isPulled)
              bounce(trigger);
            break;
          case BLINK:
            blink(trigger);
            break;
          case STRETCH:
            if (!isPulled)
              stretch(trigger);
            break;
        }
      }
    }

    drawLine(color(0, 0, 0, random(0, BLINK_OPACITY)), 0, 1);
    baseLevel = (baseLevel - BASE_LEVEL_DEFAULT) * BASE_LEVEL_DECREASE_RATE + BASE_LEVEL_DEFAULT;
  }


  private void bounce(Trigger trigger) {
    float ratio = getRatio(trigger, 0);

    float size = trigger.effect.size / 100.0;
    float start = (1 - size) * map(ratio, 0, 1, trigger.effect.position[0] / 100.0, trigger.effect.position[1] / 100.0);
    float end = start + size;

    drawLine(color(trigger.effect.colorRGB[0], trigger.effect.colorRGB[1], trigger.effect.colorRGB[2], PARTICLE_OPACITY_MAX*(1.2-ratio)), start, end);
  }


  private void blink(Trigger trigger) {
    float ratio = getRatio(trigger, 0);

    float start = trigger.effect.position[0] / 100.0;
    float end = trigger.effect.position[1] / 100.0;

    drawLine(color(trigger.effect.colorRGB[0], trigger.effect.colorRGB[1], trigger.effect.colorRGB[2], ratio*255), start, end);
  }


  private void stretch(Trigger trigger) {
    float ratio = getRatio(trigger, 0);

    float start = 0;
    float end = map(ratio, 0, 1, trigger.effect.position[0] / 100.0, trigger.effect.position[1] / 100.0) + baseLevel;

    drawLine(color(trigger.effect.colorRGB[0], trigger.effect.colorRGB[1], trigger.effect.colorRGB[2], WAVE_OPACITY), start, end);

    ratio = getRatio(trigger, -WAVE_TIME_DISTANCE);
    end = map(ratio, 0, 1, trigger.effect.position[0] / 100.0, trigger.effect.position[1] / 100.0) + baseLevel;
    drawLine(color(trigger.effect.colorRGB[0], trigger.effect.colorRGB[1], trigger.effect.colorRGB[2], WAVE_OPACITY), start, end);

    ratio = getRatio(trigger, WAVE_TIME_DISTANCE);
    end = map(ratio, 0, 1, trigger.effect.position[0] / 100.0, trigger.effect.position[1] / 100.0) + baseLevel;
    drawLine(color(trigger.effect.colorRGB[0], trigger.effect.colorRGB[1], trigger.effect.colorRGB[2], WAVE_OPACITY), start, end);
  }


  private float getRatio(Trigger trigger, int shift) {
    float phase = (float)(frameCount - trigger.startTime + shift) / MAX_DURATION * 100;
    float ratio = 100;

    if (phase <= trigger.effect.brightness[0][0])
      return trigger.effect.brightness[0][1];
    else if (phase > trigger.effect.brightness[3][0])
      return trigger.effect.brightness[3][1];

    for (int i = 1; i < 4; i++) {
      if (trigger.effect.brightness[i][0] >= phase) {
        ratio = map(
          phase,
          trigger.effect.brightness[i - 1][0],
          trigger.effect.brightness[i][0],
          trigger.effect.brightness[i - 1][1],
          trigger.effect.brightness[i][1]
        );
        break;
      }
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
    strokeCap(SQUARE);
    translate(fieldController.fieldBtsPos[indx].x + btSize, fieldController.fieldBtsPos[indx].y);
    stroke(strokeColor);
    strokeWeight(3);
    line(-4, (1 - start) * btSize * 2 + btSize, -4, (1 - end) * btSize * 2 + btSize);
    popMatrix();
    popStyle();
  }


  public void addTrigger(Trigger trigger) {
    if (indx == -1)
      triggers.clear();

    triggers.add(trigger);
  }

  public void increaseBaseLevel() {
    baseLevel = BASE_LEVEL_MAX - (BASE_LEVEL_MAX - baseLevel) * random(BASE_LEVEL_INCREASE_RATE_LOW, BASE_LEVEL_INCREASE_RATE_HIGH);
  }

  void drawBar() {
    if (fieldPos == null)
      return;

    float x = map(mdata[indx].barPos.x, -1, 1, -btSize / 2, btSize / 2);
    float y = map(mdata[indx].barPos.y, -1, 1, -btSize / 2, btSize / 2);

    pushMatrix();
    translate(fieldController.fieldBtsPos[indx].x + btSize / 2, fieldController.fieldBtsPos[indx].y + btSize / 2);
    stroke(255);
    strokeWeight(2);
    line(0, 0, x, y);
    popMatrix();
  }

  public int getNote() {
    return note;
  }

  public void pullStart() {
    if (!isPulled) {
      note = (int)map(baseLevel, BASE_LEVEL_DEFAULT, BASE_LEVEL_MAX, NOTE_MIN, NOTE_MAX) + (int)random(-1, 1);
      pullStartTime = frameCount;
    }
    isPulled = true;
  }

  public void pullEnd() {
    isPulled = false;
  }
}