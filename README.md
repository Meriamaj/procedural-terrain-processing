# Procedural Terrain with Half-Edge Mesh (Processing)

This project generates a **procedural terrain** using Processing (Java).  
It implements a **Half-Edge Mesh** structure for faces/edges/vertices,  
computes normals for smooth shading, and colors terrain by altitude  
(water, grass, earth, snow). A Gaussian function is applied to create  
a **river valley** across the terrain.

**Features**:
- Half-Edge mesh data structure
- Noise-based heightmap
- River deformation
- Vertex normals for lighting
- Altitude-based coloring

**Preview:**

<img width="795" height="709" alt="image" src="https://github.com/user-attachments/assets/f0c20721-d155-420c-871f-388288f8e3c9" />


---

Ce projet génère un **terrain procédural** en utilisant Processing (Java).  
Il met en œuvre une **structure Half-Edge Mesh** pour gérer faces/arrêtes/sommets,  
calcule les normales pour un éclairage lissé, et colorie le terrain par altitude  
(eau, herbe, terre, neige). Une fonction gaussienne crée une **vallée fluviale**  
au milieu de la carte.

**Caractéristiques :**
- Structure de maillage Half-Edge
- Heightmap basée sur le bruit
- Déformation pour rivière
- Normales des sommets pour l’éclairage
- Coloration par altitude


---

## Run
- Install [Processing](https://processing.org/)  
- Open `src/TerrainMesh.pde` in Processing IDE  
- Run the sketch
