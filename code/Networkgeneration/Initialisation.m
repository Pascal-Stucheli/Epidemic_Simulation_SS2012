%Summary of the functions needed to create our start network. bcs
%everything needed is stored in .txt or .csv files. -> has only to be
%executed once


function[]=Initialisation()

ncit = 100; %number of cities in the Network
seeded = [1 5; 2 3; 4 5;4 3];%seed for the edges
seedct = [1 0 0;1 0 0;1 0 0;1 0 0;2 0 0]; %seed for the cities

cities=networkepid(ncit,seeded,seedct); %->skipped the saving step

city_size(cities); %output is cities.txt

%%%%%%%%%%%%%%%add yannicks file for the flux size

end