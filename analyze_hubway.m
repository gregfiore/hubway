if 0
    tic
    load('hubway_date.mat')
    load('stations.mat')
    toc
end

% Generate a vector of times
days = unique(round(d.start_time));
station_ids = cell2mat(stations(:,1));
day_str = cell(length(days),1);

station_capacity = zeros(length(days),size(stations,1));

active_stations = zeros(size(stations,1),1);

% aviobj = avifile('hubway_bike_flow.avi','compression','none');

fig = figure;
set(gcf,'Position',[112         273        1784         805]);
set(gcf,'Color','k');
set(gcf,'InvertHardcopy','off')
set(gcf,'PaperPositionMode','auto')

for i = 1:length(days)
%     disp(['Processing day ',num2str(i),' of ',num2str(length(days))]);
    
    daily_ride_id = find(round(d.start_time) == days(i));
    
    if i > 1
        % carry over from the last day
        station_capacity(i,:) = station_capacity(i-1,:);
    end
    
%     disp(['On day ',num2str(i),' there were ',num2str(length(daily_ride_id)),' rides'])
    
    % compute the delta's for each ride
    for j = 1:length(daily_ride_id)
        start_station = d.start_station_id(daily_ride_id(j));
        end_station = d.end_station_id(daily_ride_id(j));
        
        start_station_index = find(station_ids == start_station);
        active_stations(start_station_index) = 1;
        end_station_index = find(station_ids == end_station);
        active_stations(end_station_index) = 1;
        
        if isempty(start_station_index)
%             disp(['End station ',num2str(start_station),' not found.']);
        end
        if isempty(end_station_index)
%             disp(['Start station ',num2str(end_station),' not found.']);
        end
        
        station_capacity(i,start_station_index) = station_capacity(i,start_station_index) - 1;
        station_capacity(i,end_station_index) = station_capacity(i,end_station_index) + 1;
    end
    
    day_str{i} = strrep(datestr(days(i),22),'.',' ');
    
    hold off
    
    for j = 1:size(stations,1)
        if active_stations(j)
            plot(j, station_capacity(i,j),'.','MarkerSize',25,'Color',[38 140 38]/256)
        else
            plot(j, station_capacity(i,j),'.','MarkerSize',25,'Color',[227 230 228]/256)
        end
        hold on
        text(j,station_capacity(i,j)+50,stations{j,3},'Rotation',90,'Color',[227 230 228]/256)
    end
    
    for j = -1200:400:800
        text(-2,j,[num2str(j),' - '],'FontName','Helvetica','FontSize',15,'Color',[227 230 228]/256,'HorizontalAlign','Right');
    end
    
    text(-10,0,'Net Bike Flow','FontName','Helvetica','FontSize',15,'Color',[227 230 228]/256,'Rotation',90,'HorizontalAlign','Center');
    
    set(gca,'YLim',[-1200 3400])
    set(gca,'XLim',[0 length(stations)+2]);
    set(gca,'YTick',[-1200:300:1200]);
    set(gca,'FontSize',18,'FontName','Helvetica');
    set(gca,'XTickLabel','');
    set(gca,'Color','k')
    
    title([day_str{i}(1:7),' ',day_str{i}(8:end)],'FontName','Helvetica','FontSize',40,'Color',[160 160 160]/256)
    drawnow
    
%     F = getframe(fig);
%     aviobj = addframe(aviobj,F);
    
%     pause(0.1)
        
%     print(fig,['images/F',num2str(i),'.png'],'-dpng');
end

% close(fig);
% aviobj = close(aviobj)

% %%%%%%%%%%%%%%%%%%%%%%
% % Time of Day by age %
% %%%%%%%%%%%%%%%%%%%%%%
% 
% % Get the time data
% % Year (1), Month (2), Day (3), Hour (4), Minute (5), Second (6)
% ride_start = datevec(d.start_time);
% hour_start = ride_start(:,4);
% ride_end = datevec(d.end_time);
% hour_end = ride_end(:,4);
% 
% % Break up the ages
% id_age_valid = find(d.birth_date ~= 0);  % indices when age is valid
% 
% age = 2012 - d.birth_date(id_age_valid);  % compute age of riders
% age_ranges = [18, 25:10:85];              % bins for ages
% 
% age_times = cell(length(age_ranges),1);   % time for rentals for people in this age range
% hours = 0.5:1:23.5;
% 
% age_hours = zeros(length(age_times),length(hours));
% 
% age_times{1} = hour_start(id_age_valid(age <= age_ranges(1)));  % first data set
% 
% for i = 2:length(age_ranges)-1
%     lower_limit = find(age > age_ranges(i-1));
%     upper_limit = find(age <= age_ranges(i));
%     age_times{i} = hour_start(id_age_valid(intersect(lower_limit,upper_limit)));
%     
%     % Put the times into histograms
%     n = hist(age_times{i},hours);
%     age_hours(i,:) = n;
%     
% end
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Plot number of rides with temperature %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% if 0
%         %%%%% NEED TO ADD PREDIPITATION
%     
%         % Unique days
%         days = unique(round(d.start_time));
%         disp([num2str(length(days)),' unique days found between ',datestr(days(1)),' and ',datestr(days(end))]);
% 
%         n_rides = zeros(length(days),1);
%         daily_temp = zeros(length(days),2);
% 
%         % 'http://classic.wunderground.com/weatherstation/WXDailyHistory.asp?ID=KMANUTTI1&graphspan=week&month='10&day=2&year=2012&format=1'
%         preamble = 'http://api.wunderground.com/api/6b782b15c7d2c5ef/history_';
%         postscript = '/q/MA/Boston.json';
% 
%         if 0
%             for i = 1:length(days)
%                 date_str = strrep(datestr(days(i),29),'-','');
%                 temp = urlread([preamble,date_str,postscript]);
%                 data = loadjson(temp);
%                 daily_temp(i,1) = str2double(data.history.dailysummary.mintempi);
%                 daily_temp(i,2) = str2double(data.history.dailysummary.maxtempi);
%                 if mod(i,10) == 0
%                     pause(60);
%                     disp([num2str(i/length(days)*100),'% done, pausing for Wunderground API.']);
%                 end
% 
%             end
%         else
%             load('weatherdata.mat');
%         end
% 
%         mean_temp = mean(daily_temp,2);
% 
%         for i = 1:length(days)
%             n_rides(i) = length(find(round(d.start_time) == days(i)));
%         end
% end
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Plot ridership vs. day of week and month %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% days = unique(round(d.start_time));
% v = datestr(days,'dddd');   % These are already sorted by date
% v = strtrim(cellstr(v));
% 
% start_id = strcmp('Monday',v);
% start_id = find(start_id == 1,1,'first');
% 
% current_id = start_id;
% 
% % find the week's data
% if strcmp(v(current_id+1),'Tuesday') && ...
%    strcmp(v(current_id+2),'Wednesday') && ...
%     strcmp(v(current_id+3),'Thursday') && ...
%     strcmp(v(current_id+4),'Friday') && ...
%     strcmp(v(current_id+5),'Saturday') && ...
%     strcmp(v(current_id+6),'Sunday')
% 
%     disp(['Complete week located from Monday ',datestr(days(current_id)),' to Sunday ',datestr(days(current_id+6))]);
%     
% 
% end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute the delta in bikes per station %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


