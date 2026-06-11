# NYC-Crime-Risk-Intelligence-Dashboard
An end-to-end data analysis project examining 84,742 NYPD complaint records to uncover crime patterns, severity distributions, and behavioral signatures across New York City's five boroughs.
 #Project Objective
To go beyond surface-level crime statistics and apply analyst-level thinking — using weighted severity scoring, window functions, and cross-dimensional analysis — to extract actionable insights from NYC crime data.
#Dataset
•	Source: NYC Open Data — NYPD Complaint Data
•	Records Analyzed: 84,742 rows
•	Cleaned Using: Python (Google Colab) — null handling, column standardization, feature engineering
•	Fields Used: Borough, Crime Type, Law Category, Premise Type, Suspect/Victim Demographics, Date, Time, Hour
 #Tools Used
Tool	Purpose
Python (Pandas)	-Data cleaning and preprocessing
MySQL	-Advanced SQL analysis and querying
Power BI	-Data visualization and dashboarding
Google Collab	-Cleaning environment
GitHub	-Version control and portfolio hosting
#Key Findings
•	Manhattan is the most severe borough with an average crime severity index of 2.20, despite ranking 2nd in total incidents — indicating a higher concentration of felony-level offenses compared to other boroughs
•	Staten Island recorded the lowest severity index at 2.08, suggesting a higher proportion of misdemeanors and violations relative to serious crimes
•	Robbery is a late-night crime — 27.4% of all robberies occur between 10pm and 6am, making it the most time-concentrated offense in the dataset
•	Petit Larceny peaks in the afternoon — 43.7% of incidents occur between 12pm and 6pm, aligning with retail and commuter activity hours
•	Burglary is an apartment crime — the #1 premise for burglary is Residence-Apt. House, while Robbery's #1 premise is the Street, revealing distinct environmental contexts per offense
•	Felony Assault spikes on weekends — 32.1% of felony assaults occur on weekends, the highest weekend concentration of any crime type analyzed, likely linked to nightlife and social gatherings
•	Petit Larceny is the most common crime with 15,995 incidents — accounting for the largest share of all complaints in the dataset.
#What Makes This Project Different
Most crime analyses stop at counting incidents by borough, time, or demographic. This project applies weighted severity scoring, SQL window functions, and cross-dimensional profiling to answer questions that matter to real analysts:
•	Not just where crime happens — but how serious it is per location
•	Not just when crime peaks — but what the time signature of each offense looks like
•	Not just what premises are dangerous — but which premises are dangerous for which specific crime

<img width="468" height="628" alt="image" src="https://github.com/user-attachments/assets/37e257df-8627-4745-962a-13319fd90552" />
