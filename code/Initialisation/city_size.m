function[cities]=city_size(cities)
%Code to determine the size of the cities

%Input parameters:
%cities: city matrix of format mx3, where the first column is filled with
%the degree of the city in the Network

%Output:
%cities: modified version of the input matrix. The city population
%(cities(:,2)) has been added

%Additional output: cities.txt stores the city matrix, so it can be reused

%rank the cities depending on degree
rank=zeros(length(cities(:,1)),1);
rank(1)=1;
for i=2:length(cities(:,1))
    %n=i;
    y=1;
    while y<i
        if cities(i,1)>=cities(rank(y),1)
            for k=(i-1):-1:y
                rank(k+1)=rank(k);
            end
            rank(y)=i;
            y=i; %to break while loop
            
        elseif y==i-1
            rank(i)=i;
            y=i;
        else
            y=y+1;
        end
    end
end

%Now use zipfs law to generate the city sizes.
%the parameters ln(a)= 18.6 b=1.23 are used (see 3.3 for further info)

a=exp(18.6);
b=1.23;

for i=1:length(cities(:,1))
    zipf=exp(-log(i/a)/b);
    cities(rank(i),2)= round(zipf+randn*zipf*0.01); %Added 1% normal distributed noise
end

%Store modified file
dlmwrite('cities.txt',cities);

end
