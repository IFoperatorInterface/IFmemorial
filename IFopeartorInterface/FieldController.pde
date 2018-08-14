public class FieldController {
  Integer btSize;
  PVector[] fieldBtsPos;
  int lastTarget;
  boolean mousePressed2;
  int order;

  FieldController() {
    int indx = 0;
    fieldBtsPos = new PVector[6 * 6];
    fieldBtsPos = setFieldPostion();
    btSize = (int) fieldBtsPos[36].x;
    lastTarget = -1;
    mousePressed2 = false;
    order = 0;

    for (int i = 0; i < 6; i++)
      for (int j = 0; j < 6; j++) {
        float x = fieldBtsPos[indx].x;
        float y = fieldBtsPos[indx].y;
        controlP5.addButton("" + (i * 6 + j))
          .setValue(i * 6 + j)
          .setPosition(x, y)
          .setSize(btSize, btSize)
          .setId(i * 6 + j);
        indx++;
      }
  }


  public void checkMouse() {
    int target = -1;

    if (mousePressed2) {
      for (int i=0; i<36; i++){
        if ((mouseX > fieldBtsPos[i].x)
            && (mouseX < fieldBtsPos[i].x+btSize)
            && (mouseY > fieldBtsPos[i].y)
            && (mouseY < fieldBtsPos[i].y+btSize))
          target = i;
      }
    }

    if (lastTarget != -1 && target != lastTarget)
      fieldButton(lastTarget);

    lastTarget = target;
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
    Effect effect = effectController.getEffect();
    if (effect.soundMode == SoundMode.CHORD)
      effect.note += order * 3;

    Trigger trigger = new Trigger(effect, a % 6, a / 6, frameCount);

    moduleView.addTrigger(trigger);
    recordController.addTrigger(trigger);

    logger.log(Log.TRIGGER, a%6, a/6, order+1, effect);

    order++;
  }

   PVector[] setFieldPostion() {
    PVector[] result = new PVector[6 * 6 + 1];
    int padding = 2;
    int spacing = 25;
    int margin = 5;
    int windowWidth = (int) windows[5].size.x - spacing * 2;
    int windowHeight = (int) windows[5].size.y - spacing * 2;
    int windowX = (int) windows[5].pos.x + spacing;
    int windowY = (int) windows[5].pos.y + spacing;
    int btSize = (windowWidth > windowHeight) ? (windowHeight - margin * 2 - padding * 5) / 6 : (windowWidth - margin * 2 - padding * 5) / 6;
    int indx = 0;
    for (int i = 0; i < 6; i++)
      for (int j = 0; j < 6; j++) {
        int x = windowX + (btSize + margin) * j;
        int y = windowY + (btSize + margin) * i;
        result[indx] = new PVector(x, y);
        indx++;
      }
    result[36] = new PVector(btSize, btSize);
    return result;
  }
}