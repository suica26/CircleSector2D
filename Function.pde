/*
関数記述用ファイル








*/

void keyPressed() {
    if (keyCode == ' ') moveFlg = !moveFlg;
    if (key == 'd') display = !display;
}

void RegistObjList(MyObject o, boolean isMoving, boolean isRotating) {
    objects.add(o);
    if (isMoving) {
        movingObjects.add(o);
        var v = new PVector(random( -1,1),random( -1,1));
        moveVec.add(PVector.mult(v.normalize(),velocity));
    }
    if (isRotating) {
        rotatingObjects.add(o);
        float rv = radians(random( -5,5));
        rotVec.append(rv);
    }
}

// 外積関数
float Cross(PVector a, PVector b) {
    return a.x * b.y - a.y * b.x;
}

//線分と線分の交点
PVector GetCrossPoints_LineLine(PVector a, PVector b, PVector c, PVector d) {
    //参考URL
    //https :/ /qiita.com/zu_rin/items/09876d2c7ec12974bc0f
    float s,t;
    float deno = Cross(PVector.sub(b,a),PVector.sub(d,c));
    //線分が平行な場合はnull
    if (deno == 0.0) return null;
    
    s = Cross(PVector.sub(c,a),PVector.sub(d,c)) / deno;
    t = Cross(PVector.sub(b,a),PVector.sub(a,c)) / deno;
    
    //線分が交差していない場合
    if (s < 0.0 || 1.0 < s || t < 0.0 ||  1.0 < t) return null;
    
    return PVector.add(a,PVector.mult(PVector.sub(b,a),s));
}

// 円と線分の交点算出
PVector[] GetCrossPoints_CircleLine(float x1, float y1, float x2, float y2, float circleX, float circleY, float r) {
    //参考URL
    //https://tjkendev.github.io/procon-library/python/geometry/circle_line_cross_point.html
    //傾きの算出
    float xd = x2 - x1;
    float yd = y2 - y1;
    //円の公式(x^2 + y^2 = r^2)への代入と整理
    float x = x1 - circleX;
    float y = y1 - circleY;
    float a = xd * xd + yd * yd;
    float b = xd * x + yd * y;
    float c = x * x + y * y - r * r;
    //二次関数の解の公式
    //D = 0の時は1点で、D < 0の時は存在しない
    float d = b * b - a * c;
    float s1 = ( -b + sqrt(d)) / a;
    float s2 = ( -b - sqrt(d)) / a;
    
    PVector[] crossPoint = new PVector[2];
    if (0 <=  s1 && s1 <= 1)
        crossPoint[0] = new PVector(x1 + s1 * xd, y1 + s1 * yd);
    if (0 <=  s2 && s2 <= 1)
        crossPoint[1] = new PVector(x1 + s2 * xd, y1 + s2 * yd);
    
    return crossPoint;
}

//円同士の交点算出
PVector[] GetCrossPoints_CircleCircle(PVector c1, PVector c2, float r1, float r2) {
    //参考URL：https://mathwords.net/ennokoten
    PVector[] crossPoint = new PVector[2];
    float x1,x2,y1,y2;
    float u,v,a,b,c,d;
    
    //(x-a)^2 + (y-b)^2 = r1^2と
    //(x-c)^2 + (y-d)^2 = r2^2を連立させたことによって求められる
    //y = -(a-c)/(b-d)x + (a^2 + b^2 - c^2 - d^2 - r1^2 r2^2)/(b-d)
    //0除算は未対応
    u = -(c1.x - c2.x) / (c1.y - c2.y);
    v = (c1.x * c1.x + c1.y * c1.y - c2.x * c2.x - c2.y * c2.y - r1 * r1 + r2 * r2) / 2.0 / (c1.y - c2.y);
    a = 1 + u * u;
    b = u * v - u * c1.y - c1.x;
    c = c1.x * c1.x + v * v + c1.y * c1.y - r1 * r1 - 2 * c1.y * v;
    d = b * b - a * c;
    x1 = ( -b + sqrt(d)) / a;
    x2 = ( -b - sqrt(d)) / a;
    y1 = u * x1 + v;
    y2 = u * x2 + v;
    
    //判別式Dが0未満の時は虚数解なのでスルー
    if (d >= 0.0) {
        crossPoint[0] = new PVector(x1,y1);
        crossPoint[1] = new PVector(x2,y2);
    }
    
    return crossPoint;
}

