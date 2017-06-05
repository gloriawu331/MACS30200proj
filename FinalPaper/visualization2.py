# Perspectives on Computational Research
# Final Project: Data Visualization

import os
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt


data = pd.read_csv('data2.csv')


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
    plt.title('Whether Individuals Moved Across Age', y=1.05)
    plt.xlabel('Age')
    plt.ylabel('Number of Individuals')

    output_path = os.path.join(output_dir, 'Fig_4')
    plt.savefig(output_path)
    plt.show()
    plt.close()
    

plot_age_major = True
if plot_age_move == True:
    counts_major0 = data[data['major_ctgy']==0].groupby('age').size().rename('counts').reset_index()
    counts_major1 = data[data['major_ctgy']==1].groupby('age').size().rename('counts').reset_index()
    counts_major2 = data[data['major_ctgy']==2].groupby('age').size().rename('counts').reset_index()
    plt.plot(counts_major0['age'], counts_major0['counts'], label='Fit Jobs Needs Social Sciences', color='red')
    plt.plot(counts_major1['age'], counts_major1['counts'], label='Fit Jobs Needs Technical Skills', color='blue')
    plt.plot(counts_major2['age'], counts_major2['counts'], label='Other Majors', color='black')

    plt.legend(loc='upper right')
    plt.title('Whether Individuals Moved by Majors', y=1.05)
    plt.xlabel('Major Categories')
    plt.ylabel('Number of Respondents')

    output_path = os.path.join(output_dir, 'Fig_4')
    plt.savefig(output_path)
    plt.show()
    plt.close()


plot_major_mobility = True
if plot_major_mobility == True:
    # major = 0
    counts_major0 = data[data['major_ctgy']==0].groupby('is_move').size().rename('counts').reset_index()
    plt.plot(counts_major0['is_move'], counts_major0['counts'], label='Majors Fit Jobs Require Social Sciences')
    # major = 1
    counts_major1 = data[data['major_ctgy']==1].groupby('is_move').size().rename('counts').reset_index()
    plt.plot(counts_major1['is_move'], counts_major1['counts'], label='Majors Fit Jobs Require Technical Skills')
    # major = 2
    counts_major2 = data[data['major_ctgy']==2].groupby('is_move').size().rename('counts').reset_index()
    plt.plot(counts_major2['is_move'], counts_major2['counts'], label='Other Majors')

    plt.title('Figure 6: Mobility by Major Type', y=1.05)
    plt.xlabel('Whether Moved')
    plt.ylabel('Number of Individuals')
    plt.legend(loc='upper right')

    output_path = os.path.join(output_dir, 'Fig_6')
    plt.savefig(output_path)
    plt.show()
    plt.close()


def find_counts(df):
    moved = []
    not_moved = []
    for i in range(20):
        temp_df = df[df['major']==i].groupby('is_move').size().rename('counts').reset_index()
        not_moved.append(int(temp_df.counts.iloc[1]))
        moved.append(int(temp_df.counts.iloc[0]))
    return moved, not_moved

moved, not_moved = find_counts(data)
x = np.array([i for i in range(1, 21)])
   
plot_major_mobility2 = True
if plot_major_mobility2 == True:
    plt.bar(x-0.15, moved, width=0.3, color='c', align='center', label='Moved')
    plt.bar(x+0.15, not_moved, width=0.3, color='pink', align='center', label='Not Moved')
    
    plt.legend(loc='upper right')
    plt.title('Mobility by College Majors')
    plt.xlabel('College Major Category')
    plt.ylabel('Number of Respondents')
    plt.xlim(0, 21)
    plt.xticks([x for x in range(1, 21)], ['Computer Sciences', 'Mathematics', 'Agricultural Sciences',
                'Biological Sciences', 'Physical Sciences', 'Psychology',
                'Social Sciences', 'Engineering', 'Health/medical Sciences',
                'Engineering-related Technologies', 'Agricultural Business & Production',
                'Business Management', 'Education', 'Philosophy/Religion/Theology',
                'Foreign Languages & Literature', 'Visual & Performing Arts',
                'Communications', 'Natural Resources & Conservation',
                'Public Affairs', 'Others'])
    locs, labels = plt.xticks()
    plt.setp(labels, rotation=90)