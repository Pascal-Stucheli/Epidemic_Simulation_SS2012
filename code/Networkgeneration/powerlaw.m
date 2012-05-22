%%Check whether the generated networks follow a power law

citie = dlmread('cities.txt');

degrees=city(:,1);

hist(loglog(degrees))