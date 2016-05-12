import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

// --- put your variables up here --- //

float div = 51.2;
int gapwidth = 5;
float barwidth = div- gapwidth;

 color[] purples = new color[]{#4200AF,#7347FA,#7300C6,#F56AFF,#500A50,#DB9CF5};
 color[] blues = new color[]{#101D67,#3F80B7,#2E4BFF,#58A1FF,#134B93,#88BAFA}; 
 color[] greens = new color[]{#023E10,#3A9D2E,#048122,#0DB435,#095000,#4CD63A};
 color[] darkers = new color[]{#003104,#02174D,#07480C,#007C6A,#013148,#00CEBB};
 color[] reds = new color[]{#520000,#C90000,#B44302,#E89C02,#480600,#FC6E61};
  color[] current; 
void mySetup() {
  current = reds;
}

void myAnimation() {
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

    bandHeight = fft.getBand(i)*5 * 2.5;

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

float maxf(float a1, float a2)
{
  return a1 > a2 ? a1 : a2;
}


boolean triggerLows(float h, int i)
{
  if (h >(width / 2)) { 
    fill(current[0], 150);
    rect(0, (height-i*2)-2, width, 4);
    return true;
  }
  return false;
}
boolean triggerSnare(float h, int i)
{
  if (i > 20)
    if (h >(width / 4)) { 
      fill(current[2], 150);
      rect(0, (height-i*2)-2, width, 4);
      return true;
    }
  return false;
}
boolean triggerMids(float h, int i)
{
  if (i > 60)
    if (h >(width / 5)) { 
      fill(current[3], 150);
      rect(0, (height-i*2)-2, width, 4);
      return true;
    }
  return false;
}
boolean triggerHighs(float h, int i)
{  
  if (i > 80)
    if (h >(width /8)) { 
      fill(current[3], 150);
      rect(0, (height-i*2)-2, width, 4);
      return true;
    }
  return false;
} 