--2019/11/14
SELECT a.idalarm,a.iddevice,a.idvariable,a.priority,v.description FROM lgalarmactive a
INNER JOIN lgvariable v
on a.idvariable = v.idvariable
--where v.description like '%LCA%'
where a.priority='0'

SELECT * FROM lgalarmrecall limit 100

SELECT * FROM cfsupervisors where description like '%领顺%'




SELECT v.kidsupervisor AS idsupervisor, v.iddevice, v.idvariable, v.description
        FROM PUBLIC.lgvariable v
        where
        	v.kidsupervisor = 126
			AND v.iddevice = -1
        	AND v.idvariable > 0
			AND v.iddevice != -1
			
SELECT a.* FROM lgalarmactive a where kidsupervisor=126
SELECT a.* FROM lgalarmactive a where kidsupervisor=56
select d.description, d.kidsupervisor, d.iddevice, d.globalindex from lgdevice d where d.kidsupervisor=126
SELECT * FROM lgvariable

SELECT d.description, d.kidsupervisor, d.iddevice, d.globalindex,a.idalarm,a.idvariable, a.priority,count(a.idalarm) as num
		FROM PUBLIC.lgdevice d
		--LEFT JOIN PUBLIC.lgvariable v ON v.iddevice = d.iddevice
		LEFT JOIN PUBLIC.lgalarmactive a ON a.iddevice = d.iddevice AND a.kidsupervisor = d.kidsupervisor
		where
			d.kidsupervisor = 56 order by num
			
select * from lgalarmrecall where kidsupervisor = 126


SELECT s.id,s.description,s.uuid,a.priority,a.idvariable, d.globalindex, a.idalarm
		FROM PUBLIC.cfsupervisors s
		LEFT JOIN PUBLIC.lgdevice d ON d.kidsupervisor = s.id
		LEFT JOIN PUBLIC.lgalarmactive a ON a.iddevice = d.iddevice AND a.kidsupervisor = d.kidsupervisor
		
		
		
SELECT a.*, v.description FROM 
		PUBLIC.lgalarmactive a
		INNER JOIN PUBLIC.lgvariable v
		ON a.kidsupervisor = v.kidsupervisor AND a.iddevice = v.iddevice 
		--AND a.idvariable = v.idvariable
		where
			a.kidsupervisor = 56
			AND a.iddevice = 486
select * from lgvariable


-- 2019/11/15
SELECT * FROM PUBLIC.aruser limit 100

--2019/11/18
SELECT * FROM cfsupervisors 

update cfsupervisors set description = 'Milan' where description like '%Manuel%'

--2019/11/20
SELECT * FROM public.cfvalmdl limit 100

select * from cfsupervisors where id =140

SELECT * from lgdevice where kidsupervisor =140 and iddevice = 53

--2019/11/21
SELECT * 
		FROM PUBLIC.cfvarmdl v
		INNER JOIN PUBLIC.cfdevmdl c ON c.id = v.iddevmdl
		INNER JOIN PUBLIC.lgdevice d ON d.devmodcode = c.code
		where
		v.frequency > 0

select * from 
(select u.*, s.kidsupervisor, l.account as remoteproAccount from cfremoteusers u inner join cfremoteusersupervisor s on u.id = s.kidremoteuser inner join cfremoteuserlink l on u.id = l.kidremoteuser ) RemoteUserWithInfo  
where  (  ( remoteuserwithinfo.kidsupervisor = 140 )  and  ( remoteuserwithinfo.remoteproAccount = 'admin' )  )  

--2019/11/28
SELECT *, d.iddevice, d.address as deviceAddress,d.code as deviceCode
			,CASE WHEN v.readwrite='1' OR v.readwrite='7' OR v.readwrite='11' OR v.readwrite='3' 
				THEN true
				ELSE false
       			END AS isWritable,
       		CASE WHEN v.readwrite='2' OR v.readwrite='7' OR v.readwrite='11' OR v.readwrite='3' 
       			THEN true
            	ELSE false
       			END AS isReadable
		FROM PUBLIC.cfvarmdl v
		INNER JOIN PUBLIC.cfdevmdl c ON c.id = v.iddevmdl
		INNER JOIN PUBLIC.lgdevice d ON d.devmodcode = c.code
		where
			-- d.kidsupervisor = #{kidsupervisor}
			-- AND d.iddevice = #{iddevice}
			-- AND 
			v.frequency > 0
		-- 	<if test="code != null">
		-- 		AND v.code = #{code}
		-- 	</if>
		-- </where>	


