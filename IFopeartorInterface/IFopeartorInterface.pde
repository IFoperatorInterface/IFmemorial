import controlP5.*;


ControlP5 controlP5;
EffectController effectController;
final int SCALE = 2;


void setup() {
  size(960, 540);

  controlP5 = new ControlP5(this);
  effectController = new EffectController();
}


void draw() {
  background(0);
}
