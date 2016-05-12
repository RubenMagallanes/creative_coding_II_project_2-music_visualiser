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
  float tween(float time) {
    float currentTime = time * .001 - startTime;
    float t = norm(currentTime, 0, animationLength);
    t = constrain(t, 0.0, 1.0);
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
  
  @Override
  float tween(float time) {
    float currentTime = time * .001 - startTime;
    float t = norm(currentTime,0,animationLength);
    t = constrain(t,0.0,1.0);
    
    t = pow(t,easeFactor);
    
    float val = lerp(startValue, startValue + valueRange, t);
    return val;    
  }
}



