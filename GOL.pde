int width = 1000, height = 1000; // set width and height of playground
int cellSize = 50;  // set cellSize width and height (cellSize * cellSize)
color cellAlive = #b6ff00; // set cell's background color to "Neongrün"
GameOfLife oszilator;
GameOfLife blinker;

void setup() { // run onces when the programm starts, variables daeclared within sezup() are not accesible within other functions, including draw()
  if (width % cellSize != 0 || height % cellSize != 0) 
    throw new IllegalArgumentException("width und height sind ein ganzzahliges Vielfaches >= 1 von cellSize");
  frameRate(3);
  windowResize(width, height);
  oszilator = new GameOfLife(height / cellSize, width / cellSize);
  oszilator.set(4, 2).set(5, 2).set(6, 2).set(10, 2).set(11, 2).set(12, 2)
       .set(2, 4).set(2, 5).set(2, 6).set(7, 4).set(7, 5).set(7, 6)
       .set(9, 4).set(9, 5).set(9, 6).set(14, 4).set(14, 5).set(14, 6)
       .set(4, 7).set(5, 7).set(6, 7).set(10, 7).set(11, 7).set(12, 7)
       .set(4, 9).set(5, 9).set(6, 9).set(10, 9).set(11, 9).set(12, 9)
       .set(2, 10).set(2, 11).set(2, 12).set(7, 10).set(7, 11).set(7, 12)
       .set(9, 10).set(9, 11).set(9, 12).set(14, 10).set(14, 11).set(14, 12)
       .set(4, 14).set(5, 14).set(6, 14).set(10, 14).set(11, 14).set(12, 14);
  /*     
  blinker = new GameOfLife(height / cellSize, width / cellSize);
  blinker.set(4, 2).set(5,2).set(6,2);  
  */
}

/*
Called directly after setup(), 
the draw() function continuously executes the lines of code contained inside its block until the program is stopped or noLoop() is called. 
draw() is called automatically and should never be called explicitly.
The number of times draw() executes in each second may be controlled with the frameRate() function.
*/
void draw() {
  background(255); // reset background to white
  oszilator.timestep();
  oszilator.display();
  /*
  blinker.timestep();
  blinker.display();
  */
}

class GameOfLife {
  int[] world;
  int rows, cols;
  final int LIVE = 1, DEAD = 0;
  GameOfLife(int rows, int cols) {
   assert rows >= 1 && cols >= 1; // 1*1 is the smallest playground
   this.rows = rows;
   this.cols = cols;
   world = new int[(rows + 2) * (cols + 2)]; // imaginärer Rand
  }
  GameOfLife set(int row, int col) {
   world[row * (cols + 2) + col] = LIVE;
   return this; 
  } //<>//
  int rules(int centerCell) { // check rules
    int count = 0;
    int neighbours[] = { // define eight neighbours
     centerCell - (cols + 2), // top
     centerCell - (cols + 2) - 1, // top-left
     centerCell - (cols + 2) + 1, // top-right
     centerCell + (cols + 2), // bottom
     centerCell + (cols + 2) - 1, // bottom-left
     centerCell + (cols + 2) + 1, // bottom-right 
     centerCell + 1, // right
     centerCell - 1 // left
    };
    for (int neighbour : neighbours) // iterate neighbours array and count alive neighbours from centerCell
      count += world[neighbour];
    /*
    Hat eine unbelebte Zelle exakt 3 belebte Nachbarn, dann ist die Zelle im nächsten Zeitschritt belebt.
    */
    if (world[centerCell] != LIVE) return count == 3 ? LIVE : DEAD;
    /*
    Eine lebende Zelle mit zwei oder drei Nachbarn bleibt im nächsten Zeitschritt am Leben. (Bedingung lebend wurde vorher überprüft)
    */
    if (count == 2 || count == 3) return LIVE;
    /*
    Einsamkeit <2 Überbevölkerung > 3 (alle Bedingungen vorher geprüft)
    */
    return DEAD;
  }
  void timestep() {
    int[] newWorld = new int[world.length];
    for (int row = 1; row <= rows; row++) {
     for (int col = 1; col <= cols; col++) {
       int pos = row * (cols + 2) + col;
       newWorld[pos] = rules(pos);
     }
    }
    world = newWorld;
  }
  void display() {
    for (int row = 1; row <= rows; row++) {
     for (int col = 1; col <= cols; col++) {
       int pos = row * (cols + 2) + col;
       if (world[pos] == LIVE) {
       fill(cellAlive);
       noStroke();
       rect((col - 1) * cellSize, (row - 1) * cellSize, cellSize, cellSize);
       }
     }
    }
  }
}
