class FieldView {
    int PEOPLE, PEOPLE_;
    PVector winPos, winSize;
    private List < Rider > riders;

    FieldView() {
        this.winPos = windows[5].pos;
        this.winSize = windows[5].size;
        riders = new ArrayList < Rider > ();
    }
    void update(int num, PVector[] loc) {
        PEOPLE = num;
        if (PEOPLE > PEOPLE_) {
            riders.add(new Rider(loc[loc.length - 1]));
        }
        for (int i = 0; i < PEOPLE; i++) {
            riders.get(i).update(loc[i]);
        }

        PEOPLE_ = PEOPLE;
    }
    public void draw() {
        for (Rider r: riders) {
            r.draw();
        }
    }
}