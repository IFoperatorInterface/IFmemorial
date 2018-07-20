class Module {
  private int x, y;


  Module(int x, int y) {
    this.x = x;
    this.y = y;
  }


  public void draw() {
    stroke(192);
    line((50+x*130+y*20)/SCALE, 50/SCALE, (50+x*130+y*20)/SCALE, 150/SCALE);
  }
}
