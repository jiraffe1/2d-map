class tile {
  PVector gridPosition;
  PVector truePosition;
  int faction;
  float elevation;
  float size;
  boolean capitalCity;
  PVector colour;
  int population; // strokeWEight = population / 20000
  int expanded;
  
  tile(PVector position_, int faction_, float elevation_, boolean capitalCity_) {
    this.size = globalTileSize;
    this.gridPosition = position_;
    this.faction = faction_;
    this.elevation = elevation_;
    this.capitalCity = capitalCity_;
    this.population = 10000;
    this.truePosition = new PVector((gridPosition.x*globalTileSize)+(globalTileSize/2), (gridPosition.y*globalTileSize)+(globalTileSize/2));
    //easier colour inhertitance
    this.colour = countryColours.get(this.faction);
    this.expanded = 0;
  }
  
  void display() {
    
    if(heightMap[int(gridPosition.x)][int(gridPosition.y)] < 3) {
      map[int(gridPosition.x)][int(gridPosition.y)] = null;
    }
    int i = int(gridPosition.x);
    int j = int(gridPosition.y);
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
      strokeWeight(1);
      stroke(this.colour.x, this.colour.y, this.colour.z);
      
      if(!skeletonView)fill(this.colour.x, this.colour.y, this.colour.z);

      rect((this.gridPosition.x*globalTileSize), (this.gridPosition.y*globalTileSize), globalTileSize, globalTileSize); 
  }
  
  ArrayList<PVector> expansionTiles() {
    ArrayList<PVector>expansionTiles  = new ArrayList<PVector>();
    int x = int(this.gridPosition.x);
    int y = int(this.gridPosition.y);
    float[] scores = new float[4];
    PVector[] coords = new PVector[4];
    
    //list index map
    /*  0
        |
    3 -   - 1
        |
        2
    */
    
    //next up: some disgusting if  statements
    if(y  != 0)coords[0] = new PVector(x, y - 1);// else coords[0] = new PVector(691337, 420);
    if(x != mapDimensions-1)coords[1] = new PVector(x + 1, y); //else coords[1] = new PVector(691337, 420);
    if(y != mapDimensions-1)coords[2] = new PVector(x, y + 1); //else coords[2] = new PVector(691337, 420);
    if(x != 0)coords[3] = new PVector(x - 1, y); //else coords[3] = new PVector(691337, 420);
    
    // give all possible expansion tiles a score
    for(int a = 3; a >= 0; a--) {
      int i = int(coords[a].x);
      int j = int(coords[a].y);
      if(i != 691337 && j != 420) {
        
        if (heightMap[i][j] < 3) {
          //dont go into the sea.
          scores[a] = 0;
        } else if (heightMap[i][j] > 3 && heightMap[i][j] < 3.4) {
          scores[a] = 0.8;
        } else if (heightMap[i][j] > 3.4 && heightMap[i][j] < 5.5) {
          scores[a] = 1;
        } else if (heightMap[i][j] > 5.5 && heightMap[i][j] < 6.25) {
          scores[a] = 0.6;
        } else if (heightMap[i][j] > 6.25 && heightMap[i][j] < 7.5) {
          scores[a] = 0.4;
        } else if (heightMap[i][j] > 7.5) {
          scores[a] = 0.1;
        }
        //override: dont take somebody else's land... yet
        if(map[i][j] != null) {
          scores[a] = 0;
        }
      }
      else {
        scores[a] = -69;
      }
    }
    
    float m = getMax(scores);
    
    for(int i = 3; i >= 0; i--) {
      if(scores[i] == m && scores[i] != 0 && scores[i] != -69) {
        expansionTiles.add(coords[i]);
      }
    }
    
    return expansionTiles;
  }
  
  float getMax(float[] search) {//helper function for expansion 
    float max = 0;
    
    for(int i = 3; i >= 0; i--) {
      if(search[i] > max) {
        max = search[i];
      }
    }
    return max;
  }
  
  void expandLand() {
    if(this.expanded < 300) {
      this.expanded++;
      int n = this.expansionTiles().size() - 1;
      int m = int(random(n));
        
      if(m!=0) {
          
        PVector p = this.expansionTiles().get(m); 
        map[int(p.x)][int(p.y)] = new tile(new PVector(p.x, p.y), this.faction, heightMap[int(p.x)][int(p.y)], false);
      }
    }
  }
}
