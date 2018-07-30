class Slider {
  private PVector pos;
  private PVector size;
  private color backgroundColor;
  private color foregroundColor;
  private int minValue, maxValue;
  private int value;
  private String name;
  private SliderChangeListener sliderChangeListener;
  private boolean isTargeted;


  Slider() {
    this.pos = new PVector(0, 0);
    this.size = new PVector(100, 100);
    this.backgroundColor = color(0, 45, 90);
    this.foregroundColor = color(0, 116, 217);
    this.minValue = 0;
    this.maxValue = 100;
    this.value = 50;
    this.name = "Slider";
    this.sliderChangeListener = null;
    this.isTargeted = false;
  }


  public Slider setPosition(int x, int y) {
    this.pos.x = x;
    this.pos.y = y;

    return this;
  }


  public Slider setSize(int w, int h) {
    this.size.x = w;
    this.size.y = h;

    return this;
  }


  public Slider setBackgroundColor(int r, int g, int b) {
    this.backgroundColor = color(r, g, b);

    return this;
  }


  public Slider setForegroundColor(int r, int g, int b) {
    this.foregroundColor = color(r, g, b);

    return this;
  }


  public Slider setRange(int minValue, int maxValue) {
    if (minValue >= maxValue)
      throw new RuntimeException();

    this.minValue = minValue;
    this.maxValue = maxValue;

    setValue(value);

    return this;
  }


  public Slider setValue(int value) {
    this.value = constrain(value, minValue, maxValue);

    return this;
  }


  public Slider setName(String name) {
    this.name = name;

    return this;
  }


  public Slider setChangeListener(SliderChangeListener sliderChangeListener) {
    this.sliderChangeListener = sliderChangeListener;

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


  private int yToValue(int y) {
    return (int) map(y, this.pos.y + this.size.y, this.pos.y, minValue, maxValue);
  }


  private int valueToY(int value) {
    return (int) map(value, minValue, maxValue, this.pos.y + this.size.y, this.pos.y);
  }


  public void draw() {
    if (isTargeted)
      change(yToValue(mouseY));

    pushStyle();

    rectMode(CORNER);
    fill(backgroundColor);
    noStroke();

    rect(pos.x, pos.y, size.x, size.y);

    rectMode(CORNERS);
    fill(foregroundColor);

    rect(pos.x, valueToY(value), pos.x + size.x, pos.y + size.y);

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
      change(yToValue(mouseY));

    isTargeted = false;
  }


  private void change(int value) {
    setValue(value);

    if (sliderChangeListener != null)
      sliderChangeListener.onChange(this.value);
  }
}




interface SliderChangeListener {
  public void onChange(int value);
}
