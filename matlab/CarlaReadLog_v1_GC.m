% close all
clear all; close all; clc



%% Set the folder
% cd '/home/is18902/git/Robopilot_Carla/PythonAPI/examples/ExperimentResutls'

%% or add results directory to path
% addpath('~/git/Robopilot_Carla/PythonAPI/examples/ExperimentResutls')

% set graph display as option
display_graphs = 0;
display_graphs_2 = 0;
plot_velocity_graph = 0;

%% setup for multiple reads
nFilep1='Experiment-'; nFilep2='.csv';
nVelocities = 1;
fileNumberOffset = 0; %for file ...-5001.csv use = 4, 6001 = 5
PCC=false; CC=false;


% file = "AssertionCheckingCaseStudyLogs_Crash.txt";
% file = "AssertionCheckingCaseStudyLogs_NearMiss.txt";
file = "AssertionCheckingCaseStudyLogs_Safe.txt";



data = importfile_data(file);

%% Find the number of exclusive agents & tests
agentIDs = unique(data.agentID,'stable');
% agentIDs = table2array(agentIDs);
Agents = unique(data.agentNo,'stable');
nAgents = length(Agents);
nRepeats = max(data.repeatNo);
maxTime = max(data.time);
timeStep = 0.1;

%% Store raw, non-interpolated data (T,X,Y) and variance
rawData = zeros(nRepeats,nAgents,3,round(maxTime/timeStep));
variance = zeros(nRepeats,nAgents,2);
avgVar = zeros(nRepeats,1);


%% For each agent get (T,X,Y) and interpolate, then variance
data2D=[];
for i=1:nRepeats+1
    for j=1:nAgents
        A = data2D;
        sel1 = data.repeatNo==i; %select data for each repeat
        sel2 = data.agentNo==j; %select data for each agent
%         sel = sel1 & sel2;
        sel = sel2;
        
        tempData = data(sel,:);
        tempT = tempData.time;
            
        if i == 1
            shortest_tempT = length(tempT) - 1; 
        end

        
        if length(tempT) < shortest_tempT
            shortest_tempT = length(tempT);
        end
         
        
        tempData = data(sel,:);
        tempT = tempData.time;
        tempT = tempT(1:shortest_tempT);
        tempX = tempData.x;
        tempX = tempX(1:shortest_tempT);
        tempY = tempData.y;
        tempY = tempY(1:shortest_tempT);
        
        rawData = rawData(:,:,:,1:shortest_tempT); % chopping data to the shortest
        rawData(i,j,:,:) = [tempT, tempX, tempY]';
        actor = j.* ones(length(squeeze(tempY)),1);
        temp2D = [squeeze(tempX), squeeze(tempY), actor];
        data2D = vertcat(A,temp2D);
%         a=0
    end
end

%% Interpolate data if you need to?
% % interpolate data
% regT = min(tempT):0.1:max(tempT); %too dense to plot
regT = min(tempT):1.0:max(tempT);

regX=interp1(tempT,tempX,regT,'linear','extrap');
regY=interp1(tempT,tempY,regT,'linear','extrap');

%% remove rows with zero
zdata2D = data2D(all(data2D,2),:);
% zdata2D(:,1) = zdata2D(:,1) * -1;
zdata2D(:,2) = zdata2D(:,2) * -1;

sel = zdata2D(:,3)==1;
actor1 = zdata2D(sel,1:2);
actor2 = zdata2D(zdata2D(:,3)==2,1:2);
actor3 = zdata2D(zdata2D(:,3)==3,1:2);
figure(1); clf; hold on; mkr=50;
scatter(actor1(:,1), actor1(:,2),mkr,'sk'); 
scatter(actor2(:,1), actor2(:,2),mkr,'*k'); 
scatter(actor3(:,1), actor3(:,2),mkr,'ok')
hLeg = legend('AV', 'VBP', 'OV', 'Location','southeast');
set(gca,'FontSize',18)

% find map limits
xmin = round(min(zdata2D(:,1)),-1);
xmax = round(max(zdata2D(:,1)), 1);
ymin = round(min(zdata2D(:,2)),-1);
ymax = round(max(zdata2D(:,2)), 1);

xlim([xmin xmax])
ylim([ymin ymax])
% or set har limts so all graphs same scale
xlim([-370 -240])
ylim([-210 -150])

% save high res (40:14 = 2.85)
% xlim([-35 0])
% ylim([3 17])
ax = gca; set(gcf, 'Color', 'w');
exportgraphics(ax,'path_divergenceXY.png','Resolution',300)

%%
addpath('/home/greg/git/CS-matlab/matlab/FileExchange/export_fig')
set(gcf, 'color', 'w')
set(gcf, 'color', 'none')
set(gca, 'color', 'w')
set(gca, 'color', 'none')
export_fig('ASR_trans', '-png', '-transparent', '-r600');


