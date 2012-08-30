import beads.*;

AudioContext beadsContext;
SamplePlayer samplePlayer;

// we can run both SamplePlayers through the same Gain
Gain sampleGain;
Glide gainValue;
Glide rateValue;

void setup() {
  size(800, 600);
  beadsContext = new AudioContext(); 
  try {  
    samplePlayer = new SamplePlayer(beadsContext, new Sample(selectInput()));
//    samplePlayer = new SamplePlayer(beadsContext, new Sample(sketchPath("") + "data/sine.aiff"));
  }

  catch(Exception e) {
    println("Exception while attempting to load sample!");
    e.printStackTrace();
    exit();
  }

  // note that we want to play the sample multiple times
  samplePlayer.setKillOnEnd(false);

  // set loop
  samplePlayer.setLoopType(SamplePlayer.LoopType.LOOP_FORWARDS);

  // initialize our rateValue Glide object
  rateValue = new Glide(beadsContext, 1, 30);
  samplePlayer.setRate(rateValue); // connect it to the SamplePlayer

  // create a gain that will control the volume of our sample player
  gainValue = new Glide(beadsContext, 0.0, 30);

  sampleGain = new Gain(beadsContext, 1, gainValue);

  sampleGain.addInput(samplePlayer);

  // connect the Gain to the AudioContext
  beadsContext.out.addInput(sampleGain);
  beadsContext.start(); // begin audio processing

  background(0); // set the background to black
  stroke(255);
}


void draw() {
  rateValue.setValue((height - mouseY) * 4.0 / height);
  gainValue.setValue(mouseX * 2.0/width);
}


void mousePressed() {
  samplePlayer.setPosition(0);
  samplePlayer.start();
}

