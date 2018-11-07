public class DataView {
  private static final float PULL_OUTER_SIZE_THRESHOLD = 0.4;
  private static final float PULL_INNER_SIZE_THRESHOLD = 0.2;
  private static final int PULL_START_COUNT_THRESHOLD = 14;
  private static final int PULL_CHARGE_COUNT_THRESHOLD = 34;
  private static final int PULL_CHARGE_COUNT_MAX = 74;
  private static final int PULL_RELEASE_COUNT_THRESHOLD = 7;
  private static final int NOT_JUMPED_COUNT_THRESHOLD = 5;
  private static final int EMPTY_NEXT_COUNT_INITIAL = 300;
  private static final int NOT_EMPTY_NEXT_COUNT_DELAY_MIN = 30;
  private static final int NOT_EMPTY_NEXT_COUNT_DELAY_MAX = 300;

  private int[] notJumpedCount;
  private int[] pullEndTime;
  private int[] pullCount;
  private PVector[] pullDirection;
  private int[] stopCount;
  private int emptyCount;
  private int emptyNextEvent;
  private int notEmptyCount;
  private int notEmptyNextEvent;


  DataView() {
    this.notJumpedCount = new int[36];

    this.pullEndTime = new int[36];
    this.pullCount = new int[36];
    this.pullDirection = new PVector[36];
    this.stopCount = new int[36];
    for (int i = 0; i < pullDirection.length; i++)
      pullDirection[i] = new PVector();

    this.emptyCount = 0;
    this.notEmptyCount = 0;
    this.emptyCount = 0;
  }


  public void draw() {
    // Trigger touch, pull, and jump
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


    // Trigger welcome and intervene
    if (AUTO_WELCOME_MODE) {
      if (fieldView.riders.size() == 0) {
        emptyCount++;
        notEmptyCount = 0;
        notEmptyNextEvent = 0;

        if (emptyCount > emptyNextEvent) {
          println(emptyCount+"Trigger welcome"+emptyNextEvent);
          emptyNextEvent += 30 * int(random(1, 7));
        }
      }
      else {
        notEmptyCount++;
        emptyCount = 0;
        emptyNextEvent = EMPTY_NEXT_COUNT_INITIAL;

        if (notEmptyCount > notEmptyNextEvent) {
          println(notEmptyCount+"Trigger intervene"+notEmptyNextEvent);
          notEmptyNextEvent += 30 * int(random(1, 7)) + int(random(NOT_EMPTY_NEXT_COUNT_DELAY_MIN, NOT_EMPTY_NEXT_COUNT_DELAY_MAX));
        }
      }
    }
  }
}
