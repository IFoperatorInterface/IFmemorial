class ModuleView {
  private Module modules[][];
  private static final int ROWS = 6;
  private static final int COLUMNS = 6;


  ModuleView() {
    modules = new Module[6][6];

    for (int i=0; i<ROWS; i++)
      for (int j=0; j<COLUMNS; j++)
        modules[i][j] = new Module(i, j);
  }


  public void draw() {
    for (int i=0; i<ROWS; i++)
      for (int j=0; j<COLUMNS; j++)
        modules[i][j].draw();
  }
}
