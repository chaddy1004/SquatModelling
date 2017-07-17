function Centroid = Centroid( r_Hip, r_Knee, r_Ankle, Spine, Femur, Tibia )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%Cartesian coordinate representation of positions of joints
p_Ankle = [0,0,0];
p_Knee = r_Ankle-r_Knee;
p_Hip = (r_Knee-r_Hip)+p_Knee;
p_Load = r_Hip + p_Hip;

%Computing Centroid of a straight line
centroid_Spine = (p_Load-p_Hip)/2;
centroid_Femur = (p_Hip-p_Knee)/2;
centroid_Tibia = p_Knee/2;

%Calculating x and y position for centroid
Centroidx = double((centroid_Spine(1)+centroid_Femur(1)+centroid_Tibia(1))/(Spine+Femur+Tibia));
Centroidy = double((centroid_Spine(2)+centroid_Femur(2)+centroid_Tibia(2))/(Spine+Femur+Tibia));

Centroid = [Centroidx,Centroidy,0];

end

