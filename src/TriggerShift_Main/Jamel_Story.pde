class JamelStory extends TSStoryBase {

  JamelStory() {
    storyName = "JamelStory";
    println(storyName + "::" + storyName);
    addScene(new Scene1());
    addScene(new Scene2());
    addScene(new Scene3());
    addScene(new Scene4());
    addScene(new Scene5());
    addScene(new Scene6());
    addScene(new Scene7());
    addScene(new Scene8());
    addScene(new Scene9());
    addScene(new Scene10());
    addScene(new Scene11());
  }

  //----------------------------------
  void onEnd() {
    println(storyName + "::onEnd");
  }


  //----------------------------------
  // SCENES:
  //----------------------------------
  // jump through flag
  class Scene1 extends TSSceneBase {
    PImage imgFlag = loadImage("jamel/flag.png");
    Scene1() {
      sceneName = "Scene1 FLAG INTRO";
      println(storyName + "::" + sceneName);
    }

    //----------------
    void onStart() {
      println(storyName + "::" + sceneName + "::onStart");
    }

    //----------------
    void onDraw(PImage userImage, TSSkeleton skeleton) {
      pushStyle();
      image(imgFlag, 0, 0, width, height);

      // play BEEP sound
      if (keyPressed && key == ' ') {
        println("BEEEP");
      }
      
      popStyle();
    }
  };



  //----------------------------------
  // draw graph and pound signs
  class Scene2 extends TSSceneBase {
    PImage imgPound = loadImage("jamel/pound.png");
    ArrayList posArray;
    ArrayList particles;

    //----------------
    Scene2() {
      sceneName = "Scene2 GRAPH";
      println(storyName + "::" + sceneName);
    }

    //----------------
    void onStart() {
      println(storyName + "::" + sceneName + "::onStart");
      posArray = new ArrayList();
      particles = new ArrayList();
    }

    //----------------
    void onDraw(PImage userImage, TSSkeleton skeleton) {
      pushStyle();
      PVector activeHand = getHighestHand();

      // add latest hand
      posArray.add(activeHand.get());
      if (posArray.size() > 100) posArray.remove(0);  // trim array

      // draw graph
      noFill();
      strokeWeight(10);
      strokeJoin(ROUND);
      strokeCap(ROUND);
      beginShape();
      PVector p1 = new PVector(-1000, -1000, -1000);
      for (int i=0; i<posArray.size(); i++) {
        PVector p2 = (PVector)posArray.get(i);
        PVector diff = PVector.sub(p1, p2);
        // only draw if distance between points is less than threshold
        if (diff.mag() < transform2D.targetSizePixels.y * 0.1) {
          stroke(255, 200, 100, i * 255.0/posArray.size());
          vertex(p2.x, p2.y);
        } 
        else {
          endShape();
          beginShape();
        }
        p1.set(p2);
      }
      endShape();

      // add particle if velocity is above threshold
      if (posArray.size() > 1) {
        PVector prv = ((PVector)posArray.get(posArray.size()-2)).get();
        PVector now = ((PVector)posArray.get(posArray.size()-1)).get();
        PVector vel = PVector.sub(prv, now);
        if (vel.mag() > transform2D.targetSizePixels.y * 0.03) {
          float r = transform2D.targetSizePixels.y * 0.1;
          now.x += random(-r, r);
          now.y += random(-r, r);
          now.z += random(-r, r);
          vel.mult(-0.2);
          particles.add(new MSAParticle(now, vel, random(-30, 30), random(-3, 3), random(height/80, height/40), 1.0, 1.0, 0.98));
        }
      }

      if (particles.size() > 20) particles.remove(0);  // trim array
      // draw particles
      for (int i=0; i<particles.size(); i++) {
        MSAParticle p = (MSAParticle) particles.get(i);
        p.draw(imgPound);
      }

      popStyle();
    }
  };


  //----------------------------------
  // Tramp
  class Scene3 extends TSSceneBase {
    PImage imgTramp1 = loadImage("jamel/tramp1.png");
    PImage imgTramp2 = loadImage("jamel/tramp2.png");
    PImage imgTrampMasked1 = createImage(imgTramp1.width, imgTramp1.height, ARGB);
    PImage imgTrampMasked2 = createImage(imgTramp2.width, imgTramp2.height, ARGB);
    float t;
    
    Scene3() {
      sceneName = "Scene3";
      println(storyName + "::" + sceneName);
    }

    //----------------
    void onStart() {
      println(storyName + "::" + sceneName + "::onStart");
    }

    //----------------
    void onDraw(PImage userImage, TSSkeleton skeleton) {
      pushStyle();
      
      // position of hand relative to waist->head
      float newt = constrain(map(getHighestHand().y, getHip().y, getHead().y, 0.0, 1.0), 0.0, 1.0);
      // smooth
      t += (newt - t) * 0.2;

      float h = height * 0.7;
      float s = h / imgTramp1.height;
      float w = imgTramp1.width * s;
      
//      imgTrampMasked1 = createImage(imgTramp1.width, (int)(imgTramp1.height * (1-t)), ARGB);
//      imgTrampMasked2 = createImage(imgTramp2.width, (int)(imgTramp2.height * t), ARGB);
      
      imgTrampMasked1.loadPixels();
      Arrays.fill(imgTrampMasked1.pixels, 0);
      imgTrampMasked1.updatePixels();
      int h1 = (int)(imgTrampMasked1.height * (1-t));
      imgTrampMasked1.copy(imgTramp1, 0, 0, imgTramp1.width, h1, 0, 0, imgTramp1.width, h1);
      
      imgTrampMasked2.loadPixels();
      Arrays.fill(imgTrampMasked2.pixels, 0);
      imgTrampMasked2.updatePixels();
      int h2 = (int)(imgTrampMasked2.height * t);
      int y2 = imgTrampMasked2.height - h2;
      imgTrampMasked2.copy(imgTramp2, 0, y2, imgTramp2.width, h2, 0, y2, imgTramp2.width, h2);
      
      image(imgTrampMasked1, width*0.2, 0, imgTrampMasked1.width * s, imgTrampMasked1.height * s);
      image(imgTrampMasked2, width*0.2, 0, imgTrampMasked2.width * s, imgTrampMasked2.height * s);
      
      popStyle();
    }
  };

  //----------------------------------
  // cats in trees
  class Scene4 extends TSSceneBase {
    PImage imgTree = loadImage("jamel/tree.png");
    ArrayList trees;
    
    class Tree {
      float targetHeight;
      PVector pos = new PVector();
      float height;
      float speed;
      float startTime;
      
      Tree() {
        targetHeight = random(height*0.4, height * 0.8);
        pos.x = random(0, width);
        pos.y = random(height * 0.5, height * 0.8);
        height = 0;
        speed = random(0.1, 0.1);
        startTime = random(0, 5);
      }
      
      void draw() {
        if(getElapsedSeconds() > startTime) height += (targetHeight-height) * speed;
        
        imageMode(CENTER);
        targetHeight = height;
        image(imgTree, pos.x, pos.y);//, imgTree.width * targetHeight / imgTree.height, targetHeight);
      }
    };
    
    Scene4() {
      sceneName = "Scene4";
      println(storyName + "::" + sceneName);
    }

    //----------------
    void onStart() {
      println(storyName + "::" + sceneName + "::onStart");
      trees = new ArrayList();
      int numTrees = 10;//(int)random(10, 15);
      for(int i=0; i<numTrees; i++) {
        trees.add(new Tree());
      }
    }

    //----------------
    void onDraw(PImage userImage, TSSkeleton skeleton) {
      pushStyle();
      
      for(int i=0; i<trees.size(); i++) {
        Tree t = (Tree)trees.get(i);
        t.draw();
      }
      
      popStyle();
    }
  };

  //----------------------------------
  class Scene5 extends TSSceneBase {
    // create triggers and other init in constructor
    Scene5() {
      sceneName = "Scene5";
      println(storyName + "::" + sceneName);
    }

    //----------------
    void onStart() {
      println(storyName + "::" + sceneName + "::onStart");
    }

    //----------------
    void onDraw(PImage userImage, TSSkeleton skeleton) {
    }
  };

  //----------------------------------
  class Scene6 extends TSSceneBase {
    // create triggers and other init in constructor
    Scene6() {
      sceneName = "Scene6";
      println(storyName + "::" + sceneName);
    }

    //----------------
    void onStart() {
      println(storyName + "::" + sceneName + "::onStart");
    }

    //----------------
    void onDraw(PImage userImage, TSSkeleton skeleton) {
    }
  };

  //----------------------------------
  class Scene7 extends TSSceneBase {
    // create triggers and other init in constructor
    Scene7() {
      sceneName = "Scene7";
      println(storyName + "::" + sceneName);
    }

    //----------------
    void onStart() {
      println(storyName + "::" + sceneName + "::onStart");
    }

    //----------------
    void onDraw(PImage userImage, TSSkeleton skeleton) {
    }
  };

  //----------------------------------
  class Scene8 extends TSSceneBase {
    // create triggers and other init in constructor
    Scene8() {
      sceneName = "Scene8";
      println(storyName + "::" + sceneName);
    }

    //----------------
    void onStart() {
      println(storyName + "::" + sceneName + "::onStart");
    }

    //----------------
    void onDraw(PImage userImage, TSSkeleton skeleton) {
    }
  };

  //----------------------------------
  class Scene9 extends TSSceneBase {
    // create triggers and other init in constructor
    Scene9() {
      sceneName = "Scene9";
      println(storyName + "::" + sceneName);
    }

    //----------------
    void onStart() {
      println(storyName + "::" + sceneName + "::onStart");
    }

    //----------------
    void onDraw(PImage userImage, TSSkeleton skeleton) {
    }
  };

  //----------------------------------
  class Scene10 extends TSSceneBase {
    // create triggers and other init in constructor
    Scene10() {
      sceneName = "Scene10";
      println(storyName + "::" + sceneName);
    }

    //----------------
    void onStart() {
      println(storyName + "::" + sceneName + "::onStart");
    }

    //----------------
    void onDraw(PImage userImage, TSSkeleton skeleton) {
    }
  };

  //----------------------------------
  class Scene11 extends TSSceneBase {
    // create triggers and other init in constructor
    Scene11() {
      sceneName = "Scene11";
      println(storyName + "::" + sceneName);
    }

    //----------------
    void onStart() {
      println(storyName + "::" + sceneName + "::onStart");
    }

    //----------------
    void onDraw(PImage userImage, TSSkeleton skeleton) {
    }
  };
}

