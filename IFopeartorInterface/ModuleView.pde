class ModuleView {
  private List<Trigger> triggers;
  private Module modules[][];
  private static final int ROWS = 6;
  private static final int COLUMNS = 6;


  ModuleView() {
    triggers = new ArrayList<Trigger>();
    modules = new Module[6][6];

    for (int i=0; i<ROWS; i++)
      for (int j=0; j<COLUMNS; j++)
        modules[i][j] = new Module(i, j);
  }


  public void draw() {
    for (int i=0; i<ROWS; i++)
      for (int j=0; j<COLUMNS; j++)
        modules[i][j].draw();

    println();
    for (Trigger t : triggers)
      println(t.x + "," + t.y + "," + t.startTime);
  }


  public void addTrigger(Trigger trigger) {
    triggers.add(trigger);
  }
}
