#!/bin/sh

# Source tutorial run functions
. $WM_PROJECT_DIR/bin/tools/RunFunctions
application=`getApplication`

runApplication blockMesh
# gmsh gmsh/mesh.geo -3 -o gmsh/mesh.msh -format msh22
# gmshToFoam gmsh/mesh.msh
# changeDictionary
setFields


runApplication $application

