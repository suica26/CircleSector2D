PVector origin = new PVector(0,0);
PVector mousePos = new PVector(0,0);
ArrayList<MyObject> objects = new ArrayList<MyObject>();
Sector2D fanShape;
MyBox box;
MyCircle circle;
float epsilon = 0.01;
float s,t;

/////////////////////////メインブロック///////////////////////////

void settings() {
    size(1000,750);
}

void setup() {
    fanShape = new Sector2D(radians( -60),radians(60),origin, 100,400);
    box = new MyBox(origin,150,150);
    circle = new MyCircle(new PVector(0,0), 100);
    
    objects.add(fanShape);
    //objects.add(box);
    objects.add(circle);
}

void draw() {
    pushMatrix();
    translate(width / 2, height / 2);
    background(255);
    fill(255);
    
    for (MyObject o : objects) {
        o.DisplayShape();
    }
    
    var start = millis();
    
    ArrayList<PVector> crossPoints = new ArrayList<PVector>();
    var sbP = GetCrossPoints_SectorBox(fanShape,box);
    var scP = GetCrossPoints_SectorCircle(fanShape,circle);
    /*
    for (PVector sb : sbP) {
    crossPoints.add(sb);
}
    for (PVector v : box.v) {
    crossPoints.add(v);
}
    */
    for (PVector sc : scP) {
        crossPoints.add(sc);
        if (frameCount % 20 == 0) {
            println(sc);
        }
    }
    
    for (PVector point : crossPoints) {
        fill(255,0,0);
        if (CheckPointInSector(fanShape,point))
            fill(0,255,0);
        ellipse(point.x, point.y, 10, 10);
    }
    
    var finish = millis();
    
    popMatrix();
    /*
    if (frameCount % 20 == 0) {
    println(finish - start);
}
    */
}
