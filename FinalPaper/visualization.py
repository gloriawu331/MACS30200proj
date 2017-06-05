# Perspectives on Computational Research
# Final Project: Data Visualization

import os
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt


data = pd.read_csv('data1.csv')


# Create directory if images directory does not already exist
'''
--------------------------------------------------------------------
cur_path    = string, path name of current directory
output_fldr = string, folder in current path to save files
output_dir  = string, total path of images folder
output_path = string, path of file name of figure to be saved
--------------------------------------------------------------------
'''
cur_path = os.path.split(os.path.abspath(__file__))[0]
output_fldr = 'images'
output_dir = os.path.join(cur_path, output_fldr)
if not os.access(output_dir, os.F_OK):
    os.makedirs(output_dir)
    

plot_age = True
if plot_age == True:
    plt.hist(data['age'])

    plt.title('Figure 1: Distributon of Age', y=1.05)
    plt.xlabel('Age')
    plt.ylabel('Frequency')
        
    output_path = os.path.join(output_dir, 'Fig_1')
    plt.savefig(output_path)
    plt.show()
    plt.close()

plot_salary = True
if plot_salary == True:
    plt.hist(data['salary'], 50)

    plt.title('Figure 2: Distributon of Annualized Salary', y=1.05)
    plt.xlabel('Annualized Salary($)')
    plt.ylabel('Frequency')
        
    output_path = os.path.join(output_dir, 'Fig_2')
    plt.savefig(output_path)
    plt.show()
    plt.close()

plot_lninc = True
if plot_lninc == True:
    plt.hist(data['lninc'].dropna(), 50)

    plt.title('Figure 3: Distributon of Logged Annualized Salary', y=1.05)
    plt.xlabel('Logged Annualized Salary($)')
    plt.ylabel('Frequency')
        
    output_path = os.path.join(output_dir, 'Fig_3')
    plt.savefig(output_path)
    plt.show()
    plt.close()

plot_age_move = True
if plot_age_move == True:
    counts_is_moved = data[data['is_move']==1].groupby('age').size().rename('counts').reset_index()
    counts_not_moved = data[data['is_move']==0].groupby('age').size().rename('counts').reset_index()
    plt.plot(counts_is_moved['age'], counts_is_moved['counts'], label='Moved', color='red')
    plt.plot(counts_not_moved['age'], counts_not_moved['counts'], label='Not Moved', color='blue')
    
    plt.legend(loc='upper right')
    plt.title('Figure 4: Whether Individuals Move Across Age', y=1.05)
    plt.xlabel('Age')
    plt.ylabel('Number of Individuals')

    output_path = os.path.join(output_dir, 'Fig_4')
    plt.savefig(output_path)
    plt.show()
    plt.close()

plot_gender_move = True
if plot_gender_move == True:
    # distance = 0
    counts_distance0 = data[data['distance']==0].groupby('age').size().rename('counts').reset_index()
    plt.plot(counts_distance0['age'], counts_distance0['counts'], label='Not Moved')
    # distance = 1
    counts_distance1 = data[data['distance']==1].groupby('age').size().rename('counts').reset_index()
    plt.plot(counts_distance1['age'], counts_distance1['counts'], label='Distance = 1')
    # distance = 2
    counts_distance2 = data[data['distance']==2].groupby('age').size().rename('counts').reset_index()
    plt.plot(counts_distance2['age'], counts_distance2['counts'], label='Distance = 2')
    # distance = 3
    counts_distance3 = data[data['distance']==3].groupby('age').size().rename('counts').reset_index()
    plt.plot(counts_distance3['age'], counts_distance3['counts'], label='Distance = 3')
    # distance = 4
    counts_distance4 = data[data['distance']==4].groupby('age').size().rename('counts').reset_index()
    plt.plot(counts_distance4['age'], counts_distance4['counts'], label='Distance = 4')
    # distance = 5
    counts_distance5 = data[data['distance']==5].groupby('age').size().rename('counts').reset_index()
    plt.plot(counts_distance5['age'], counts_distance5['counts'], label='Distance = 5')
    # distance = 8
    counts_distance8 = data[data['distance']==8].groupby('age').size().rename('counts').reset_index()
    plt.plot(counts_distance8['age'], counts_distance8['counts'], label='Move Abroad')
    
    plt.legend(loc='upper right')
    plt.title('Figure 5: Distance of Move Across Age', y=1.05)
    plt.xlabel('Age')
    plt.ylabel('Number of Individuals')

    output_path = os.path.join(output_dir, 'Fig_5')
    plt.savefig(output_path)
    plt.show()
    plt.close()

plot_distance = False
if plot_distance == True:
    counts_distance = data.groupby('distance').size().rename('counts').reset_index()
    plt.plot(counts_distance['distance'], counts_distance['counts'])

    plt.title('Figure 6: General Distance of Move', y=1.05)
    plt.xlabel('Distance')
    plt.ylabel('Number of Individuals')

    output_path = os.path.join(output_dir, 'Fig_6')
    plt.savefig(output_path)
    plt.show()
    plt.close()

plot_major_mobility = True
if plot_major_mobility == True:
    # major = 0
    counts_major0 = data[data['major']==0].groupby('distance').size().rename('counts').reset_index()
    plt.plot(counts_major0['distance'], counts_major0['counts'], label='Natural Sciences')
    # major = 1
    counts_major1 = data[data['major']==1].groupby('distance').size().rename('counts').reset_index()
    plt.plot(counts_major1['distance'], counts_major1['counts'], label='Social Sciences')
    # major = 2
    counts_major2 = data[data['major']==2].groupby('distance').size().rename('counts').reset_index()
    plt.plot(counts_major2['distance'], counts_major2['counts'], label='Others')

    plt.title('Figure 6: Mobility by Major', y=1.05)
    plt.xlabel('Distance')
    plt.ylabel('Number of Individuals')
    plt.legend(loc='upper right')

    output_path = os.path.join(output_dir, 'Fig_6')
    plt.savefig(output_path)
    plt.show()
    plt.close()