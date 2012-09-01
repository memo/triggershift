
class PointSmoother {
  //----------------------------------
  PVector currentPos;
  PVector prevPos;
  PVector velocity;
  PVector smoothedVelocity;

  int lastUpdateTimeStamp;
  float smoothingAmount;

  //----------------------------------
  PointSmoother(float _smoothingAmount) {
    velocity=new PVector(0, 0, 0);
    currentPos=new PVector(0, 0, 0);
    prevPos = null;
    smoothedVelocity=new PVector(0, 0, 0);
    smoothingAmount = _smoothingAmount;
  }


  //----------------------------------
  void update(PVector newPos) {
    // get time since last update (for velocity)
    float secondsSinceLastUpdate = (millis() - lastUpdateTimeStamp) * 0.001;
    lastUpdateTimeStamp = millis();

    //update current joint position
    currentPos = newPos;
    if (prevPos != null) {
      // calculate velocity
      velocity = PVector.sub(newPos, prevPos);
      velocity.mult(secondsSinceLastUpdate);

      // smoothvel += (vel - smoothvel) * smoothingAmount
      smoothedVelocity.add(PVector.mult( PVector.sub(velocity, smoothedVelocity), smoothingAmount));
    }
    prevPos = newPos.get();
  }
};

