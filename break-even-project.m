%{
ENGR1250-00     
Emanuel,Giles,Robert
Breakeven Analysis Project
4/2/19
%}

clear
close all
clc

FC = {'Concrete', 14, 32, 93000, 900, 5, 4; 'Wood', 21, 55, 110000, 800, ... 
13, 10; 'Adobe', 17, 45, 61000, 600, 5, 5};

concrete = FC{1}(1:8);
wood = FC{2}(1:4);
adobe = FC{3}(1:5);

Menu = menu('Construction material of enclosure:', concrete, ...
wood, adobe);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% ----------- FIXED COST ------------- %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Wall dimensions
thickness = [FC{1,2}, FC{2,2}, FC{3,2}]; % [in]
inches = 12;
foot = 1;
surfacearea_wall = 3000; %surface area for 1 wall [ft^2]
intoftconversion = thickness(Menu)*foot/inches; %[in]*[ft/in] = [ft]
walldimensions = intoftconversion*surfacearea_wall; %[ft]*[ft^2] = [ft^3]

% Material cost for 1 wall (y-intercept)
materials = [FC{1,3}, FC{2,3}, FC{3,3}]; %[$/ft^3]
materialcost = materials(Menu);
material = walldimensions*materialcost; %[ft^3]*[$/ft^3] = [$]

% Miscellaneous construction materials
miscellaneous = [FC{1,4}, FC{2,4}, FC{3,4}]; %[$]
    misc_cost = miscellaneous(Menu);

% Labor cost
labor = [FC{1,5}, FC{2,5}, FC{3,5}];%[$/ppl*week]
    labor_cost = labor(Menu);

% Number of laborers
laborers = [FC{1,6}, FC{2,6}, FC{3,6}]; %[ppl]
    laborers_number = laborers(Menu);

% Number of weeks of construction
weeks = [FC{1,7}, FC{2,7}, FC{3,7}];   %[week]
    weeks_construction = weeks(Menu);

% Labor & time 
laborandtime = labor_cost*laborers_number*weeks_construction; 
% [$/ppl*week]*[ppl]*[week] = [$]

% Fixed Cost
fixed_cost = material + misc_cost + laborandtime; %[$]



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% ----------- VARIABLE COST ------------- %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

VCInstr = {'Energy cost  [$/week]','Operational labor cost  [$/week]',...
    'Maintenance cost  [$/week]', 'Landfill cost  [$/week]',...
    'Weeks per year zoo will operate', 'Number of years of analysis'};
VCResp = inputdlg(VCInstr,'Variable costs and revenue projections for enclosure');
VC = [str2double(VCResp{1,1}),str2double(VCResp{2,1}), str2double(VCResp{3,1}), ...
    str2double(VCResp{4,1}), str2double(VCResp{5,1}), str2double(VCResp{6,1})];

energy_cost = VC(1,1); % [$/week]
oplabor_cost = VC(1,2); % [$/week]
maint_cost = VC(1,3); % [$/week]
landfill_cost = VC(1,4); % [$/week]
opweek_peryear = VC(1,5); % [week/year]
analysis_inyears = VC(1,6); % [year]

% Total variable cost
tot_varcost = energy_cost + oplabor_cost + maint_cost + landfill_cost; %[$/week]


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% ----------- TOTAL COST ------------- %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Total cost
total_cost = tot_varcost*opweek_peryear; %[$/year]
t = 0:analysis_inyears;

tot_cost = total_cost*t + fixed_cost;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% ----------- REVENUE ------------- %%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

RInstr = {'Admission price [$/person]', 'Ticket admissions per week', ...
    'Expected donations [$/week]'};
RResp = inputdlg(RInstr,'Enter anticipated zoo public interest and donations');

R = [str2double(RResp{1,1}),str2double(RResp{2,1}), str2double(RResp{3,1})];

admission_price = R(1,1); % [$/ppl]
admission_perweek = R(1,2); % [ppl/week]
donations_perweek = R(1,3); % [$/week]

% Total revenue
revenue = admission_price*admission_perweek; % [$/week]
revenue_perweek = revenue+donations_perweek; % [$/week]
total_revenue = revenue_perweek*opweek_peryear; % [$/year]

tot_revenue = total_revenue*t;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% ----------- PROFIT ------------- %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

profit = total_revenue - total_cost; % [$/year]

total_profit = profit*t; % [$/year]

% breakeven (x,y) coordinates
x = fixed_cost/(total_revenue-total_cost); % x-coordinate [year]
y = total_revenue*x; % y-coordinate [$]
breakeven_month = x*12;
y2 = profit*x; % y-coordinate for profit graph

% total_revenue*t = total_cost*t + fixed_cost



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% ------- SUMMARY OF RESULTS ---------- %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

material_select = FC{Menu};

fprintf ('Material: %s \n', material_select)
fprintf ('\tOperating %0.f weeks per year will generate per year: \n'...
    ,opweek_peryear)
fprintf ('\t\tRevenue: $%0.0f \n',total_revenue)
fprintf ('\t\tCost:    $%0.0f \n',total_cost)
fprintf ('\tThe breakeven time is %0.2f months \n',breakeven_month)
fprintf ('\tThe total profit after %0.0f years is $%0.3E. \n',analysis_inyears ...
    ,total_profit(1,6))
fprintf ('It will take a one-time donaton of $%0.2f to breakeven in six months.\n',...
    profit)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% ---------- GRAPHS ------------ %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure('color','w');
hold on
plot(t,tot_cost,'-r','LineWidth',2);
plot(t,tot_revenue,'--b','LineWidth',2);
plot(x,y,'og','MarkerSize',6,'MarkerFaceColor','g');
grid on
xlabel('Time  (t) [y]','FontSize',12);
ylabel('Total Cost (TC) [$] or Revenue (R) [$]','FontSize',12);
title('Zoo Enclosure Profitability', 'FontSize', 15)
legend(' total cost',' revenue','breakeven','location','Northwest')


figure('color','w');
hold on
plot(t,total_profit,'-g','LineWidth',2);
plot(x,y2,'ob','MarkerSize',6,'MarkerFaceColor','b');
grid on
xlabel('Time  (t) [y]','FontSize',12);
ylabel('Profit  (p)[$]','FontSize',12);
title('Zoo Enclosure Profit Analysis', 'FontSize', 15)
legend(' profit','breakeven','location','Northwest')









