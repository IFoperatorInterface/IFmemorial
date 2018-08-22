public class DataView {
  private static final float TOUCH_ACCEL_THRESHOLD = 0.02;
  private static final float TOUCH_POS_THRESHOLD = 0.15;
  private static final float PULL_OUTER_SIZE_THRESHOLD = 0.4;
  private static final float PULL_INNER_SIZE_THRESHOLD = 0.2;
  private static final int PULL_START_COUNT_THRESHOLD = 7;
  private static final int PULL_CHARGE_COUNT_THRESHOLD = 27;
  private static final int PULL_CHARGE_COUNT_MAX = 52;
  private static final int PULL_RELEASE_COUNT_THRESHOLD = 7;
  private static final int NOT_JUMPED_COUNT_THRESHOLD = 5;

  private int[] notJumpedCount;
  private int[] pullEndTime;
  private int[] pullCount;
  private PVector[] pullDirection;
  private float[][] position;
  private float[][] speed;


  DataView() {
    this.notJumpedCount = new int[36];

    this.pullEndTime = new int[36];
    this.pullCount = new int[36];
    this.pullDirection = new PVector[36];
    this.position = new float[36][2];
    this.speed = new float[36][2];
    for (int i = 0; i < pullDirection.length; i++)
      pullDirection[i] = new PVector();
  }


  public void draw() {
    for (int i=0; i<36; i++) {
      int y = i / 6;
      int x = i % 6;

      float positionX = mdata[i].barPos.x * 0.4 + position[i][0] * 0.6;
      float positionY = mdata[i].barPos.y * 0.4 + position[i][1] * 0.6;
      float speedX = positionX - position[i][0];
      float speedY = positionY - position[i][1];
      float accelX = speedX - speed[i][0];
      float accelY = speedY - speed[i][1];

      position[i][0] = positionX;
      position[i][1] = positionY;
      speed[i][0] = speedX;
      speed[i][1] = speedY;
      float posMag = sqrt(sq(positionX) + sq(positionY));
      float accelMag = sqrt(sq(accelX) + sq(accelY));

      if (accelMag > TOUCH_ACCEL_THRESHOLD
          && posMag < TOUCH_POS_THRESHOLD) {
        presetController.triggerTouch(x, y);
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
