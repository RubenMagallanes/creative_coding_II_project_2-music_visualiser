import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import ddf.minim.*; 
import ddf.minim.analysis.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Project2final extends PApplet {

/*
	Example demonstrating the use of the 
 		SoundFace Utility.
 	(Based on the Lorenzo Bravi and Casey Reas' 
 	Intro to Processing assignment)
 
 	Prof. Rhazes Spell, 
 	Victoria University of Wellingtion
 	School of Design (c)2013
 */



// =-=-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-=-=
//  only modify variables in this section
// =-=-=-=-=-=-=-=-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-=-=


//Put in your sketch dimensions
int SIZE = 512;
int sketchWidth = SIZE;//800//512// 256
int sketchHeight = SIZE;

// Song Details
String artist="";
String song="";

//Save your audio into the data folder within your project
String beats = "music/SENTO NEL CORE.mp3";

//The scaling amount for the volume
float gain = 2000.0f;

// Controls how jumpy the volume is.
// 1.0 => jumpy; 0.0=> frozen
float volumeEasing = 0.1f;

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

public void setup() {
  

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
  title = new TitleEvent(2.0f, 3.0f);
  fft = new FFT(player.bufferSize(), player.sampleRate());

  mySetup();
  //frameRate(30);
  //noLoop();
}

boolean p = false; 
int fillcol = 0;

public void draw() {
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
public void keyPressed() {
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
class TitleEvent {
  float alpha;
  int c = color(200, 200, 200);
  boolean on;

  EasingTween tween;

  TitleEvent(float duration, float startTime) {
    super();
    tween = new EasingTween(255.0f, duration, -255.0f, startTime, 2.0f);

    alpha = 255;
  }

  public void update() {
    alpha = tween.tween(millis());
    on = alpha > 0.0f;
  }

  public void run() {    
    update();
    if (on) {
      pushStyle();
      fill(c, alpha);
      text(artist, .05f * width, .90f * height);
      text(song, .05f * width, .93f * height);
      popStyle();
    }
  }
}
// --- put your variables up here --- //

float div = 51.2f;
int gapwidth = 5;
float barwidth = div- gapwidth;

 int[] purples = new int[]{0xff4200AF,0xff7347FA,0xff7300C6,0xffF56AFF,0xff500A50,0xffDB9CF5};
 int[] blues = new int[]{0xff101D67,0xff3F80B7,0xff2E4BFF,0xff58A1FF,0xff134B93,0xff88BAFA}; 
 int[] greens = new int[]{0xff023E10,0xff3A9D2E,0xff048122,0xff0DB435,0xff095000,0xff4CD63A};
 int[] darkers = new int[]{0xff003104,0xff02174D,0xff07480C,0xff007C6A,0xff013148,0xff00CEBB};
 int[] reds = new int[]{0xff520000,0xffC90000,0xffB44302,0xffE89C02,0xff480600,0xffFC6E61};
  int[] current; 
public void mySetup() {
  current = reds;
}

public void myAnimation() {
  if (millis()>42500) current = purples;
  if (millis()>77000) current = blues;
  if (millis()>113000)current = darkers;
  if (millis()>148000)current = greens;
  fft.forward(player.mix);

  // print(fft.specSize ());

  // stroke(255, 255, 255);
  float bandHeight;
  float prev, next;
  boolean flag1= false, flag2 = false;
  for (int i = 0; i< fft.specSize (); i++)
  {

    bandHeight = fft.getBand(i)*5 * 2.5f;

    if (!triggerLows(bandHeight, i))
      if (!triggerSnare(bandHeight, i))
        if (!triggerMids(bandHeight, i))
          triggerHighs(bandHeight, i);

    flag1 = false;
    flag2 = false;
    if (i>1)
      if (fft.getBand(i) > fft.getBand(i-1) && fft.getBand(i) > fft.getBand(i-2)) flag1 = true;

    if (i< fft.specSize()-2)
      if (fft.getBand(i) > fft.getBand(i+1)&&fft.getBand(i) > fft.getBand(i+2)) flag2 = true;
    stroke(current[4]);
    if (flag1 && flag2) stroke(current[5]);

    if (i % 2 == 0)
    {
      line(0, height-i*2, bandHeight, height -i*2);
      if (flag1 && flag2) {
        pushStyle();
        stroke(255); 
        point(bandHeight +10, height-i*2);
        popStyle();
      }
    } else {
      line (width - bandHeight, height-i*2, width, height-i*2);
      if (flag1 && flag2) {
        pushStyle();
        stroke(255); 
        point(width - bandHeight-10, height-i*2);
        popStyle();
      }
    }
  }
  
   
}

// --- if you have any other functions place them here --- //

public float maxf(float a1, float a2)
{
  return a1 > a2 ? a1 : a2;
}


public boolean triggerLows(float h, int i)
{
  if (h >(width / 2)) { 
    fill(current[0], 150);
    rect(0, (height-i*2)-2, width, 4);
    return true;
  }
  return false;
}
public boolean triggerSnare(float h, int i)
{
  if (i > 20)
    if (h >(width / 4)) { 
      fill(current[2], 150);
      rect(0, (height-i*2)-2, width, 4);
      return true;
    }
  return false;
}
public boolean triggerMids(float h, int i)
{
  if (i > 60)
    if (h >(width / 5)) { 
      fill(current[3], 150);
      rect(0, (height-i*2)-2, width, 4);
      return true;
    }
  return false;
}
public boolean triggerHighs(float h, int i)
{  
  if (i > 80)
    if (h >(width /8)) { 
      fill(current[3], 150);
      rect(0, (height-i*2)-2, width, 4);
      return true;
    }
  return false;
} 
class SoundUtil {
  private AudioInput in;
  private float s_volume;
  private float volume;
  private float gainEasing;
  private float gain;

  private final float DUMMY_MIN_VOL = 2500;
  private final float DUMMY_MAX_VOL = 0;

  private float _min = DUMMY_MIN_VOL;  // dummy initial minimum value
  private float _max = DUMMY_MAX_VOL;     //dummy initial maximum value

  SoundUtil() {
    in = minim.getLineIn(Minim.MONO, 512);
    gain = 100.0f;
    gainEasing = 1.0f;
  }


  /**
   *  @param g this controls the loudness of your music; the higher the number the louder the volume
   *  
   */
  public void setGain(float g) {
    gain = g;
  }

  /**
   *  @param g a number between 0 and 1; the higher the number the more sharp changes in volume will be. The smaller the nummber
   *  the smoother the changes in volume.
   */
  public void setGainEasing(float g) {
    gainEasing = g;
  }

  public float getNormVolume() {
    float _vol = in.right.level() * gain;

    if ( _vol < _min ) { 
      _min = _vol;
    }

    if ( _vol > _max ) {
      _max = _vol;
    }

    //          return parent.norm(_vol,_min,_max);
    return norm(getVolume(), _min, _max);
  }

  public void resetNormVolume() {
    _min = DUMMY_MIN_VOL;
    _max = DUMMY_MAX_VOL;
  }

  public float getVolume() {
    s_volume = in.right.level() * gain;

    float d_volume = s_volume - volume;

    if (abs(d_volume) > 1) {
      volume += d_volume * gainEasing;
    }

    return volume;
  }
}
class BasicTween {
  float startValue;
  float animationLength;
  float valueRange;
  // in milliseconds
  float startTime;

  // Parameters:
  // aStart = the starting value for the tween
  // aDuration = how long the tween will take to complete
  // aValueRange = the range of the tween value. The final value for your tween
  //                will be equal to (aStart + aValueRange)
  // aStartTime = the time that the tween should start in seconds.
  BasicTween(float aStart, float aDuration, float aValueRange, float aStartTime) {
    startValue = aStart;
    animationLength = aDuration;
    valueRange = aValueRange;
    startTime = aStartTime;
  }  

  //Time in milliseconds
  public float tween(float time) {
    float currentTime = time * .001f - startTime;
    float t = norm(currentTime, 0, animationLength);
    t = constrain(t, 0.0f, 1.0f);
    float val = lerp(startValue, startValue + valueRange, t);
    return val;
  }
}


class EasingTween extends BasicTween {
  float easeFactor;


  // Parameters:
  // aStart = the starting value for the tween
  // aDuration = how long the tween will take to complete
  // aValueRange = the range of the tween value. The final value for your tween
  //                will be equal to (aStart + aValueRange)
  // aStartTime = the time that the tween should start in seconds.  
  EasingTween(float aStart, float aDuration, float aValueRange, float aStartTime, float aFactor) {
    super(aStart,aDuration,aValueRange,aStartTime);
    easeFactor = aFactor;
  }  
  
  public @Override
  float tween(float time) {
    float currentTime = time * .001f - startTime;
    float t = norm(currentTime,0,animationLength);
    t = constrain(t,0.0f,1.0f);
    
    t = pow(t,easeFactor);
    
    float val = lerp(startValue, startValue + valueRange, t);
    return val;    
  }
}

      public void settings() {  size(512,512); }
      static public void main(String[] passedArgs) {
            String[] appletArgs = new String[] { "Project2final" };
            if (passedArgs != null) {
              PApplet.main(concat(appletArgs, passedArgs));
            } else {
              PApplet.main(appletArgs);
            }
      }
}
