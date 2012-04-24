%20.4.2012 Christian Jordi
%Generation of a scale free network

clear all  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%to be removed ->insert function definition here

%Parameters
ncit= 1000; %number of cities

%variables
seeded = [1 5; 2 3; 4 5;4 3];%seed for the edges
seedct = [1 0 0;1 0 0;1 0 0;1 0 0;2 0 0]; %seed for the cities
cities=zeros(ncit,3);
pos= length(seedct(:,1));
cities(1:pos,1:3)=seedct; %Stores (degree,Susceptibles,Infected)
edge=seeded; %Connections btwn the cities, store lower index first
pass=0; %number of passengers on an edge %%%%%%not used yet%%%%%%%%%
mlinks=1; %number of links that are fixed at each step
sumlinks=length(edge(:,1)); %total number of edges
linkage=0; %Determines wether a new edge has been set 

%functions
while pos < ncit
    pos= pos+1;
    posed=length(edge)+1;
    linkage=0;
    
    while linkage ~= mlinks %true as long as the new edge has not been set
        rnode = ceil(rand * pos); %randomly choose a node in front of the current position
        deg = cities(rnode,1); %degree of the chosen node
        rlink = rand; %random number to determine wether an edge is formed
        
         if rlink < deg / sumlinks %&& Net(pos,rnode) ~= 1 && Net(rnode,pos) ~= 1 as long as only one linkage is set per step
                                   % (mlinks=1) the oher two conditions do not matter
            cities(pos,1)=1; %degree of the new introduced city is set to 1
            cities(rnode,1)=cities(rnode,1)+1; %The deg of the chosen city is increased by one
            edge(posed,1)=rnode; %stores the new edge
            edge(posed,2)=pos;
            sumlinks=length(edge(:,1));
            linkage=linkage+1;
         end
    end
end
%bring data in a form gephi can understand
edgecell=num2cell(edge);
edgecell2{length(edgecell),3}=0;


for i=1:length(edgecell)
    edgecell2{i+1,1}=edgecell{i,1};
    edgecell2{i+1,2}=edgecell{i,2};
    edgecell2{i+1,3}='undirected';
end

edgecell2{1,1}='source';
edgecell2{1,2}='target';
edgecell2{1,3}='type';

%Save the data
cell2csv('smallernetwork.csv', edgecell2, [], 2007, [])
dlmwrite('cities.txt',cities);
