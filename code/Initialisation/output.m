infected=dlmread('out5.txt');

gefx=importdata('final10k1.gexf');

cities=length(infected(:,1)); %number of cities in the array
timesteps=length(infected(1,:)); %number of timesteps -> use all timesteps. Minimization done in the storing part

%strings needed for search

target='      <node id="1" start="0.0">';
data='          <attvalue for="Infected" value="0000000" start="0000.0" endopen="0000.0"></attvalue>';
findata='          <attvalue for="Infected" value="1000" start="5.0"></attvalue>';

lgefx2=length(gefx)+cities*timesteps;
gefx2=cell(lgefx2,1);

pos=1;
pos2=1;
while strcmp(target,gefx{pos}) ~= 1
      gefx2{pos2}=gefx{pos};
       pos=pos+1;
       pos2=pos2+1;
end

gefx2{pos2+1}='        <attvalues>';
pos2=pos2+1; %Update to the correct position

for i=1:cities
      
       for n=1:timesteps-1
           data2=data; 
           dummy=num2str(infected(i,n));
           d=length(dummy);
           data2(50-d:49)=dummy(1:d);
           dummy=num2str(n);
           d=length(dummy);
           data2(63-d:62)=dummy(1:d);
           dummy=num2str(n+1);
           d=length(dummy);
           data2(80-d:79)=dummy(1:d);
           gefx2{pos2+n}=data2; 
       end
       
       pos2=pos2+timesteps;
       
       findata2=findata;
       dummy=num2str(infected(i,timesteps));
       d=length(dummy);
       findata2(50-d:49)=dummy(1:d);
       dummy=num2str(timesteps);
       d=length(dummy);
       findata2(63-d:62)=dummy(1:d);
       
       gefx2(pos2)=findata2; %the infected for the first node are now calculated
       
       pos=pos+4;
       
       for t=1:7
           gefx2{pos2+t}=gefx{pos+t};
       end
       
       pos2=pos2+8;
       pos=pos+8;
   
end
gefx2(pos2:pos2+length(gefx)-pos)=gefx(pos:length(gefx));






% file_1 = fopen('Untitled.gexf','w')
% % file_2 = fopen('output2.txt','w')
% % 
% fprintf(file_1,'<?xml version="1.0" encoding="UTF-8"?> \n <gexf xmlns="http://www.gexf.net/1.2draft" version="1.2" xmlns:viz="http://www.gexf.net/1.2draft/viz" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.gexf.net/1.2draft http://www.gexf.net/1.2draft/gexf.xsd"> \n  <meta lastmodifieddate="2012-05-02"> \n    <creator>Gephi 0.8</creator> \n    <description></description> \n  </meta> \n  <graph defaultedgetype="undirected" timeformat="double" mode="dynamic"> \n    <attributes class="node" mode="static"> \n      <attribute id="degree" title="Degree" type="integer"> \n        <default>0</default> \n      </attribute> \n    </attributes> \n    <attributes class="node" mode="dynamic"> \n      <attribute id="Infected" title="Infected" type="integer"></attribute> \n    </attributes> \n    <attributes class="edge" mode="dynamic"> \n      <attribute id="weight" title="Weight" type="float"></attribute> \n    </attributes> \n')
% 
% a=textread('Untitled.gexf')
% fclose(file_1)
% % fclose(file_2)