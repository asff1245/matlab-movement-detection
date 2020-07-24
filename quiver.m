%% divide plot into grid
x_range = [150,450];
y_range = [-10, 450]; %공간의 크기 설정
grid_size = 20;%격자 한칸의 크기 지정

x_index = floor((x_fin - x_range(1)) ./ grid_size) + 1;
y_index = floor((y_fin - y_range(1)) ./ grid_size) + 1; %x,y의 좌표값과 최솟값을 이용해 좌표값이 포함되는 범위 찾기


GRID = cell(...
    (x_range(2) - x_range(1)) / grid_size,...
    (y_range(2) - y_range(1)) / grid_size); % 원하는 크기와 간격의 격자공간 만들기

%% Assign points to cells
x_thr = std(transfer_x)*2;
y_thr = std(transfer_y)*2; %판단기준
for i = 1 : size(x_t1,1)-1
    if (abs(transfer_x(i)) < x_thr) && (abs(transfer_y(i)) < y_thr) %x,y이동값이 이상치가 아닐 때
        GRID{x_index(i),y_index(i)} = [GRID{x_index(i),y_index(i)};transfer_x(i),transfer_y(i)]; %해당하는 영역에 x,y 이동값을 배정
    end
end

%% Sum all grids
sumGrid = zeros([size(GRID),2]); %각 칸의 이동값들의 합을 저장
numGrid = zeros(size(GRID)); %각 칸에 배정된 값들의 개수를 저장
for i = 1 : size(GRID,1) * size(GRID,2)
    if isempty(GRID{i}) %값이 배정되지 않은 칸들에 대해서 0을 배정
        temp = [0,0];
        numGrid(i) = 0; %이동값의 합과 값들의 개수가 저장될 변수에도 0을 배정
    else %해당 칸에 값이 배정되어 있는 경우
        temp = sum(GRID{i},1); %임시로 합을 저장
        numGrid(i) = size(GRID{i},1); %이동값의 개수 저장
    end
    sumGrid(i) = temp(1); %임시로 저장했던 x이동값의 합을 알맞는 위치에 배정
    sumGrid(size(GRID,1) * size(GRID,2) + i) = temp(2); %임시로 저장했던 y이동값들의 합을 알맞는 위치에 배정
end


%% Draw

figure(1);
clf
imagesc(x_range(1):grid_size:x_range(2)-grid_size, y_range(1):grid_size:y_range(2)-grid_size,numGrid', 'AlphaData',0.8); %해당 칸에 방문하는 횟수
hold on;
[x,y] = meshgrid(x_range(1):grid_size:x_range(2)-grid_size, y_range(1):grid_size:y_range(2)-grid_size);
quiver(...
    x,...
    y,...
    sumGrid(:,:,1)',...
    sumGrid(:,:,2)','Color', 'w', 'LineWidth', 0.5); %각 칸에 x,y의 이동 경향성 화살표로 표시



