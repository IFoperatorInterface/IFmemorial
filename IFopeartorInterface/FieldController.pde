public class FieldController {
  private static final int ROWS = 1;
  private static final int COLUMNS = 16;

  Integer btSize;
  PVector[] fieldBtsPos;
  int lastTarget;
  boolean mousePressed2;
  int order;

  FieldController() {
    int indx = 0;
    fieldBtsPos = new PVector[ROWS * COLUMNS];
    fieldBtsPos = setFieldPostion();
    btSize = (int) fieldBtsPos[ROWS * COLUMNS].x;
    lastTarget = -1;
    mousePressed2 = false;
    order = 0;

    for (int i = 0; i < ROWS; i++)
      for (int j = 0; j < COLUMNS; j++) {
        float x = fieldBtsPos[indx].x;
        float y = fieldBtsPos[indx].y;
        controlP5.addButton("" + (i * COLUMNS + j))
          .setValue(i * COLUMNS + j)
          .setPosition(x, y)
          .setSize(btSize, btSize)
          .setId(i * COLUMNS + j);
        indx++;
      }
  }


  public void checkMouse() {
    int target = -1;

    if (mousePressed2) {
      target = getTarget();
    }

    if (target != -1)
      fieldButtonHold(target);

    if (lastTarget != -1 && target != lastTarget)
      fieldButton(lastTarget);

    lastTarget = target;
  }


  private int getTarget() {
    int target = -1;

    for (int i=0; i<ROWS*COLUMNS; i++){
      if ((mouseX > fieldBtsPos[i].x)
          && (mouseX < fieldBtsPos[i].x+btSize)
          && (mouseY > fieldBtsPos[i].y)
          && (mouseY < fieldBtsPos[i].y+btSize))
        target = i;
    }

    return target;
  }


  public void onDraw() {
    checkMouse();
  }


  public void onMousePressed() {
    order = 0;
    mousePressed2 = true;
  }


  public void onMouseReleased() {
    checkMouse();

    mousePressed2 = false;
  }


  void fieldButton(int a) {
    presetController.triggerPullEnd(a%COLUMNS, a/COLUMNS, new PVector(0, 0), 0);
  }

  void fieldButtonHold(int a) {
    presetController.triggerPullStart(a%COLUMNS, a/COLUMNS, random(0, 100));
  }

   PVector[] setFieldPostion() {
    PVector[] result = new PVector[ROWS * COLUMNS + 1];
    int padding = 2;
    int spacing = 25;
    int margin = 5;
    int windowWidth = (int) windows[5].size.x - spacing * 2;
    int windowHeight = (int) windows[5].size.y - spacing * 2;
    int windowX = (int) windows[5].pos.x + spacing;
    int windowY = (int) windows[5].pos.y + spacing;
    int btSize = (windowWidth > windowHeight) ? (windowHeight - margin * 2 - padding * 5) / 16 : (windowWidth - margin * 2 - padding * 5) / 16;
    int indx = 0;
    for (int i = 0; i < ROWS; i++)
      for (int j = 0; j < COLUMNS; j++) {
        int x = windowX + (btSize + margin) * j;
        int y = windowY + (btSize + margin) * i;
        result[indx] = new PVector(x, y);
        indx++;
      }
    result[ROWS * COLUMNS] = new PVector(btSize, btSize);
    return result;
  }
}