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

  //------------------------------------------------------------------------------------------------------
  void onEnd() {
    println(storyName + "::onEnd");
  }


  //------------------------------------------------------------------------------------------------------
  // SCENES:
  //------------------------------------------------------------------------------------------------------
  // jump through flag
  class Scene1 extends TSSceneBase {
    PImage imgFlag = loadImage("jamel/flag.png");
    PImage imgFlagRip1 = loadImage("jamel/flagrip1.png");
    PImage imgFlagRip2 = loadImage("jamel/flagrip2.png");
    int ripStartMillis = 0;

    Scene1() {
      sceneName = "Scene1 FLAG INTRO";
      println(storyName + "::" + sceneName);
    }

    //----------------
    void onStart() {
      println(storyName + "::" + sceneName + "::onStart");
      ripStartMillis = 0;
    }

    //----------------
    void onDraw(PImage userImage, TSSkeleton skeleton) {
      drawMaskedUser();
      pushStyle();
      imageMode(CORNER);

      if (ripStartMillis == 0) {
        image(imgFlag, 0, 0, width, height);
      } 
      else {
        float rot = (millis() - ripStartMillis) * 0.001 * 90;
        if (rot < 180) {
          int xpos = (int)(width * 0.25);
          pushMatrix();
          translate(xpos, height);
          rotate( -radians(rot) );
          image(imgFlagRip1, -xpos, -height, width, height);
          popMatrix();

          pushMatrix();
          translate(width-xpos, height);
          rotate( radians(rot) );
          image(imgFlagRip2, xpos-width, -height, width, height);
          popMatrix();
        }
      }

      // play BEEP sound
      if (keyPressed && key == ' ') {
        println("BEEEP");
      }

      popStyle();

      if (getLeftHand().y < getHead().y && getRightHand().y < getHead().y && ripStartMillis == 0 ) ripStartMillis = millis();
    }
  };



  //------------------------------------------------------------------------------------------------------
  // draw graph and pound signs
  class Scene2 extends TSSceneBase {
    MSAParticle graph = new MSAParticle(loadImage("jamel/graph.png"));

    boolean doInteraction;
    //    MSAParticleSystem particleSystem = new MSAParticleSystem();
    //    PImage[] imgs = { 
    //      loadImage("jamel/pound.png"), loadImage("jamel/dollar.png"), loadImage("jamel/euro.png")
    //      };

    ArrayList posArray;

    //----------------
    Scene2() {
      sceneName = "Scene2 GRAPH";
      println(storyName + "::" + sceneName);
    }

    //----------------
    void onStart() {
      println(storyName + "::" + sceneName + "::onStart");
      doInteraction = false;

      graph.pos = new PVector(width/2, height/2);
      graph.radius = 0;
      graph.targetRadius = width * 0.3;
      graph.radiusSpeed = 0.2;

      posArray = new ArrayList();
      posArray.add(new PVector(-1000, -1000, -1000));  // add first point, makes logic easier
      //      particleSystem.start();
      //
      //      particleSystem.startPos.set(new PVector(0, 0, 0), new PVector(units(20), units(20), units(20)));
      //      particleSystem.startVel.set(new PVector(0, 0, 0), new PVector(units(50), units(50), units(50)));
      //      particleSystem.acc.set(new PVector(0, units(-20), 0), new PVector(0, units(5), 0));
      //      particleSystem.inheritVel.set(new PVector(0, 0, 0), new PVector(0, 0, 0));
      //      particleSystem.inheritVelMult.set(new PVector(width*0.1, height*0.1, 0), new PVector(0, 0, 0));
      //
      //      particleSystem.startRot.set(0, 30);
      //      particleSystem.rotVel.set(0, 3);
      //
      //      particleSystem.startRadius.set(0, 0);
      //      particleSystem.targetRadius.set(units(15), units(2));
      //      particleSystem.radiusSpeed.set(0.5, 0.1);
      //
      //      particleSystem.startAlpha.set(1, 0);
      //      particleSystem.targetAlpha.set(0, 0);
      //      particleSystem.alphaSpeed.set(0.02, 0.01);
      //
      //      particleSystem.drag.set(0.3, 0.1);
      //      particleSystem.maxCount = 100;
      //
      //      particleSystem.maxCount = 20;
      //      particleSystem.imgs = imgs;
    }

    //----------------
    void onDraw(PImage userImage, TSSkeleton skeleton) {
      drawMaskedUser();
      graph.draw();

      PVector activeHand = getRightHand();
      if (activeHand.x < graph.x1()) doInteraction = true;

      if (doInteraction) {
        pushStyle();
        PVector lastPoint = (PVector)posArray.get(posArray.size()-1);

        // add latest hand
        //      if(frameCount % 10 == 0) {
        if (graph.pointIn(activeHand) && activeHand.x > lastPoint.x && PVector.sub(activeHand, lastPoint).mag() > height * 0.05) {
          posArray.add(activeHand.get());
          if (posArray.size() > 100) posArray.remove(0);  // trim array
        }
        //      }

        // draw graph
        noFill();
        strokeWeight(5);
        //      strokeJoin(ROUND);
        //      strokeCap(ROUND);
        beginShape();
        PVector p1 = new PVector(-1000, -1000, -1000);
        for (int i=0; i<posArray.size(); i++) {
          PVector p2 = (PVector)posArray.get(i);
          PVector diff = PVector.sub(p1, p2);
          // only draw if distance between points is less than threshold
          if (diff.mag() < width * 0.2) {
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

        fill(255);
        noStroke();
        for (int i=0; i<posArray.size(); i++) {
          PVector p2 = (PVector)posArray.get(i);
          ellipse(p2.x, p2.y, 10, 10);
        }
        popStyle();
      }

      //      if (getHighestHandVelocity().mag() > 0.1) {
      //        particleSystem.startPos.base = getHighestHand();
      //        particleSystem.inheritVel.base = getHighestHandVelocity();
      //        particleSystem.add();
      //      }
      //
      //      particleSystem.draw();
    }
  };


  class Tramp {
    PImage imgTramp1 = loadImage("jamel/newtramp.png");
    PImage imgTramp2 = loadImage("jamel/businessman.png");
    PImage imgTrampMasked1 = createImage(imgTramp1.width, imgTramp1.height, ARGB);
    PImage imgTrampMasked2 = createImage(imgTramp2.width, imgTramp2.height, ARGB);
    float h = height * 0.8;
    float s = h / imgTramp1.height;
    float w = imgTramp1.width * s;
    PVector pos = new PVector(units(50), height - h);
    float fillAmount;

    void draw() {
      pushStyle();

      imgTrampMasked1.loadPixels();
      Arrays.fill(imgTrampMasked1.pixels, 0);
      imgTrampMasked1.updatePixels();
      int h1 = (int)(imgTrampMasked1.height * (1-fillAmount));
      imgTrampMasked1.copy(imgTramp1, 0, 0, imgTramp1.width, h1, 0, 0, imgTramp1.width, h1);

      imgTrampMasked2.loadPixels();
      Arrays.fill(imgTrampMasked2.pixels, 0);
      imgTrampMasked2.updatePixels();
      int h2 = (int)(imgTrampMasked2.height * fillAmount);
      int y2 = imgTrampMasked2.height - h2;
      imgTrampMasked2.copy(imgTramp2, 0, y2, imgTramp2.width, h2, 0, y2, imgTramp2.width, h2);

      imageMode(CORNER);
      image(imgTrampMasked1, pos.x, pos.y, imgTrampMasked1.width * s, imgTrampMasked1.height * s);
      image(imgTrampMasked2, pos.x, pos.y, imgTrampMasked2.width * s, imgTrampMasked2.height * s);

      popStyle();
    }
  };
  Tramp tramp = new Tramp();

  //------------------------------------------------------------------------------------------------------
  // Tramp
  class Scene3 extends TSSceneBase {
    boolean doInteraction;

    Scene3() {
      sceneName = "Scene3 TRAMP";
      println(storyName + "::" + sceneName);
    }

    //----------------
    void onStart() {
      println(storyName + "::" + sceneName + "::onStart");
      doInteraction = false;
      tramp.fillAmount = 0;
    }

    //----------------
    void onDraw(PImage userImage, TSSkeleton skeleton) {
      drawMaskedUser();

      // position of hand relative to waist->head
      float newt = constrain(map(getLeftHand().y, getHip().y, getHead().y, 0.0, 1.0), 0.0, 1.0);
      if (newt < 0.01) doInteraction = true;
      if (doInteraction) tramp.fillAmount += (newt - tramp.fillAmount) * 0.5;
      else tramp.fillAmount = 0;
      tramp.draw();
    }
  };



  // params
  int numTrees = 8;
  float catSpeedDown = 0.4;
  float catSpeedUp = 0.3;

  class Cat {
    Tree tree;
    PVector pos = new PVector();
    float rot = random(-30, 30);
    int flipDir;
    PImage img;

    Cat(Tree t) {
      tree = t;
      flipDir = pos.x < width/2 ? -1 : 1;
    }
    
    void draw() {
        if(tree.currentHeight < 10) return;
        
        float w = width * 0.15;
        float h = w * img.height / img.width;

        pushMatrix();
        translate(pos.x, pos.y);
        scale(flipDir, 1); 
        rotate(radians(rot));
        image(img, 0, 0, w, h);
        popMatrix();
      }
  };

  class Tree {
    float targetHeight = random(height*0.5, height * 0.6);
    float currentHeight = 0;
    PVector targetPos = new PVector(random(0, width), random(height * 0.7, height * 1) - targetHeight);  // position of center top
    PVector currentPos = new PVector();
    float speed = random(0.5, 0.6);
    float startTime;
    Cat cat;
    float elapsedSeconds;

    void draw() {
      currentPos = new PVector(targetPos.x, targetPos.y + targetHeight - currentHeight);
      if (elapsedSeconds > startTime) currentHeight += (targetHeight-currentHeight) * speed;
      float currentWidth = imgTree.width * currentHeight / imgTree.height;
      image(imgTree, currentPos.x - currentWidth/2, currentPos.y, currentWidth, currentHeight);
    }

    boolean isGrown() {
      return elapsedSeconds > startTime + 1;
    }
  };


  // vars
  Tree []trees = new Tree[numTrees];
  PImage imgTree = loadImage("jamel/tree.png");
  PImage[] imgCatsJumping = { 
    loadImage("jamel/cat1.png"), loadImage("jamel/cat2.png"), loadImage("jamel/cat3.png")
    };
  PImage[] imgCatsSitting = { 
    loadImage("jamel/cat1sit.png"), loadImage("jamel/cat2sit.png"), loadImage("jamel/cat3sit.png")
    };


    //------------------------------------------------------------------------------------------------------
    // cats in trees
  class Scene4 extends TSSceneBase {
    boolean throwCats;

    Scene4() {
      sceneName = "Scene4 CATS";
      println(storyName + "::" + sceneName);
    }

    //----------------
    void onStart() {
      println(storyName + "::" + sceneName + "::onStart");
      throwCats = false;
      for (int i=0; i<numTrees; i++) {
        Tree t = trees[i] = new Tree();
        float r = (i+0.5)/numTrees;
        t.targetPos.x = r * width;
        t.startTime = r * 2;
        t.cat = new Cat(t);
      }
    }

    //----------------
    void onDraw(PImage userImage, TSSkeleton skeleton) {
      pushStyle();
      imageMode(CORNER);
      for (int i=0; i<numTrees; i++) {
        Tree t = trees[i];
        t.elapsedSeconds = getElapsedSeconds();
        t.draw();
      }
      popStyle();

      drawMaskedUser();

      PVector rightHand = getRightHand();
      PVector leftHand = getLeftHand();

      if (throwCats == false && getLeftHand().y < getHead().y && getRightHand().y < getHead().y) {
        throwCats = true;
      } 

      pushStyle();
      imageMode(CENTER);
      for (int i=0; i<numTrees; i++) {
        Tree t = trees[i];
        if (t.isGrown()) {
          PVector diff;
          if (throwCats) {
            diff = PVector.sub(t.currentPos, t.cat.pos);
            diff.mult(catSpeedUp);
            t.cat.pos.add(diff);
          } 
          else {
            // find closest hand
            PVector closestHand = abs(rightHand.x - t.cat.pos.x) > abs(leftHand.x - t.cat.pos.x) ? leftHand : rightHand;

            // lerp to closest hand
            diff = PVector.sub(closestHand, t.cat.pos);
            diff.mult(catSpeedDown);
            t.cat.pos.add(diff);
          }

          t.cat.img = diff.mag() > units(10) ? imgCatsJumping[i % 3] : imgCatsSitting[i % 3];
        } 
        else {
          t.cat.pos = t.currentPos.get();
          t.cat.img = imgCatsSitting[i % 3];
        }
        
        t.cat.draw();

      }
      popStyle();
    }
  };

  //------------------------------------------------------------------------------------------------------
  // lied (re-dress tramp)
  class Scene5 extends TSSceneBase {
    boolean doInteraction;

    Scene5() {
      sceneName = "Scene5 LIED";
      println(storyName + "::" + sceneName);
    }

    //----------------
    void onStart() {
      println(storyName + "::" + sceneName + "::onStart");
      doInteraction = false;
      tramp.fillAmount = 1;
    }

    //----------------
    void onDraw(PImage userImage, TSSkeleton skeleton) {
      drawMaskedUser();

      // position of hand relative to waist->head
      float newt = constrain(map(getLeftHand().y, getHip().y, getHead().y, 0.0, 1.0), 0.0, 1.0);
      if (newt > 0.99) doInteraction = true;
      if (doInteraction) tramp.fillAmount += (newt - tramp.fillAmount) * 0.5;
      else tramp.fillAmount = 1;

      tramp.draw();
    }
  };

  PImage imgFlag = loadImage("jamel/flagjamel.png");

  //------------------------------------------------------------------------------------------------------
  // my country
  class Scene6 extends TSSceneBase {
    boolean inPosition;
    boolean doInteraction;

    Scene6() {
      sceneName = "Scene6 MYCOUNTRY";
      println(storyName + "::" + sceneName);
    }

    //----------------
    void onStart() {
      println(storyName + "::" + sceneName + "::onStart");
      //      inPosition = false;
      doInteraction = false;
    }

    //----------------
    void onDraw(PImage userImage, TSSkeleton skeleton) {
      float curY = getHighestHand().y;
      float headToHip = getHip().y - getHead().y;
      float topY = getHead().y - headToHip/2;
      if (curY < topY) doInteraction = true;
      if (doInteraction) {
        float y = map(curY, topY, getHip().y, -height, 0);
        if (y>0) y = 0;
        image(imgFlag, 0, y, width, height);
      }
      drawMaskedUser();
    }
  };

  //------------------------------------------------------------------------------------------------------
  // hair
  class Scene7 extends TSSceneBase {
    PImage imgHair1 = loadImage("jamel/interestinghair.png");
    PImage imgHair2 = loadImage("jamel/boringhair.png");
    boolean isTriggered;

    Scene7() {
      sceneName = "Scene7 HAIR";
      println(storyName + "::" + sceneName);
    }

    //----------------
    void onStart() {
      println(storyName + "::" + sceneName + "::onStart");
      isTriggered = false;
    }

    //----------------
    void onDraw(PImage userImage, TSSkeleton skeleton) {
      image(imgFlag, 0, 0, width, height);
      drawMaskedUser();

      pushStyle();
      imageMode(CENTER);
      PVector headPos = getHead();
      headPos.y -= units(80);

      if (isTriggered == false) {
        float w = width * 0.3;
        float h = w * imgHair1.height / imgHair1.width;
        if (getElapsedSeconds() < 0.2) {
          float s = getElapsedSeconds()/0.2;
          image(imgHair1, headPos.x, headPos.y, s * w, s * h);
        } 
        else {
          image(imgHair1, headPos.x, headPos.y, w, h);
        }
      } 
      else {
        //        float w = width * 0.15;
        //        float h = w * imgHair1.height / imgHair1.width;
        //        image(imgHair2, headPos.x, headPos.y, w, h);
      }
      popStyle();

      if (getHighestHand().y < getHead().y) isTriggered = true;
    }
  };

  //------------------------------------------------------------------------------------------------------
  // prison
  class Scene8 extends TSSceneBase {
    PImage imgBars = loadImage("jamel/prisonbars.png");
    float x1, x2;
    boolean shut1, shut2;
    boolean doInteraction;

    Scene8() {
      sceneName = "Scene8 PRISON";
      println(storyName + "::" + sceneName);
    }

    //----------------
    void onStart() {
      println(storyName + "::" + sceneName + "::onStart");
      doInteraction = false;
      x1 = width/2;
      x2 = width/2;
      shut1 = false;
      shut2 = false;
    }

    //----------------
    void onDraw(PImage userImage, TSSkeleton skeleton) {
      drawMaskedUser();

      float h = height;
      float w = h / imgBars.height * width;

      x1 += (map(getLeftHand().x, getHip().x - getMaxArmLength()/2, getHip().x, 0, width/2) - x1) * 0.5;
      x2 += (map(getRightHand().x, getHip().x + getMaxArmLength()/2, getHip().x, width, width/2) - x2) * 0.5;

      if (x1 < width * 0.1 && x2 > width * 0.9) doInteraction = true;

      if (doInteraction) {
        if (x1 > width * 0.5) {
          // sound
          // shake
          shut1 = true;
        }

        if (x2 < width * 0.5) {
          // sound
          // shake
          shut2 = true;
        }

        if (shut1) x1 = width * 0.5;
        if (shut2) x2 = width * 0.5;

        pushStyle();
        imageMode(CORNER);
        image(imgBars, x1 - w, 0, w, h);
        image(imgBars, x2, 0, w, h);
        popStyle();
      }
    }
  };

  //------------------------------------------------------------------------------------------------------
  // no marriage
  class Scene9 extends TSSceneBase {
    Scene9() {
      sceneName = "Scene9 NOMARRIAGE";
      println(storyName + "::" + sceneName);
    }

    //----------------
    void onStart() {
      println(storyName + "::" + sceneName + "::onStart");
    }

    //----------------
    void onDraw(PImage userImage, TSSkeleton skeleton) {
      drawMaskedUser();
    }
  };

  //------------------------------------------------------------------------------------------------------
  // forever
  class Scene10 extends TSSceneBase {
    Scene10() {
      sceneName = "Scene10 FOREVER";
      println(storyName + "::" + sceneName);
    }

    //----------------
    void onStart() {
      println(storyName + "::" + sceneName + "::onStart");
    }

    //----------------
    void onDraw(PImage userImage, TSSkeleton skeleton) {
      drawMaskedUser();
    }
  };

  //------------------------------------------------------------------------------------------------------
  class Scene11 extends TSSceneBase {
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

