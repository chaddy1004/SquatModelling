%Implemented by Sally Hui, our group member from my original iterative script
close all 
clear 
clc

%Length of bones in Meters
Spine = 0.56843; %The length from hip to where the load is applied
Femur = 0.34299; %Thigh
Tibia = 0.49733; %Shin

x0 = [55; 55; 55];

[x,fval] = fminsearch(@normMoment,[55, 55, 55]);
Ankle_opt = x(1)
Knee_opt = x(2)
Hip_opt = x(3)

%Vector Definitions
%Dependent Angles in Degrees
Beta = Knee_opt - Ankle_opt;
Alpha = Hip_opt - Beta;
    
ri_Hip = [(Spine*cosd(Alpha)),(Spine*sind(Alpha)),0];
ri_Knee = [(-1*Femur*cosd(Beta)),(Femur*sind(Beta)),0]+ri_Hip;
ri_Ankle = [(Tibia*cosd(Ankle_opt)),(Tibia*sind(Ankle_opt)),0] + ri_Knee;
    
Best_Posture = [ri_Hip;ri_Knee;ri_Ankle];
Best_Centroid = Centroid(ri_Hip, ri_Knee, ri_Ankle, Spine, Femur, Tibia);

figure
plot(Best_Centroid(1),Best_Centroid(2),'*')
hold on
DrawPosture(Best_Posture);
%Best_Posture








