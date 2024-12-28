%{    
ENGR1250-005   Emanuel,Giles,Robert   4/2/19
Breakeven Analysis Project: Construction of New Zoo Enclosure
%}

clear
close all
clc

FC = {'Concrete', 14, 32, 93000, 900, 5, 4; 'Wood', 21, 55, 110000,...
    800, 13, 10; 'Adobe', 17, 45, 61000, 600, 5, 5};

concrete = FC{1}(1:8);
wood = FC{2}(1:4);
adobe = FC{3}(1:5);

Menu = menu('Construction material of enclosure:', concrete,wood,adobe);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%% ----------- FIXED COST ------------- %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%-Wall dimensions
thickness = [FC{1,2}, FC{2,2}, FC{3,2}]; % [in]
inches = 12;
foot = 1;
surfacearea_wall = 3000; %[ft^2] wall enclosure surface area
intoftconversion = thickness(Menu)*foot/inches; %[ft] unit conversion
walldimensions = intoftconversion*surfacearea_wall; %[ft^3] wall dimensions

%-Material cost
materials = [FC{1,3}, FC{2,3}, FC{3,3}]; %[$/ft^3]
materialcost = materials(Menu);
material = walldimensions*materialcost; %[$]

%-Miscellaneous construction materials
miscellaneous = [FC{1,4}, FC{2,4}, FC{3,4}]; %[$]
    misc_cost = miscellaneous(Menu);

%-Labor cost
labor = [FC{1,5}, FC{2,5}, FC{3,5}];%[$/ppl*week]
    labor_cost = labor(Menu);

%-Number of laborers
laborers = [FC{1,6}, FC{2,6}, FC{3,6}]; %[ppl]
    laborers_number = laborers(Menu);

%-Number of weeks of construction
weeks = [FC{1,7}, FC{2,7}, FC{3,7}];   %[week]
    weeks_construction = weeks(Menu);

%-Labor & time 
laborandtime = labor_cost*laborers_number*weeks_construction; 
% [$/ppl*week]*[ppl]*[week] = [$]

%-Fixed Cost (y-intercept)
fixed_cost = material + misc_cost + laborandtime; %[$]


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% ----------- VARIABLE COST ------------- %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

energy_cost = input('Energy cost  [$/week]: ');
oplabor_cost = input('Operational labor cost [$/week]: ');
maint_cost = input('Maintenance cost [$/week]: ');
landfill_cost = input('Landfill cost [$/week]: ');
opweek_peryear = input('Weeks per year zoo will operate: ');
analysis_inyears = input('Number of years of analysis: ');

%-Total variable cost
tot_varcost = energy_cost + oplabor_cost + maint_cost + landfill_cost; %[$/week]


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%% ----------- TOTAL COST ------------- %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%-Total cost
total_cost = tot_varcost*opweek_peryear; %[$/year]
t = 0:analysis_inyears; %[year]

tot_cost = total_cost*t + fixed_cost; 
%-total cost = variable cost*time + fixed cost-%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% ----------- REVENUE ------------- %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

admission_price = input('Admission price [$/person: ');
admission_perweek = input('Ticket admissions per week: ');
donations_perweek = input('Expected donations [$/week]: ');

%-Revenue
revenue = admission_price*admission_perweek; % [$/week]
revenue_perweek = revenue+donations_perweek; % [$/week]
total_revenue = revenue_perweek*opweek_peryear; % [$/year]

tot_revenue = total_revenue*t; 
%--revenue = selling price*time--%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% ----------- PROFIT ------------- %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

profit = total_revenue - total_cost; % [$/year] 
%--profit = revenue - total cost--%

total_profit = profit*t; % [$]

%-Breakeven coordinate points (x,y)
x = fixed_cost/(total_revenue-total_cost); % [year] both graphs
y = total_revenue*x; % [$] total cost & revenue graph
y2 = profit*x; % [$] profit graph
breakeven_month = x*12;
breakeven_6month = profit/2;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%% ------- SUMMARY OF RESULTS ---------- %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

material_select = FC{Menu};
fprintf ('Material: %s \n', material_select)
fprintf ('\tOperating %0.f weeks per year will generate per year: \n'...
    ,opweek_peryear)
fprintf ('\t\tRevenue: $%0.0f \n',total_revenue)
fprintf ('\t\tCost:    $%0.0f \n',total_cost)
fprintf ('\tThe breakeven time is %0.2f months \n',breakeven_month)
fprintf ('\tThe total profit after %0.0f years is $%0.3E. \n',...
    analysis_inyears,total_profit(1,1+analysis_inyears))
fprintf ('It will take a one-time donaton of $%0.2f',breakeven_6month)
fprintf (' to breakeven in six months.\n')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% ------------- GRAPHS ------------- %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%-Total cost & revenue graph
figure('color','w');
hold on
plot(t,tot_cost,'-r','LineWidth',1);
plot(t,tot_revenue,'--b','LineWidth',1);
plot(x,y,'ob','MarkerSize',5,'MarkerFaceColor','b');
grid on
xlabel('Time  (t) [y]','FontSize',12);
ylabel('Total Cost (TC) [$] or Revenue (R) [$]','FontSize',12);
title('Zoo Enclosure Breakeven Analyis', 'FontSize', 14)
legend(' total cost',' revenue','breakeven','location','Northwest')


%-Profit graph
figure('color','w');
hold on
plot(t,total_profit,'-g','LineWidth',1);
plot(x,y2,'ob','MarkerSize',5,'MarkerFaceColor','b');
grid on
xlabel('Time  (t) [y]','FontSize',12);
ylabel('Profit  (p)[$]','FontSize',12);
title('Zoo Enclosure Profit Analysis', 'FontSize', 14)
legend(' profit','breakeven','location','Southeast')

