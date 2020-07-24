function [x,y] = autocorrection(x, y, x_min, x_max, y_min, y_max)
%% autocorrection
%   xy movement 데이터를 보고 튕긴 부분을 자동으로 correct 해준다.

%% Offset based correction

Foundoutlier=false; %이상치 발견 여부를 판단
step=0;
before_index=1; %이상치 직전 값의 순서
after_index=1; %이상치 직후 값의 순서 

for i=1:length(x)
    if Foundoutlier
        if x(i)<x_min || x(i)>x_max % 이상치가 계속될 때
            step=step+1;
            if i==length(x) %마지막 값까지 이상치일때
                x(before_index:end)=x(before_index);
            end
        else % 정상값을 이제 발견했을 때
            after_index=i;
            if before_index==0 %첫번째 값부터 이상치
                x(1:after_index)=x(after_index); %잘못된 값들을 수정
                step=0; %step 초기화
                Foundoutlier=false;
            else
                step=step+2;
                x(before_index:after_index)=linspace(x(before_index), x(after_index),step); %잘못된 값들을 직전 값과 직후 값 사이의 일정한 간격의 수치들로 수정
            end
            step=0; %step초기화
            Foundoutlier=false;
        end
    else
        if x(i)<x_min || x(i)>x_max % 이상치를 처음으로 발견
            if i==1 % 이상치가 첫번째 값일 때
                before_index=0;
            else % 그 외의 경우
                before_index=i-1;
                step=step+1;
            end
            Foundoutlier=true;
        end
    end
end


Foundoutlier=false;
step=0;
before_index=0;
after_index=0;

for i=1:length(y) %x값의 경우와 동일
    if Foundoutlier
        if y(i)<y_min || y(i)>y_max % 이상치
            step=step+1;
            if i==length(y) %마지막 값까지 이상치일때
                y(before_index:end)=y(before_index);
            end
        else % 정상값을 이제 발견했을 때
            after_index=i;
            if before_index==0 %첫번째 값부터 이상치
                y(1:after_index)=y(after_index);
                step=0;
                Foundoutlier=false;
            else
                step=step+2;
                y(before_index:after_index)=linspace(y(before_index), y(after_index),step);
            end
            step=0;
            Foundoutlier=false;
        end
    else
        if y(i)<y_min || y(i)>y_max % 이상치 발견
            if i==1 % 이상치가 첫번쨰 값일 때
                before_index=0;
            else % 그 외의 경우
                before_index=i-1;
                step=step+1;
            end
            Foundoutlier=true; %이상치를 발견했다고 판단
        end
    end
end
end
