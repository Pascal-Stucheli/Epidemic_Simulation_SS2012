%20.4.2012 Christian Jordi
%Generation of a scale free network, with the possibility to form loops

function[cities,edge]=networkepid2loops(ncit,seeded,seedct)

%Input parameters are:
%ncit: integer, number of nodes in the generated network
%seeded: seed for the edges matrix. array of size (nx2)
%seedct: seed for the city matrix. array of size (mx3)

%Output is:
%cities: matrix of size ncitx3, the first column is filled, the two others
%are blank
%edge: matrix of size yx2, undirected edge list of the graph {city,city2;..]

%Additional output: -a .txt file of the edge list to be used by other
%                       functions
%                   -a .csv file of the edge list, to be used by gephi

cities=zeros(ncit,3);
pos= length(seedct(:,1));
cities(1:pos,1:3)=seedct; %Stores (degree,Inhabitants,Infected)
edge=seeded; %Connections btwn the cities, store lower index first
pass=0; %number of passengers on an edge %%%%%%not used yet%%%%%%%%%
mlinks=2; %number of links that are fixed at each step increased to two
sumlinks=length(edge(:,1)); %total number of edges
linkage=0; %Determines wether a new edge has been set 

%functions
while pos < ncit
    pos= pos+1;
    posed=length(edge)+1;
    linkage=0;
    
    while linkage ~= mlinks %true as long as the new edge has not been set
        
        %pos= pos+1;
        %posed=length(edge)+1;
        
        rnode = ceil(rand * pos); %randomly choose a node in front of the current position
        deg = cities(rnode,1); %degree of the chosen node
        rlink = rand; %random number to determine wether an edge is formed
        
         if rlink < deg / sumlinks && isequal(edge(length(edge(:,1)),:),[rnode,pos])~=1%&& Net(pos,rnode) ~= 1 && Net(rnode,pos) ~= 1 as long as only one linkage is set per step
                                   % (mlinks=1) the oher two conditions do not matter
            cities(pos,1)=cities(pos,1)+1; %degree of the new introduced city is increased by one
            cities(rnode,1)=cities(rnode,1)+1; %The deg of the chosen city is increased by one
            edge(posed,1)=rnode; %stores the new edge
            edge(posed,2)=pos;
            sumlinks=length(edge(:,1));
            linkage=linkage+1;
            posed=posed+1;
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
cell2csv('smallernetwork10kfinalloop.csv', edgecell2, [], 2007, [])
dlmwrite('edges.txt',edge);

end