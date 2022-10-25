/*
衝突判定関数をまとめたファイルです

*/


boolean CollisionDetection_CircleCricle(MyCircle c1, MyCircle c2) {
    float d = dist(c1.position.x, c1.position.y, c2.position.x, c2.position.y);
    if (d <= c1.r + c2.r) return true;
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

boolean CollisionDetection_CapsuleCapsule(MyCapsule c1, MyCapsule c2) {
    var ssDistItems = CalcSegmentSegmentDist(c1.s, c1.e, c2.s, c2.e);
    float dist = ssDistItems[0];
    
    if (dist > c1.r + c2.r) return false;
    else{
        float s = ssDistItems[1];
        PVector p = PVector.add(c1.s, PVector.mult(PVector.sub(c1.e, c1.s), s));
        circle(p.x, p.y, 10);
        println("s:" + s);
        
        float t = ssDistItems[2];
        PVector q = PVector.add(c2.s, PVector.mult(PVector.sub(c2.e, c2.s), t));
        circle(q.x, q.y, 10);
        println("t:" + t);
    }
    
    return true;
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

boolean CollisionDetection_BoxCircle(MyBox b, MyCircle c) {
    var vBox = new MyBox(new PVector(b.position.x, b.position.y), b.w + c.r * 2, b.h, 0);
    vBox.Rotate(b.angle, vBox.position);
    if (CheckPointInBox(vBox, c.position)) return true;
    
    var hBox = new MyBox(new PVector(b.position.x, b.position.y), b.w, b.h + c.r * 2, 0);
    hBox.Rotate(b.angle, hBox.position);
    if (CheckPointInBox(hBox, c.position)) return true;
    
    for (PVector v : b.v) {
        if (CheckPointInCircle(c, v)) return true;
    }
    
    return false;
}

boolean CollisionDetection_CircleCapsule(MyCircle cir, MyCapsule cap) {
    if (CalcPointSegmentDist(cir.position, cap.s, cap.e)[0] <= cir.r + cap.r) return true;
    else return false;
}