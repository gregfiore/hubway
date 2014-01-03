function plot_time(data,radius)

img = imread('clock.png');

imagesc(img)
img = rgb2gray(img);
[m,n] = size(img);
center = [round(n/2),round(m/2)];

morning = 1;
line_width = 15;
line_color = 'k';
max_cnt = max(data);
sf = radius / max_cnt;

for i = 1:12
    if morning
        angle = 90-30*(i-1)+360/24;
        hold on
        plot(center(1)+[0, sf*data(i)*cosd(angle)],center(2)+[0, -sf*data(i)*sind(angle)],'k','linewidth',line_width);
    end
end

axis equal