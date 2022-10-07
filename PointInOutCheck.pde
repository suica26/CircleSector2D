
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
        if (Cross(PVector.sub(p,f.origin),PVector.sub(f.a,f.origin)) >= epsilon)return false;
        if (Cross(PVector.sub(p,f.origin),PVector.sub(f.ad,f.origin)) <= -epsilon) return false;
    }
    else{   //負の回転の場合
        if (Cross(PVector.sub(p,f.origin),PVector.sub(f.a,f.origin)) <= -epsilon) return false;
        if (Cross(PVector.sub(p,f.origin),PVector.sub(f.ad,f.origin)) >= epsilon) return false;
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