class FieldView {
    int PEOPLE, PEOPLE_;
    PVector winPos, winSize;
    private List < Rider > riders;
    private float weight;

    FieldView() {
        this.winPos = windows[5].pos;
        this.winSize = windows[5].size;
        riders = new ArrayList < Rider > ();
    }
    void update(int num, PVector[] loc, float[] weight) {
        PEOPLE = num;
        if (PEOPLE > PEOPLE_) {
            riders.add(new Rider(loc[loc.length - 1]));
        }
        for (int i = 0; i < PEOPLE; i++) {
            riders.get(i).update(loc[i], weight[i]);
        }

        PEOPLE_ = PEOPLE;
    }
    public void draw() {
        for (Rider r: riders) {
            r.draw();
        }
    }
}