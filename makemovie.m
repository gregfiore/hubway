aviobj = avifile('hubway_bike_flow.avi','compression','none');

files = dir('F*.png');

for i = 1:length(files)
    im = imread(files(i).name);
    aviobj = addframe(aviobj, im);
    i
end

close(aviobj);