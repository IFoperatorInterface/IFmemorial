public class DataView {
  private static final float SPEED_THRESHOLD = 0.03;

  private PVector[] curPos;
  private PVector[] prevPos;
  private int[] stopCount;
  private int[] notJumpedCount;
  private PVector[] maxPos;
  private int[] pullEndTime;
  private int[] pullCount;


  DataView() {
    this.curPos = new PVector[36];
    for (int i=0; i<curPos.length; i++)
      curPos[i] = new PVector(0, 0);

    this.prevPos = new PVector[36];
    for (int i=0; i<prevPos.length; i++)
      prevPos[i] = new PVector(0, 0);

    this.stopCount = new int[36];
    this.notJumpedCount = new int[36];

    this.maxPos = new PVector[36];
    for (int i=0; i<36; i++)
      maxPos[i] = new PVector(0, 0);

    this.pullEndTime = new int[36];
    this.pullCount = new int[36];
  }


  public void draw() {
    for (int i=0; i<36; i++) {
      int y = i / 6;
      int x = i % 6;

      curPos[i].x = mdata[i].barPos.x * 0.2 + curPos[i].x * 0.8;
      curPos[i].y = mdata[i].barPos.y * 0.2 + curPos[i].y * 0.8;

      if (curPos[i].dist(prevPos[i]) < curPos[i].mag() * 0.1) {
        if (stopCount[i] == 0) {
          PVector newMaxPos = new PVector(curPos[i].x, curPos[i].y);

          if (maxPos[i].dist(newMaxPos) > 0.05
              && maxPos[i].dist(PVector.mult(newMaxPos, -1)) > 0.05
              && newMaxPos.mag() < 0.4)
            presetController.trigger(Preset.TOUCH, x, y);

          maxPos[i] = newMaxPos;
        }
        stopCount[i]++;
      }
      else {
        stopCount[i] = 0;
      }

      if (curPos[i].mag() > 0.4) {
        if (pullCount[i] > 10)
          presetController.triggerPullStart(x, y, (curPos[i].mag() - 0.4) * 2);
        pullEndTime[i] = frameCount;
        pullCount[i]++;
      }
      else if (curPos[i].mag() < 0.2) {
        if (frameCount - pullEndTime[i] < 5
            && pullCount[i] > 10)
          presetController.triggerPullEnd(x, y, 0);
        pullCount[i] = 0;
      }

      prevPos[i].x = curPos[i].x;
      prevPos[i].y = curPos[i].y;

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
