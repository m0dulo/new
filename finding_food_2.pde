/* @pjs preload="bush.png,dog.png,ground.png,parterre-1.png,parterre-2.png,parterre-3.png,parterre-4.png" */
float mapWidth = 1200, mapHeight = 1200;
float vpWidth = 600, vpHeight = 600;
float vpOriginX = 0, vpOriginY = 0;
float dogX, dogY;
float foodRange = 30;

PImage dogImage;
PImage groundImage;
int parterreImgCount = 4;
PImage[] parterreImage = new PImage[parterreImgCount];
PImage bushImage;

class Barrier {
  float x, y;
  boolean isParterre;
  float radius; int parterreType;
  float width, height;
  boolean containsPoint(float px, float py) {
    if (this.isParterre) return dist(x, y, px, py) <= radius;
    else return px >= x && px <= x + width && py >= y && py <= y + height;
  }
  void draw(float vpx, float vpy) {
    if (this.isParterre) image(parterreImage[parterreType], x - vpx, y - vpy, radius * 2, radius * 2);
    else image(bushImage, x - vpx + width / 2, y - vpy + height / 2, width, height);
  }
}
int barrierCount = 15;
Barrier[] barriers = new Barrier[barrierCount];
float[] foodX = new float[3];
float[] foodY = new float[3];
color[] foodColour = new color[]{#FF0000, #00FF00, #0000FF};
String[] foodName = new String[]{"Red food", "Green food", "Blue food"};

int i, j;

float rpx, rpy;
void randomPoint() {
  boolean fine;
  do {
    rpx = random(mapWidth);
    rpy = random(mapHeight);
    fine = true;
    for (int i = 0; i < barrierCount; ++i)
      if (barriers[i].containsPoint(rpx, rpy)) {
        fine = false; break;
      }
  } while (!fine);
}

void setup() {
  size((int)vpWidth, (int)vpHeight);
  dogImage = loadImage("dog.png");
  groundImage = loadImage("ground.png");
  for (i = 0; i < parterreImgCount; ++i)
    parterreImage[i] = loadImage("parterre-" + (i + 1) + ".png");
  bushImage = loadImage("bush.png");
  imageMode(CENTER);
  textSize(64);

  // Generate the map
  float minX = 0;
  for (i = 0; i < barrierCount; ++i) {
    barriers[i] = new Barrier();
    barriers[i].isParterre = true;
    barriers[i].radius = random(64, 192);
    barriers[i].parterreType = (int)random(parterreImgCount);
    barriers[i].x = minX + random(barriers[i].radius, barriers[i].radius * 2);
    barriers[i].y = random(barriers[i].radius, mapHeight - barriers[i].radius);
    minX = barriers[i].x + barriers[i].radius;
    if (minX > mapWidth) break;
  }
  ++i;
  barriers[i] = new Barrier();
  barriers[i].isParterre = false;
  barriers[i].width = random(64, 384);
  barriers[i].height = random(64, 384);
  barriers[i].x = random(0, mapWidth - barriers[i].width);
  barriers[i].y = random(0, mapHeight - barriers[i].height);
  barrierCount = i + 1;

  // Place the dog
  randomPoint();
  dogX = rpx; dogY = rpy;
  vpOriginX = constrain(dogX - vpWidth / 2, 0, mapWidth - vpWidth);
  vpOriginY = constrain(dogY - vpHeight / 2, 0, mapHeight - vpHeight);
  // Place the food
  for (i = 0; i < 3; ++i) {
    randomPoint();
    foodX[i] = rpx;
    foodY[i] = rpy;
  }
}

void draw() {
  background(0);
  // Draw the ground
  float offsetX = vpOriginX % groundImage.width,
    offsetY = vpOriginY % groundImage.height;
  for (i = 0; i < ceil(vpWidth / groundImage.width) + 1; ++i)
    for (j = 0; j < ceil(vpHeight / groundImage.height) + 1; ++j)
      image(groundImage, (i + 0.5) * groundImage.width - offsetX, (j + 0.5) * groundImage.height - offsetY);

  // Draw the barriers
  for (i = 0; i < barrierCount; ++i) {
    barriers[i].draw(vpOriginX, vpOriginY);
  }

  // Draw the dog
  image(dogImage, dogX - vpOriginX, dogY - vpOriginY);

  // Draw the cover
  fill(
    max(0, 255 - dist(dogX, dogY, foodX[0], foodY[0])),
    max(0, 255 - dist(dogX, dogY, foodX[1], foodY[1])),
    max(0, 255 - dist(dogX, dogY, foodX[2], foodY[2])),
    96);
  rect(0, 0, vpWidth, vpHeight);
  for (i = 0; i < 3; ++i) {
    if (dist(dogX, dogY, foodX[i], foodY[i]) <= foodRange) {
      fill(foodColour[i]);
      text(foodName[i] + "\nFound", dogX - vpOriginX, dogY - vpOriginY);
    }
  }

  // Move
  if (keyPressed) {
    float dogTX = dogX, dogTY = dogY;
    switch (key) {
      case 'W': case 'w': dogTY = constrain(dogY - 4, 0, mapWidth); break;
      case 'A': case 'a': dogTX = constrain(dogX - 4, 0, mapWidth); break;
      case 'S': case 's': dogTY = constrain(dogY + 4, 0, mapWidth); break;
      case 'D': case 'd': dogTX = constrain(dogX + 4, 0, mapWidth); break;
    }
    for (i = 0; i < barrierCount; ++i)
      if (barriers[i].containsPoint(dogTX, dogTY)) {
        dogTX = dogX; dogTY = dogY; break;
      }
    dogX = dogTX;
    dogY = dogTY;
    vpOriginX = constrain(dogX - vpWidth / 2, 0, mapWidth - vpWidth);
    vpOriginY = constrain(dogY - vpHeight / 2, 0, mapHeight - vpHeight);
  }
}

