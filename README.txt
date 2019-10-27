-------------------------------------------------------------------------------------
             SHCGM - Stochastic Homotopy Conditional Gradient Method
-------------------------------------------------------------------------------------

We used this version of the code to produce our numerical results in [LYFC2019].

Please check <https://github.com/alpyurtsever/SHCGM> for any future updates. 

Please contact "alp.yurtsever@epfl.ch" or "francesco.locatello@inf.ethz.ch" for your 
questions, requests, and feedbacks.

-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

INSTRUCTIONS

=== k-means Clustering SDP ==========================================================

Files are in "Clustering" folder.

1) Run "DownloadData" to download the implementation of k-means SDP [MVW2017] from 
Soledad Villar's github page <https://github.com/solevillar/kmeans_sdp/>. 
Please read the README files in the downloaded content. You are downloading this 
content on your will, and we do not accept responsibility for the use of this 
content. 

2) Run "TestHCGM" and "TestSHCGM". These scripts will run the test with the two 
optimization algorithms, homotopy conditional gradient method (HCGM) [YFLC2018] and 
the stochastic version SHCGM [LYFC2019], and save the results.

3) Run "PlotFig1" to generate Figure 1 in [LYFC2019].

=== Online Covariance Matrix Estimation =============================================

1) Run "TestCME". This script will run 6 tests with various methods and settings, 
and save the results.

2) Run "PlotFig2" and "PlotFig3" to generate Figures 2 and 3 in [LYFC2019].

=== Stochastic Matrix Completion ====================================================

1) Run "DownloadData". This will download the MovieLens 100k and 1m datasets [HK2016] 
and unzip them. Please read the README files in the downloaded content. You are 
downloading this content on your will, and we do not accept responsibility 
for the use of this content. 

2) Run "TestMovieLens100k". This will run the tests with SHCGM and Stochastic 
Frank-Wolfe method (SFW1) [MHK2018] with 100k dataset and save the results. 

3) Run "TestMovieLens1m". This will run the tests with SHCGM and Stochastic Three 
Composite Convex Minimization Method (S3CCM) [YVC2016] with 1m dataset and save the 
results.

4) Run "PlotFig4" and "PlotFig5" to generate Figures 4 and 5 in [LYFC2019].

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

References

* [LYFC2019] F. Locatello, A. Yurtsever, O. Fercoq, V. Cevher,
"Stochastic Conditional Gradient Method for Composite Convex Minimization"
Advances in Neural Information Processing Systems 32 (NeurIPS 2019).

[MVW2017] D.G. Mixon, S. Villar, R. Ward, 
"Clustering Subgaussian Mixtures by Semidefinite Programming" 
Information and Inference: A Journal of the IMA, 6(4):389–415, 2017.

[YFLC2018] A. Yurtsever, O. Fercoq, F. Locatello, and V. Cevher,
"A Conditional Gradient Framework for Composite Convex Minimization with Applications 
to Semidefinite Programming" 
In Proc. 35th International Conference on Machine Learning, (ICML 2018).

[HK2016] F.M. Harper, J.A. Konstan, 
"The MovieLens Datasets: History and Context" 
ACM Transactions on Interactive Intelligent Systems, 2016.

[MHK2018] A. Mokhtari, H. Hassani, and A. Karbasi, 
"Stochastic Conditional Gradient Methods: From Convex Minimization to Submodular Maximization" 
arXiv:1804.09554, 2018.

[YVC2016] A. Yurtsever, B.C. Vu, V. Cevher, 
"Stochastic Three-Composite Convex Minimization" 
Advances in Neural Information Processing Systems 29, (NeurIPS 2016).

-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

COPYRIGHT

Copyright (C) 2019 Laboratory for Information and Inference Systems (LIONS)
		   Ecole Polytechnique Federale de Lausanne, Switzerland.

This package (SHCGM) implements the numerical experiments for the Stochastic Homotopy
Conditional Gradient Method proposed in [LYFC2019]. 

SHCGM is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, version 3 of the License.

SHCGM is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

CITATION

If you find this toolbox useful in your research, please cite our work:

[LYFC2019] F. Locatello, A. Yurtsever, O. Fercoq, V. Cevher,
"Stochastic Conditional Gradient Method for Composite Convex Minimization"
Advances in Neural Information Processing Systems 32 (NeurIPS 2019).

-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

Last edit: Alp Yurtsever - October 26, 2019