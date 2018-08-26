class TimeView {
    private final String title;
    private final int initialTime;
    TimeView() {
        int d = day();
        int m = month();
        int y = year();
        int h = hour();
        title = "Interview_" + String.valueOf(m) + "." + String.valueOf(d) + "." + String.valueOf(y) + "." + String.valueOf(h) + ":00";
        initialTime = millis();
    }
    void draw() {
        int sec = ((millis() - initialTime) / 1000) % 60;
        int minute = ((millis() - initialTime) / (1000 * 60)) % 60;
        String count = String.format("TIME: %d:%02d", minute, sec);
        int fontSize = 15;
        pushStyle();
        textFont(titleFont);
        textSize(fontSize);
        float pd = 8;
        float textWidth = textWidth(count);
        float _x = windows[3].pos.x + windows[3].size.x - pd * 4 - textWidth;
        float _y = windows[3].pos.y + windows[3].size.y / 2 - fontSize;
        text(count, _x, _y + 4 * pd);
        popStyle();
    }
}
