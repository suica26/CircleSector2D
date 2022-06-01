PVector origin = new PVector(0,0);
PVector mousePos = new PVector(0,0);
ArrayList<MyObject> objects = new ArrayList<MyObject>();
ArrayList<MyObject> movingObjects = new ArrayList<MyObject>();
ArrayList<PVector> moveVec = new ArrayList<PVector>();
ArrayList<PVector> latticePoints = new ArrayList<PVector>();
Sector2D fanShape;
MyBox box;
MyCircle circle;
float epsilon = 0.01;
float s,t;
float velocity = 5.0;
int moveFlg = 1;

/////////////////////////メインブロック///////////////////////////

void settings() {
    size(1000,750);
}

void setup() {
    //オブジェクト宣言
    fanShape = new Sector2D(radians( -30),radians(30),origin, 100,400);
    //box = new MyBox(origin,150,150);
    //circle = new MyCircle(new PVector(0,0), 100);
    
    //オブジェクトの登録
    RegistObjList(fanShape,true);
    //RegistObjList(box,true);
    //RegistObjList(circle,true);
    
    //格子状に点を配置(扇形範囲の確認用)
    
    for (int x = 0; x <= 50; x++) {
        for (int y = 0;y <= 50;y++) {
            latticePoints.add(new PVector( -width / 2.0 + x * width / 50.0, -height / 2.0 + y * height / 50.0));
        }
    }
    
}

void draw() {
    pushMatrix();
    translate(width / 2, height / 2);
    background(255);
    fill(255);
    
    //図形描画
    for (MyObject o : objects) {
        o.DisplayShape();
    }
    
    //図形の平行移動
    int l = movingObjects.size();
    if (moveFlg > 0) {
        for (int i = 0;i < l;i++) {
            var movePos = PVector.add(movingObjects.get(i).position,moveVec.get(i));
            movingObjects.get(i).SetPos(movePos);
            if (movePos.x < - width / 2.0 || movePos.x > width / 2.0) moveVec.get(i).x *= -1;
            if (movePos.y < - height / 2.0 || movePos.y > height / 2.0) moveVec.get(i).y *= -1;
        }
    }
    
    fanShape.Rotate(radians(1));
    
    var start = millis();
    
    ArrayList<PVector> crossPoints = new ArrayList<PVector>();
    
    /*
    var sbP = GetCrossPoints_SectorBox(fanShape,box);
    var scP = GetCrossPoints_SectorCircle(fanShape,circle);
    
    for (PVectorsb : sbP) {
    crossPoints.add(sb);
}
    crossPoints.add(box.position);
    for (PVectorsc : scP) {
    crossPoints.add(sc);
}
    crossPoints.add(circle.position);
    for (PVectorpoint : crossPoints) {
    fill(255,0,0);
    if (CheckPointInSector(fanShape,point))
    fill(0,255,0);
    ellipse(point.x,point.y, 8, 8);
}
    */
    
    //格子点との内外判定
    
    for (PVector point : latticePoints) {
        fill(255,0,0);
        if (CheckPointInSector(fanShape,point))
            fill(0,255,0);
        ellipse(point.x,point.y, 8, 8);
    }
    
    var finish = millis();
    
    popMatrix();
    if (frameCount % 60 == 0) {
        println("start:" + start);
        println("finish:" + finish);
        println("progressTime:" + (finish - start));
    }
}
