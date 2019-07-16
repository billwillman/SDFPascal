unit sdf;

interface

uses
  Classes, Types, System.Math.Vectors, System.Math;

Type

  vec3 = TPoint3D;
  vec2 = TPointF;
  vec4 = TVector3D;
  mat3 = TMatrix3D;

  TSDFObject = record
     // 坐标系三方向(相对于世界坐标系)
     mat: mat3;
     // 坐标系
     constructor Create(const AOrigin: vec3; xAxis, yAxis, zAxis: vec3);
  end;

  TSDFSphereObject = record
     obj: TSDFObject;
     // 半径
     radius: Single;
  end;

  TSDFBoxObject = record
     obj: TSDFObject;
     // 长宽高
     bounds: vec3;
  end;

  TSDFRoundBoxObject = record
    obj: TSDFObject;
    bounds: vec3;
    radius: Single;
  end;

  TSDFTorus = record
    obj: TSDFObject;
    // 宽高
    bounds: vec2;
  end;

  // http://iquilezles.org/www/articles/distfunctions/distfunctions.htm
  // 工具函数，负责判断区域，通过SDF函数
  TSDFHelper = class
  private
    // 球
    class function sdSphere(const p: vec3; s: Single): Single;
    // 立方盒
    class function sdBox(const p: vec3; const b: vec3): Single;
    // 带圆角立方盒
    class function sdRoundBox(const p: vec3; const b: vec3; r: Single): Single;
    // 甜甜圈
    class function sdTorus(const p: vec3; const t: vec2): Single;
    // 有范围的甜甜圈：ra: 坐标中心到甜甜圈小圆中心的距离，rb是小圆中心的半径
    class function sdCappedTorus(const p: vec3; const sc: vec2; ra, rb: Single): Single;
    // 圆柱体
    class function sdCylinder(const p, c: vec3): Single;
    // 圆锥体
    class function sdCone(const p: vec3; const c: vec2): Single;
    // 平面
    class function sdPlane(const p: vec3; const n: vec4): Single;
    // 六凌体
    class function sdHexPrism(const p: vec3; const h: vec2): Single;
    // 三凌体
    class function sdTriPrism(const p: vec3; const h: vec2): Single;
    // 水平胶囊体
    class function sdCapsule(const p, a, b: vec3; r: Single): Single;
    // 垂直胶囊体
    class function sdVerticalCapsule(const p: vec3; h, r: Single): Single;
    // 三角形
    class function sdTriangle(const p, a, b, c: vec3): Single;
  public
    // 点到圆的距离(>0表示在圈之外，<0在圈之内，=0在圈上)
    class function CheckSphere(const obj: TSDFSphereObject; const p: vec3): Single;
    // 点到立方盒的距离
    class function CheckBox(const obj: TSDFBoxObject; const p: vec3): Single;
    // 点到圆角立方盒的距离
    class function CheckRoundBox(const obj: TSDFRoundBoxObject; const p: vec3): Single;
    // 点到甜甜圈的距离
    class function CheckTorus(const obj: TSDFTorus; const p: vec3): Single;
  end;

implementation

{ TSDFHelper }

class function TSDFHelper.CheckBox(const obj: TSDFBoxObject;
  const p: vec3): Single;
var
  transP: vec3;
begin
  transP := p * obj.obj.mat;
  Result := sdBox(transP, obj.bounds);
end;

class function TSDFHelper.CheckRoundBox(const obj: TSDFRoundBoxObject;
  const p: vec3): Single;
var
  transP: vec3;
begin
  transP := p * obj.obj.mat;
  Result := sdRoundBox(transP, obj.bounds, obj.radius);
end;

class function TSDFHelper.CheckSphere(const obj: TSDFSphereObject;
  const p: vec3): Single;
var
  transP: vec3;
begin
  transP := p * obj.obj.mat;
  Result := sdSphere(transP, obj.radius);
end;

class function TSDFHelper.CheckTorus(const obj: TSDFTorus;
  const p: vec3): Single;
var
  transP: vec3;
begin
  transP := p * obj.obj.mat;
  Result := sdTorus(transP, obj.bounds);
end;

class function TSDFHelper.sdBox(const p, b: vec3): Single;
var
  d, maxD: vec3;
begin
  d.X := Abs(p.X) - b.X;
  d.Y := Abs(p.Y) - b.Y;
  d.Z := Abs(p.Z) - b.Z;

  maxD.X := Max(0.0, d.X);
  maxD.Y := Max(0.0, d.Y);
  maxD.Z := Max(0.0, d.Z);

  Result := maxD.Length + Min(Max(d.X, Max(d.Y, d.Z)), 0.0);
end;

class function TSDFHelper.sdRoundBox(const p, b: vec3; r: Single): Single;
var
  d, maxD: vec3;
begin
  d.X := Abs(p.X) - b.X;
  d.Y := Abs(p.Y) - b.Y;
  d.Z := Abs(p.Z) - b.Z;

  maxD.X := Max(0.0, d.X);
  maxD.Y := Max(0.0, d.Y);
  maxD.Z := Max(0.0, d.Z);

  Result := maxD.Length - r + Min(Max(d.X, Max(d.Y, d.Z)), 0.0);
end;

class function TSDFHelper.sdCappedTorus(const p: vec3; const sc: vec2; ra,
  rb: Single): Single;
begin

end;

class function TSDFHelper.sdCapsule(const p, a, b: vec3; r: Single): Single;
begin

end;

class function TSDFHelper.sdCone(const p: vec3; const c: vec2): Single;
begin

end;

class function TSDFHelper.sdCylinder(const p, c: vec3): Single;
begin

end;

class function TSDFHelper.sdHexPrism(const p: vec3; const h: vec2): Single;
begin

end;

class function TSDFHelper.sdPlane(const p: vec3; const n: vec4): Single;
begin

end;

class function TSDFHelper.sdSphere(const p: vec3; s: Single): Single;
begin
  Result := p.Length - s;
end;

class function TSDFHelper.sdTorus(const p: vec3; const t: vec2): Single;
var
  q: vec2;
begin
  q := vec2.Create(vec2.Create(p.X, p.Z).Length - t.X, p.Y);
  Result := q.Length - t.Y;
end;

class function TSDFHelper.sdTriangle(const p, a, b, c: vec3): Single;
begin

end;

class function TSDFHelper.sdTriPrism(const p: vec3; const h: vec2): Single;
begin

end;

class function TSDFHelper.sdVerticalCapsule(const p: vec3; h,
  r: Single): Single;
begin

end;

{ TSDFObject }

constructor TSDFObject.Create(const AOrigin: vec3;
  xAxis, yAxis, zAxis: vec3);
begin
  // 平移
  mat.m41 := -AOrigin.X;
  mat.m42 := -AOrigin.Y;
  mat.m43 := -AOrigin.Z;

  xAxis := xAxis.Normalize;
  mat.m11 := xAxis.X;
  mat.m21 := xAxis.Y;
  mat.m31 := xAxis.Z;

  yAxis := yAxis.Normalize;
  mat.m12 := yAxis.X;
  mat.m22 := yAxis.Y;
  mat.m32 := yAxis.Z;

  zAxis := zAxis.Normalize;
  mat.m13 := zAxis.X;
  mat.m23 := zAxis.Y;
  mat.m33 := zAxis.Z;
end;

end.
