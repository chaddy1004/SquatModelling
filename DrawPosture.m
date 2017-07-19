function DrawPosture( r_Collection )
%vectarrow is a function obtained from Rentian Xiong from Matlab
%FileExchange platform. 
%https://www.mathworks.com/matlabcentral/fileexchange/7470-plot-2d-3d-vector-with-arrow
%All Credits to him for the function

%Unravel the input set of vectors 
r_Hip = r_Collection(1,:);
r_Knee = r_Collection(2,:);
r_Ankle = r_Collection(3,:);

%Defining the Cartesian coordinates of each joints
p_Ankle = [0,0,0];
p_Knee = r_Ankle-r_Knee;
p_Hip = (r_Knee-r_Hip)+p_Knee;
p_Load = r_Hip + p_Hip;
p_Toes = [0.17,-0.085,0]; %Measured value
p_Heel = [-0.085,-0.085,0]; %Measured value

vectarrow(p_Ankle,p_Knee);
hold on
vectarrow(p_Knee, p_Hip);
hold on 
vectarrow(p_Hip,p_Load);
hold on
vectarrow(p_Ankle,p_Toes);
hold on 
vectarrow(p_Ankle,p_Heel);
title('Optimum Posture to Reduce Joint Torque')
xlabel('x Position')
ylabel('y Position')
hold on %Uncomment to view every iteration graphed on same plot
view(0,90)%To project the the vector onto xy plane
end

