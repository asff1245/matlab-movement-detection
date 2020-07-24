figure
x=data(:,1); 
y=data(:,2); %데이터에서 x,y값 지정. 사용중인 데이터 이름이 data인지 확인하기
plot(x,y)
x_min=input("x좌표의 최소값을 입력하세요") 
x_max=input("x좌표의 최대값을 입력하세요")
y_min=input("y좌표의 최소값을 입력하세요")
y_max=input("y좌표의 최대값을 입력하세요")



  
  %% Offset based correction
[x,y] = autocorrection(x, y, x_min, x_max, y_min, y_max); 
%% distance based correction
x_rev = x; 
y_rev = y; %x,y를 이동거리에 비례해서 수정
  threshold = 5; %이상치의 판단기준
  for i = 2 : length(x)
      distance = ( (x(i) - x(i-1)).^2 + (y(i) - y(i-1)).^2 ).^0.5; %x,y가 이동한 거리의 계산
      if distance >= threshold
          x_rev(i) = -1000;
          y_rev(i) = -1000; %거리가 역치 이상이면 해당 x,y값의 왜곡을 극대화하기-> autocorrection함수로 탐지할 수 있는 이상치로 만들기
      end
  end
  
  [x_fin,y_fin] = autocorrection(x_rev, y_rev, x_min, x_max, y_min, y_max); %다시  이상치 수정

  

%% distance correction and plotting
for i=1:length(x_fin)-1 %위의 수정으로 인해 생긴 작은 왜곡들을 재수정
transfer_x(i)=x_fin(i+1)-x_fin(i); 
transfer_y(i)=y_fin(i+1)-y_fin(i); %x,y들이 각각 이동하는 거리
if transfer_x(i)>mean(transfer_x)+std(transfer_x) || transfer_x(i)<mean(transfer_x)-std(transfer_x) %좌표의 이동거리를 평균적인 이동거리와 비교
    x_fin(i:i+1)=x_fin(i-1);
end
if transfer_y(i)>mean(transfer_y)+std(transfer_y) || transfer_y(i)<mean(transfer_y)-std(transfer_y)
    y_fin(i:i+1)=y_fin(i-1);
end
end
movement=sqrt(transfer_x.^2+transfer_y.^2); %실제로 좌표가 이동한 대각선 거리 구하기
movement=filloutliers(movement,'previous','median'); %이상치 탐지 후 이전 값으로 변경
movement=movmean(movement,100); %그래프를 완만하게
  %%
  figure(1);
clf
subplot(1,4,1);
plot(data(:,1), data(:,2)); %원본 데이터
subplot(1,4,2);
plot(x,y); %1차수정
subplot(1,4,3);
plot(x_fin, y_fin); %최종수정
subplot(1,4,4);
plot(movement); %이동거리의 변화