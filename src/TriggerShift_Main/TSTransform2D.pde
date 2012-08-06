
// stores 2D transformation information in a simple format
// e.g. how to map kinect data into our world
// target area must be fully contained (i.e. smaller and inside) output area

/*
 ________________
 |                |
 |    ________    |
 |   |        |   |
 |   |        |   |
 |   |________|   |
 |________________|
 */

class TSTransform2D {
  public PVector outputSizePixels;  // size of the output (in pixels) (e.g. 1920, 1080 for HD output)
  public PVector inputSizePixels;  // size of the input (in pixels) (e.g. 640, 480 for kinect)

  public PVector targetSize;      // size of target area (in normalized coordinates) (i.e. how much of the output should the input be mapped to)
  public PVector targetCenter;    // center coordinates of target area (in normalized coordinates) (i.e. where in the output should the input be mapped to)

  protected PVector targetSizePixels;      // size of target area (in pixels)
  protected PVector targetCenterPixels;    // center coordinates of target area (in pixels)
  protected PVector targetTopLeftPixels;   // top left coordinates of target area (in pixels)


  TSTransform2D() {
    outputSizePixels.set(width, height, 0);
    inputSizePixels.set(640, 480, 0);

    targetSize.set(1, 1, 0);           // set input target area to cover entire output
    targetCenter.set(0.5, 0.5, 0);     // set input target to be centered in output

    update();
  }

  TSTransform2D(PVector _outputSizePixels, PVector _inputSizePixels, PVector _targetSize, PVector _targetCenter) {
    set(_outputSizePixels, _inputSizePixels, _targetSize, _targetCenter);
  }


  void set(PVector _outputSizePixels, PVector _inputSizePixels, PVector _targetSize, PVector _targetCenter) {
    outputSizePixels = _outputSizePixels;
    inputSizePixels = _inputSizePixels;

    targetSize = _targetSize;
    targetCenter = _targetCenter;

    update();
  }

  // calculates, updates and caches various helper variables
  void update() {
    targetSizePixels.x = targetSize.x * outputSizePixels.x;
    targetSizePixels.y = targetSize.y * outputSizePixels.y;

    targetCenterPixels.x = targetCenter.x * outputSizePixels.x;
    targetCenterPixels.y = targetCenter.y * outputSizePixels.y;

    targetTopLeftPixels.x = targetCenterPixels.x - targetSizePixels.x /2;
    targetTopLeftPixels.y = targetCenterPixels.y - targetSizePixels.y /2;
  }


  // takes normalized input coordinates (0...1, 0...1) maps them to the target area, and returns world coordinates
  public PVector getWorldCoordsForInputNorm(PVector p) {
    return new PVector(
    targetTopLeftPixels.x + p.x * targetSizePixels.x, 
    targetTopLeftPixels.y + p.y * targetSizePixels.y);
  }

  // takes coordinates in input space (e.g. kinect coordinates) maps them to the target area, and returns world coordinates
  public PVector getWorldCoordsForInputPixels(PVector p) {
    return getWorldCoordsForInputNorm(new PVector(
    p.x / inputSizePixels.x,
    p.y / inputSizePixels.y));
  }
};

