# Interference-Coordination-in-Full-Duplex-HetNet-with-Large-Scale-Antenna-Arrays
Paper about Small Cell, Massive MIMO and Full-duplex

## Introduction

这篇论文研究的是结合了Small Cell, Massive MIMO和Full-duplex这三种5G关键技术的二层异构网络场景，为了消除干扰使得网络总吞吐量达到最大，提出了三种算法。
- 遗传算法
- 贪心算法
- 基于代价的分布式染色算法

前两种均是中心化算法，第三种分布式算法是本文的核心内容。

## Matlab Code

- channel.m : 建立瑞利衰落信道
- scene.m : 建立异构网络场景，基站和用户分布
- parameter.m : 优化问题的关键参数
- dl_capacity.m : 计算网络总吞吐量的函数
- normal.m : 矩阵归一化函数
- Genetic_Algorithm: 遗传算法模块
- Greedy.m : 贪心算法模块
- GCA.m : 分布式染色算法模块
- main_N.m : 研究不同天线数下的算法性能脚本
- main_S.m : 研究不同小区数下的算法性能脚本
- GradientDescent.m : 梯度下降法求解模块（额外部分，未在论文中提及）
- Bicoloring.m, DFS.m: 一种利用二分图的中心化算法（效果与DGCA类似，未提及）
- GcaPlot.m : 研究DGCA的参数性能
- TimePlot.m : 研究各算法的时间复杂度
