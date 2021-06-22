--(a)
--Ensure class sizes students are greater than or equal to 5
ALTER TABLE Enrolled
ADD CONSTRAINT minimum_enrollment
CHECK	((SELECT COUNT(Enrolled.snum)
		 FROM Enrolled
		 GROUP BY Enrolled.cname) >= 5); --GROUP BY required for aggregate function COUNT

--Ensure class sizes are less than or equal to 30.
ALTER TABLE Enrolled
ADD CONSTRAINT maximum_enrollment
CHECK	((SELECT COUNT(Enrolled.snum)
		  FROM Enrolled
		  GROUP BY Enrolled.cname) <= 30);

--(b)
--Column is declared with constraint that the room field cannot be empty.

--(c)
ALTER TABLE Class
ADD CONSTRAINT atmost_two_classes
CHECK	((SELECT COUNT(C.fid)
		  FROM Class C, Faculty F
		  WHERE C.fid = F.fid --Reduce cross-product of tables to where fid of Faculty is the same listed in Classes
		  GROUP BY F.fid) <=2); --There must be atleast two distinct instances of the faculty id

--(d)
ALTER TABLE Class
ADD CONSTRAINT dept_33_limit
CHECK	((SELECT COUNT(C.fid)
		  FROM CLASS C, Faculty F
		  WHERE C.fid = F.fid and F.deptid = 33
		  GROUP BY F.fid) >= 2);

--(e)
ALTER TABLE Enrolled
ADD CONSTRAINT mandatory_class
CHECK	(SELECT COUNT(S.snum)
		 FROM Student S
		 WHERE S.snum <> (	SELECT E.snum
							FROM Enrolled E
							WHERE E.cname = 'Math101')) = 0); --Returns a table containing Student Ids that are enrolled in Math101

--(f)
ALTER TABLE Class
ADD CONSTRAINT earliest_latest_class
CHECK	((SELECT MAX(C.meets_at)
		 FROM Class C) <> (SELECT MIN(C.meets_at)
						 FROM Class C));

--(g)
SELECT C.room, C.meets_at
FROM Class C
WHERE (C.room <> C.meets_at);

--(h)
ALTER TABLE Faculty
ADD CONSTRAINT max_department
CHECK	(SELECT MAX(*) --Returns maximum value from nested query on next line
		 FROM (SELECT COUNT(*) --Select statement returns a table of size of each department
			   FROM Faculty F
			   GROUP BY F.deptid)) --Counts number of faculty with a given department id
			< 2* --Maximum value from above must be less than two times value queried below
			(SELECT MIN(*) --Returns minimum value from nested query on next line
			 FROM (SELECT COUNT(*) --Creates a table of department sizes
				   FROM FACULTY F
				   GROUP BY F.deptid));


--(i)
ALTER TABLE Faculty
ADD CONSTRAINT minimum_dept_size
CHECK	((Select MIN(*)
		 FROM Faculty F
		 GROUP BY F.deptid) >= 10); --Minimum value returned from query must be greater than or equal to 10

--(j) I used figure 5.20 (triggers) as a reference for this question
CREATE TRIGGER one_update AFTER INSERT ON Enrolled
DECLARE
	count INTEGER;
BEGIN
	count := 1; --Only one update allowed
END;

--(k)
ALTER TABLE Student
ADD CONSTRAINT moreCS_thanMath
CHECK	((SELECT COUNT(*)
		  FROM Student S
		  WHERE S.major = 'CS') > (SELECT COUNT(*)
								   FROM Student S
								   WHERE S.major = 'Math'));


--(l)
ALTER TABLE Enrolled
ADD CONSTRAINT
CHECK	((SELECT DISTINCT COUNT(*)
		 FROM Enrolled E, Student S
		 WHERE (S.snum = E.snum and S.major = 'CS')) > (SELECT DISTINCT COUNT(*)
														FROM Enrolled E, Student S
														WHERE (S.snum = E.snum and S.major = 'Math'));

--(m)
ALTER TABLE Enrolled
ADD CONSTRAINT 
CHECK ((SELECT COUNT(*)
		FROM Enrolled E, Student S, Faculty F
		WHERE (S.sname = E.snum and F.deptid = 33) > (SELECT COUNT(S.major)
													   FROM Student S
													   WHERE S.major = 'Math');

--(n)
ALTER TABLE Student
ADD CONSTRAINT atleast_one_CS
CHECK(	(SELECT COUNT(S.major) --Count of fields matching the string 'CS' must be greater than zero
		FROM Student S
		WHERE (S.major = 'CS')) > 0);

--(o)
ALTER TABLE Class
ADD CONSTRAINT cannot_share_room
CHECK(SELECT COUNT(*)
	  FROM Faculty F, Class C
	  WHERE (F.deptid != C.room));