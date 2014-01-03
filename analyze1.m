if 0
    tic
    load('hubway_date.mat')
    toc
end

%%%%%%%%%%%%%%%%%%%%%%
% Time of Day by age %
%%%%%%%%%%%%%%%%%%%%%%

% Get the time data
% Year (1), Month (2), Day (3), Hour (4), Minute (5), Second (6)
ride_start = datevec(d.start_time);
hour_start = ride_start(:,4);
ride_end = datevec(d.end_time);
hour_end = ride_end(:,4);

% Break up the ages
id_age_valid = find(d.birth_date ~= 0);  % indices when age is valid

age = 2012 - d.birth_date(id_age_valid);  % compute age of riders
age_ranges = [18, 25:10:85];              % bins for ages

age_times = cell(length(age_ranges),1);   % time for rentals for people in this age range
hours = 0.5:1:23.5;

age_hours = zeros(length(age_times),length(hours));

age_times{1} = hour_start(id_age_valid(age <= age_ranges(1)));  % first data set

for i = 2:length(age_ranges)-1
    lower_limit = find(age > age_ranges(i-1));
    upper_limit = find(age <= age_ranges(i));
    age_times{i} = hour_start(id_age_valid(intersect(lower_limit,upper_limit)));
    
    % Put the times into histograms
    n = hist(age_times{i},hours);
    age_hours(i,:) = n;
    
end



