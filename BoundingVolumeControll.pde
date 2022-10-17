/*
境界ボリュームの操作を行う関数をまとめたファイルです



*/
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
    
    return new MyBox(new PVector((MX + mX) / 2.0,(MY + mY) / 2.0),MX - mX,MY - mY, 3);
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
    
    b.position.set((MX + mX) / 2,(MY + mY) / 2);
    b.w = MX - mX;
    b.h = MY - mY;
    b.v[0].set(b.position.x + b.w / 2, b.position.y + b.h / 2);
    b.v[1].set(b.position.x - b.w / 2, b.position.y + b.h / 2);
    b.v[2].set(b.position.x - b.w / 2, b.position.y - b.h / 2);
    b.v[3].set(b.position.x + b.w / 2, b.position.y - b.h / 2);
    b.angle = 0;
}

void AdjustSector(Sector2D s, float t) {
    s.alpha = t;
    s.a.set(s.r1 * cos(s.alpha) + s.origin.x, s.r1 * sin(s.alpha) + s.origin.y);
    s.b.set(s.r2 * cos(s.alpha) + s.origin.x, s.r2 * sin(s.alpha) + s.origin.y);
    s.ad.set(s.r1 * cos(s.theta) + s.origin.x, s.r1 * sin(s.theta) + s.origin.y);
    s.bd.set(s.r2 * cos(s.theta) + s.origin.x, s.r2 * sin(s.theta) + s.origin.y);
    s.position = PVector.mult(PVector.add(PVector.sub(s.a,s.origin),PVector.sub(s.ad,s.origin)).normalize(),(s.r2 + s.r1) / 2.0);
}

void AdjustSector(Sector2D s, float alpha, float theta, float r1, float r2) {
    s.alpha = alpha;
    s.theta = theta;
    s.r1 = r1;
    s.r2 = r2;
    
    s.a.set(s.r1 * cos(s.alpha) + s.origin.x, s.r1 * sin(s.alpha) + s.origin.y);
    s.b.set(s.r2 * cos(s.alpha) + s.origin.x, s.r2 * sin(s.alpha) + s.origin.y);
    s.ad.set(s.r1 * cos(s.theta) + s.origin.x, s.r1 * sin(s.theta) + s.origin.y);
    s.bd.set(s.r2 * cos(s.theta) + s.origin.x, s.r2 * sin(s.theta) + s.origin.y);
    s.position = PVector.mult(PVector.add(PVector.sub(s.a,s.origin),PVector.sub(s.ad,s.origin)).normalize(),(s.r2 + s.r1) / 2.0);
}