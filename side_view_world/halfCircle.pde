class HalfCircleShape extends Particle {

  PShape p_shape;
  color col;
  
  HalfCircleShape(float x, float y, float w, float h_, Body body_, color c_) {
    super(body_);
    body.setUserData(this);
    col = c_;
    //p_shape = makeHalfCircleShape(w, h, c_);
  }
  
   void display() {   
    Vec2 pos = box2d.getBodyPixelCoord(body);
    float a = body.getAngle();

    // First we get the Fixture attached to the body...
    Fixture f = body.getFixtureList();
    while (f instanceof Fixture) {
      // ...then the Shape attached to the Fixture.
      PolygonShape ps = (PolygonShape) f.getShape();
  
      // Translate drawing to local position and orientation angle
      pushMatrix();
      translate(pos.x,pos.y);
      rotate(-a);
      
      // colouring preferences
      fill(col);
      noStroke();
      
      beginShape();
      // Get shape coordinates from the body that exists in the world simulation.
      for (int i = 0; i < ps.getVertexCount(); i++) {
        Vec2 v = box2d.vectorWorldToPixels(ps.getVertex(i));
        vertex(v.x,v.y);
      }
      endShape(CLOSE);
      
      // translate out of local coordinates to be ready to draw the next item.
      popMatrix();
      
      f = f.getNext();
    } 
  }
}


// Here's our function that adds the particle to the Box2D world
Body makeHalfCircleBody(float x, float y, float w, float h) {
  // A smoother shape could be made with more points, but Jbox2d 
  // has a limit on the number of points allowed.  This could be 
  // avoided by making multiple bodies (quarter-circles, etc.) 
  // and linking them with a fixture like how the raindrop shape
  // is made.
  
  PVector[] pts = new PVector[8];
  pts[0] = new PVector(1, 0.5);
  pts[1] = new PVector(0.924, 0.129);
  pts[2] = new PVector(0.7071, -0.2071);
  pts[3] = new PVector(0.185, -0.479);
  pts[4] = new PVector(-0.232, -0.475);
  pts[5] = new PVector(-0.7071, -0.2071);
  pts[6] = new PVector(-0.92, 0.113);
  pts[7] = new PVector(-1, 0.5);
  
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
  
  // determine the "default" size vector coordinates
  float def_width = max_x_pos - min_x_pos;
  float def_height = max_y_pos - min_y_pos;
  
  // calculate a scale value based on desired size passed into the function. 
  float scale_x = w / def_width;
  float scale_y = h / def_height;
  //println(def_width);
  //println(def_height);
  //println(scale_x);
  //println(scale_y);
  
  // Scale points
  for (int i = 0; i < pts.length; i++) {
    pts[i] = new PVector(pts[i].x * scale_x, pts[i].y * scale_y);
  }
  
  Body body;
  
  // Define a body
  BodyDef bd = new BodyDef();
  bd.position = box2d.coordPixelsToWorld(x, y);
  bd.type = BodyType.DYNAMIC;
  body = box2d.createBody(bd);

  PolygonShape ps = new PolygonShape();
  
  // The shape needs to be converted from pixel coordinates to 
  // coordinates for the physics world.
  Vec2 verts[] = new Vec2[pts.length];
  for (int i = 0; i < pts.length; i++) {
    PVector this_vect = pts[i];
    verts[i] = new Vec2(box2d.scalarPixelsToWorld(this_vect.x), box2d.scalarPixelsToWorld(this_vect.y));
  }
  ps.set(verts, verts.length);
  FixtureDef fd = new FixtureDef();
  fd.shape = ps;

  // Parameters that affect physics
  fd.density = .09;
  fd.friction = gl_friction;
  fd.restitution = .8;
  

  // Attach fixture to body
  body.createFixture(fd);

  //body.setAngularVelocity(30);
  body.setAngularVelocity(0.2f);
  
  return(body);
}
