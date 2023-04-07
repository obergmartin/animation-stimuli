/*
 *  Animation generation by Martin Oberg 
 *  December 2022
 *
 * Requires the library: Box2D for Processing 
 * The physics engine is Jbox2d.  Code is adapted by many examples in:
 * The Nature of Code, http://natureofcode.com
 * It is a Java/Processing wrapper for box2d: https://box2d.org/
 */ 


import shiffman.box2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;

// A reference to our box2d world
Box2DProcessing box2d;

// An ArrayList of particles that will fall on the surface
ArrayList<Boundary> boundaries;

// Particle is the parent class that others inherit from  
ArrayList<Particle> particles;

/****************************************
 * A flag to record animation frames
 ****************************************/
boolean recording = false;
//boolean recording = true;

color c1 = color(126,  126 ,225);
color c2 = color(249, 255 ,52);
color c3 = color(255,  177, 108);
color c4 = color(0,  153 ,53);
color c5 = color(204, 229 ,225);
color c6 = color(0,  51,102);
color c7 = color(102, 0, 102);
color c8 = color(20, 154, 131);
color c9 = color(84, 0, 119);
color c10 = color(65, 139, 225);
color c11 = color(219, 23, 149);
color c12 = color(29, 32, 101);
color c13 = color(155, 219, 178);
color c14 = color(255,  111, 111);
color c15 = color(102, 150, 198);
color c16 = color(252, 166, 91);

color col1, col2;
int n_collisions;
float timeStep;
int velocityIterations;
int positionIterations;
int n_frames;

// For bodies
Body body1;
Body body2;
float x1_pos;
float y1_pos;
float x2_pos;
float y2_pos;
float w_px;
float h_px;

// global friction variable so all animation s behave similarly
float gl_friction = 0.05;


/****************************************
 * This is run once before draw()
 ****************************************/
void setup() {
  // These parameters will tune the performance and accuracy of the physics simlulation
  timeStep = 1.0f / 60.0f;
  velocityIterations = 20;
  positionIterations = 20;
  n_frames = 0;
  
  // Size of the animation window
  size(640, 360);
  
  // Initialize box2d physics and create the world
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  box2d.setGravity(0, -40.);
  // Turn on collision listening!
  //box2d.listenForCollisions();

  boundaries = new ArrayList<Boundary>();
  //bottom
  boundaries.add(new Boundary(width/2, height-10, width-10, 10));
  //right
  boundaries.add(new Boundary(width-10,height/2, 10, height-10));
  //left
  boundaries.add(new Boundary(8, height/2, 10, height-10));
  
  // Choose which animation to run
  //negative1();
  positive2();
  //positive3();
  //negative2();
  
  // location to save frames
  String path = sketchPath("output/");
  // Use Tools > Movie Maker to generate .mp4 animation
  
  // Erase everything in the output directory before starting!  Save the animation somewhere else.
  File fp = new File(path);
  String[] fileNames = fp.list();
  for (int i=0; i<fileNames.length; i++) {
    //println(fileNames[i]);
    File f = new File(fileNames[i]);
    if (f.exists()) f.delete();
  }
}


/****************************************
 * This is run for each animation frame
 ****************************************/
void draw() {
  
  // step through time and update particles based on physics
  box2d.step(timeStep, velocityIterations, positionIterations);

  // clear the background
  background(255);

  // displaty particles
  // The for loop shouldn't require much computational overhead,
  // but since there are only 2 particles and 3 or 4 walls object  
  // drawing could easily be done explicitly for each object.  
  for (Particle p: particles) {
    p.display();
  }

  // Display all the boundaries
  for (Boundary wall: boundaries) {
    wall.display();
  }
  
  if (recording) doSaveFrame();
  
  // Stop after 600 frames (10s @ 60fps) 
  n_frames +=1;
  if (n_frames > 600) {
    exit();
  }
}

void doSaveFrame() {
  saveFrame("output/frame_####.tif");
}


// We could remove these and "box2d.listenForCollisions();" above to save performance if 
// we do not care about collision counting. 
void beginContact(Contact cp) {
  // Get both fixtures
  Fixture f1 = cp.getFixtureA();
  Fixture f2 = cp.getFixtureB();
  // Get both bodies
  Body b1 = f1.getBody();
  Body b2 = f2.getBody();

  // Get our objects that reference these bodies
  Object o1 = b1.getUserData();
  Object o2 = b2.getUserData();

  // Need to re-write for Particle class, but we are not counting collisions any more
  //if (o1.getClass() == Particle2.class && o2.getClass() == Particle2.class) {
  //  n_collisions += 1;
  //  println("N collisions:"+str(n_collisions));
  //}
}


void endContact(Contact cp){
  //cp;
}


///////////////////////////////////////////////////
// Stimuli Condition Setup
///////////////////////////////////////////////////

