 %Input variables
%Vehicle_1
%Kerb_weight(lb)%Payload(lb)=4750;%(lb)****
%total_weight=Kerb_Weight+Payload;
%total_weight_lb=4750;
total_weight_lb_to_kg=4750*0.4536;
total_weight=2154.6;%mass in kg
Gravitational_force= 9.81;%(m/s^2)
Air_density=1.225;%(kg/m3)
Width=1.8;%(m)
Height=1;%(m)
Frontal_Area=1.8;%(m^2)
Drag_coefficient=0.2;
grade_angle=15;%(deg)
velocity=20;%(m/s)
Coefficient_of_rolling_resistance=0.012;
Gear_Ratio_g = 7;
wheel_radius_cal=0.217;%m
moment_of_inertia=2;%kg/m^3
efficiency=0.90;
%IMPORTING_THE_DRIVE_CYCLE_DATA_EUDC
%Drive cycle plot- Time(S) vs Velocity (M-S)
EUDC_DATA=readtable('EUDC.xlsx');
EUDC_time_C=EUDC_DATA{:,1};%sec
EUDC_velocity_C=EUDC_DATA{:,3};%m/sec,velocity column data
figure(3)
plot(EUDC_time_C,EUDC_velocity_C,'b-')
xlabel('EUDC time(sec)');
ylabel('EUDC Velocity(m/s)');
legend('Time(sec)vsVelocity(m/s)')
title('EUDC Drive cycle plot')
grid on
%*********************************************%
%Highway Fuel Economy Driving Schedule
figure(4)
HEFET_DATA=readtable('HEFET_DATA.xlsx');
HEFET_time=HEFET_DATA{:,1};%sec
HEFET_velocity=HEFET_DATA{:,2};%mph
plot(HEFET_time,HEFET_velocity)
xlabel('time(sec)');
legend('Time(S)vsVelocity(mph)')
title('HWY Drive cycle plot')
grid on
%SC03 is the Air Conditioning "Supplemental FTP" driving schedule.
figure(5)
SCO3_DATA=readtable('sco3.xlsx');
SCO3_time=SCO3_DATA{:,1};
SCO3_velocity=SCO3_DATA{:,2};%mph
plot(SCO3_time,SCO3_velocity)
xlabel('time(sec)');
ylabel('velocity(mph)');
legend('Time(S)vsVelocity(mph)')
title('SC03 Drive cycle plot')
grid on
%*******US06 driving schedule
figure(6)
US06_DATA=readtable('US06.xlsx');
US06_time=US06_DATA{:,1};
US06_velocity=US06_DATA{:,2};%mph
plot(US06_time,US06_velocity)
xlabel('time(sec)');
ylabel('velocity(mph)');
legend('Time(S)vsVelocity(mph)')
title('US06 Drive cycle plot')
grid on
%****************************************%
%Theoretically
%**********************************************%
%Question:Generate below plot
%Total resistance(N) vs Velocity(M-S)-Plot
grade_angle_rad=(grade_angle*pi/180);%rad
EUDC_velocity=EUDC_velocity_C.';%covert velocity to row 
EUDC_time=EUDC_time_C.';%covert time to row data
acceleration=[diff(EUDC_velocity)./diff(EUDC_time) 0];%m/s^2
linear_acceleration_force=total_weight*acceleration;%N
angular_acceleration_force=((moment_of_inertia)*(Gear_Ratio_g^2)*(acceleration))/((wheel_radius_cal^2)*(efficiency));%N
Aerodynamic_resistance_force=0.5*Air_density*Drag_coefficient*Frontal_Area.*EUDC_velocity.*EUDC_velocity;%N
Rolling_resistance_force=Coefficient_of_rolling_resistance*total_weight*9.81*cos(grade_angle_rad)*ones(size(EUDC_velocity));%N
Grade_Resistace_force=total_weight*9.81*sin(grade_angle_rad)*ones(size(EUDC_velocity));%N
Total_resitance_force=Rolling_resistance_force+Grade_Resistace_force+Aerodynamic_resistance_force+linear_acceleration_force+angular_acceleration_force;%N
Total_power=Total_resitance_force.*EUDC_velocity;%watt
Total_power_COL=reshape(Total_power,1370,1);%converted to cloumn vector
power_in=[EUDC_time_C,Total_power_COL];
out=sim('Energy_sim');
Energy=out.energynew;
time=out.time;
EUDC_velocity_size=[0;EUDC_velocity_C];%m/s,%converted to column
figure(1)
subplot(3,3,1)
plot(time,Energy,'r-');
xlabel('velocity(sec)')
ylabel('Total Energy (J)')
legend('Energy consumed(J) vs time (sec)')
subplot(3,3,2)
plot(EUDC_velocity_size,Energy,'k-');
xlabel('velocity(m/s)')
ylabel('Total Energy (J)')
legend('Energy consumed(J) vs Velocity (m/s)')
grid on
subplot(3,3,3)
plot(EUDC_velocity,Total_resitance_force,'m-');
xlabel('velocity(m/s)');
ylabel('Total resitance force(N)');
legend('Total resitance force VS velocity');
title('Total Tractive force VS velocity')
grid on
subplot(3,3,4)
plot(EUDC_velocity,Total_power,'g-');
xlabel('velocity(m/s)')
ylabel('Total Power (W)')
legend('TotalPower(W) vs Velocity (m/s)')
grid on
subplot(3,3,5)
plot(EUDC_velocity,Aerodynamic_resistance_force);
xlabel('velocity(m/s)')
ylabel('Aerodynamic resistance force')
title('Aerodynamic resistance force(N) vs Velocity (m/s)')
grid on
subplot(3,3,6)
plot(EUDC_velocity,Rolling_resistance_force);
xlabel('velocity(m/s)')
ylabel('Rolling resistance force(N)')
title('Rolling resistance force(N) vs Velocity (m/s)')
grid on
subplot(3,3,7)
plot(EUDC_velocity,Grade_Resistace_force);
xlabel('velocity(m/s)')
ylabel('Gradient resistance force(N)')
title('Gradient resistance force(N) vs Velocity (m/s)')
grid on
subplot(3,3,8)
plot(EUDC_time,acceleration);
xlabel('velocity(m/s)')
ylabel('accelaration')
title('acceleration(m/s^2) vs Velocity (m/s)')
grid on
Distance=EUDC_velocity.*EUDC_time;
subplot(3,3,9)
plot(EUDC_time,Distance,'c')
xlabel('Time(sec))')
ylabel('Distance(m)')
title('Distance(m) vs Time(sec)')
grid on
figure(2)
subplot(2,2,1)
plot(sort(EUDC_velocity),sort(Total_resitance_force),'m-');
xlabel('velocity(m/s)');
ylabel('Total resitance force(N)');
legend('Total resitance force VS velocity');
title('sorted:Total Tractive force VS velocity')
grid on
subplot(2,2,2)
plot(sort(EUDC_velocity),sort(Total_power),'g-');
xlabel('velocity(m/s)')
ylabel('Total Power (W)')
legend('sorted:TotalPower(W) vs Velocity (m/s)')
grid on
subplot(2,2,3)
plot(EUDC_time,EUDC_velocity,'c')
xlabel('Time(sec))')
ylabel('velocity(m/s)')
title(' EUDC:velocity(m/s)vs Time(sec)')
grid on
subplot(2,2,4)
plot(sort(EUDC_velocity_size),sort(Energy),'m-');
xlabel('velocity(m/s)')
ylabel('Total Energy (J)')
legend('sort:Energy consumed(J) vs Velocity (m/s)')
grid on

