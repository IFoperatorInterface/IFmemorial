class SystemView {
    Title[] sliderTitles = new Title[4];
    Title previewTitle;
    SystemView() {
    }
    void draw() {

        adrGUI();

        for (Title t: sliderTitles)
            t.display();

        windowGUI();
    }
    void windowGUI() {
        if (recordController.isRecording) {
            float x = windows[4].pos.x;
            float y = windows[4].pos.y;
            float w = windows[4].size.x;
            float h = windows[4].size.y;
            float scale = 100;
            float speed = 8;
            pushStyle();
            noFill();
            strokeWeight(5);
            stroke(millis() % (scale * speed), 0, 0);
            rect(x, y, w, h);
            popStyle();
        }
        PVector pos = effectController.previewModule.pos;
        float pd = 10;
        float w = 14;
        float h = pos.y - windows[1].pos.y;
        pushStyle();
        noFill();
        stroke(120);
        rect(pos.x - w / 2, pos.y - h + pd, w, h, w / 2);
        popStyle();
        previewTitle.display();

        for (Window win: windows)
            win.display();

    }
    void adrGUI() {
        int NUM_ADR = 3;
        int pd = 10;
        int h = int(windows[NUM_ADR - 1].size.y - pd);
        int btSize = int(h / 3);

        int x = int(windows[NUM_ADR - 1].pos.x) + (btSize + pd) * NUM_ADR + pd * 3 / 2;
        int y = int(windows[NUM_ADR - 1].pos.y + pd / 2);
        int w = width / 2 - 15 - x - pd / 2;
        // color c = (!adrBt.isMouseOver()) ? color(0, 55, 110) : color(0, 116, 180);
        color c = color(0, 45, 90);
        pushStyle();
        stroke(c);
        strokeWeight(pd);
        fill(c);
        rect(x, y, w, h);
        popStyle();

        for (ADRpointer p: effectController.adrPointers)
            p.draw();

        for (int i = 0; i < effectController.adrPointers.length - 1; i++) {
            stroke(255);
            line(effectController.adrPointers[i].pos.x, effectController.adrPointers[i].pos.y, effectController.adrPointers[i + 1].pos.x, effectController.adrPointers[i + 1].pos.y);
        }
    }
}

class Title {
    PVector pos;
    String title;
    Title(PVector pos, String title) {
        this.pos = pos;
        this.title = title;
    }
    void display() {
        pushStyle();
        fill(255);
        textAlign(CENTER, CENTER);
        textFont(titleFont);
        if (!title.contains("NoTitle"))
            text(title.toUpperCase(), pos.x, pos.y);

        popStyle();
    }
}