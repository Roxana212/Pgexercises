--You'd like to get the first and last name of the last member(s) who signed up.
SELECT 
firstname, 
surname, 
joindate
FROM cd.members
	WHERE joindate = 
		(SELECT MAX(joindate) 
			FROM cd.members)

--How can you produce a list of the start times for bookings for tennis courts, for the date '2012-09-21'? 
Return a list of start time and facility name pairings, ordered by the time.
SELECT 
b.starttime, 
f.name
FROM cd.bookings AS b
JOIN cd.facilities AS f
	ON b.facid=f.facid
WHERE b.starttime >='2012-09-21' AND b.starttime<'2012-09-22'
	AND f.name LIKE 'Tennis%'
ORDER BY b.starttime

--Produce a list of all members who have used a tennis court
SELECT DISTINCT
CONCAT (m.firstname,' ', m.surname) AS name, 
f.name AS facility
FROM cd.members AS m
	JOIN cd.bookings AS b
	ON m.memid=b.memid
	JOIN cd.facilities AS f
	ON b.facid=f.facid
WHERE f.name IN ('Tennis Court 1', 'Tennis Court 2')
ORDER BY name, facility

--How can you produce a list of bookings on the day of 2012-09-14 which will cost the member (or guest) more than $30? 
Include in your output the name of the facility, the name of the member formatted as a single column, and the cost. 
Order by descending cost, and do not use any subqueries.
SELECT
CONCAT (m.firstname, ' ', m.surname) AS member, 
f.name AS facility,
CASE
	WHEN m.memid=0 THEN b.slots*f.guestcost
	ELSE b.slots*f.membercost
END AS cost
FROM cd.members AS m
	JOIN cd.bookings AS b
	ON m.memid=b.memid
	JOIN cd.facilities AS f
	ON b.facid=f.facid
WHERE b.starttime >= '2012-09-14' AND b.starttime<'2012-09-15'
		AND (
		  (m.memid!=0 AND b.slots*f.membercost>30) OR (m.memid=0 AND b.slots*f.guestcost>30)
		   )
ORDER BY cost DESC;

--Try to simplify the query above using subqueries
SELECT member, facility, cost FROM
	(SELECT
	CONCAT (m.firstname, ' ', m.surname) AS member, 
	f.name AS facility, 
	CASE 
		WHEN m.memid=0 THEN b.slots*f.guestcost
		ELSE b.slots*f.membercost 
	END AS cost
	FROM cd.members AS m
	JOIN cd.bookings AS b
	ON m.memid=b.memid
	JOIN cd.facilities AS f
	ON b.facid=f.facid
	WHERE b.starttime >= '2012-09-14' AND b.starttime<'2012-09-15') 
WHERE cost>30	
ORDER BY cost DESC;
