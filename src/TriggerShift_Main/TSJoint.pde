
class TSJoint {
  //----------------------------------
  PVector [] buffer;
  PVector smoothedVelocity;
  //velocity this frame - unsmoothed
  PVector velocity;
  PVector currentPos;
  PVector prevPos;
  //for the circular buffer
  int bufferIndex;

  TSJoint(int smoothingAmt) {
    
    buffer= new PVector[smoothingAmt];

    for (int i=0;i<buffer.length;i++) {
      buffer[i]=new PVector(0, 0, 0);
    }
    velocity=new PVector(0, 0, 0);
    currentPos=new PVector(0, 0, 0);
    prevPos=new PVector(0, 0, 0);
    smoothedVelocity=new PVector(0, 0, 0);

    bufferIndex=0;
  }
  void updateAll(PVector newPos) {
    //update current joint position
    currentPos=newPos;
    //map velocity to depth image size - I can't find how to get the depth of this context
    velocity.x= map( newPos.x-prevPos.x, -context.depthWidth(), context.depthWidth(), -1, 1);
    velocity.y= map(newPos.y-prevPos.y, -context.depthHeight(), context.depthHeight(), -1, 1);
    velocity.z= newPos.z-prevPos.z;
    
    //overwrite the circular buffer
    buffer[bufferIndex]=velocity;
  //and incrememnt the buffer index
    bufferIndex++;
    if (bufferIndex>=buffer.length) {
      bufferIndex=0;
    }
    prevPos=newPos;
    smoothedVelocity=getSmoothedVelocity();
  }

  PVector getSmoothedVelocity() {

    PVector total=new PVector(0, 0, 0);
    for (int i=0;i<buffer.length;i++) {
      total.x+=buffer[i].x;
      total.y+=buffer[i].y;
      total.z+=buffer[i].z;
    }

    PVector smthd= new PVector(total.x/buffer.length, total.y/buffer.length, total.z/buffer.length  );
    return smthd;
  }
};

