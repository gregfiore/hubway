if 1

    % Read in Hubway data

    cd('/Users/gregfiore/Dropbox/Projects/Hubway')

    labels = {'id','status','duration','start_date','start_station_id','end_date','end_station_id','bike_nr','subscription_type','zip_code','birth_date','gender'};

    formats = {'%d','%s',     '%d',        '%s',         '%d',            '%s',        '%d',           '%s',       '%s',            '%s'        '%d'        '%s'};

    n_records = 552073;

    format_string = '';

    for i = 1:length(formats)
        format_string = [format_string,' ',formats{i}];
    end

    fid = fopen('trips.csv');

    labels2 = fgetl(fid);

    disp('Reading in text file')
    
    C = textscan(fid,format_string,n_records,'Delimiter',',');

    fclose(fid);
    
    for i = 1:length(labels)
        eval(['d.',labels{i}, '=C{',num2str(i),'};']);
    end
    
    clear C
    
%     for i = 1:n_records
%         start_date{i} = start_date{i}(1:21);
%         end_date{i} = end_date{i}(1:21);
%     end
    
end

good_dates = find(d.birth_date ~= 0);

ages = 2012-birth_date(good_dates);

disp('Converting start dates.')
start_date2 = cell2mat(d.start_date);
start_date2 = start_date2(:,2:20);
start_date2 = cellstr(start_date2);

d.start_time = datenum(start_date2,31);

disp('Converting end dates.')
end_date2 = cell2mat(d.end_date);
end_date2 = end_date2(:,2:20);
end_date2 = cellstr(end_date2);

d.end_time = datenum(end_date2,31);

disp('Saving data.');
save hubway_date.mat d