void negative1() {
  col1 = c7;
  col2 = c8;

  // Create the empty list
  particles = new ArrayList<>();
  PieShape p1, p2;
  
  x1_pos = 320.;
  y1_pos = 150.;
  x2_pos = int(random(50, 130));
  y2_pos = 150.;
  w_px = 60;
  h_px = 60;
  
  body1 = makePieBody(x1_pos, y1_pos, w_px, h_px);
  body2 = makePieBody(x2_pos, y2_pos, w_px, h_px);
  
  float ang1, ang2;
  //ang1 = round(10. * random(.8*PI, 1.2*PI)) / 10.;
  //ang2 = round(10. * random(1.8*PI, 0.3*PI)) / 10.;
  x2_pos = 117.;
  ang1 = 3.5;
  ang2 = 2.7;
  float initial_mag = 7500.;
  // was useful when generating random starts for particular behaviour
  //println("x2_pos", x2_pos);
  //println("ang1", ang1);
  //println("ang2", ang2);
  
  // right side
  p1 = new PieShape(x1_pos, y1_pos, w_px, h_px, body1, col1);
  p1.applyForce(new Vec2(initial_mag*cos(ang1), initial_mag*sin(ang1)));
  particles.add(p1);
  
  p2 = new PieShape(x2_pos, y2_pos, w_px, h_px, body2, col2);
  p2.applyForce(new Vec2(initial_mag*cos(ang2), initial_mag*sin(ang2)));
  particles.add(p2);
}


void positive2() {
  col1 = c7;
  col2 = c8;

  // Create the empty list
  particles = new ArrayList<>();
  HalfCircleShape p1, p2;
  
  x1_pos = 320.;
  y1_pos = 150.;
  x2_pos = int(random(50, 130));
  y2_pos = 150.;
  w_px = 80;
  h_px = 40;
  
  body1 = makeHalfCircleBody(x1_pos, y1_pos-(0.), w_px, h_px/1.);
  body2 = makeHalfCircleBody(x2_pos, y2_pos, w_px, h_px);
  
  float ang1, ang2;
  //ang1 = round(10.*random(.8*PI, 1.2*PI)) / 10.;
  //ang2 = round(10.*random(1.8*PI, 0.3*PI)) / 10.;
  x2_pos = 117.;
  ang1 = 3.7;
  ang2 = 5.8;
  float initial_mag = 7000.;
  //println("x2_pos", x2_pos);
  //println("ang1", ang1);
  //println("ang2", ang2);
  
  // right side
  p1 = new HalfCircleShape(x1_pos, y1_pos, w_px, h_px, body1, c1);
  p1.applyForce(new Vec2(initial_mag*cos(ang1), initial_mag*sin(ang1)));
  particles.add(p1);
  
  p2 = new HalfCircleShape(x2_pos, y2_pos, w_px, h_px, body2, c2);
  p2.applyForce(new Vec2(initial_mag*cos(ang2), initial_mag*sin(ang2)));
  particles.add(p2);
}


void positive3() {
  col1 = c13;
  col2 = c14;

  // Create the empty list
  CrossShape p1,p2;
  particles = new ArrayList<>();
  
  x1_pos = 320.;
  y1_pos = 150.;
  x2_pos = int(random(50, 130));
  y2_pos = 150.;
  w_px = 60;
  h_px = 30;
  
  float ang1, ang2;
  //float ang1 = round(10.*random(.8*PI, 1.2*PI)) / 10.;
  //float ang2 = round(10.*random(1.8*PI, 0.3*PI)) / 10.;
  x2_pos = 117.;
  ang1 = 3.5;
  ang2 = 5.7;
  float initial_mag = 9000.;
  //println("x2_pos", x2_pos);
  //println("ang1", ang1);
  //println("ang2", ang2);
  
  body1 = makeCrossBody(x1_pos, y1_pos, w_px, w_px);
  body2 = makeCrossBody(x2_pos, y2_pos, w_px, w_px);
  
  // right side
  p1 = new CrossShape(body1, col1);
  p1.applyForce(new Vec2(initial_mag*cos(ang1), initial_mag*sin(ang1)));
  particles.add(p1);
  
  p2 = new CrossShape(body2, col2);
  p2.applyForce(new Vec2(initial_mag*cos(ang2), initial_mag*sin(ang2)));
  particles.add(p2);
}


void negative2() {
  col1 = c15;
  col2 = c16;

  // Create the empty list
  RainDropShape p1, p2;
  particles = new ArrayList<>();
  
  x1_pos = 450.;
  y1_pos = 250.;
  x2_pos = int(random(50, 130));
  y2_pos = 250.;
  w_px = 30;
  h_px = 30;
  
  // adjust initial settings
  // Allow some random behaviour.  These values will be displayed in the console.
  // Copy those values below to hard code.
  float ang1, ang2;
  //ang1 = round(10.*random(.8*PI, 1.2*PI)) / 10.;
  //ang2 = round(10.*random(1.8*PI, 0.3*PI)) / 10.;
 
  x2_pos = 230.;
  ang1 = 4.5;
  ang2 = 2.6;
  float initial_mag = 8000.;
  //println("x2_pos", x2_pos);
  //println("ang1", ang1);
  //println("ang2", ang2);
  
  body1 = makeRainDropBody(x1_pos, y1_pos, w_px, w_px);
  body2 = makeRainDropBody(x2_pos, y2_pos, w_px, w_px);
  
  // right side
  p1 = new RainDropShape(body1, w_px, col1);
  p1.applyForce(new Vec2(initial_mag*cos(ang1), initial_mag*sin(ang1)));
  particles.add(p1);
  
  p2 = new RainDropShape(body2, w_px, col2);
  p2.applyForce(new Vec2(initial_mag*cos(ang2), initial_mag*sin(ang2)));
  particles.add(p2);
}
