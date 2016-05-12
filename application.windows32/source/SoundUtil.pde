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