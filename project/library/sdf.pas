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
     // ����ϵ������(�������������ϵ)
     mat: mat3;
     // ����ϵ
     constructor Create(const AOrigin: vec3; xAxis, yAxis, zAxis: vec3);
  end;

  TSDFSphereObject = record
     obj: TSDFObject;
     // �뾶
     radius: Single;
  end;

  TSDFBoxObject = record
     obj: TSDFObject;
     // �����
     bounds: vec3;
  end;

  TSDFRoundBoxObject = record
    obj: TSDFObject;
    bounds: vec3;
    radius: Single;
  end;

  TSDFTorus = record
    obj: TSDFObject;
    // ���
    bounds: vec2;
  end;

  // http://iquilezles.org/www/articles/distfunctions/distfunctions.htm
  // ���ߺ����������ж�����ͨ��SDF����
  TSDFHelper = class
  private
    // ��
    class function sdSphere(const p: vec3; s: Single): Single;
    // ������
    class function sdBox(const p: vec3; const b: vec3): Single;
    // ��Բ��������
    class function sdRoundBox(const p: vec3; const b: vec3; r: Single): Single;
    // ����Ȧ
    class function sdTorus(const p: vec3; const t: vec2): Single;
    // �з�Χ������Ȧ��ra: �������ĵ�����ȦСԲ���ĵľ��룬rb��СԲ���ĵİ뾶
    class function sdCappedTorus(const p: vec3; const sc: vec2; ra, rb: Single): Single;
    // Բ����
    class function sdCylinder(const p, c: vec3): Single;
    // Բ׶��
    class function sdCone(const p: vec3; const c: vec2): Single;
    // ƽ��
    class function sdPlane(const p: vec3; const n: vec4): Single;
    // ������
    class function sdHexPrism(const p: vec3; const h: vec2): Single;
    // ������
    class function sdTriPrism(const p: vec3; const h: vec2): Single;
    // ˮƽ������
    class function sdCapsule(const p, a, b: vec3; r: Single): Single;
    // ��ֱ������
    class function sdVerticalCapsule(const p: vec3; h, r: Single): Single;
    // ������
    class function sdTriangle(const p, a, b, c: vec3): Single;
  public
    // �㵽Բ�ľ���(>0��ʾ��Ȧ֮�⣬<0��Ȧ֮�ڣ�=0��Ȧ��)
    class function CheckSphere(const obj: TSDFSphereObject; const p: vec3): Single;
    // �㵽�����еľ���
    class function CheckBox(const obj: TSDFBoxObject; const p: vec3): Single;
    // �㵽Բ�������еľ���
    class function CheckRoundBox(const obj: TSDFRoundBoxObject; const p: vec3): Single;
    // �㵽����Ȧ�ľ���
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
  // ƽ��
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
