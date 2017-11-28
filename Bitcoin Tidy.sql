Create Databse Crypto;



Create Table Bitcoin (
			Time_stamp varchar(25),
             Open_price double,
             High_price double,
             Low_price double,
             Close_price  double,
             Volume_BTC double,
             Volume_currency double,
	     Weighted_price double,
	     B1.Height double,
	     B2.Height double,
	     B2.TimeStampUtc double,
             );
             
             

    
 /* LOADING CSV FILE INTO TABLE */   
            
LOAD DATA LOCAL INFILE 'C:/Program Files/MySQL/MySQL Server 5.7/Uploads/test.csv' 
INTO TABLE bitcoin
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

SELECT 
	B1.Height AS FromBlock, 
	B2.Height AS ToBlock, 
	B3.Height AS FromTime,
	B2.TimeStampUtc AS ToTime,
	IIF(B2.TimeStampUTC < B1.TimeStampUTC, '-', '') +  RIGHT('00' + CONVERT(varchar, (DATEDIFF(SECOND, B1.TimeStampUTC, B2.TimeStampUTC) / 86400)), 2) + ':' + CONVERT(varchar, DATEADD(ss, DATEDIFF(SECOND, IIF(B1.TimeStampUTC < B2.TimeStampUTC, B1.TimeStampUTC, B2.TimeStampUTC), IIF(B2.TimeStampUTC > B1.TimeStampUTC, B2.TimeStampUTC, B1.TimeStampUTC)), 0), 108) AS Duration_DDHHMMSS,
	DATEDIFF(SECOND, B1.TimeStampUTC, B2.TimeStampUTC) as DurationSeconds
FROM 
	Block B1 INNER JOIN
	Block B2 ON B1.Height = B2.Height - 1
WHERE
	B1.BranchID = 1 AND  -- Ignore orphaned blocks
	B2.BranchID = 1      -- Ignore orphaned blocks
ORDER BY
	DurationSeconds DESC  -- Change between 'ASC' to 'DESC' to order differently


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