select * from cfvalmdl


--2019/11/29
select * from lgalarmactive where kidsupervisor=13 and idalarm=311

--2020/1/10
SELECT * FROM (
			SELECT * 
		FROM ( 
		SELECT 
			sup.id AS id,
			alrsAllByPrio.numAllAlarm AS nalarms, 
			sup.description AS description, 
			are.description AS areadescription, 
			cli.description AS clientdescription, 
			sit.description AS sitedescription, 
			sit.latitude AS latitude, 
			sit.longitude AS longitude, 
			sup.ktype AS typecode, 
			alrsAllByPrio.numAllAlarm, 
			alrsAllByPrio.numAllPriority1, 
			alrsAllByPrio.numAllPriority2, 
			alrsAllByPrio.numAllPriority3, 
			alrsAllByPrio.numAllPriority4,
		FROM PUBLIC.cfsupervisors sup 
		INNER JOIN PUBLIC.cftypesupervisors typsup ON sup.ktype = typsup.code 
		INNER JOIN PUBLIC.cfcompany sit ON sup.ksite = sit.code 
		INNER JOIN PUBLIC.cfarea are ON sit.karea=are.code 
		INNER JOIN PUBLIC.cfcompany cli ON sit.kclient = cli.code 
		LEFT JOIN PUBLIC.lgsupervstatus svs ON sup.id = svs.kidsupervisor
		LEFT JOIN ( SELECT DISTINCT lgalarmactive.kidsupervisor, 
	   				SUM(CASE WHEN TO_NUMBER(priority,'999999') = 1 THEN 1 ELSE 0 END) AS numAllPriority1, 
	   				SUM(CASE WHEN TO_NUMBER(priority,'999999') = 2 THEN 1 ELSE 0 END) AS numAllPriority2, 
	   				SUM(CASE WHEN TO_NUMBER(priority,'999999') = 3 THEN 1 ELSE 0 END) AS numAllPriority3, 
	   				SUM(CASE WHEN TO_NUMBER(priority,'999999') >=4 THEN 1 ELSE 0 END) AS numAllPriority4, 
	   				SUM(1) AS numAllAlarm 
					FROM PUBLIC.lgalarmactive 
					INNER JOIN PUBLIC.lgdevice ON lgalarmactive.kidsupervisor = lgdevice.kidsupervisor AND lgalarmactive.iddevice = lgdevice.iddevice 
					WHERE endtime IS null 
	  				GROUP BY lgalarmactive.kidsupervisor 
	  		) AS alrsAllByPrio ON alrsAllByPrio.kidsupervisor =  sup.id 
	) cfsupervisors 
		WHERE  (cfsupervisors.id > 0)
		ORDER BY cfsupervisors.description ASC nulls first)map
		INNER JOIN PUBLIC.cfsupervisors s ON map.id = s.id
	    INNER JOIN PUBLIC.cfcompany m ON s.ksite = m.code
	    INNER JOIN PUBLIC.cfusercompany c ON c.kcompany = m.kclient
	    INNER JOIN PUBLIC.aruser u ON u.account = c.kaccount
	    WHERE u.username = #{username}


SELECT lgalarmactive.kidsupervisor, 
	   				SUM(CASE WHEN TO_NUMBER(priority,'999999') = 1 THEN 1 ELSE 0 END) AS numAllPriority1, 
	   				SUM(CASE WHEN TO_NUMBER(priority,'999999') = 2 THEN 1 ELSE 0 END) AS numAllPriority2, 
	   				SUM(CASE WHEN TO_NUMBER(priority,'999999') = 3 THEN 1 ELSE 0 END) AS numAllPriority3, 
	   				SUM(CASE WHEN TO_NUMBER(priority,'999999') >=4 THEN 1 ELSE 0 END) AS numAllPriority4
					FROM PUBLIC.lgalarmactive 
					INNER JOIN PUBLIC.lgdevice ON lgalarmactive.kidsupervisor = lgdevice.kidsupervisor AND lgalarmactive.iddevice = lgdevice.iddevice 
					WHERE endtime IS null 
	  				GROUP BY lgalarmactive.kidsupervisor
					
select * from cfcompany

