//identical to MSAParticle but with no alpha fade and translation has an offset to account for the fact that the shard images are not trimmed.
class ShardParticle extends MSAParticle{
  PVector offset;
  ShardParticle(PVector _pos, PVector _posVel, float _rot, float _rotVel, float _radius, float _alpha, float _drag, float _fade){
    super( _pos,  _posVel,  _rot,  _rotVel,  _radius,  _alpha,  _drag,  _fade);
    
  }
  void setOffset(PVector _offset){
    offset=_offset;
  }
  void draw(PImage img) {
    pushStyle();
    pushMatrix();
    translate(pos.x, pos.y);
    //translate rotation point to the middle of the actual image
    translate(offset.x,offset.y);
    rotate(radians(rot));
    translate(-offset.x,-offset.y);

    imageMode(CORNER);
    tint(255, alpha * 255);
    image(img, 0, 0, radius*2, radius*2);

    
    pos.add(posVel);
    rot += rotVel;

    popMatrix();
    popStyle();
  }
  
}
