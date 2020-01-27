# CF Tracker Pro

## Inspiration
Cystic Fibrosis (CF) is a disease that causes the body to produce mucus that is much thicker than usual. The two organs most affected are the lungs and pancreas, where the thick mucus causes breathing and digestive problems. The thicker mucus has trouble moving out of the lungs, so bacteria can remain and cause infections. Approximately 30,000 people in the United States have been diagnosed with CF, which affects both males and females. Approximately 12 million Americans, or 1 in every 20 people living in this country, is a CF carrier and they don’t even know it.

## What it does
Right now, there is no cure for CF. People with CF have to do many things to make sure that the mucus doesn’t build up in their lungs and pancreas.

One such current treatment is high-frequency chest wall oscillation, which involves wearing an inflatable vest that is attached to a machine. The vibrations not only separate mucus from the airway walls, they also help move it up into the large airways. Another treatment is pancreatic enzyme replacement therapy (PERT), which helps ensure that nutrients are effectively absorbed from food. About 90 percent of people with cystic fibrosis need to take the PERT enzymes before eating.

An easy to use and convenient app that CF patients can use to track different treatments
The 3 features we determined where most important for our prototype were:
- Nebulizer Treatment Tracking
    - Tracks times of how long different medications were taken, including Albuterol, hypertonic (Hptn) saline, and 
    - Pulmozyme and gives the user feedback about when treatments are done
- Meal/Enzyme Tracking
    - Tracks which meals are eaten at which time of day and tracks how many enzymes were eaten with each meal
- Enzyme Recommendations
    - At the end of the day, the user inputs their stool rating (-1, 1)
        - -1 is greasy/diarrhea, 0 is good, 1 is constipated
    - App takes into account enzyme count for the day and returns whether the user took too many enzymes or not enough

## How I built it
We used flutter to build a iOS and Android app that has three main functions:
1. It tracks the length of time daily treatments are taken
2. Tracks enzymes taken at different meal times
3. Sends stool and other data (inputted by the user) to a database run on firebase. A server-side program gets this data and runs a model (Tensorflow/Keras Dense Layer Neural Network) to determine if a person should take more or less enzymes.

## Challenges I ran into
Tensorflow not working :(

## Accomplishments that I'm proud of
TensorFlow worked!

## What I learned
How to make TensorFlow work

## What's next for CF Tracker Pro
More complex and accurate machine learning and data collection functionality.
Using better data that is taken from real people with CF to train a better model.

## Credits
- [Bharat Kathi](https://github.com/bk1031)
  - App Development + Database Schema
- [Thomas Liang](https://github.com/ThomasLiang123)
  - Server Side Development + Machine Learning Implementation
