public class FieldController {
  FieldController() {
    int indx = 0;
    PVector[] fieldBtsPos = new PVector[6 * 6];
    fieldBtsPos = setFieldPostion();
    int btSize = (int) fieldBtsPos[36].x;

    for (int i = 0; i < 6; i++)
      for (int j = 0; j < 6; j++) {
        float x = fieldBtsPos[indx].x;
        float y = fieldBtsPos[indx].y;
        controlP5.addButton("" + (i * 6 + j))
          .setValue(i * 6 + j)
          .setPosition(x, y)
          .setSize(btSize, btSize)
          .setId(i * 6 + j)
          .plugTo(this, "fieldButton");
        indx++;
      }
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


  void fieldButton(int a) {
    Trigger trigger = new Trigger(effectController.getEffect(), a % 6, a / 6, frameCount);

    moduleView.addTrigger(trigger);
  }
}