public class DataView {
  private static final float PULL_OUTER_SIZE_THRESHOLD = 0.4;
  private static final float PULL_INNER_SIZE_THRESHOLD = 0.2;
  private static final int PULL_START_COUNT_THRESHOLD = 14;
  private static final int PULL_CHARGE_COUNT_THRESHOLD = 34;

  private int[] pullEndTime;
  private int[] pullCount;
  private PVector[] pullDirection;


  DataView() {
    this.pullEndTime = new int[36];
    this.pullCount = new int[36];
    this.pullDirection = new PVector[36];
  }


  public void draw() {
    // Trigger touch, pull, and jump
    for (int i=0; i<36; i++) {
      int y = i / 6;
      int x = i % 6;

      if (mdata[i].barPos.mag() > PULL_OUTER_SIZE_THRESHOLD) {
        if (pullCount[i] > PULL_START_COUNT_THRESHOLD) {
          presetController.triggerPullStart(x, y, 1);
        }
        pullEndTime[i] = frameCount;
        pullCount[i]++;
      }
      else if (mdata[i].barPos.mag() <= PULL_INNER_SIZE_THRESHOLD) {
        if (pullCount[i] > PULL_CHARGE_COUNT_THRESHOLD) {
          presetController.triggerPullEnd(x, y, pullDirection[i], 1);
        }
        pullCount[i] = 0;
      }
    }
  }
}
