% close all
clear all; close all; clc;

file_name = 'runtime_log_file.csv';
T1 = readtable(file_name);

x = T1(:,1);
x = table2array(x);

v = 60;
SD = 0.3*v +0.058 -0.011*v + 0.015*v*v;

asser1 = 0; % VBP outside DSav
asser2 = 0; % OV outside DSav
asser3 = 0; % AV outside DSov
asser4 = 0; % No DSav intersection DSov

oft = 7;

figure(1)
for i = 1:oft:x(end)

    
    d_1 = T1(i,end-4);
    d_1 = table2array(d_1);
    if iscell(d_1)
        d_1 = cell2mat(d_1);
        d_1 = str2num(d_1);
    end

    s_1 = T1(i,end-3);
    s_1 = table2array(s_1);
    if iscell(s_1)
        s_1 = cell2mat(s_1);
        s_1 = str2num(s_1);
    end

    d_2 = T1(i,end-2);
    d_2 = table2array(d_2);
    if iscell(d_2)
        d_2 = cell2mat(d_2);
        d_2 = str2num(d_2);
    end

    s_2 = T1(i,end-1);
    s_2 = table2array(s_2);
    if iscell(s_2)
        s_2 = cell2mat(s_2);
        s_2 = str2num(s_2);
    end

    display(s_2)

    display(i)
    if i <= 85
        pulling_out = 1;
        passing     = 0;
        abort       = 0;


        asser1 = 0;
        asser2 = 0;
        asser3 = 0;
        asser4 = 0;
    end

    if i> 85 && i <= 250
        pulling_out = 0;
        passing     = 1;
        abort       = 0;


        asser1 = 0;
        asser2 = 0;
        asser3 = 0;
        asser4 = 0;
        SD2  = SD*2;
        % Check if there is overlap in DS of OV and AV
        if ~isempty(s_2) && s_2 > SD && s_2 < SD2
            asser2 = 0;
            asser3 = 0;
            asser4 = 1;
        end

        % Check if AV and OV are insided each other's danger spaces.
        if s_2 < SD
            asser2 = 1;
            asser3 = 1;
            asser4 = 1;
        end
    end

    if i > 250 && i <= 299
        pulling_out = 0;
        passing     = 0;
        abort       = 1;

    end

    video_playtime = table2array(T1(i,1))/30 + 90;
    display(video_playtime)
    if abort == 0
        if asser1 == 0
            scatter(video_playtime,[4],'ko')
        elseif asser1 == 1
            scatter(video_playtime,[4],'filled','ko')
        end
        hold on

        if asser2 == 0
            scatter(video_playtime,[3],'ko')
        elseif asser2 == 1
            scatter(video_playtime,[3],'filled','ko')
        end
        hold on

        if asser3 == 0
            scatter(video_playtime,[2],'ko')
        elseif asser3 == 1
            scatter(video_playtime,[2],'filled','ko')
        end
        hold on

        if asser4 == 0
            scatter(video_playtime,[1],'ko')
        elseif asser4 == 1
            scatter(video_playtime,[1],'filled','ko')
        end
        hold on
    end

end
% scatter([1, 2, 3],[1, 1, 1],'ko')
% hold on
% scatter([4],[1],'filled','ko')
% hold on
%
% scatter([1, 2, 3, 4],[2, 2, 2, 2],'ko')
% hold on
%
% scatter([1, 2, 3, 4],[3, 3, 3, 3],'ko')
% hold on
%
% scatter([1, 2],[4, 4],'ko')
% hold on
% scatter([3, 4],[4, 4],'filled','ko')
% hold on
%
FontSize1 = 12;
FontSize2 = 8;

xlabel("Video play time line (s)")
ylabel("Assertion Number")
set(gca,'FontSize',FontSize1)

ylim([0 5])
xlim([89 100])
yticks([1 2 3 4])
% yticklabels({'VBP outside DS_{AV}','OV outside DS_{AV}','AV outside DS_{AV} = 3','No DS_{AV} intersection DS_{OV}'})
yticklabels({'(4)','(3)','(2)','(1)'})


drawbrace([90 4.2], [92.83 4.2], 10, 'Color', 'k');
text(90.83,4.6,'Pulling out')

drawbrace([92.83 4.2], [98.33 4.2], 10, 'Color', 'k');
text(94.67,4.6,'Passing VBP')

% drawbrace([250 4.2], [300 4.2], 10, 'Color', 'k');
annotation('arrow',[0.64 0.9],[0.5 0.5],'Color','r')
text(97.0,2.5,'Overtake Abort','Color','red')

plot([96,96],[0.1,4.3],'--r')
