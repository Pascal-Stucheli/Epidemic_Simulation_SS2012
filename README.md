
## MATLAB FS12 – Research Plan 

> * Group Name: EpicDemics
> * Group participants names: Christian Jordi, Yannick Schmid, Pascal Stücheli
> * Project Title: Epidemic_Simulation_SS2012

## General Introduction

We want to simulate an epidemic outbreak. The use of this could be to identify weak spots in traffic and to find key points in fighting the outbreak.   

## The Model

First step would be to create a random network of imaginary cities. We want to use real data from aviation and in a second step from road traffic. This data will be averaged with respect to the two connected cities, which means
we have to categorize the citys in a defined number of city-categories. Second step would be to stochasticly simulate the outbreak in a random city. 
Each city will then be simulated and calculated how many infected die, how many travel and how many infect another person. 

## Fundamental Questions

As mentioned above, with the focus  on stochastics, we wand to investigate the impact of fluctuations on the outcome of a disease. How does the outcome of the disease changes with different simulations? How many people were infected during the simulations? The aim is to answer this question for the different cities we want to simulate. Furthermore, we are interested to see, how the disease spread in terms of means of transport. Additionally, different conditions could be tested (cities vs. villages, city with a dense public transport network vs. city with few public transport).

## Expected Results

Big fluctuations in the speed of the infection caused by the randomness of the model. Faster outbreak if the initial infection was placed in a hub, that had many interconnections with other hubs.

## References 

We would like to try out our own modelling ideas. But we read different papers on this topic for inspiration.
For example:
D. Balcan et al.:Seasonal transmission potential and activity peaks of the new influenza A(H1N1): a Monte Carlo likelihood analysis based on human mobility.BMC Medicine 2009,7:45


## Research Methods

SI - Model to start with. No recovered and also no dead. In a later step, depending on the perfomance of the 
Model, we will decide to implement dead or recovered too. 
The model will be random based stochastic working with different distributions (binomial, hypergeometric and normal).
It will be a city based model.

## Other

-- Air traffic data --
http://www.transtats.bts.gov/Tables.asp?DB_ID=111&DB_Name=Air%20Carrier%20Statistics%20%28Form%2041%20Traffic%29-%20All%20Carriers&DB_Short_Name=Air%20Carriers
-- US Traffic data --
http://www.bts.gov/publications/national_transportation_statistics/html/table_01_41.html
http://www.bts.gov/publications/national_transportation_statistics/html/table_01_42.html  