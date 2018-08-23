public class DataView {
  private static final float PULL_OUTER_SIZE_THRESHOLD = 0.4;
  private static final float PULL_INNER_SIZE_THRESHOLD = 0.2;
  private static final int PULL_START_COUNT_THRESHOLD = 14;
  private static final int PULL_CHARGE_COUNT_THRESHOLD = 34;
  private static final int PULL_CHARGE_COUNT_MAX = 74;
  private static final int PULL_RELEASE_COUNT_THRESHOLD = 7;
  private static final int NOT_JUMPED_COUNT_THRESHOLD = 5;

  private int[] notJumpedCount;
  private int[] pullEndTime;
  private int[] pullCount;
  private PVector[] pullDirection;
  private int[] stopCount;


  DataView() {
    this.notJumpedCount = new int[36];

    this.pullEndTime = new int[36];
    this.pullCount = new int[36];
    this.pullDirection = new PVector[36];
    this.stopCount = new int[36];
    for (int i = 0; i < pullDirection.length; i++)
      pullDirection[i] = new PVector();
  }


  public void draw() {
    for (int i=0; i<36; i++) {
      int y = i / 6;
      int x = i % 6;

      if (mdata[i].barPos.mag() < 0.15) {
        stopCount[i]++;
      }
      else if (mdata[i].barPos.mag() >= 0.25) {
        if (stopCount[i] > 30) {
          presetController.triggerTouch(x, y);
        }
        stopCount[i] = 0;
      }

      if (mdata[i].barPos.mag() > PULL_OUTER_SIZE_THRESHOLD) {
        if (pullCount[i] > PULL_START_COUNT_THRESHOLD) {
          float size = map(pullCount[i], PULL_START_COUNT_THRESHOLD, PULL_CHARGE_COUNT_MAX, 0, 1);
          size = constrain(size, 0, 1);
          presetController.triggerPullStart(x, y, size);
        }
        pullEndTime[i] = frameCount;
        pullCount[i]++;
      }
      else if (mdata[i].barPos.mag() > PULL_INNER_SIZE_THRESHOLD) {
        if (frameCount - pullEndTime[i] == 1)
          pullDirection[i].set(mdata[i].barPos);
      }
      else {
        if (frameCount - pullEndTime[i] < PULL_RELEASE_COUNT_THRESHOLD
            && pullCount[i] > PULL_CHARGE_COUNT_THRESHOLD) {
          float size = map(pullCount[i], PULL_START_COUNT_THRESHOLD, PULL_CHARGE_COUNT_MAX, 0, 1);
          size = constrain(size, 0, 1);
          presetController.triggerPullEnd(x, y, pullDirection[i], size);
        }
        pullCount[i] = 0;
      }

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
