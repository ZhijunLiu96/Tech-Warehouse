id		dt				lowcarbon
1001	2021-12-12		123
1002	2021-12-12		45
1001	2021-12-13		43
1001	2021-12-13		45
1001	2021-12-13		23
1002	2021-12-14		45
1001	2021-12-14		230
1002	2021-12-15		45
1001	2021-12-15		23
找出连续3天及以上减少碳排放量在100以上的用户

1)按照用户ID及时间字段分组,计算每个用户单日减少的碳排放量
select
    id,
    dt,
    sum(lowcarbon) lowcarbon
from test1
group by id,dt
having lowcarbon>100;t1
1001	2021-12-12		123
1001	2021-12-13		111
1001	2021-12-14		230

等差数列法:两个等差数列如果等差相同,则相同位置的数据相减等到的结果相同
2)按照用户分组,同时按照时间排序,计算每条数据的Rank值
select
    id,
    dt,
    lowcarbon,
    rank() over(partition by id order by dt) rk
from t1;t2

3)将每行数据中的日期减去Rank值
select
    id,
    dt,
    lowcarbon,
    date_sub(dt,rk) flag
from t2;t3

4)按照用户及Flag分组,求每个组有多少条数据,并找出大于等于3条的数据
select
    id,
    flag,
    count(*) ct
from t3
group by id,flag
having ct>=3;

5)最终HQL
select
    id,
    flag,
    count(*) ct
from 
(select
    id,
    dt,
    lowcarbon,
    date_sub(dt,rk) flag
from 
(select
    id,
    dt,
    lowcarbon,
    rank() over(partition by id order by dt) rk
from 
(select
    id,
    dt,
    sum(lowcarbon) lowcarbon
from test1
group by id,dt
having lowcarbon>100)t1)t2)t3
group by id,flag
having ct>=3;