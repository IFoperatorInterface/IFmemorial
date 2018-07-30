public class DataView {
  private static final float SPEED_THRESHOLD = 0.03;

  private PVector[] prevPos;
  private int[] stopCount;
  private int[] notJumpedCount;
  private PVector[] maxPos;


  DataView() {
    this.prevPos = new PVector[36];
    for (int i=0; i<prevPos.length; i++)
      prevPos[i] = new PVector(0, 0);

    this.stopCount = new int[36];
    this.notJumpedCount = new int[36];

    this.maxPos = new PVector[36];
    for (int i=0; i<36; i++)
      maxPos[i] = new PVector(0, 0);
  }


  public void draw() {
    for (int i=0; i<36; i++) {
      int y = i / 6;
      int x = i % 6;

      if (mdata[i].barPos.dist(prevPos[i]) < SPEED_THRESHOLD) {
        if (stopCount[i] == 0) {
          PVector newMaxPos = new PVector(mdata[i].barPos.x, mdata[i].barPos.y);

          if (maxPos[i].dist(newMaxPos) > 0.05
              && maxPos[i].dist(PVector.mult(newMaxPos, -1)) > 0.05)
            presetController.trigger(Preset.TOUCH, x, y);

          maxPos[i] = newMaxPos;
        }
        stopCount[i]++;
      }
      else {
        stopCount[i] = 0;
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
