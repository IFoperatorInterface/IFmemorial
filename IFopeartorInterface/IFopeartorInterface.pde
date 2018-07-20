import controlP5.*;


ControlP5 controlP5;
EffectController effectController;
FieldController fieldController;
final int SCALE = 2;


void setup() {
  size(960, 540);

  controlP5 = new ControlP5(this);
  effectController = new EffectController();
  fieldController = new FieldController();
}


void draw() {
  background(0);
}
