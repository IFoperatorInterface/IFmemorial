public class DataView {
  private static final float SPEED_THRESHOLD = 0.03;
  private static final float PULL_OUTER_SIZE_THRESHOLD = 0.3;
  private static final float PULL_INNER_SIZE_THRESHOLD = 0.15;
  private static final int PULL_START_COUNT_THRESHOLD = 7;
  private static final int PULL_CHARGE_COUNT_THRESHOLD = 52;
  private static final int PULL_RELEASE_COUNT_THRESHOLD = 5;
  private static final int NOT_JUMPED_COUNT_THRESHOLD = 5;

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

      if (curPos[i].mag() > PULL_OUTER_SIZE_THRESHOLD) {
        if (pullCount[i] > PULL_START_COUNT_THRESHOLD) {
          float size = map(pullCount[i], PULL_START_COUNT_THRESHOLD, PULL_CHARGE_COUNT_THRESHOLD, 0, 1);
          size = constrain(size, 0, 1);
          presetController.triggerPullStart(x, y, size);
        }
        pullEndTime[i] = frameCount;
        pullCount[i]++;
      }
      else if (curPos[i].mag() < PULL_INNER_SIZE_THRESHOLD) {
        if (frameCount - pullEndTime[i] < PULL_RELEASE_COUNT_THRESHOLD
            && pullCount[i] > PULL_CHARGE_COUNT_THRESHOLD)
          presetController.triggerPullEnd(x, y, curPos[i]);
        pullCount[i] = 0;
      }

      prevPos[i].x = curPos[i].x;
      prevPos[i].y = curPos[i].y;

      if (mdata[i].isJumped) {
        if (notJumpedCount[i] > NOT_JUMPED_COUNT_THRESHOLD)
          presetController.triggerJump(x, y);
        notJumpedCount[i] = 0;
      }
      else {
        notJumpedCount[i]++;
      }
    }
  }
}
