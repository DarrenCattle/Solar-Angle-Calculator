%% Solar Angle Calculator
% Darren Cattle 11/24/2014
% This will calculate solar azimuth and zenith over a day.
% Output will go into a table format.
% Only required definitions are day of year and latitude.

%%
% clear your workspace
clc
clear
%% Definitions
day = 180; % 180 = June 29th
latitude = 30; % 30.25 = Austin, TX
%% Direction of Beam Radiation
answer = zeros(24*60,5);
% Hour Loop
for i = 0:12
% Minute Loop
    for j = 1:60
        hour = i;
        min = j;
        B = (day-1)*360/365.242;
        E = 229.18*(0.000075+0.001868*cosd(B)...
            -0.032077*sind(B)-0.014615*cosd(2*B)-0.040849*sind(2*B));
        decl = 23.45*sind(360*(284+day)/365.242);
        hourangle = 15*(hour*60+min-720)/60;
        czenith = cosd(latitude)*cosd(decl)*cosd(hourangle)+sind(latitude)*sind(decl);
            zenith = acosd(czenith);
        cazimuth = -(sind(latitude)*czenith-sind(decl))/(cosd(latitude)*sind(zenith));
            azimuth = 180-acosd(cazimuth);
        wew = acosd(tand(decl)/tand(latitude));
        C1 = -1;
        C2 = -1;
        C3 = -1;
        if(abs(hourangle)<= wew)
            C1=1;
        else
            C1=-1;
        end
        if(latitude-decl>=0)
            C2=1;
        else
            C2=-1;
        end 
        if(hourangle>=0)
            C3=1;
        else
            C3=-1;
        end
        prime = asind(sind(hourangle)*cosd(decl)/sind(zenith));
        ys=C1*C2*prime+C3*(1-C1*C2)*90;
        A = ys+180; % Final Azimuth from North Clockwise
        Z = 90-zenith; % Final Angle from Horizontal Ground
        answer(i*60+j,1) = day;
        answer(i*60+j,2) = hour;
        answer(i*60+j,3) = min;
        answer(i*60+j,4) = Z;
        answer(i*60+j,5) = A;
    end
end
% Display Answer
answer
% Display Plots
plot(answer(1:1440,5));