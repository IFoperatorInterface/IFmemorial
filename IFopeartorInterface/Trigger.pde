class Trigger {
  public final Effect effect;
  public final int x, y;
  public final int startTime;


  Trigger(Effect effect, int x, int y, int startTime) {
    this.effect = effect;
    this.x = x;
    this.y = y;
    this.startTime = startTime;
  }
}
