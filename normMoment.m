
%Written by Sally Hui, our group member
function [ Norm_Curr ] = normMoment( x0 )

    Ankle_A = x0(1);
    Knee_A = x0(2);
    Hip_A = x0(3);

    if (Ankle_A < 55 || Ankle_A > 90 || Knee_A < 55 || Knee_A > 90 || Hip_A < 55 || Hip_A > 90)
        Norm_Curr = 9000000000000000;
    else
        %Length of bones in Meters
        Spine = 0.56843; %The length from hip to where the load is applied
        Femur = 0.34299; %Thigh
        Tibia = 0.49733; %Shin

        %Position of Toe and Heel (Constant)
        p_Toes = [0.19,-0.085,0]; 
        p_Heel = [-0.085,-0.085,0];

        %Applied Load
        Mass_Person = 80;
        Load_Mag = 25;

        %Angle Inputs in Degrees
        Ankle_Ai = 123;
        Knee_Ai = 42;
        Hip_Ai = 32;

        %Dependent Angles in Degrees
        Beta = Knee_Ai - Ankle_Ai;
        Alpha = Hip_Ai - Beta;

        %Vector Definitions
        ri_Hip = [(Spine*cosd(Alpha)),(Spine*sind(Alpha)),0]
        ri_Knee = [(-1*Femur*cosd(Beta)),(Femur*sind(Beta)),0]+ri_Hip
        ri_Ankle = [(Tibia*cosd(Ankle_Ai)),(Tibia*sind(Ankle_Ai)),0] + ri_Knee
        F = [0,-Load_Mag,0];

        Initial_Posture = [ri_Hip;ri_Knee;ri_Ankle];

        %Best Value 
        Best_Moment = [9999999,9,99]; %Just Initializing to a very high value
        Norm_BestMoment = 1000000000000000; %Just initializing to a very high value
        Best_Posture = [ri_Hip;ri_Knee;ri_Ankle];
        Iterations = 0;
        Iter2 = 0;
        TotalI = 0;

        %Dependent Angles in Degrees
        Beta = Knee_A - Ankle_A;
        Alpha = Hip_A - Beta;

    %     Vector Definitions
        r_Hip = [(Spine*cosd(Alpha)),(Spine*sind(Alpha)),0];
        r_Knee = [(-1*Femur*cosd(Beta)),(Femur*sind(Beta)),0]+r_Hip;
        r_Ankle = [(Tibia*cosd(Ankle_A)),(Tibia*sind(Ankle_A)),0] + r_Knee;
        p_Knee = r_Ankle-r_Knee;
        p_Hip = (r_Knee-r_Hip)+p_Knee;
        p_Load = r_Hip + p_Hip;
        Centroid_P = Centroid(r_Hip, r_Knee, r_Ankle, Spine, Femur, Tibia);

    %     Calculation Moments
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
            plot(Centroid_P(1),Centroid_P(2),'*')
            hold on
            DrawPosture([r_Hip;r_Knee;r_Ankle])
            drawnow
        end

        Curr_Moment = [M_Hip,M_Knee,M_Ankle];

        Norm_Curr = sqrt((M_Hip^2)+(M_Knee^2)+(M_Ankle^2));
    end
end

