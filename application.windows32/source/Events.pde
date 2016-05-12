class TitleEvent {
  float alpha;
  color c = color(200, 200, 200);
  boolean on;

  EasingTween tween;

  TitleEvent(float duration, float startTime) {
    super();
    tween = new EasingTween(255.0, duration, -255.0, startTime, 2.0);

    alpha = 255;
  }

  void update() {
    alpha = tween.tween(millis());
    on = alpha > 0.0;
  }

  void run() {    
    update();
    if (on) {
      pushStyle();
      fill(c, alpha);
      text(artist, .05 * width, .90 * height);
      text(song, .05 * width, .93 * height);
      popStyle();
    }
  }
}