
class Vertex {
  PVector position;
  HalfEdge edge;  // une des demi-arêtes qui sort de ce sommet
  PVector normal;

  Vertex(float x, float y, float z) {
    position = new PVector(x, y, z);
    normal = new PVector(0, 1, 0);
  }
}

class HalfEdge {
  Vertex origin;
  HalfEdge twin;
  HalfEdge next;
  Face face;

  HalfEdge(Vertex origin) {
    this.origin = origin;
  }
}

class Face {
  HalfEdge edge;

  Face(HalfEdge edge) {
    this.edge = edge;
  }
}

ArrayList<Vertex> vertices = new ArrayList<Vertex>();
ArrayList<Face> faces = new ArrayList<Face>();
int cols = 50;
int rows = 50;
float spacing = 10;
float[][] heightMap;

void setup() {
  size(800, 800, P3D);
  heightMap = new float[cols + 1][rows + 1];
  generateHeightMap();
  createMesh();
  computeNormals();
}

void draw() {
  background(135, 206, 235);
  lights();
  translate(width / 2, height / 2, -300);
  rotateX(PI/3);
  translate(-cols * spacing / 2, -rows * spacing / 2);

  for (Face face : faces) {
    drawFace(face);
  }
}

void generateHeightMap() {
  float scale = 0.1;
  for (int i = 0; i <= cols; i++) {
    for (int j = 0; j <= rows; j++) {
      float n = noise(i * scale, j * scale);
      // RIVIERE : On baisse la hauteur au milieu
      float river = exp(-pow((i - cols / 2.0) / 5.0, 2));
      heightMap[i][j] = map(n, 0, 1, -20, 20) - 20 * river;
    }
  }
}

void createMesh() {
  Vertex[][] grid = new Vertex[cols + 1][rows + 1];

  // Créer tous les sommets
  for (int i = 0; i <= cols; i++) {
    for (int j = 0; j <= rows; j++) {
      Vertex v = new Vertex(i * spacing, j * spacing, heightMap[i][j]);
      grid[i][j] = v;
      vertices.add(v);
    }
  }

  // Créer les triangles et demi-arêtes
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      Vertex v0 = grid[i][j];
      Vertex v1 = grid[i + 1][j];
      Vertex v2 = grid[i][j + 1];
      Vertex v3 = grid[i + 1][j + 1];

      createTriangle(v0, v1, v2);
      createTriangle(v1, v3, v2);
    }
  }
}

void createTriangle(Vertex v0, Vertex v1, Vertex v2) {
  HalfEdge e0 = new HalfEdge(v0);
  HalfEdge e1 = new HalfEdge(v1);
  HalfEdge e2 = new HalfEdge(v2);

  e0.next = e1;
  e1.next = e2;
  e2.next = e0;

  Face f = new Face(e0);
  e0.face = f;
  e1.face = f;
  e2.face = f;

  faces.add(f);
}

void drawFace(Face f) {
  HalfEdge e0 = f.edge;
  HalfEdge e1 = e0.next;
  HalfEdge e2 = e1.next;

  Vertex v0 = e0.origin;
  Vertex v1 = e1.origin;
  Vertex v2 = e2.origin;

  beginShape(TRIANGLES);
  fill(getColor(v0.position.z));
  normal(v0.normal.x, v0.normal.y, v0.normal.z);
  vertex(v0.position.x, v0.position.y, v0.position.z);

  fill(getColor(v1.position.z));
  normal(v1.normal.x, v1.normal.y, v1.normal.z);
  vertex(v1.position.x, v1.position.y, v1.position.z);

  fill(getColor(v2.position.z));
  normal(v2.normal.x, v2.normal.y, v2.normal.z);
  vertex(v2.position.x, v2.position.y, v2.position.z);
  endShape();
}

color getColor(float z) {
  if (z < -10) return color(30, 144, 255); // Eau (rivière)
  if (z < 0) return color(34, 139, 34);    // Herbe
  if (z < 10) return color(139, 69, 19);   // Terre
  return color(255);                       // Sommet (neige)
}

void computeNormals() {
  for (Vertex v : vertices) {
    v.normal.set(0, 0, 0);
  }

  for (Face f : faces) {
    HalfEdge e0 = f.edge;
    HalfEdge e1 = e0.next;
    HalfEdge e2 = e1.next;

    PVector p0 = e0.origin.position;
    PVector p1 = e1.origin.position;
    PVector p2 = e2.origin.position;

    PVector u = PVector.sub(p1, p0);
    PVector v = PVector.sub(p2, p0);
    PVector normal = u.cross(v).normalize();

    e0.origin.normal.add(normal);
    e1.origin.normal.add(normal);
    e2.origin.normal.add(normal);
  }

  for (Vertex v : vertices) {
    v.normal.normalize();
  }
}
