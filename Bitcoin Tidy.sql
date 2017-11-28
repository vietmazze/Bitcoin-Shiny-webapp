Create Table Bitcoin (
			Time_stamp varchar(25),
             Open_price double,
             High_price double,
             Low_price double,
             Close_price  double,
             Volume_BTC double,
             Volume_currency double,
			 Weighted_price double
             );
             
             

    
 /* LOADING CSV FILE INTO TABLE */   
            
LOAD DATA LOCAL INFILE 'C:/Program Files/MySQL/MySQL Server 5.7/Uploads/test.csv' 
INTO TABLE bitcoin
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;



#/ Fixing data and deleting NA data*/
Delete From bitcoin
where open_price=0; 

/* Convert Unix time to datatime */
update bitcoin
set Time_stamp=from_unixtime(time_stamp,'%Y-%m-%d-%HH-%mm-%ss');


/* Drop unnecessary columns*/ 

Alter table bitcoin
Drop Column High_price,
Drop Column Low_price;




/* Grouping Data by the year*/

Select * From bitcoin
Group by Time_stamp
Having Time_stamp LIKE '__15%';

/* Grouping data by distinct hour of every date*/
Select Distinct Time_stamp, Open_price
From bitcoin
Group by Time_stamp;



