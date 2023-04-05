class RainDropShape extends Particle {

  float w;
  color col;
  
  RainDropShape(Body body_, float w_, color c_) {
    super(body_);
    w = w_;
    col = c_;
  }
  
  void display() {
    Vec2 pos = box2d.getBodyPixelCoord(body);
    float a = body.getAngle();

    // First we get the Fixture attached to the body...
    Fixture f = body.getFixtureList();
    // ...then the Shape attached to the Fixture.
    PolygonShape ps = (PolygonShape) f.getShape();

    //rectMode(CENTER);
    pushMatrix();
    translate(pos.x,pos.y);
    rotate(-a);
    fill(col);
    //stroke(0);
    noStroke();
    beginShape();
    //[offset-up] We can loop through that array and convert each vertex from Box2D space to pixels.
    for (int i = 0; i < ps.getVertexCount(); i++) {
      Vec2 v = box2d.vectorWorldToPixels(ps.getVertex(i));
      vertex(v.x,v.y);
    }
    endShape(CLOSE);
    popMatrix();
    
    pushMatrix();
    translate(pos.x, pos.y);
    fill(col);
    noStroke();
    circle(0.,0.,w*2.);
    popMatrix();
  }
}


// Here's our function that adds the particle to the Box2D world
Body makeRainDropBody(float x, float y, float w, float h) {
  
  PVector[] pts = new PVector[3];
  pts[0] = new PVector(0., 45.);
  pts[1] = new PVector(-24., 18.);
  pts[2] = new PVector(24., 18.);
  
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
  scale_y = scale_x;
  //float scale_mag = new PVector(scale_x, scale_y).mag();
  //println(def_width);
  //println(def_height);
  
  //println(scale_x);
  //println(scale_y);
  
  //// Scale points
  //for (int i = 0; i < pts.length; i++) {
  //  pts[i] = new PVector(pts[i].x * scale_x, pts[i].y * scale_y);
  //  //pts[i] = pts[i].mult(scale_mag);
  //}
  
  Body body;
  
  // Define a body
  BodyDef bd = new BodyDef();
  // Set its position
  bd.position = box2d.coordPixelsToWorld(x, y);
  bd.type = BodyType.DYNAMIC;
  //bd.linearDamping = 0.9;
  //bd.angularDamping = 0.9;
  body = box2d.createBody(bd);

  // Make the body's shape a circle
  CircleShape cs = new CircleShape();
  cs.m_radius = box2d.scalarPixelsToWorld(w);
  //cs.set_density(0.5);??
  
  PolygonShape ps = new PolygonShape();
  Vec2 verts[] = new Vec2[pts.length];
  for (int i = 0; i < pts.length; i++) {
    PVector this_vect = pts[i];
    verts[i] = new Vec2(box2d.scalarPixelsToWorld(this_vect.x), box2d.scalarPixelsToWorld(this_vect.y));
  }
  ps.set(verts, verts.length);

  FixtureDef fd1 = new FixtureDef();
  fd1.shape = cs;
  // Parameters that affect physics
  fd1.density = .081;
  fd1.friction = gl_friction;
  fd1.restitution = .8;



  FixtureDef fd = new FixtureDef();
  fd.shape = ps;
  // Parameters that affect physics
  fd.density = .081;
  fd.friction = gl_friction;
  fd.restitution = .8;
  
  
  // Attach fixture to body
  body.createFixture(fd1);
  body.createFixture(fd);
  bd.angularDamping = 0.2;

  //body.setAngularVelocity(30);
  body.setAngularVelocity(0.1f);
  
  return(body);
}
