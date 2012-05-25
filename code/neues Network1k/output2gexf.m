%This function transfers the data, generated by our simulation into a .gexf
%file, that encodes for a dynamic Network. This gexf file can be visualized
%using Gephi.

%The function needs a txt file containing the infected levels in the
%Network at various timesteps, a gexf file containg the network data and
%optional a file containing the total population of all the cities

function[]=output2gexf()

infected=dlmread('exp61new.txt'); %Problem!!! contains NaN...

gexf=importdata('dyndemo500.gexf');

cities=dlmread('cities.txt');

pop=cities(:,2);

cities=length(infected(:,1)); %number of cities in the array
timesteps=length(infected(1,:)); %number of timesteps 

%Normalize the infected over the total city population
for i=1:cities
    infected(i,:)=infected(i,:)/pop(i);
end

h=1;
q=1;

%Reduces the total number of timesteps used for the generation of the
%dynamic graph.
while q<=timesteps
    infected2(:,h)=infected(:,q);
    %After q=800 the infection is almost complete -> take less datapoints
    if q>800
        q=q+50;
    else q=q+1;
    end
    
    h=h+1;
end

infected=infected2;
timesteps=length(infected(1,:))

%strings needed for search and the insertion of the data

target='      <node id="1" start="1.0">';
data='          <attvalue for="Infected" value="000000000000" start="0000.0" endopen="0000.0"></attvalue>';
findata='          <attvalue for="Infected" value="000000000000" start="0000.0"></attvalue>';

%lgexf2=length(gexf)+cities*timesteps;
gexf2=cell(10000,1);

pos=1;
pos2=1;

%Copies the header of the template gexf file into the new version until the
%data of the first node can be inserted

while strcmp(target,gexf{pos}) ~= 1
    gexf2{pos2}=gexf{pos};
    pos=pos+1;    %15
    pos2=pos2+1; %15
end

gexf2{pos2}=target;
gexf2{pos2+1}='        <attvalues>';
pos2=pos2+1; %Update to the correct position 16

%Insertion of the infected levels at every timestep for each node.

for i=1:cities
    
    for n=1:timesteps-1
        data2=data;
        dummy=num2str(infected(i,n));
        d=length(dummy);
        data2(55-d:54)=dummy(1:d);
        dummy=num2str(n);
        d=length(dummy);
        data2(68-d:67)=dummy(1:d);
        dummy=num2str(n+1);
        d=length(dummy);
        data2(85-d:84)=dummy(1:d);
        gexf2{pos2+n}=data2;
    end
    
    pos2=pos2+timesteps; %19
    
    %The data of the last timepoint needs another format, because it has
    %no endpoint
    
    findata2=findata;
    dummy=num2str(infected(i,timesteps));
    d=length(dummy);
    findata2(55-d:54)=dummy(1:d);
    dummy=num2str(timesteps);
    d=length(dummy);
    findata2(68-d:67)=dummy(1:d);
    
    gexf2{pos2}=findata2; %the infected for the first node are now calculated
    
    pos=pos+3;%18 %24
    
    %Copies the positions of the nodes from the template into the new
    %gexf
    
    for t=1:7
        gexf2{pos2+t}=gexf{pos+t}; %
    end
    
    pos2=pos2+7;%40
    pos=pos+6;%23
    
end

%Copies the rest of the template gexf

for y=0:length(gexf)-pos
    gexf2{pos2+y-1}=gexf{pos+y};
end

%The collected data is now exported into a new gexf file

file_1 = fopen('500dynamic.gexf','w');

for u=1:length(gexf2)
    fprintf(file_1,gexf2{u});
    fprintf(file_1,'\n');
end

fclose(file_1)

end