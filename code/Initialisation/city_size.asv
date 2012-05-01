%Code to determine the size of the cities

function[cities]=city_size(cities)

%Input parameters:
%cities: city matrix of format mx3, where the first column is filled with
%the degree of the city in the Network

%Output:
%cities: modified version of the input matrix. The city population
%(cities(:,2)) has been added

%Additional output: cities.txt stores the city matrix, so it can be reused

  %new idea: use zipfs law:
 %http://www.dbresearch.de/PROD/DBR_INTERNET_DE-PROD/PROD0000000000242036/Die+seltsam+stabile+Gr%C3%B6%C3%9Fenstruktur+deutscher+St%C3%A4dte.pdf
 %Rang=alpha*E^-betha
 %ln(R)=ln(a)-ln(E)*b -> ln(a)= 18.6 b=1.23
 %->ln(E)=-ln(R/a)/b
 %cities=dlmread('cities.txt');
 
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
 
 %Now use zipfs law to generate the city sizes. Problem Among the level 1
 %cities a huge size difference will be observed???
 a=exp(18.6);
 b=1.23;
 
 for i=1:length(cities(:,1))
     zipf=exp(-log(i/a)/b);
    cities(rank(i),2)= round(zipf+randn*zipf*0.01); %Added 1% normal dist. noise
 end
 
 %smallest city has around 13k inhabitants and biggest city has 3.7M maybe
 %the parameters should be adjusted to allow smaller cities, or the number
 %of cities has to be increased
 
 %Total Population Around 54M (at a size of 1000)
 total=sum(cities(:,2))
 
 %Export modified file back
 dlmwrite('cities.txt',cities);
 
end
