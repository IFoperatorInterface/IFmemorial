class Button {

  private PVector pos;
  private PVector size;
  private color backgroundColor;
  private String name;
  private ButtonPressListener buttonPressListener;


  Button() {
    this.pos = new PVector(0, 0);
    this.size = new PVector(100, 100);
    this.backgroundColor = color(0, 45, 90);
    this.name = "Button";
    this.buttonPressListener = null;
  }


  public Button setPos(int x, int y) {
    this.pos.x = x;
    this.pos.y = y;

    return this;
  }


  public Button setSize(int w, int h) {
    this.size.x = w;
    this.size.y = h;

    return this;
  }


  public Button setBackgroundColor(int r, int g, int b) {
    this.backgroundColor = color(r, g, b);

    return this;
  }


  public Button setPressListener(ButtonPressListener buttonPressListener) {
    this.buttonPressListener = buttonPressListener;

    return this;
  }


  private boolean isInside(int x, int y) {
    if (x < this.pos.x)
      return false;
    if (x > this.pos.x + this.size.x)
      return false;
    if (y < this.pos.y)
      return false;
    if (y > this.pos.y + this.pos.y)
      return false;

    return true;
  }


  public void draw() {
    pushStyle();

    rectMode(CORNER);
    fill(backgroundColor);
    noStroke();

    rect(pos.x, pos.y, size.x, size.y);

    popStyle();
  }


  public void press(int x, int y) {
    if (buttonPressListener == null)
      return;

    if (!isInside(x, y))
      return;

    buttonPressListener.onPress();
  }
}




interface ButtonPressListener {
  public void onPress();
}
