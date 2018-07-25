public class DataView {
  private static final float SPEED_THRESHOLD = 0.03;
  private static final float SIZE_THRESHOLD = 0.1;

  private PVector[] prevPos;
  private int[] stopCount;
  private int[] notJumpedCount;


  DataView() {
    this.prevPos = new PVector[36];
    for (int i=0; i<prevPos.length; i++)
      prevPos[i] = new PVector(0, 0);

    this.stopCount = new int[36];
    this.notJumpedCount = new int[36];
  }


  public void draw() {
    for (int i=0; i<36; i++) {
      int y = i / 6;
      int x = i % 6;

      if (mdata[i].barPos.dist(prevPos[i]) < SPEED_THRESHOLD) {
        if (mdata[i].barPos.mag() > SIZE_THRESHOLD) {
          if (stopCount[i] > 30)
            presetController.trigger(Preset.TOUCH, x, y);
          stopCount[i] = 0;
        }
        else {
          stopCount[i]++;
        }
      }

      prevPos[i].x = mdata[i].barPos.x;
      prevPos[i].y = mdata[i].barPos.y;

      if (mdata[i].isJumped) {
        if (notJumpedCount[i] > 3)
          presetController.trigger(Preset.JUMP, x, y);
        notJumpedCount[i] = 0;
      }
      else {
        notJumpedCount[i]++;
      }
    }
  }
}
