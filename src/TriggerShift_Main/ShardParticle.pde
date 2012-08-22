//identical to MSAParticle but with no alpha fade and translation has an offset to account for the fact that the shard images are not trimmed.
class ShardParticle extends MSAParticle {
  PVector offset=new PVector(0, 0, 0);
  PVector pPos;
  boolean showWord=false;
  String word="";
  int imageIndex=0;
  ShardParticle(PVector _pos, PVector _posVel, float _rot, float _rotVel, float _radius, float _alpha, float _drag, float _fadeSpeed) {
//    super( _pos, _posVel, _rot, _rotVel, _radius, _alpha, _drag, _fade);
    pos = _pos.get();
    posVel = _posVel.get();
    posAcc = new PVector(0, 0, 0);
    rot = _rot;
    rotVel = _rotVel;
    radius = _radius;
    alpha = _alpha;
    drag = _drag;
    alphaSpeed = alphaSpeed;
    pPos=_pos;
  }
  void setWord(String _word) {
    word=_word;
  }
  void setImageIndex(int _imageIndex) {
    imageIndex=_imageIndex;
  }
  void setOffset(PVector _offset) {
    offset=_offset;
  }
  void setPos(PVector _pos) {
    pos=_pos;
  }
  void setPosVel(PVector _posVel) {
    posVel=_posVel;
  }
  void setRot(float _rot) {
    rot=_rot;
  }
  void setRotVel(float _rotVel) {
    rotVel=_rotVel;
  }
  void draw(PImage img) {
    pushStyle();
    pushMatrix();
    translate(pos.x, pos.y);
    //translate rotation point to the middle of the actual image
    translate(offset.x, offset.y);
    rotate(radians(rot));
    translate(-offset.x, -offset.y);

    imageMode(CORNER);
    //tint(255, alpha * 255);
    image(img, 0, 0);


    pos.add(posVel);
    rot += rotVel;

    popMatrix();
    popStyle();
  }
  void draw() {
    pushStyle();
    pushMatrix();
    translate(pos.x, pos.y);
    //translate rotation point to the middle of the actual image
    translate(offset.x, offset.y);

    // rot = atan2(pPos.y-pos.y, pPos.x-pos.x);
    rotate(radians(rot));
    translate(-offset.x, -offset.y);

    imageMode(CORNER);
    //tint(255, alpha * 255);
    if (showWord) {
      fill(255);
      text(word, 0, 0);
    }
    else {
      ellipse(0, 0, radius, radius);
    }


    pos.add(posVel);
    rot += rotVel;
    pPos=pos;
    popMatrix();
    popStyle();
  }
  void drawWithoutTranslation(PImage img) {
    pushStyle();
    pushMatrix();
    rotate(radians(rot));
    translate(-offset.x, -offset.y);

    imageMode(CORNER);
    //tint(255, alpha * 255);
    image(img, 0, 0);


    pos.add(posVel);
    rot += rotVel;

    popMatrix();
    popStyle();
  }
}

