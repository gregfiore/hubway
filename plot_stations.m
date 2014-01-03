clear all
close all
clc

load('stations.mat');

address_coordinates = [cell2mat(stations(:,8)), cell2mat(stations(:,7))];

latitude = mean(nonzeros(address_coordinates(1,2)));
longitude = mean(nonzeros(address_coordinates(1,1)));

preamble = 'http://maps.google.com/maps/api/staticmap?';

center_text = ['center=',num2str(latitude),',',num2str(longitude)];
center_text = '';

zoom_text = ['&zoom=20'];
zoom_text = '';


size_text = ['&size=640x640'];

type_text = ['&maptype=roadmap'];


% Note: if the center and zoom parameters are not included, the Static Map
% server will automatically construct an image which contains the supplied
% markers

marker_text = [];

for i = 1:50
    marker_text = [marker_text,'&markers=color:blue%7C',num2str(address_coordinates(i,2)),',',num2str(address_coordinates(i,1)),];
end
% 
%  marker_text = [marker_text,'&markers=color:blue%7C',num2str(address_coordinates(1,2)),',',num2str(address_coordinates(1,1)),];


sensor_text = ['&sensor=false'];

url_text = [preamble,center_text,zoom_text,size_text,type_text,marker_text,sensor_text];

filename = urlwrite(url_text,'tmp.png');
[M Mcolor] = imread(filename);

image(M); colormap(Mcolor);