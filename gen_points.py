#!/bin/python

# Python

# Numpy
import numpy as np

# Matplotlib
import matplotlib.pyplot as plt


if __name__ == "__main__":

	print ("Generate two sets of 2D points")
	
	mean_1 = (13.4, 5.4)
	cov_1 = [[2.4, 1.56],[-0.87, 0.61]]

	mean_2 = (8.4, -2.4)
	cov_2 = [[12.4, 5.34],[-2.17, 5.1]]
	
	first_set = np.random.multivariate_normal(mean_1, cov_1, 100)
	second_set = np.random.multivariate_normal(mean_2, cov_2, 100)
	
	#print first_set.shape
	plt.scatter(first_set[:,0], first_set[:,1], c='red')
	plt.scatter(second_set[:,0], second_set[:,1], c='blue')
	plt.show()
	
