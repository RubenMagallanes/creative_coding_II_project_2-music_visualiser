/*
	Example demonstrating the use of the 
 		SoundFace Utility.
 	(Based on the Lorenzo Bravi and Casey Reas' 
 	Intro to Processing assignment)
 
 	Prof. Rhazes Spell, 
 	Victoria University of Wellingtion
 	School of Design (c)2013
 */

import ddf.minim.*;
import ddf.minim.analysis.*;
// =-=-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-=-=
//  only modify variables in this section
// =-=-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-=-=


//Put in your sketch dimensions
//800//512// 256


// Song Details
String artist="";
String song="";

//Save your audio into the data folder within your project
String beats = "music/SENTO NEL CORE.mp3";

//The scaling amount for the volume
float gain = 2000.0;

// Controls how jumpy the volume is.
// 1.0 => jumpy; 0.0=> frozen
float volumeEasing = 0.1;

// =-=-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-=-=

//This is the input volume to drive your animation
// This value is not normalized. It will be scaled by whatever you 
// set the gain variable to
float v;

// This is the normalized volume to drive your animation
float nv;

//set this to true if you want to use Volume to drive your face
//if set to false then the input will be driven by 'mouseX'
boolean mic = false;

boolean play = false;

FFT fft;



SoundUtil util;
Minim minim;
AudioPlayer player;
TitleEvent title;
int SIZE;
void settings() {
  size(512,512);
}

void setup() {

SIZE=512;
  // ---
  // YOU MUST HAVE THESE LINE
  // ---
  minim = new Minim(this);
  player = minim.loadFile(beats, SIZE);// filename, buffersize
  util = new SoundUtil();	

  // use this to scale the input Volume up)
  // play around with a number that works for you
  // this value will not matter for the normalized volume
  // since the normalized volume will return a number between 0 and 1
  util.setGain(gain);

  // use this to smooth the transition between different volume reads. 
  // (acceptable values between [0,1] - the lower the value the smoother the transition )
  util.setGainEasing(volumeEasing);

  ellipseMode(CENTER);
  PFont font = loadFont("AndaleMono-24.vlw");
  textFont(font, 18);

  //Change these values to change the fading of the Title
  title = new TitleEvent(2.0, 3.0);
  fft = new FFT(player.bufferSize(), player.sampleRate());

  mySetup();
  //frameRate(30);
  //noLoop();
}

boolean p = false; 
int fillcol = 0;

void draw() {
  if (!p) player.play();
  //background(0);
  //fillcol = (int) map(millis(),0,220000, 0,150);
  if (fillcol > 255) fillcol = 255;  

  fill(fillcol, 30);
  stroke (0, 100);
  rect(0, 0, width, height);
  /*if (mic) {
   v = util.getVolume();
   nv = util.getNormVolume();
   } else {
   v = map(mouseX, 0, width, 0, 100);
   nv = norm(mouseX, 0, width);
   }*/
  title.run();
  myAnimation();
  if (doc) {   
    pushStyle();
    fill(50);
    stroke(50);
    rect(0, 0, width, height);
    fill(255);
    stroke(255);
    text ("this is a simple music visualiser that changes \ncolours as time goes on.\nIt displays "+
    "different colours for different \nfrequency bands, as well as if a certain \nfrequency band is louder than others.", 10, 30);
    popStyle();
  }
}

boolean doc = false;
void keyPressed() {
  switch(key) {
  case 'r':
    util.resetNormVolume();
    break;
  case 'm':  //toggle the microphone setting between microphone input and mouse input
    mic = !mic; 
    break;
  case 'p':
    //toggle the play flag
    play = !play;
    if (play) {      
      player.play();
    } else {
      player.pause();
    }
    break;
  case 'd':
    //Call a function or class to show your documentation
    doc = !doc;

    break;
  default:
    println("unknown command: " + key);
  }
}