// 扇形構成要素(外円、内円、二線分)と四角形の交点算出
ArrayList<PVector> GetCrossPoints_SectorBox(Sector2D f,MyBox b) {
    //円と線分の交差点算出
    ArrayList<PVector> points = new ArrayList<PVector>();
    for (int i = 0;i < 4;i++) {
        int e1,e2;
        e1 = i;
        if (i ==  3) e2 = 0; 
        else e2 = i + 1;
        
        var p1 = GetCrossPoints_CircleLine(b.v[e1].x,b.v[e1].y,b.v[e2].x,b.v[e2].y,f.origin.x,f.origin.y,f.r1);
        var p2 = GetCrossPoints_CircleLine(b.v[e1].x,b.v[e1].y,b.v[e2].x,b.v[e2].y,f.origin.x,f.origin.y,f.r2);
        
        if (p1[0] != null)points.add(p1[0]);
        if (p1[1] != null)points.add(p1[1]);
        if (p2[0] != null)points.add(p2[0]);
        if (p2[1] != null)points.add(p2[1]);
    }
    
    //線分と線分の交差点算出
    for (int i = 0; i < 4;i++) {
        int e1,e2;
        e1 = i;
        if (i == 3) e2 = 0; 
        else e2 = i + 1;
        
        var p = GetCrossPoints_LineLine(b.v[e1],b.v[e2],f.a,f.b);
        var q = GetCrossPoints_LineLine(b.v[e1],b.v[e2],f.ad,f.bd);
        
        if (p!= null) points.add(p);
        if (q!= null) points.add(q);
    }
    
    return points;
}

//扇形と円の交差点算出
ArrayList<PVector> GetCrossPoints_SectorCircle(Sector2D f, MyCircle c) {
    ArrayList<PVector> points = new ArrayList<PVector>();
    
    for (PVector p : GetCrossPoints_CircleCircle(f.origin,c.position,f.r1,c.r)) {
        if (p!= null)
            points.add(p);
    } 
    for (PVector p : GetCrossPoints_CircleCircle(f.origin,c.position,f.r2,c.r)) {
        if (p!= null)
            points.add(p);
    } 
    for (PVector p : GetCrossPoints_CircleLine(f.a.x,f.a.y,f.b.x,f.b.y,c.position.x,c.position.y,c.r)) {
        if (p!= null)
            points.add(p);
    } 
    for (PVector p : GetCrossPoints_CircleLine(f.ad.x,f.ad.y,f.bd.x,f.bd.y,c.position.x,c.position.y,c.r)) {
        if (p!= null)
            points.add(p);
    }
    
    return points;
}

//長方形同士の交差点算出
ArrayList<PVector> GetCrossPoints_BoxBox(MyBox b1, MyBox b2) {
    ArrayList<PVector> points = new ArrayList<PVector>();
    
    for (int i = 0;i < 4;i++) {
        int e1,e2;
        e1 = i;
        if (i == 3) e2 = 0;
        else e2 = i + 1;
        
        for (int j = 0;j < 4;j++) {
            int e3,e4;
            e3 = j;
            if (j == 3) e4 = 0;
            else e4 = j + 1;
            
            var p = GetCrossPoints_LineLine(b1.v[e1],b1.v[e2],b2.v[e3],b2.v[e4]);
            if (p!= null) points.add(p);
        }
    }
    
    return points;
}

// 扇形と点の内外判定
boolean CheckPointInSector(Sector2D f, PVector p) {
    float distance = PVector.sub(f.origin,p).mag();
    //内円よりも外側にあるかどうか
    if (distance < f.r1 - epsilon) return false;
    //外円よりも内側にあるかどうか
    if (distance > f.r2 + epsilon) return false;
    //回転方向で場合分け
    
    //正の回転の場合
    if (f.theta - f.alpha >= 0) {
        if (Cross(PVector.sub(p,f.a),PVector.sub(f.b,f.a)) >= epsilon) return false;
        if (Cross(PVector.sub(p,f.ad),PVector.sub(f.bd,f.ad)) <- epsilon) return false;
    }
    else{   //負の回転の場合
        if (Cross(PVector.sub(p,f.a),PVector.sub(f.b,f.a)) <- epsilon) return false;
        if (Cross(PVector.sub(p,f.ad),PVector.sub(f.bd,f.ad)) >= epsilon) return false;
    }
    
    return true;
}

// 長方形と点の内外判定
boolean CheckPointInBox(MyBox b, PVector p) {
    for (int i = 0;i < 3;i++) {
        if (Cross(PVector.sub(b.v[i + 1],b.v[i]),PVector.sub(p,b.v[i])) < 0) return false;
    } 
    if (Cross(PVector.sub(b.v[0],b.v[3]),PVector.sub(p,b.v[3])) < 0) return false;
    return true;
}

// 円と点の内外判定
boolean CheckPointInCircle(MyCircle c, PVector p) {
    if (PVector.sub(p,c.position).mag() > c.r) return false;
    return true;
}

// 回転行列
PVector RotateMatrix(float theta, PVector v) {
    float x = v.x * cos(theta) - v.y * sin(theta);
    float y = v.x * sin(theta) + v.y * cos(theta);
    PVector r = new PVector(x,y);
    return r;
}

