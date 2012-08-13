class ChardeneStory extends TSStoryBase {

  ChardeneStory() {
    println("ChardeneStory::ChardeneStory");
   // addScene(new Scene_turn_cards());
  }
}


//flicking gesture throws water out of a cup
class Scene_throw_coffee extends TSSceneBase {



  Scene_throw_coffee() {
    println("CelineStory::Scene_throw_coffee");
  }

  // this is called when the scene starts (i.e. is triggered)
  void onStart() {
    println("CelineStory::Scene_throw_coffee::onStart");
  }

  void onDraw(PImage userImage, TSSkeleton skeleton) {

    PVector leftHand = skeleton.getJointCoordsInWorld(1, SimpleOpenNI.SKEL_LEFT_HAND, transform2D, openNIContext);

 
    //scale the image according to the mapped distance between hands
  }
};
