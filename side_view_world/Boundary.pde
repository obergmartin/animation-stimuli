class Boundary {
  // A fixed boundary class
  // A boundary is a simple rectangle with x,y,width,and height
  // (x, y) is the centre of the object.  (0, 0) is the top left of the screen
  float x; 
  float y; 
  float w;
  float h;
  
  // We also have to make a body for box2d to know about it
  Body b;

  Boundary(float x_,float y_, float w_, float h_) {
    x = x_;
    y = y_;
    w = w_;
    h = h_;

    // Define the polygon
    PolygonShape sd = new PolygonShape();
    // Figure out the box2d coordinates
    float box2dW = box2d.scalarPixelsToWorld(w/2);
    float box2dH = box2d.scalarPixelsToWorld(h/2);
    sd.setAsBox(box2dW, box2dH);

    // Create the body
    BodyDef bd = new BodyDef();
    bd.type = BodyType.STATIC;
    bd.position.set(box2d.coordPixelsToWorld(x,y));
    b = box2d.createBody(bd);
    
    // Attached the shape to the body using a Fixture
    b.createFixture(sd,1);
    b.setUserData(this);
  }

  // Draw the boundary, if it were at an angle we'd have to do something fancier
  void display() {
    // colour
    fill(0);
    // no outline
    stroke(0);
    // class defined as centre orientated box
    rectMode(CENTER);
    rect(x,y,w,h);
  }

}
