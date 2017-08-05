float[][] pos = new float[][]{
  // Left eye
  {160, 325}, {250, 270},
  // Right eye
  {440, 330}, {340, 270},
  // Mouth centre
  {294, 366},
  // Inner frame
  {90, 210}, {90, 450}, {510, 450}, {510, 210},
  // Outer frame
  {60, 180}, {60, 480}, {540, 480}, {540, 180},
  // Two antennas' ends
  {270 - 70 * sqrt(3), 110}, {375, 180 - 60 * sqrt(3)}
};
float[][] moved = new float[15][2];
float[][] additionalPos = new float[15][2];
// The real position of the i-th element is (float[2] is treated as one point):
//  pos[i] + (mousePos - pos[i]) * moveFactor[i] + additionalPos[i]
float[] moveFactor =
  {0.2, 0.2, 0.2, 0.2, 0.2, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.05, 0.05};
float maxAdditional = 5, deltaAdditional = 1;
float mouthRad = 27, footWidth = 50, footYAdj = 10;

void setup() {
  size(600, 600);
  noFill();
  strokeWeight(15);
  smooth();
}

float change(float val, float min, float max, float delta)
{
  if (val <= min) return min + delta;
  if (val >= max) return max - delta;
  else return random(2) < 1 ? (val + delta) : (val - delta);
}

float weighted(float a, float b, float w)
{ return a * w + b * (1 - w); }

void draw() {
  //clear();
  background(192);

  for (int i = 0; i < 15; ++i) {
      additionalPos[i][0] = change(additionalPos[i][0], -maxAdditional, maxAdditional, deltaAdditional);
      additionalPos[i][1] = change(additionalPos[i][1], -maxAdditional, maxAdditional, deltaAdditional);
      moved[i][0] = pos[i][0] + (mouseX - pos[i][0]) * moveFactor[i] + additionalPos[i][0];
      moved[i][1] = pos[i][1] + (mouseY - pos[i][1]) * moveFactor[i] + additionalPos[i][1];
  }
  line(moved[0][0], moved[0][1], moved[1][0], moved[1][1]);
  line(moved[2][0], moved[2][1], moved[3][0], moved[3][1]);
  arc(moved[4][0] - mouthRad, moved[4][1], mouthRad * 2, mouthRad * 2, 0, PI);
  arc(moved[4][0] + mouthRad, moved[4][1], mouthRad * 2, mouthRad * 2, 0, PI);
  line(moved[5][0], moved[5][1], moved[6][0], moved[6][1]);
  line(moved[7][0], moved[7][1], moved[6][0], moved[6][1]);
  line(moved[5][0], moved[5][1], moved[8][0], moved[8][1]);
  line(moved[7][0], moved[7][1], moved[8][0], moved[8][1]);
  line(moved[9][0], moved[9][1], moved[10][0], moved[10][1]);
  line(moved[11][0], moved[11][1], moved[10][0], moved[10][1]);
  line(moved[9][0], moved[9][1], moved[12][0], moved[12][1]);
  line(moved[11][0], moved[11][1], moved[12][0], moved[12][1]);
  line(
    weighted(moved[12][0], moved[9][0], 0.47),
    weighted(moved[12][1], moved[9][1], 0.47),
    moved[13][0], moved[13][1]);
  line(
    weighted(moved[12][0], moved[9][0], 0.55),
    weighted(moved[12][1], moved[9][1], 0.55),
    moved[14][0], moved[14][1]);
  arc(
    weighted(moved[10][0], moved[11][0], 0.17) + footYAdj,
    weighted(moved[10][1], moved[11][1], 0.17) + footYAdj,
    footWidth, footWidth, PI * -0.1, PI * 1.1);
  arc(
    weighted(moved[10][0], moved[11][0], 0.83) + footYAdj,
    weighted(moved[10][1], moved[11][1], 0.83) + footYAdj,
    footWidth, footWidth, PI * -0.1, PI * 1.1);
}
