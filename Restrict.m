close all 
clear 
clc

%PreProcessing 
%Height of Person in meters
Height = 1.85;

Tibia = (0.285-0.045) * Height;
Femur = (0.530-0.285) * Height;
Spine= (0.87-0.53) * Height;
Foot = 0.15* Height;

p_Toes = [(1/2)*Foot,-0.085,0]; 
p_Heel = [-(1/2)*Foot,-0.085,0];


%Applied Load
Mass_Person = 90*9.8;
Load_Mag = 40*9.8;
F = [0,-Load_Mag,0];
F_COM=[0,-((Mass_Person*0.634)),0];



%Best Value  
n = 1;
m = 1;
%Array for values everytime restricted and unrestricted condition gets
%triggered
Restricted_T_Hip = [];
Restricted_T_Knee = [];
Restricted_T_Ankle = [];
Restricted_M_Hip = [];
Restricted_M_Knee = [];
Unrestricted_T_Hip = [];
Unrestricted_T_Knee = [];
Unrestricted_T_Ankle = [];
Unrestricted_M_Hip = [];
Unrestricted_M_Knee = [];
%Each angle are going from 55degrees to 89.5degrees. The resolution can be
%changed


for Ankle_A = 50:80 
   for Knee_A = 55:80
       for Hip_A = 50:80
        %Dependent Angles in Degrees
        Beta = abs(Knee_A - Ankle_A); %The angle of knee from the horizontal
        Alpha = abs(Hip_A - Beta); %The angle of hip from the horizontal
        
        %Vector Definitions
        r_Hip = [(Spine*cosd(Alpha)),(Spine*sind(Alpha)),0]; %r vector from the hip to the load force
        r_Knee = [(-1*Femur*cosd(Beta)),(Femur*sind(Beta)),0]+r_Hip; %r vector from the knee to the load force
        r_Ankle = [(Tibia*cosd(Ankle_A)),(Tibia*sind(Ankle_A)),0] + r_Knee;%r vector from the ankle to the load force
        
        p_Knee = r_Ankle-r_Knee;
        p_Hip = (r_Knee-r_Hip)+p_Knee;
        p_Load = r_Hip + p_Hip;
        


        
        %Finding centroid of each iteration 
        Centroid_P = Centroid(r_Hip, r_Knee, r_Ankle, Spine, Femur, Tibia);
        
        
        rC_Hip = p_Hip - Centroid_P;
        rC_Knee = p_Knee - Centroid_P; 
        rC_Ankle = [0,0,0] - Centroid_P;
        
                
        %Calculation of Moments
        M_Hip = CrossProduct(r_Hip,F) + CrossProduct(rC_Hip,F_COM);
        M_Knee = CrossProduct(r_Knee,F)+ CrossProduct(rC_Knee,F_COM);
        M_Ankle = CrossProduct(r_Ankle,F)+CrossProduct(rC_Ankle,F_COM);
        

        if p_Knee(1) < p_Toes(1)
            Angles = [Hip_A,Knee_A];
            R_Posture = [r_Hip;r_Knee;r_Ankle];
            Restricted_T_Hip(n) = Hip_A;
            Restricted_T_Knee(n) = Knee_A;
            Restricted_T_Ankle(n) = Ankle_A;
            Restricted_M_Hip(n) = M_Hip;
            Restricted_M_Knee(n) = M_Knee;
%             hold on 
%              DrawPosture(R_Posture);
%              drawnow
            n = n+1;
        end
                
        if p_Knee(1) > p_Toes(1)
            Hip_A
            Knee_A
            Angles2 = [Hip_A,Knee_A];
            U_Posture = [r_Hip;r_Knee;r_Ankle];
            Unrestricted_T_Hip(m) = Hip_A;
            Unrestricted_T_Knee(m) = Knee_A;
            Unrestricted_T_Ankle(m) = Ankle_A;
            Unrestricted_M_Hip(m) = M_Hip;
            Unrestricted_M_Knee(m) = M_Knee;
%              DrawPosture(U_Posture);
%              drawnow
            m = m+1;
        end

        %Curr_Moment = [M_Hip,M_Knee,M_Ankle];
       end
   end
end
n
m
% disp('Angle Restricted')
% mean(Restricted_T_Hip)
% std(Restricted_T_Hip)
% mean(Restricted_T_Knee)
% std(Restricted_T_Knee)
% mean(Restricted_T_Ankle)
% std(Restricted_T_Ankle)

disp('Moment Restricted')
mean(Restricted_M_Hip)
std(Restricted_M_Hip)
mean(Restricted_M_Knee)
std(Restricted_M_Knee)

% disp('Angle Unestricted')
% mean(Unrestricted_T_Hip)
% std(Unrestricted_T_Hip)
% mean(Unrestricted_T_Knee)
% std(Unrestricted_T_Knee)
% mean(Unrestricted_T_Ankle)
% std(Unrestricted_T_Ankle)

disp('Moment Unestricted')
mean(Unrestricted_M_Hip)
std(Unrestricted_M_Hip)
mean(Unrestricted_M_Knee)
std(Unrestricted_M_Knee)

% Restricted/n
% Unrestricted/m
