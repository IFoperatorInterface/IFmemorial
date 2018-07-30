public class DataView {
  private static final float SPEED_THRESHOLD = 0.03;

  private PVector[] curPos;
  private PVector[] prevPos;
  private int[] notJumpedCount;
  private int[] pullEndTime;
  private int[] pullCount;


  DataView() {
    this.curPos = new PVector[36];
    for (int i=0; i<curPos.length; i++)
      curPos[i] = new PVector(0, 0);

    this.prevPos = new PVector[36];
    for (int i=0; i<prevPos.length; i++)
      prevPos[i] = new PVector(0, 0);

    this.notJumpedCount = new int[36];

    this.pullEndTime = new int[36];
    this.pullCount = new int[36];
  }


  public void draw() {
    for (int i=0; i<36; i++) {
      int y = i / 6;
      int x = i % 6;

      curPos[i].x = mdata[i].barPos.x * 0.2 + curPos[i].x * 0.8;
      curPos[i].y = mdata[i].barPos.y * 0.2 + curPos[i].y * 0.8;

      if (curPos[i].mag() > 0.4) {
        if (pullCount[i] > 10)
          presetController.triggerPullStart(x, y, (curPos[i].mag() - 0.4) * 2);
        pullEndTime[i] = frameCount;
        pullCount[i]++;
      }
      else if (curPos[i].mag() < 0.2) {
        if (frameCount - pullEndTime[i] < 5
            && pullCount[i] > 10)
          presetController.triggerPullEnd(x, y, curPos[i]);
        pullCount[i] = 0;
      }

      prevPos[i].x = curPos[i].x;
      prevPos[i].y = curPos[i].y;

      if (mdata[i].isJumped) {
        if (notJumpedCount[i] > 3)
          presetController.triggerJump(x, y);
        notJumpedCount[i] = 0;
      }
      else {
        notJumpedCount[i]++;
      }
    }
  }
}
