
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
    //円の公式(x^2 + y^2= r^2)への代入と整理
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
    // 参考URL：https :/ /mathwords.net/ennokoten
    PVector[] crossPoint = new PVector[2];
    float x1,x2,y1,y2;
    float u,v,a,b,c,d;
    
    // (x - a) ^ 2 + (y - b) ^ 2 = r1 ^ 2と
    //(x - c) ^ 2 + (y - d) ^ 2 = r2 ^ 2を連立させたことによって求められる
    //y = -(a - c) / (b - d)x + (a ^ 2 + b ^ 2 - c ^ 2 - d ^ 2 - r1 ^ 2 r2 ^ 2) / (b - d)
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
    
    // 判別式Dが0未満の時は虚数解なのでスルー
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
