color ledColor;
class ModuleView {
  private List < Trigger > triggers;
  private Module modules[][];
  private static final int ROWS = 6;
  private static final int COLUMNS = 6;
  private static final int DELAY = 5;

  private List < Rider > riders;
  
  ModuleView() {
    triggers = new ArrayList < Trigger > ();
    modules = new Module[6][6];
    riders = new ArrayList < Rider > ();

    int indx = 0;
    PVector[] fieldBtsPos = new PVector[ROWS * COLUMNS];
    fieldBtsPos = fieldController.setFieldPostion();
    for (int i = 0; i < ROWS; i++)
      for (int j = 0; j < COLUMNS; j++) {
        int x = (int) opc.ledStripPos[indx].x;
        int y = (int) opc.ledStripPos[indx].y;
        PVector loc = fieldBtsPos[indx];
        int btSize = (int) fieldBtsPos[36].x;
        modules[i][j] = new Module(indx, x, y, loc, btSize);
        indx++;
      }
    ledColor = controlP5.get(ColorWheel.class, "ledColor").getRGB();
  }



  public void draw() {
    for (int i = 0; i < ROWS; i++) {
      for (int j = 0; j < COLUMNS; j++) {
        modules[i][j].draw();
        modules[i][j].drawBar();
      }
    }
    for (Rider r: riders) {
      r.draw();
    }

    // Remove old trigger in triggers
    Iterator < Trigger > triggersIterator = triggers.iterator();
    while (triggersIterator.hasNext()) {
      Trigger t = triggersIterator.next();

      int phase = frameCount - t.startTime;

      if ((phase > DELAY * ROWS) &&
        (phase > DELAY * COLUMNS))
        triggersIterator.remove();

      if (phase == 1)
        modules[t.y][t.x].updateTrigger(new Trigger(t.effect, t.x, t.y, frameCount));

      if (phase % DELAY == 1) {
        int distance = (frameCount - t.startTime) / DELAY;

        if (t.effect.fieldMode[FieldMode.UP.ordinal()]) {
          int y = t.y - distance;
          if (y >= 0)
            modules[y][t.x].updateTrigger(new Trigger(t.effect, t.x, t.y, frameCount));
        }

        if (t.effect.fieldMode[FieldMode.DOWN.ordinal()]) {
          int y = t.y + distance;
          if (y < 6)
            modules[y][t.x].updateTrigger(new Trigger(t.effect, t.x, t.y, frameCount));
        }

        if (t.effect.fieldMode[FieldMode.LEFT.ordinal()]) {
          int x = t.x - distance;
          if (x >= 0)
            modules[t.y][x].updateTrigger(new Trigger(t.effect, t.x, t.y, frameCount));
        }

        if (t.effect.fieldMode[FieldMode.RIGHT.ordinal()]) {
          int x = t.x + distance;
          if (x < 6)
            modules[t.y][x].updateTrigger(new Trigger(t.effect, t.x, t.y, frameCount));
        }

        if (t.effect.fieldMode[FieldMode.ELLIPSE.ordinal()]) {
          for (int x=0; x<6; x++)
            for (int y=0; y<6; y++)
              if ((int)sqrt((x-t.x)*(x-t.x) + (y-t.y)*(y-t.y)) == distance)
                modules[y][x].updateTrigger(new Trigger(t.effect, t.x, t.y, frameCount));
        }
      }
    }
  }


  public void addTrigger(Trigger trigger) {
    triggers.add(trigger);
  }
}