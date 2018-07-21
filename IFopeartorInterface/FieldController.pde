public class FieldController {
  FieldController() {
    for (int i=0; i<6; i++)
      for (int j=0; j<6; j++) {
        controlP5.addButton("fieldButton"+i*6+j)
         .setValue(i*6+j)
         .setPosition((1000+100*j)/SCALE, (300+100*i)/SCALE)
         .setSize(90/SCALE, 90/SCALE)
         .plugTo(this, "fieldButton")
         ;
      }
  }


  void fieldButton(int a) {
    println("Pressed " + a/6 + "," + a%6 + " in field");
  }
}
