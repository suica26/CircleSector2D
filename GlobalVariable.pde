/*
グローバル変数記述用ファイルです








*/

ArrayList<MyObject> objects = new ArrayList<MyObject>();            //オブジェクトリスト
ArrayList<Sector2D> sectors = new ArrayList<Sector2D>();            //扇形オブジェクトリスト
ArrayList<MyBox> boxes = new ArrayList<MyBox>();                    //長方形オブジェクトリスト
ArrayList<MyCircle> circles = new ArrayList<MyCircle>();            //円形オブジェクトリスト
PVector currentFillColor = new PVector();                           //直近のfillに設定した色
PVector currentStrokeColor = new PVector();                           //直近のstrokeに設定した色
float currentStrokeWeight;                                          //直近の線分の大きさ
float epsilon = 0.01;                                               //計算誤差補正値
boolean display = true;                                             //描画切り替えフラグ
PVector[] boundingPoints = new PVector[8];                          //BV計算用頂点
MyBox AABB;                                                         //AABBボックス
Sector2D sector;
PVector zAxis = new PVector(0, 0, 1);
MyCapsule capsule;
MyCapsule cap2;
MyCircle circle;
PVector m = new PVector();