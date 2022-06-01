PVector origin = new PVector(0,0);
PVector mousePos = new PVector(0,0);
ArrayList<MyObject> objects = new ArrayList<MyObject>();
ArrayList<MyObject> movingObjects = new ArrayList<MyObject>();
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
    fanShape = new Sector2D(radians( -30),radians(30),origin, 100,400);
    box = new MyBox(origin,150,150);
    circle = new MyCircle(new PVector(0,0), 100);
    
    RegistObjList(fanShape,false);
    RegistObjList(box,true);
    RegistObjList(circle,true);
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
    crossPoints.add(box.pos);
    */
    for (PVector sc : scP) {
        crossPoints.add(sc);
    }
    crossPoints.add(circle.position);
    for (PVector point : crossPoints) {
        fill(255,0,0);
        if (CheckPointInSector(fanShape,point))
            fill(0,255,0);
        ellipse(point.x,point.y, 10, 10);
    }
    
    var finish = millis();
    
    popMatrix();
    if (frameCount % 60 == 0) {
        println("start:" + start);
        println("finish:" + finish);
        println("progressTime:" + (finish - start));
    }
}