// 扇形関数 P(s,t) = R(tθ)L(s) + O
//次の条件の時、扇形の中の点を返す
//0 <= s <= 1
//0 <= t <= 1
PVector SectorPoint(Sector2D f, float s, float t) {
    PVector v = PVector.add(PVector.sub(f.a,f.origin),PVector.mult(PVector.sub(f.b,f.a),s));
    PVector p = PVector.add(RotateMatrix(t * (f.theta - f.alpha),v),f.origin);
    return p;
}

MyBox CreateAABB(PVector[] points) {
    //最小、最大の座標を計算する
    float mX,MX,mY,MY;
    mX = 10000;
    MX = -10000;
    mY = 10000;
    MY = -10000;
    
    for (PVector p : points) {
        if (mX >= p.x) mX = p.x;
        if (MX <= p.x) MX = p.x;
        if (mY >= p.y) mY = p.y;
        if (MY <= p.y) MY = p.y;
    }
    
    return new MyBox(new PVector((MX + mX) / 2.0,(MY + mY) / 2.0),MX - mX,MY - mY,false,false,false);
}

void AdjustAABB(MyBox b, PVector[] points) {
    //最小、最大の座標を計算する
    float mX,MX,mY,MY;
    mX = 10000;
    MX = -10000;
    mY = 10000;
    MY = -10000;
    
    for (PVector p : points) {
        if (mX >= p.x) mX = p.x;
        if (MX <= p.x) MX = p.x;
        if (mY >= p.y) mY = p.y;
        if (MY <= p.y) MY = p.y;
    }
    
    b.position = new PVector((MX + mX) / 2.0,(MY + mY) / 2.0);
    b.w = MX - mX;
    b.h = MY - mY;
    b.v[0].set(b.position.x + b.w / 2, b.position.y + b.h / 2);
    b.v[1].set(b.position.x - b.w / 2, b.position.y + b.h / 2);
    b.v[2].set(b.position.x - b.w / 2, b.position.y - b.h / 2);
    b.v[3].set(b.position.x + b.w / 2, b.position.y - b.h / 2);
}

void AdjustSector(Sector2D s, float t) {
    s.alpha = t;
    s.a.set(s.r1 * cos(s.alpha) + s.origin.x, s.r1 * sin(s.alpha) + s.origin.y);
    s.b.set(s.r2 * cos(s.alpha) + s.origin.x, s.r2 * sin(s.alpha) + s.origin.y);
    s.ad.set(s.r1 * cos(s.theta) + s.origin.x, s.r1 * sin(s.theta) + s.origin.y);
    s.bd.set(s.r2 * cos(s.theta) + s.origin.x, s.r2 * sin(s.theta) + s.origin.y);
    s.position = PVector.mult(PVector.add(PVector.sub(s.a,s.origin),PVector.sub(s.ad,s.origin)).normalize(),(s.r2 + s.r1) / 2.0);
}

/////////////////////////////////////////////////////////////////
/*
draw内関数
*/

void movement() {
    int vl = movingObjects.size();
    int rl = rotatingObjects.size();
    
    //図形の平行移動
    for (int i = 0;i < vl;i++) {
        var movePos = PVector.add(movingObjects.get(i).position,moveVec.get(i));
        movingObjects.get(i).SetPos(movePos);
        if (movePos.x < - width / 2.0 || movePos.x > width / 2.0) moveVec.get(i).x *= -1;
        if (movePos.y < - height / 2.0 || movePos.y > height / 2.0) moveVec.get(i).y *= -1;
    }
    //図形の回転
    for (int j = 0;j < rl;j++) {
        rotatingObjects.get(j).Rotate(rotVec.get(j));
    }
}

boolean CollisionDetection_SectorBox(Sector2D s, MyBox b) {
    //扇形と長方形が交差しているかのチェック
    var sbP = GetCrossPoints_SectorBox(s,b);
    for (PVector p : sbP) {
        // 扇形内外判定
        if (CheckPointInSector(s,p)) return true;
    }
    
    // 長方形に扇形が覆われているかのチェック
    if (CheckPointInBox(b,s.position)) return true;
    
    // 扇形に長方形が覆われているかのチェック
    if (CheckPointInSector(s,b.position)) return true;
    
    return false;
}

boolean CollisionDetection_SectorCircle(Sector2D s, MyCircle c) {
    //扇形と円が交差しているかのチェック
    var scP = GetCrossPoints_SectorCircle(s,c);
    for (PVector p : scP) {
        //扇形内外判定
        if (CheckPointInSector(s,p)) return true;
    }
    
    //円に扇形が覆われているかのチェック
    if (CheckPointInCircle(c,s.position)) return true;
    
    //扇形に円が覆われているかのチェック
    if (CheckPointInSector(s,c.position)) return true;
    
    return false;
}

boolean CollisionDetection_BoxBox(MyBox b1, MyBox b2) {
    var bbP = GetCrossPoints_BoxBox(b1,b2);
    
    for (PVector p : bbP) {
        if (p!= null) return true;
    }
    
    if (CheckPointInBox(b1,b2.position)) return true;
    
    return false;
}