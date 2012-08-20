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
        if(rot < 180) {
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

      if (getLeftHand().y < getLeftElbow().y && getRightHand().y < getRightElbow().y && ripStartMillis == 0 ) ripStartMillis = millis();
    }
  };



  //------------------------------------------------------------------------------------------------------
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
      drawMaskedUser();
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


  //------------------------------------------------------------------------------------------------------
  // Tramp
  class Scene3 extends TSSceneBase {
    PImage imgTramp1 = loadImage("jamel/tramp1.png");
    PImage imgTramp2 = loadImage("jamel/tramp2.png");
    PImage imgTrampMasked1 = createImage(imgTramp1.width, imgTramp1.height, ARGB);
    PImage imgTrampMasked2 = createImage(imgTramp2.width, imgTramp2.height, ARGB);
    float fillAmount;

    Scene3() {
      sceneName = "Scene3 TRAMP";
      println(storyName + "::" + sceneName);
    }

    //----------------
    void onStart() {
      println(storyName + "::" + sceneName + "::onStart");
      fillAmount = 0;
    }

    //----------------
    void onDraw(PImage userImage, TSSkeleton skeleton) {
      drawMaskedUser();

      pushStyle();

      // position of hand relative to waist->head
      float newt = constrain(map(getHighestHand().y, getHip().y, getHead().y, 0.0, 1.0), 0.0, 1.0);
      // smooth
      fillAmount += (newt - fillAmount) * 0.5;

      float h = height * 0.7;
      float s = h / imgTramp1.height;
      float w = imgTramp1.width * s;

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
      image(imgTrampMasked1, width*0.2, 0, imgTrampMasked1.width * s, imgTrampMasked1.height * s);
      image(imgTrampMasked2, width*0.2, 0, imgTrampMasked2.width * s, imgTrampMasked2.height * s);

      popStyle();
    }
  };



  // params
  int numTrees = 8;
  float catSpeedDown = 0.4;
  float catSpeedUp = 0.3;

  class Cat {
    Tree tree;
    PVector pos;
    float rot = random(-30, 30);
    int flipDir;

    Cat(Tree t) {
      tree = t;
      pos = tree.pos.get();
      flipDir = pos.x < width/2 ? -1 : 1;
    }
  };

  class Tree {
    float targetHeight = random(height*0.5, height * 0.6);
    float currentHeight = 0;
    PVector pos = new PVector(random(0, width), random(height * 0.7, height * 1) - targetHeight);  // position of center top
    float speed = random(0.5, 0.6);
    float startTime;
    Cat cat;
    float elapsedSeconds;

    void draw() {
      if (elapsedSeconds > startTime) currentHeight += (targetHeight-currentHeight) * speed;
      float currentWidth = imgTree.width * currentHeight / imgTree.height;
      image(imgTree, pos.x - currentWidth/2, pos.y + targetHeight - currentHeight, currentWidth, currentHeight);
    }

    boolean isGrown() {
      return elapsedSeconds > startTime + 1;
    }
  };


  // vars
  Tree []trees = new Tree[numTrees];
  PImage imgTree = loadImage("jamel/tree.png");
  PImage[] imgCats = { 
    loadImage("jamel/cat1.png"), loadImage("jamel/cat2.png"), loadImage("jamel/cat3.png")
    };


    //------------------------------------------------------------------------------------------------------
    // cats in trees
  class Scene4 extends TSSceneBase {

    Scene4() {
      sceneName = "Scene4 CATS";
      println(storyName + "::" + sceneName);
    }

    //----------------
    void onStart() {
      println(storyName + "::" + sceneName + "::onStart");
      for (int i=0; i<numTrees; i++) {
        Tree t = trees[i] = new Tree();
        float r = (i+0.5)/numTrees;
        t.pos.x = r * width;
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

      pushStyle();
      imageMode(CENTER);
      for (int i=0; i<numTrees; i++) {
        Tree t = trees[i];
        if (t.isGrown()) {
          PImage imgCat = imgCats[i % 3];
          float catWidth = width * 0.15;
          float catHeight = catWidth * imgCat.height / imgCat.width;

          // find closest hand
          PVector closestHand = abs(rightHand.x - t.cat.pos.x) > abs(leftHand.x - t.cat.pos.x) ? leftHand : rightHand;

          // lerp to closest hand
          PVector diff = PVector.sub(closestHand, t.cat.pos);
          diff.mult(catSpeedDown);
          t.cat.pos.add(diff);

          pushMatrix();
          translate(t.cat.pos.x, t.cat.pos.y);
          scale(t.cat.flipDir, 1); 
          rotate(radians(t.cat.rot));
          image(imgCat, 0, 0, catWidth, catHeight);
          popMatrix();
        }
      }
      popStyle();
    }
  };

  //------------------------------------------------------------------------------------------------------
  // lied
  class Scene5 extends TSSceneBase {
    PImage imgTramp1 = loadImage("jamel/tramp1.png");
    PImage imgTramp2 = loadImage("jamel/tramp2.png");
    PImage imgTrampMasked1 = createImage(imgTramp1.width, imgTramp1.height, ARGB);
    PImage imgTrampMasked2 = createImage(imgTramp2.width, imgTramp2.height, ARGB);
    float fillAmount;


    Scene5() {
      sceneName = "Scene5 LIED";
      println(storyName + "::" + sceneName);
    }

    //----------------
    void onStart() {
      println(storyName + "::" + sceneName + "::onStart");
      fillAmount = 1;
    }

    //----------------
    void onDraw(PImage userImage, TSSkeleton skeleton) {
      // do cats
      if (getElapsedSeconds() < 3) {
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

        pushStyle();
        imageMode(CENTER);
        for (int i=0; i<numTrees; i++) {
          Tree t = trees[i];
          PImage imgCat = imgCats[i % 3];
          float catWidth = width * 0.15;
          float catHeight = catWidth * imgCat.height / imgCat.width;

          // lerp to tree
          PVector diff = PVector.sub(t.pos, t.cat.pos);
          diff.mult(catSpeedUp);
          t.cat.pos.add(diff);

          pushMatrix();
          translate(t.cat.pos.x, t.cat.pos.y);
          scale(t.cat.flipDir, 1); 
          rotate(radians(t.cat.rot));
          image(imgCat, 0, 0, catWidth, catHeight);
          popMatrix();
        }
        popStyle();
      } 
      else {
        // do tramp
        drawMaskedUser();

        pushStyle();

        // position of hand relative to waist->head
        float newt = constrain(map(getHighestHand().y, getHip().y, getHead().y, 0.0, 1.0), 0.0, 1.0);
        // smooth
        fillAmount += (newt - fillAmount) * 0.5;

        float h = height * 0.7;
        float s = h / imgTramp1.height;
        float w = imgTramp1.width * s;

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
        image(imgTrampMasked1, width*0.2, 0, imgTrampMasked1.width * s, imgTrampMasked1.height * s);
        image(imgTrampMasked2, width*0.2, 0, imgTrampMasked2.width * s, imgTrampMasked2.height * s);

        popStyle();
      }
    }
  };

  //------------------------------------------------------------------------------------------------------
  // my country
  class Scene6 extends TSSceneBase {
    PImage imgFlag = loadImage("jamel/flagjamel.png");

    Scene6() {
      sceneName = "Scene6 MYCOUNTRY";
      println(storyName + "::" + sceneName);
    }

    //----------------
    void onStart() {
      println(storyName + "::" + sceneName + "::onStart");
    }

    //----------------
    void onDraw(PImage userImage, TSSkeleton skeleton) {
      float s = getElapsedSeconds() < 0.5 ? getElapsedSeconds()/0.5 : 1;
      pushStyle();
      imageMode(CENTER);
      image(imgFlag, width/2, height/2, width * s, height * s);
      popStyle();

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
      drawMaskedUser();
      
      pushStyle();
      imageMode(CENTER);
      PVector headPos = getHead();
      
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
        float w = width * 0.15;
        float h = w * imgHair1.height / imgHair1.width;
        image(imgHair2, headPos.x, headPos.y, w, h);
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
    
    Scene8() {
      sceneName = "Scene8 PRISON";
      println(storyName + "::" + sceneName);
    }

    //----------------
    void onStart() {
      println(storyName + "::" + sceneName + "::onStart");
      x1 = 0;
      x2 = width;
    }

    //----------------
    void onDraw(PImage userImage, TSSkeleton skeleton) {
      drawMaskedUser();
      
      pushStyle();
      imageMode(CORNER);
      float h = height;
      float w = h / imgBars.height * width;
      
      x1 += (map(getLeftHand().x, getHip().x - getMaxArmLength(), getHip().x, 0, width/2) - x1) * 0.5;
      x2 += (map(getRightHand().x, getHip().x + getMaxArmLength(), getHip().x, width, width/2) - x2) * 0.5;
      
      image(imgBars, x1 - w, 0, w, h);
      image(imgBars, x2, 0, w, h);
      popStyle();
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

