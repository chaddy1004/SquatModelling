close all 
clear 
clc


%Height of Person in meters
Height = 1.85;

%Length of bones in Meters
Spine = 0.56843; %The length from hip to where the load is applied
Femur = 0.34299; %Thigh
Tibia = 0.49733; %Shin

%Position of Toe and Heel (Constant)
p_Toes = [0.19,-0.085,0]; 
p_Heel = [-0.085,-0.085,0];

%Applied Load
Mass_Person = 90;
Load_Mag = 80;
F = [0,-Load_Mag,0];

%Best Value 
Best_Moment = [9999999,9,99]; %Just Initializing to a very high value
Norm_BestMoment = 1000000000000000; %Just initializing to a very high value

Iterations = 0;
Iter2 = 0;
TotalI = 0;
for Ankle_A = 55:89.5
    for Knee_A = 55:89.5
        for Hip_A = 55:89.5
        %Dependent Angles in Degrees
        Beta = Knee_A - Ankle_A;
        Alpha = Hip_A - Beta;
        %Vector Definitions
        r_Hip = [(Spine*cosd(Alpha)),(Spine*sind(Alpha)),0];
        r_Knee = [(-1*Femur*cosd(Beta)),(Femur*sind(Beta)),0]+r_Hip;
        r_Ankle = [(Tibia*cosd(Ankle_A)),(Tibia*sind(Ankle_A)),0] + r_Knee;
        p_Knee = r_Ankle-r_Knee;
        p_Hip = (r_Knee-r_Hip)+p_Knee;
        p_Load = r_Hip + p_Hip;
        Centroid_P = Centroid(r_Hip, r_Knee, r_Ankle, Spine, Femur, Tibia);
        
        %Calculation Moments
        M_Hip = CrossProduct(r_Hip,F);
        M_Knee = CrossProduct(r_Knee,F);
        M_Ankle = CrossProduct(r_Ankle,F);

        F_Reaction=[0,(Load_Mag+Mass_Person),0];
        rC_Load = p_Load - Centroid_P;
        rC_Toes = p_Toes - Centroid_P;
        rC_Heel = p_Heel - Centroid_P;
        
        M_Load = abs(CrossProduct(rC_Load,F))
        M_Reaction_Toe = abs(CrossProduct(rC_Toes, F_Reaction))
        M_Reaction_Heel = abs(CrossProduct(rC_Heel, F_Reaction))
        
        if(M_Load-M_Reaction_Toe > 0 || M_Load-M_Reaction_Heel >0)
            Iter2 = Iter2+1;
%             plot(Centroid_P(1),Centroid_P(2),'*')
%             hold on
%             DrawPosture([r_Hip;r_Knee;r_Ankle])
%             drawnow
            continue  
        end
        
        Curr_Moment = [M_Hip,M_Knee,M_Ankle];
        Norm_Curr = sqrt((M_Hip^2)+(M_Knee^2)+(M_Ankle^2));
        if  Norm_BestMoment > Norm_Curr
            Best_Centroid = Centroid_P;
            Norm_BestMoment = Norm_Curr;
            Best_Moment = Curr_Moment;
            Best_Angle = [Hip_A,Knee_A,Ankle_A];
            Best_Posture = [r_Hip;r_Knee;r_Ankle];
            BP_Points = [p_Load;p_Hip;p_Knee];
            plot(Best_Centroid(1),Best_Centroid(2),'*')
            hold on 
            DrawPosture([r_Hip;r_Knee;r_Ankle]);
            drawnow
            Iterations = Iterations + 1;
        end
        TotalI = TotalI+1;
        end
    end
end
figure
plot(Best_Centroid(1),Best_Centroid(2),'*')
hold on
DrawPosture(Best_Posture);
Best_Posture
Best_Moment
Best_Angle
BP_Points;



%%%%%%%%%%%%%%%%%%%%%%%%%DynamicAnalysis Starts Here
%Angles when Standing Up
%Angle Inputs in Degrees
Ankle_Ai = 90;
Knee_Ai = 180;
Hip_Ai = 180;

%Dependent Angles in Degrees
Beta_i = Knee_Ai - Ankle_Ai;
Alpha_i = Hip_Ai - Beta_i;


%Angles when Squatting 
%Anghle Inputs in Degrees
Ankle_As = Best_Angle(3);
Knee_As = Best_Angle(2);
Hip_As = Best_Angle(1);

%Dependent Angles in Degrees
Beta_s = Knee_As - Ankle_As;
Alpha_s = Hip_As - Beta_s;

%Vector Definitions
ri_Hip = [(Spine*cosd(Alpha_i)),(Spine*sind(Alpha_i)),0]
ri_Knee = [(-1*Femur*cosd(Beta_i)),(Femur*sind(Beta_i)),0]+ri_Hip
ri_Ankle = [(Tibia*cosd(Ankle_Ai)),(Tibia*sind(Ankle_Ai)),0] + ri_Knee
F = [0,-Load_Mag,0];

%Angular Accelerations
a_Torso = 0;
a_Femur = 0;
a_Tibia = 0;

%MainLoop
for a_Torso =  deg2rad(20):0.001:deg2rad(80) %0.0001 for best resolution
    for a_Femur = deg2rad(20):0.001:deg2rad(80) %This one has to be negative direction
        for a_Tibia = deg2rad(20):0.001:deg2rad(80)
            while()
                
        end
    end
end












