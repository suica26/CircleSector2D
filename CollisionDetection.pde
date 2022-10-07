
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