int mapDimensions =250;
float globalTileSize;
float[][] heightMap;
ArrayList<PVector>countryColours;
tile[][] map;
int seed = 0;
boolean blackAndWhite = false;
boolean changeSeed = false;
float toOffsetColour = 0;
boolean skeletonView;
int faction = 0;

void setup() {
  size(1000, 1000);
  globalTileSize = 1000/mapDimensions;
  heightMap = new float[mapDimensions][mapDimensions];
  map = new tile[mapDimensions][mapDimensions];
  countryColours = new ArrayList<PVector>();
  flattenHeightMap();
  addHeight();
}

void draw() {
  background(255);
  if (changeSeed) {
    noiseSeed(seed);    

    seed++;
    addHeight();
  }

  drawHeightMap();
  showAllMapTiles();
}

void flattenHeightMap() {
  for (int i = mapDimensions - 1; i >= 0; i--) {
    for (int j = mapDimensions - 1; j >= 0; j--) {
      heightMap[i][j] = 0;
    }
  }
}

void fillMapWithNull() {
  for (int i = mapDimensions - 1; i >= 0; i--) {
    for (int j = mapDimensions - 1; j >= 0; j--) {
      map[i][j] = null;
    }
  }
}

void addHeight() {
  float yoff = 0;
  for (int y = 0; y < mapDimensions; y++) {
    float xoff = 0;
    for (int x = 0; x < mapDimensions; x++) {
      heightMap[x][y] = (noise(xoff, yoff)*10)+toOffsetColour;
      xoff += 0.04;
    }

    yoff += 0.04;
  }
}

void drawHeightMap() {
  for (int i = mapDimensions - 1; i >= 0; i--) {
    for (int j = mapDimensions - 1; j >= 0; j--) {
      if (heightMap[i][j] < 3) {
        fill(0, 0, 255);
      } else if (heightMap[i][j] > 3 && heightMap[i][j] < 3.4) {
        fill(255, 255, 0);
      } else if (heightMap[i][j] > 3.4 && heightMap[i][j] < 5.5) {
        fill(0, 255, 0);
      } else if (heightMap[i][j] > 5.5 && heightMap[i][j] < 6.25) {
        fill(0, 230, 0);
      } else if (heightMap[i][j] > 6.25 && heightMap[i][j] < 7.5) {
        fill(150);
      } else if (heightMap[i][j] > 7.5) {
        fill(255);
      }
      strokeWeight(0);
      stroke(0);
      if (blackAndWhite)fill(heightMap[i][j]*25);

      rect((i*globalTileSize), (j*globalTileSize), globalTileSize, globalTileSize);
    }
  }
}

void addCapitalCities() {
  boolean okSpot = false;
  PVector placePos = new PVector(0,0);

    //dont put countries in the water, it isnt a good idea
    while(!okSpot) {
      placePos = new PVector(round(random(mapDimensions-1)), round(random(mapDimensions-1)));
      if(heightMap[int(placePos.x)][int(placePos.y)] > 3 && map[int(placePos.x)][int(placePos.y)] == null) {
        okSpot = true;
      }
      else {
        okSpot = false;
      }
    }
    countryColours.add(new PVector(random(250), random(250), random(250)));
    map[int(placePos.x)][int(placePos.y)] = new tile(new PVector(placePos.x, placePos.y), faction, heightMap[int(placePos.x)][int(placePos.y)], true);
    faction++;
}

void keyPressed() {
  if (key == 'q') {
    if (blackAndWhite) {
      blackAndWhite = false;
    } else {
      blackAndWhite = true;
    }
  }
  if (key == 'w') {
    if (changeSeed) {
      changeSeed = false;
    } else {
      changeSeed = true;
    }
  }
  
  if (key == 'u') {
    if (skeletonView) {
      skeletonView = false;
    } else {
      skeletonView = true;
    }
  }

  if (key == 'a') {
    toOffsetColour -= 0.01;
    addHeight();
  }

  if (key == 's') {
    toOffsetColour += 0.01;
    addHeight();
  }
  if(key == 't') {
    addCapitalCities();
  }
  if(key == 'y') {
    allTilesExpand();
  }
  
}

void showAllMapTiles() {
  for(int i = 0; i < mapDimensions; i++) {
    for(int j = 0; j < mapDimensions; j++) {
      if(map[i][j] != null) {
        map[i][j].display();
      }
    }
  }
}

void allTilesExpand() {
  for(int i = 0; i < mapDimensions; i++) {
    for(int j = 0; j < mapDimensions; j++) {
      if(map[i][j] != null) {
        map[i][j].expandLand();
      }
    }
  }
}
