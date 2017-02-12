/* @pjs preload="DSI_VC_Banner_Mask.jpg"; */

int WIDTH = 11000;
int HEIGHT = 1200;

int COLOUR_WIDTH = 16;
int COLOUR_HEIGHT = 3;

float COLOUR_SPREAD = 0.35;
int NO_OF_CHANGES = 100; // number of circles to update each interation

int  radius = 12;
int drop = 30;
int gridWidth; //number of circles in one row on the x axis

boolean increaseSpread = true;

PImage banner;
ArrayList <Circle> circles;
CircleGrid circleGrid;

void setup() {
  size(12800, 1190);
  background(0);
  smooth();

  PImage back = get(50, 50, 300, 300);
  image(back, 100, 100);
  banner = loadImage("DSI_VC_Banner_Mask.jpg", "jpg");
  circleGrid = new CircleGrid();
}

void draw() {
  circleGrid.run();
}


class CircleGrid {
  CircleGrid() {
    circles = new ArrayList <Circle>();
    circles.add(new Circle());

    while (circles.get (circles.size () -1).yPos < HEIGHT + radius) {
      circles.add(new Circle());
    }

    for (int i = 0; i < circles.size (); i++)
      circles.get(i).drawCircle();
  }

  void run() {
    for (int i = 0; i < NO_OF_CHANGES; i ++) {
      int ranCircle = int(random(circles.size()-1));
      circles.get(ranCircle).update();
    }

    //variance in colour spread
     if (increaseSpread) {
     COLOUR_SPREAD += 0.00005;
     if (COLOUR_SPREAD >= 0.8)
     increaseSpread = false;
     } else {
     COLOUR_SPREAD -= 0.00005;
     if (COLOUR_SPREAD <= 0.4)
     increaseSpread = true;
     }
  }
}

class Circle {
  int index;
  int xPos;
  int yPos;
  int row;
  int position;
  boolean active; //to trak whether to display this circle or not
  Circle () {
    index = circles.size();
    //for first circle
    if (index == 0) {
      xPos = 0;
      yPos = 0;
      row = 0;
      position = 0; //index of the circle in its row
    } else {
      //determine using position of previous circle
      xPos = circles.get(index-1).xPos + (radius*2);
      yPos = circles.get(index-1).yPos;
      row = circles.get(index-1).row;
      position = circles.get(index-1).position + 1;

      //check if position has reached beyond bounds of canvas
      //if so, go to the next row
      if (xPos > (WIDTH + radius)) {
        xPos = 0;
        position = 0;
        row += 1;
        yPos += (radius*2);
      }
      
      //check whether the circle is to be active
      if (banner.get(xPos, yPos) >= -1){
        active = true;
      }
      else{
        active = false;
      }
      
      //update the grid width
      if (position > gridWidth)
        gridWidth = position;

    }
  }

  void drawCircle() {
    //Only draw if wihin the mask
    /*
    if (banner.get(xPos, yPos) >= -1){
      noStroke();
      fill(colors[int((COLOUR_WIDTH/(gridWidth + 1.0)) * position)][int(random(3))]);
      fill(colors[int(random(COLOUR_WIDTH))][int(random(COLOUR_HEIGHT))]);
      ellipse(xPos, yPos, radius*2, radius*2);
    } */
  }


  void update() {
      //Only draw if wihin the mask
      //if (banner.get(xPos, yPos) >= -1){
      //draw the hexagon
      if (active){
      noStroke();
        
      int colorSelect = -1;
       while (colorSelect < 0 || colorSelect >= COLOUR_WIDTH) {
       int spreadCalculation = int(random(-COLOUR_SPREAD*COLOUR_WIDTH, COLOUR_SPREAD*COLOUR_WIDTH));    
       colorSelect = int((COLOUR_WIDTH/(gridWidth + 1.0))* position)
       + spreadCalculation;
       } 
      //for color spread
      fill(colors[colorSelect][int(random(3))]);
  
      //use random for color
      //fill(colors[int(random(COLOUR_WIDTH))][int(random(3))]);
      ellipse(xPos, yPos, radius*2, radius*2);
     }
  }
}