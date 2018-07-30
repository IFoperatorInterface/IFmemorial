class Graph {
  private PVector pos;
  private PVector size;
  private color backgroundColor;
  private int minXValue, maxXValue;
  private int minYValue, maxYValue;
  private int xValue, yValue;
  private String name;
  private GraphChangeListener graphChangeListener;
  private boolean isTargeted;


  Graph() {
    this.pos = new PVector(0, 0);
    this.size = new PVector(100, 100);
    this.backgroundColor = color(0, 45, 90);
    this.minXValue = 0;
    this.maxXValue = 100;
    this.minYValue = 0;
    this.maxYValue = 100;
    this.xValue = 50;
    this.yValue = 50;
    this.name = "Graph";
    this.graphChangeListener = null;
    this.isTargeted = false;
  }


  public Graph setPosition(int x, int y) {
    this.pos.x = x;
    this.pos.y = y;

    return this;
  }


  public Graph setSize(int w, int h) {
    this.size.x = w;
    this.size.y = h;

    return this;
  }


  public Graph setBackgroundColor(int r, int g, int b) {
    this.backgroundColor = color(r, g, b);

    return this;
  }


  public Graph setMinMax(int minXValue, int minYValue, int maxXValue, int maxYValue) {
    if (minXValue >= maxXValue)
      throw new RuntimeException();
    if (minYValue >= maxYValue)
      throw new RuntimeException();

    this.minXValue = minXValue;
    this.minYValue = minYValue;
    this.maxXValue = maxXValue;
    this.maxYValue = maxYValue;

    this.xValue = constrain(xValue, minXValue, maxXValue);
    this.yValue = constrain(yValue, minYValue, maxYValue);

    return this;
  }


  public Graph setValue(int xValue, int yValue) {
    this.xValue = constrain(xValue, minXValue, maxXValue);
    this.yValue = constrain(yValue, minYValue, maxYValue);

    return this;
  }


  public Graph setName(String name) {
    this.name = name;

    return this;
  }


  public Graph setChangeListener(GraphChangeListener graphChangeListener) {
    this.graphChangeListener = graphChangeListener;

    return this;
  }


  private boolean isInside(int x, int y) {
    if (x < this.pos.x)
      return false;
    if (x > this.pos.x + this.size.x)
      return false;
    if (y < this.pos.y)
      return false;
    if (y > this.pos.y + this.size.y)
      return false;

    return true;
  }


  private int xToValue(int x) {
    return (int) map(x, this.pos.x, this.pos.x + this.size.x, minXValue, maxXValue);
  }


  private int yToValue(int y) {
    return (int) map(y, this.pos.y + this.size.y, this.pos.y, minYValue, maxYValue);
  }


  private int valueToX(int value) {
    return (int) map(value, minXValue, maxXValue, this.pos.x, this.pos.x + this.size.x);
  }


  private int valueToY(int value) {
    return (int) map(value, minYValue, maxYValue, this.pos.y + this.size.y, this.pos.y);
  }


  public void draw() {
    if (isTargeted)
      change(xToValue(mouseX), yToValue(mouseY));

    pushStyle();

    rectMode(CORNER);
    fill(backgroundColor);
    noStroke();

    rect(pos.x, pos.y, size.x, size.y);

    fill(255);
    textAlign(CENTER, CENTER);
    textFont(titleFont);

    text(name.toUpperCase(), pos.x + size.x / 2, pos.y + size.y / 2);

    popStyle();
  }


  public void mousePressed() {
    isTargeted = isInside(mouseX, mouseY);
  }


  public void mouseReleased() {
    if (isTargeted)
      change(xToValue(mouseX), yToValue(mouseY));

    isTargeted = false;
  }


  private void change(int xValue, int yValue) {
    setValue(xValue, yValue);
    println(xValue, yValue);

    if (graphChangeListener != null)
      graphChangeListener.onChange(this.xValue, this.yValue);
  }
}




interface GraphChangeListener {
  public void onChange(int xValue, int yValue);
}
