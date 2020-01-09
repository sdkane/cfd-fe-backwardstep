This was the final project for ME614 - Computational Fluid Dynamics Spring 2014 and was programmed in just under three weeks as the professor did not hand the assignment out until the final three weeks of class. Because of this the driving motivation behind the code was to get each individual part working and producing correct output without worrying about any sort of coding formatting.<br>

The code was developed completely from scratch with reference to the class textbook for appropriate equations. <br>
The program entry point is in GlobalSolver.m

The results obtained from this program are in no way guaranteed correct and should be treated as such.

This collection of Matlab scripts is designed to solve a single fluid dynamics finite element problem, a backward step.
As a bonus to the original problem, I designed the program to be able to solve a user sized mesh and adjustable step size.

This is a naive approach and can be improved in many respects.<br>
Program runtime on an Intel Core i7 4800MQ 2.7GHz processor was in excess of three hours for a small mesh size.<br>

The output is saved to a csv which can then be fed into the plot script collection which produces output as seen below.

![p&v_contours](https://raw.githubusercontent.com/sdkane/cfd_fe_backwardstep/master/plots/Pressure%20and%20Velocity%20Contours%20Re150%20for%2060sec.png)
![streamlines](https://raw.githubusercontent.com/sdkane/cfd_fe_backwardstep/master/plots/Streamlines%20Re150%20for%2060sec.png)