% %**************************************************************%
% % % RPM of the motor to maintain to maintain vehicle speed of 20m/s
% % %Tire_Size  90/100_R10_53J;
width_of_tire_mm=90;%mm,
width_of_tire=0.090;%m*****%width_of_tire=90*10^-3 m
Height_of_tire=0.090;%m
aspect_ratio=Height_of_tire/width_of_tire;%percentage***%aspect_ratio=100
rim_diameter_inch=10;%inch
rim_diameter=0.254;%m**********%rim_diameter=0.0254*10
rim_rad=rim_diameter/2;%m
wheel_radius=rim_rad+Height_of_tire;%m
circumfrance_of_wheel=2*pi*wheel_radius;%m
velocity_kmh=velocity*(18/5);%km/h
RPM_of_wheel=(velocity_kmh*1000)/(60*circumfrance_of_wheel);%rpm
RPM_of_motor=RPM_of_wheel*Gear_Ratio_g;%rpm
disp('Question:RPM of the motor to maintain  vehicle speed of 20m/s')
fprintf('RPM of motor=%f rpm\n',RPM_of_motor)
%Question:Find Air resistance Total resistance, Total Power,Energy Consumed  @ 20m/s 
Rolling_resistance_force_20=Coefficient_of_rolling_resistance*total_weight*9.81*cos(grade_angle_rad);%N
Grade_Resistace_force_20=total_weight*9.81*sin(grade_angle_rad);%Newton
Aerodynamic_resistance_force_20=0.5*Air_density*Drag_coefficient*Frontal_Area*velocity*velocity;
Total_resitance_force_20=Rolling_resistance_force_20+Grade_Resistace_force_20+Aerodynamic_resistance_force_20;%N
Power_required_at_the_wheel_20=Total_resitance_force_20*velocity;%watt
time_20=50;%sec*******assumed
Energy_consumed_20=Power_required_at_the_wheel_20*time_20;%joule
fprintf('Rolling resistance force at 20m/s=%f N\n',Rolling_resistance_force_20);%n
fprintf('Grade resistance force at 20m/s=%f N\n',Grade_Resistace_force_20);%N
fprintf('Aerodynamic resistance force at 20m/s=%f N\n',Aerodynamic_resistance_force_20);%N
fprintf('Total resistance force at 20m/s=%f N\n',Total_resitance_force_20);%N
fprintf('Total power 20m/s=%f N\n',Power_required_at_the_wheel_20);%W
fprintf('Total Energy 20m/s=%f N\n',Energy_consumed_20);%J
%Question:Calculate the Motor speed (rpm) for the vehicle to run 90 km/hr.
velocity_kmph_90=90;%km/h
RPM_of_wheel_90=(velocity_kmph_90*1000)/(60*circumfrance_of_wheel);%rpm
RPM_of_motor_90=RPM_of_wheel_90*Gear_Ratio_g;%rpm
disp('Question:Calculate the Motor speed (rpm) for the vehicle to run 90 km/hr');
fprintf('RPM of motor at 90km/h=%f rpm\n',RPM_of_motor_90);
% % %Question:Calculate the Motor power(W) for the vehicle to run 90 km/hr
velocity_mpers=velocity_kmph_90*(5/18);
Rolling_resistance_force_20=Coefficient_of_rolling_resistance*total_weight*9.81*cos(grade_angle_rad);%N
Grade_Resistace_force_20=total_weight*9.81*sin(grade_angle_rad);%N
Aerodynamic_resistance_force_90=0.5*Air_density*Drag_coefficient*Frontal_Area*velocity_mpers*velocity_mpers;%N
Total_resitance_force_90=Rolling_resistance_force_20+Grade_Resistace_force_20+Aerodynamic_resistance_force_90;%N
Power_required_at_the_wheel=Total_resitance_force_90*velocity_mpers;%watt
%assume efficiency as 90%
efficiency=90;%percentage
motor_power=Power_required_at_the_wheel/(efficiency/100);
disp('Question:Calculate the Motor power(W) for the vehicle to run 90 km/hr')
fprintf('Total resistive force at 90km/h=%f N\n',Total_resitance_force_90)
fprintf('Motor power(W) for the vehicle to run 90 km/hr=%f W\n',motor_power)





