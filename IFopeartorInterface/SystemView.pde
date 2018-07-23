class SystemView {
    Title[] ledBehaviorTiltles = new Title[3];
    Title[] fieldDirectionTitles = new Title[6];
    SystemView() {

    }
    void draw() {
        for (Title t: fieldDirectionTitles){
            t.display();
        }
            
        
        for (Title t: ledBehaviorTiltles)
            t.display();

        for (Window w: windows)
            w.display();


        for (int i = 0; i < effectController.adrPointers.length; i++)
            effectController.adrPointers[i].draw();

        stroke(255);
        line(effectController.adrPointers[0].pos.x, effectController.adrPointers[0].pos.y, effectController.adrPointers[1].pos.x, effectController.adrPointers[1].pos.y);
        line(effectController.adrPointers[0].pos.x, effectController.adrPointers[0].pos.y, effectController.adrPointers[2].pos.x, effectController.adrPointers[2].pos.y);
        line(effectController.adrPointers[3].pos.x, effectController.adrPointers[3].pos.y, effectController.adrPointers[1].pos.x, effectController.adrPointers[1].pos.y);
    }
}