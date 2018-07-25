class FieldView {
    PVector winPos, winSize;
    private List < Rider > riders;
    private float weight;
    int num;
    Rider[] riders2;

    FieldView() {
        this.winPos = windows[5].pos;
        this.winSize = windows[5].size;
        riders = new ArrayList < Rider > ();
        riders2 = new Rider[5];
        // for (Rider r: riders2) {
        //     PVector pos = new PVector(0, 0);
        //     r = new Rider(pos, 0);
        // }
        for (int i = 0; i < riders2.length; i++) {
            riders2[i] = new Rider(new PVector(0, 0), 0, i);
        }
    }
    void update(int num) {

        // for (int i = 0; i < riders2.length; i++) {
        //     riders2[i].update(loc[i], weight[i]);
        // }
        // riders.clear();
        // printArray(loc);
        // for (int i = 0; i < loc.length; i++) {
            // riders.add(new Rider(loc[i], weight[i], i));
        // }
        // this.num = num;
        // println(num, loc[0], weight[0]);
        // riders.clear();
        // riders.add(new Rider(loc[num], weight[num]));

        // for (int i = 0; i < loc.length && i < weight.length; i++)
        //     riders.add(new Rider(loc[i], weight[i]));
        this.num = num;
        // PEOPLE = num;
        // PEOPLE_ = PEOPLE;
        // print(num, "/");
        // printArray(loc);
    }
    public void draw() {
        if (num > 0)
            for (int i = 0; i < riders2.length; i++)
                riders2[i].draw();
        // for (Rider r: riders) {
        //     r.draw();
        // }

    }
}