SELECT * FROM PUBLIC.cfcompany m
LEFT JOIN (
	SELECT lgalarmactive.kidsupervisor, 
	   	SUM(CASE WHEN TO_NUMBER(priority,'999999') = 1 THEN 1 ELSE 0 END) AS numAllPriority1, 
	   	SUM(CASE WHEN TO_NUMBER(priority,'999999') = 2 THEN 1 ELSE 0 END) AS numAllPriority2, 
	   	SUM(CASE WHEN TO_NUMBER(priority,'999999') = 3 THEN 1 ELSE 0 END) AS numAllPriority3, 
	   	SUM(CASE WHEN TO_NUMBER(priority,'999999') >=4 THEN 1 ELSE 0 END) AS numAllPriority4
		FROM PUBLIC.lgalarmactive 
		INNER JOIN PUBLIC.lgdevice ON lgalarmactive.kidsupervisor = lgdevice.kidsupervisor AND lgalarmactive.iddevice = lgdevice.iddevice 
		WHERE endtime IS null 
	  	GROUP BY lgalarmactive.kidsupervisor
)AS s ON m.code = s.ksite


SELECT cfcompany.code,cfcompany.description,
SUM(s.numAllPriority1) AS numAllPriority1,
SUM(s.numAllPriority2) AS numAllPriority2,
SUM(s.numAllPriority3) AS numAllPriority3,
SUM(s.numAllPriority4) AS numAllPriority4
FROM PUBLIC.cfcompany
LEFT JOIN (
	SELECT lgalarmactive.kidsupervisor, cfsupervisors.ksite,
	   	SUM(CASE WHEN TO_NUMBER(priority,'999999') = 1 THEN 1 ELSE 0 END) AS numAllPriority1, 
	   	SUM(CASE WHEN TO_NUMBER(priority,'999999') = 2 THEN 1 ELSE 0 END) AS numAllPriority2, 
	   	SUM(CASE WHEN TO_NUMBER(priority,'999999') = 3 THEN 1 ELSE 0 END) AS numAllPriority3, 
	   	SUM(CASE WHEN TO_NUMBER(priority,'999999') >=4 THEN 1 ELSE 0 END) AS numAllPriority4
		FROM PUBLIC.lgalarmactive 
		INNER JOIN PUBLIC.lgdevice ON lgalarmactive.kidsupervisor = lgdevice.kidsupervisor AND lgalarmactive.iddevice = lgdevice.iddevice 
		INNER JOIN PUBLIC.cfsupervisors ON cfsupervisors.id = lgdevice.kidsupervisor
		WHERE endtime IS null 
	  	GROUP BY lgalarmactive.kidsupervisor,cfsupervisors.ksite
)AS s ON cfcompany.code = s.ksite


SELECT cfcompany.code,cfcompany.description,
SUM(s.countPriority1) AS countPriority1,
SUM(s.countPriority2) AS countPriority2,
SUM(s.countPriority3) AS countPriority3,
SUM(s.countPriority4) AS countPriority4
FROM PUBLIC.cfcompany
LEFT JOIN (
	SELECT lgalarmactive.kidsupervisor, cfsupervisors.ksite,
	   	SUM(CASE WHEN TO_NUMBER(priority,'999999') = 1 THEN 1 ELSE 0 END) AS countPriority1, 
	   	SUM(CASE WHEN TO_NUMBER(priority,'999999') = 2 THEN 1 ELSE 0 END) AS countPriority2, 
	   	SUM(CASE WHEN TO_NUMBER(priority,'999999') = 3 THEN 1 ELSE 0 END) AS countPriority3, 
	   	SUM(CASE WHEN TO_NUMBER(priority,'999999') >=4 THEN 1 ELSE 0 END) AS countPriority4
		FROM PUBLIC.lgalarmactive 
		INNER JOIN PUBLIC.lgdevice ON lgalarmactive.kidsupervisor = lgdevice.kidsupervisor AND lgalarmactive.iddevice = lgdevice.iddevice 
		INNER JOIN PUBLIC.cfsupervisors ON cfsupervisors.id = lgdevice.kidsupervisor
		WHERE endtime IS null 
	  	GROUP BY lgalarmactive.kidsupervisor,cfsupervisors.ksite
)AS s ON cfcompany.code = s.ksite
GROUP BY cfcompany.code,cfcompany.description
