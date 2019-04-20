public class DataView {
  private static final float PULL_OUTER_SIZE_THRESHOLD = 0.3; // Pull 인식 거리 threshold. 단위: 0-?
  private static final float PULL_INNER_SIZE_THRESHOLD = 0.1; // Pull 놓음 인식 거리 threshold. Outer 값보다 작아야 함. 단위: 0-?
  private static final int PULL_START_COUNT_THRESHOLD = 18; // Pull 당김 인식 시간 threshold. 너무 짧으면 놓은 뒤 흔들릴때마다 pull로 인식. 단위: frame
  private static final int PULL_CHARGE_COUNT_THRESHOLD = 30; // Pull 놓음 인식 시간 threshold. 너무 짧으면 놓은 뒤 흔들릴때마다 pull로 인식. 단위: frame

  private static final int ROWS = 1;
  private static final int COLUMNS = 16;

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
    //println("adfa");
    for (int i=0; i<36 && i<ROWS*COLUMNS; i++) {
      int y = i / COLUMNS;
      int x = i % COLUMNS;
      
      if (mdata[i].barPos.mag() > PULL_OUTER_SIZE_THRESHOLD) {
        if (pullCount[i] > PULL_START_COUNT_THRESHOLD) {
          presetController.triggerPullStart(x, y, 1);
          moduleView.pullStart(x, y);
        }
        pullEndTime[i] = frameCount;
        pullCount[i]++;
      }
      
      else if (mdata[i].barPos.mag() <= PULL_INNER_SIZE_THRESHOLD) {
        if (pullCount[i] > PULL_CHARGE_COUNT_THRESHOLD) {
          presetController.triggerPullEnd(x, y, pullDirection[i], 1);
        }
        moduleView.pullEnd(x, y);
        pullCount[i] = 0;
      }
    }
  }
}
