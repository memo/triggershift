class LornaStory extends TSStoryBase {

  LornaStory() {
    storyName = "LornaStory";
    println(storyName + "::" + storyName);
    addScene(new Scene_reach_for_stars());
  }

  //----------------------------------
  void onEnd() {
    println(storyName + "::onEnd");
  }
}

//SCENE 13 2 HANDS UP ATTACTS STAR PARTICLES
class Scene_reach_for_stars extends TSSceneBase {
  int numStars=20;
  StarParticle[] stars = new StarParticle[numStars];
  boolean startAttract;
  float amt;
  Scene_reach_for_stars() {
    sceneName="scene13 REACH FOR STARS";

    println("Lorna::Scene_reach_for_stars");
  }

  // this is called when the scene starts (i.e. is triggered)
  void onStart() {
    for (int i=0;i<stars.length;i++) {
      stars[i]= new StarParticle(new PVector(random(width), random(height/2)), new PVector (0, 0, 0), random(TWO_PI), 0, random(20, 30));
    }
    startAttract=false;
    println("Lorna::Scene_reach_for_stars::onStart");
    amt=0.0;
    //player.close();
    //player = minim.loadFile("LORNA/question.mp3");
    //player.loop();
  }
  void onDraw(PImage userImage, TSSkeleton skeleton) {
    PVector leftHand = skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_LEFT_HAND, transform2D, openNIContext);
    PVector rightHand = skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_RIGHT_HAND, transform2D, openNIContext);
    PVector head = skeleton.getJointCoordsInWorld(lastUserId, SimpleOpenNI.SKEL_HEAD, transform2D, openNIContext);
    //SKEL_WAIST is not working! 

    //if both arms go above the head start linking the image pos to hands

    if (leftHand.y<head.y && rightHand.y<head.y) startAttract = true;
    drawMaskedUser();
    pushStyle();
    pushMatrix();
    //attract half the stars to the left hand and half to the right
    if (startAttract) {
      for (int i=0;i<stars.length/2;i++) {
        stars[i].update(leftHand, amt);
        if (dist(stars[i].pos.x, stars[i].pos.y, leftHand.x, leftHand.y)<20) {
          stars[i].setAlive(false);
        }
      }
      for (int i=stars.length/2;i<stars.length;i++) {
        stars[i].update(rightHand, amt);
        if (dist(stars[i].pos.x, stars[i].pos.y, rightHand.x, rightHand.y)<20) {
          stars[i].setAlive(false);
        }
      }
      if (amt<1) {
        amt+=0.03;
      }
    }
    for (int i=0;i<stars.length;i++) {

      stars[i].draw();
    }

    popMatrix();
    popStyle();
  }
};

