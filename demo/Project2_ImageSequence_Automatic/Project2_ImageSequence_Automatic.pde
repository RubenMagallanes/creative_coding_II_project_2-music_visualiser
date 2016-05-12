import ddf.minim.*;
SoundFaceUtil util;

//Your name
String name = "Demo";

//This is the input variable to drive your face
float v;
// This is the normalized volume
float nv;

//set this to true if you want to use Volume to drive your face
//if set to false then the input will be driven by 'mouseX'
boolean mic = false;

ArrayList<PImage>sequence;

void setup() {
  size(300, 300);

  // ---
  // YOU MUST HAVE THIS LINE
  // ---
  util = SoundFaceUtil.setup(this);	

  // use this to scale the input Volume up)
  // play around with a number that works for you
  util.setGain(2000);

  // use this to smooth the transition between different volume reads. 
  // (acceptable values between [0,1] - the lower the value the smoother the transition )
  util.setGainEasing(0.5);

  PFont font = loadFont("AndaleMono-24.vlw");
  textFont(font, 18);

  sequence = new ArrayList<PImage>();
  sequence.add(loadImage("Untitled-1.png"));
  sequence.add(loadImage("Untitled-2.png"));
  sequence.add(loadImage("Untitled-3.png"));
  sequence.add(loadImage("Untitled-4.png"));
  sequence.add(loadImage("Untitled-5.png"));
}

//how fast the index will increment - this is like your frames per second playback
//for the image sequence
float indVel = .1;
float ind = 0;

void draw() {
  background(0);

  if (mic) {
    v = util.getVolume();
    nv = util.getNormVolume();
  } else {
    v = mouseX;
    nv = norm(mouseX, 0, width);
  }


  // determine the target velocity based on the normalized volume or
  // mouse substitute
  float targetVel = lerp(.01,1.0,nv);
  
  //this controls how fast your playback speed will change
  //Lower numbers will be smoother/slower change. 1.0 = instant change
  float easingFactor = 0.01;

  //Change the rate that your index is incrementing
  indVel += (targetVel - indVel) * easingFactor;

  //increase your index
  ind += indVel;
  
  // make sure that your index is the lowest possible integer  
  int myInd = floor(ind);
  //prevent the index from being 0
  myInd = max(0,myInd);
  
  //make the index wrap so that it is never greater than the size of the array
  myInd = myInd % sequence.size();

  //draw the image from the list at the given index
  image(sequence.get(myInd), 0, 0);

  label();
}


void label() {
  pushStyle();
  fill(150);
  text(name, .05 * width, .95 * height);
  popStyle();
}


void keyPressed() {
  switch(key) {
  case 'r':
    util.resetNormVolume();
    break;
  case 'm':  //toggle the microphone setting between microphone input and mouse input
    mic = !mic; 
    break;
  default:
    println("unknown command: " + key);
  }
}

