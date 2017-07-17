close all 
clear 
clc

%PreProcessing 
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
F_Reaction=[0,(Load_Mag+Mass_Person),0];

%Best Value  
Best_Moment = [9999999,9,99]; %Just Initializing to a very high value
Norm_BestMoment = 1000000000000000; %Just initializing to a very high value

%Each angle are going from 55degrees to 89.5degrees. The resolution can be
%changed
for Ankle_A = 55:89.5 
    for Knee_A = 55:89.5
        for Hip_A = 55:89.5
        %Dependent Angles in Degrees
        Beta = Knee_A - Ankle_A; %The angle of knee from the horizontal
        Alpha = Hip_A - Beta; %The angle of hip from the horizontal
        
        %Vector Definitions
        r_Hip = [(Spine*cosd(Alpha)),(Spine*sind(Alpha)),0]; %r vector from the hip to the load force
        r_Knee = [(-1*Femur*cosd(Beta)),(Femur*sind(Beta)),0]+r_Hip; %r vector from the knee to the load force
        r_Ankle = [(Tibia*cosd(Ankle_A)),(Tibia*sind(Ankle_A)),0] + r_Knee;%r vector from the ankle to the load force
        
        p_Knee = r_Ankle-r_Knee;
        p_Hip = (r_Knee-r_Hip)+p_Knee;
        p_Load = r_Hip + p_Hip;
        
        %Finding centroid of each iteration 
        Centroid_P = Centroid(r_Hip, r_Knee, r_Ankle, Spine, Femur, Tibia);
        
        %Calculation of Moments
        M_Hip = CrossProduct(r_Hip,F);
        M_Knee = CrossProduct(r_Knee,F);
        M_Ankle = CrossProduct(r_Ankle,F);

        %r vector calculation for the reaction forces
        rC_Load = p_Load - Centroid_P;
        rC_Toes = p_Toes - Centroid_P;
        rC_Heel = p_Heel - Centroid_P;
        
        %Moment calculation for the reaction forces
        M_Load = abs(CrossProduct(rC_Load,F));
        M_Reaction_Toe = abs(CrossProduct(rC_Toes, F_Reaction));
        M_Reaction_Heel = abs(CrossProduct(rC_Heel, F_Reaction));
        
        %One of the constraints. If the reaction force cannot produce
        %moment greater than the moment applied about the centroid, the
        %person will fall over.
        if(M_Load-M_Reaction_Toe > 0 || M_Load-M_Reaction_Heel >0)
              %uncomment the following lines if you want to graph the
              %positions that  will tip over the person
            plot(Centroid_P(1),Centroid_P(2),'*')
            hold on
            DrawPosture([r_Hip;r_Knee;r_Ankle])
            drawnow
            continue  
        end
        
        Curr_Moment = [M_Hip,M_Knee,M_Ankle];
        %Calculating the norm of the moments
        Norm_Curr = sqrt((M_Hip^2)+(M_Knee^2)+(M_Ankle^2));
        
        %Update the BestMoment if the norm is lower
        if  Norm_BestMoment > Norm_Curr
            Best_Centroid = Centroid_P;
            Norm_BestMoment = Norm_Curr;
            Best_Moment = Curr_Moment;
            Best_Posture = [r_Hip;r_Knee;r_Ankle];
            BP_Points = [p_Load;p_Hip;p_Knee];
%             plot(Best_Centroid(1),Best_Centroid(2),'*')
%             hold on 
%             DrawPosture([r_Hip;r_Knee;r_Ankle]);
%             drawnow
        end
        end
    end
end
%PostProcessing for information
figure
plot(Best_Centroid(1),Best_Centroid(2),'*')
hold on
DrawPosture(Best_Posture);
Best_Posture
Best_Moment
BP_Points;
