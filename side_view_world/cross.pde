class CrossShape extends Particle {

  PShape p_shape;
  color col;
  
  //CrossShape(float x, float y, float w, float h_, Body body_, color c_) {
  CrossShape(Body body_, color c_) {
    super(body_);
    col = c_;
    //p_shape = makeCrossShape(w, h, c_);
  }
  
   void display() {    
    Vec2 pos = box2d.getBodyPixelCoord(body);
    float a = body.getAngle();

    // First we get the Fixture attached to the body...
    Fixture f = body.getFixtureList();
    while (f instanceof Fixture) {
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
      
      f = f.getNext();
    } 
  }
}



// Here's our function that adds the particle to the Box2D world
Body makeCrossBody(float x, float y, float w, float h) {
  
  PVector[] pts = new PVector[4];
  pts[0] = new PVector(1., .333);
  pts[1] = new PVector(-1., .333);
  pts[2] = new PVector(-1., -.333);
  pts[3] = new PVector(1., -.333);
  
  PVector[] pts2 = new PVector[4];
  pts2[0] = new PVector(0.333, 1.);
  pts2[1] = new PVector(-0.333, 1.);
  pts2[2] = new PVector(-.333, -1.);
  pts2[3] = new PVector(.333, -1.);
  

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
  
  // Scale points
  for (int i = 0; i < pts.length; i++) {
    pts[i] = new PVector(pts[i].x * scale_x, pts[i].y * scale_y);
    pts2[i] = new PVector(pts2[i].x * scale_x, pts2[i].y * scale_y);
    //pts[i] = pts[i].mult(scale_mag);
  }
  
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
  //CircleShape cs = new CircleShape();
  //cs.m_radius = box2d.scalarPixelsToWorld(r);
  PolygonShape ps = new PolygonShape();
  
  Vec2 verts[] = new Vec2[pts.length];
  for (int i = 0; i < pts.length; i++) {
    PVector this_vect = pts[i];
    verts[i] = new Vec2(box2d.scalarPixelsToWorld(this_vect.x), box2d.scalarPixelsToWorld(this_vect.y));
  }
  ps.set(verts, verts.length);


  PolygonShape ps2 = new PolygonShape();
 
  Vec2 verts2[] = new Vec2[pts.length];
  for (int i = 0; i < pts2.length; i++) {
    PVector this_vect = pts2[i];
    verts2[i] = new Vec2(box2d.scalarPixelsToWorld(this_vect.x), box2d.scalarPixelsToWorld(this_vect.y));
  }
  ps2.set(verts2, verts2.length);
  


  FixtureDef fd = new FixtureDef();
  fd.shape = ps;
  // Parameters that affect physics
  fd.density = .1;
  fd.friction = 0.1;
  fd.restitution = .75;
  
  FixtureDef fd2 = new FixtureDef();
  fd2.shape = ps2;
  // Parameters that affect physics
  fd2.density = .1;
  fd2.friction = 0.1;
  fd2.restitution = .85;

  // Attach fixture to body
  body.createFixture(fd);
  body.createFixture(fd2);

  //body.setAngularVelocity(30);
  body.setAngularVelocity(0.1f);
  
  return(body);
}
