%This function transfers the data, generated by our simulation into a .gexf
%file, that encodes for a dynamic Network. This gexf file can be visualized
%using Gephi.

%The function needs a txt file containing the infected levels in the
%Network at various timesteps, a gefx file containg the network data and
%optional a file containing the total population of all the cities


function[]=output2gexf()

infected=dlmread('exp21.txt'); %Problem!!! contains NaN...

gefx=importdata('dyndemo500.gexf');

cities=dlmread('cities.txt');

pop=cities(:,2);

%clear cities

cities=length(infected(:,1)); %number of cities in the array
timesteps=length(infected(1,:)); %number of timesteps -> use all timesteps. Minimization done in the storing part

%%%%%%%%%%%%%%%%%%new, should be outsourced into the data collecting part

%Normalize the infected over the total city population
for i=1:cities
    infected(i,:)=infected(i,:)/pop(i);
end

clear pop

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%555

%to be deleted
h=1;
q=1;

%Reduces the total number of timesteps used for the generation of the
%dynamic graph. This could be outsourced

while q<=timesteps
    infected2(:,h)=infected(:,q);
    if q<400
    q=q+20;
    end
    if q<800 && q>400
        q=q+2;
    end
    if q>800
        q=q+50;
    end

        h=h+1;
end
infected=infected2;
timesteps=length(infected(1,:))

%strings needed for search and the insertion of the data

target='      <node id="1" start="1.0">';
data='          <attvalue for="Infected" value="000000000000" start="0000.0" endopen="0000.0"></attvalue>';
findata='          <attvalue for="Infected" value="000000000000" start="0000.0"></attvalue>';

%lgefx2=length(gefx)+cities*timesteps;
gefx2=cell(10000,1);

pos=1;
pos2=1;

%Copies the header of the template gexf file into the new version until the
%data of the first node can be inserted

while strcmp(target,gefx{pos}) ~= 1
      gefx2{pos2}=gefx{pos};
       pos=pos+1;    %15
       pos2=pos2+1; %15
end

gefx2{pos2}=target;
gefx2{pos2+1}='        <attvalues>';
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
           gefx2{pos2+n}=data2; 
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
       
       gefx2{pos2}=findata2; %the infected for the first node are now calculated
       
       pos=pos+3;%18 %24
       
       %Copies the positions of the nodes from the template into the new
       %gexf
       
       for t=1:7
           gefx2{pos2+t}=gefx{pos+t}; %
       end
       
       pos2=pos2+7;%40
       pos=pos+6;%23
   
end

%Copies the rest of the template gexf

for y=0:length(gefx)-pos
gefx2{pos2+y-1}=gefx{pos+y};
end

%The collected data is now exported into a new gexf file

file_1 = fopen('500dynamic.gexf','w');

for u=1:length(gefx2)
    fprintf(file_1,gefx2{u}); 
    fprintf(file_1,'\n');
end

fclose(file_1)

end