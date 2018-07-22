class ModuleView {
  private List < Trigger > triggers;
  private Module modules[][];
  private static final int ROWS = 6;
  private static final int COLUMNS = 6;
  private static final int DELAY = 5;


  ModuleView() {
    triggers = new ArrayList < Trigger > ();
    modules = new Module[6][6];
    int indx = 0;
    for (int i = 0; i < ROWS; i++)
      for (int j = 0; j < COLUMNS; j++) {
        int x = (int) opc.ledStripPos[indx].x;
        int y = (int) opc.ledStripPos[indx].y;
        modules[i][j] = new Module(x, y);
        indx++;
      }
  }


  public void draw() {
    for (int i = 0; i < ROWS; i++)
      for (int j = 0; j < COLUMNS; j++)
        modules[i][j].draw();

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

      if (t.effect.fieldMode[FieldMode.UP.ordinal()] && (phase % DELAY == 1)) {
        int y = t.y - (frameCount - t.startTime) / DELAY;
        if (y >= 0)
          modules[y][t.x].updateTrigger(new Trigger(t.effect, t.x, t.y, frameCount));
      }

      if (t.effect.fieldMode[FieldMode.DOWN.ordinal()] && (phase % DELAY == 1)) {
        int y = t.y + (frameCount - t.startTime) / DELAY;
        if (y < 6)
          modules[y][t.x].updateTrigger(new Trigger(t.effect, t.x, t.y, frameCount));
      }

      if (t.effect.fieldMode[FieldMode.LEFT.ordinal()] && (phase % DELAY == 1)) {
        int x = t.x - (frameCount - t.startTime) / DELAY;
        if (x >= 0)
          modules[t.y][x].updateTrigger(new Trigger(t.effect, t.x, t.y, frameCount));
      }

      if (t.effect.fieldMode[FieldMode.RIGHT.ordinal()] && (phase % DELAY == 1)) {
        int x = t.x + (frameCount - t.startTime) / DELAY;
        if (x < 6)
          modules[t.y][x].updateTrigger(new Trigger(t.effect, t.x, t.y, frameCount));
      }
    }
  }


  public void addTrigger(Trigger trigger) {
    triggers.add(trigger);
  }
}