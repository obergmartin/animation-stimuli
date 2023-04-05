/*
  This shape is implemented in a less than ideal fashion.
  The PShape type allows easy drawing of the arc of a circle,
  which is what the pie/pacman shape is.  However, box2d still
  needs coordinates to define a body.  The shape could be 
  simulated as a circle but that might result in the shape 
  "floating" when actually resting on the ground.  The body
  definition that gets used is actually an octogon, which of 
  course is not a circle, but should not cause any visual 
  artifacts as all sides are treated equally.  
 */
class PieShape extends Particle {

  PShape p_shape;
  color col;
  
  PieShape(float x, float y, float w, float h_, Body body_, color c_) {
    super(body_);
    body.setUserData(this);
    col = c_;
    p_shape = makePieShape(w, h_, c_);
  }
  
  void display() {
    Vec2 pos = box2d.getBodyPixelCoord(body);
    float a = body.getAngle();

    
    //rectMode(CENTER);
    pushMatrix();
    translate(pos.x,pos.y);
    rotate(-a);
    fill(col);
    //stroke(0);
    noStroke();
    
    shape(p_shape);
    popMatrix();
  }
}

PShape makePieShape(float w, float h, color c) {
    
  PVector[] pts = new PVector[8];
  pts[0] = new PVector(1, 0);
  pts[1] = new PVector(.7071, .7071);
  pts[2] = new PVector(0, 1);
  pts[3] = new PVector(-0.7071, 0.7071);
  pts[4] = new PVector(-1, 0);
  pts[5] = new PVector(-0.7071, -0.7071);
  pts[6] = new PVector(0, -1);
  pts[7] = new PVector(0.7071, -0.7071);  
  
  // Determine width and height for scaling purposes
  float min_x_pos = 9999;
  float min_y_pos = 9999;
  float max_x_pos = -9999;
  float max_y_pos = -9999;
  
  for (int i = 0; i < pts.length; i++) {
    if (pts[i].x > max_x_pos) max_x_pos = pts[i].x;
    if (pts[i].x < min_x_pos) min_x_pos = pts[i].x;
    if (pts[i].y > max_y_pos) max_y_pos = pts[i].y;
    if (pts[i].y < min_y_pos) min_y_pos = pts[i].y;
  }
  
  float def_width = max_x_pos - min_x_pos;
  float def_height = max_y_pos - min_y_pos;
  
  float scale_x = w / def_width;
  float scale_y = h / def_height;
  //float scale_mag = new PVector(scale_x, scale_y).mag();
  //println(def_width);
  //println(def_height);
  
  
  //println(scale_x);
  //println(scale_y);
  
  // Scale points
  for (int i = 0; i < pts.length; i++) {
    pts[i] = new PVector(pts[i].x * scale_x, pts[i].y * scale_y);
    //pts[i] = pts[i].mult(scale_mag);
  }
  
  // These constants for PI and HALF_PI rotate the arc so the body defined
  // below has a flat edge that lines up with the arc opening.  There are
  // not quite perfect, but close.
  PShape s = createShape(ARC, 0.,0., w,h, 0.125*PI, 3.675*HALF_PI, PIE);
  s.setStroke(false);
  s.setFill(c);
  
  return(s);
}


// Here's our function that adds the particle to the Box2D world
Body makePieBody(float x, float y, float w, float h) {
  
  PVector[] pts = new PVector[8];
  pts[0] = new PVector(1, 0);
  pts[1] = new PVector(.7071, .7071);
  pts[2] = new PVector(0, 1);
  pts[3] = new PVector(-0.7071, 0.7071);
  pts[4] = new PVector(-1, 0);
  pts[5] = new PVector(-0.7071, -0.7071);
  pts[6] = new PVector(0, -1);
  pts[7] = new PVector(0.7071, -0.7071);  
  
  // Determine width and height for scaling purposes
  float min_x_pos = 9999;
  float min_y_pos = 9999;
  float max_x_pos = -9999;
  float max_y_pos = -9999;
  
  for (int i = 0; i < pts.length; i++) {
    if (pts[i].x > max_x_pos) max_x_pos = pts[i].x;
    if (pts[i].x < min_x_pos) min_x_pos = pts[i].x;
    if (pts[i].y > max_y_pos) max_y_pos = pts[i].y;
    if (pts[i].y < min_y_pos) min_y_pos = pts[i].y;
  }
  
  float def_width = max_x_pos - min_x_pos;
  float def_height = max_y_pos - min_y_pos;
  
  float scale_x = w / def_width;
  float scale_y = h / def_height;
  //float scale_mag = new PVector(scale_x, scale_y).mag();
  //println(def_width);
  //println(def_height);
  
  //println(scale_x);
  //println(scale_y);
  //println("x");
  
  // Scale points
  for (int i = 0; i < pts.length; i++) {
    pts[i] = new PVector(pts[i].x * scale_x, pts[i].y * scale_y);
    //pts[i] = pts[i].mult(scale_mag);
  }
  
  Body body;
  
  // Define a body
  BodyDef bd = new BodyDef();
  // Set its position
  bd.position = box2d.coordPixelsToWorld(x, y);
  bd.type = BodyType.DYNAMIC;
  body = box2d.createBody(bd);

  PolygonShape ps = new PolygonShape();
  Vec2 verts[] = new Vec2[pts.length];
  for (int i = 0; i < pts.length; i++) {
    PVector this_vect = pts[i];
    verts[i] = new Vec2(box2d.scalarPixelsToWorld(this_vect.x), box2d.scalarPixelsToWorld(this_vect.y));
  }
  ps.set(verts, verts.length);
  
  FixtureDef fd = new FixtureDef();
  //fd.shape = circle;//ps;
  fd.shape = ps;
  // Parameters that affect physics
  fd.density = .1;
  fd.friction = gl_friction;
  fd.restitution = .75;
  

  // Attach fixture to body
  body.createFixture(fd);

  //body.setAngularVelocity(30);
  body.setAngularVelocity(0.0f);
  
  return(body);
}
