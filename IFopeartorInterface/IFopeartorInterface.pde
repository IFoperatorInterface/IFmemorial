import controlP5.*;


ControlP5 controlP5;
EffectController effectController;
FieldController fieldController;
ModuleView moduleView;
final int SCALE = 2;


void setup() {
  size(960, 540);

  controlP5 = new ControlP5(this);
  effectController = new EffectController();
  fieldController = new FieldController();
  moduleView = new ModuleView();
}


void draw() {
  background(0);
  moduleView.draw();
}
