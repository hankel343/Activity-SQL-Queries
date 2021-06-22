CREATE TABLE Student (
	snum INTEGER PRIMARY KEY,
	sname VARCHAR(20),
	major VARCHAR(20),
	standing VARCHAR(20),
	age INTEGER
);

CREATE TABLE Faculty (
	fid INTEGER PRIMARY KEY,
	fname VARCHAR(20),
	deptid INTEGER,
);

CREATE TABLE Class (
	cname VARCHAR(20) PRIMARY KEY,
	meets_at VARCHAR(20),
	room VARCHAR(20) NOT NULL, --(b)
	fid INTEGER,
);

CREATE TABLE Enrolled (
	snum INTEGER,
	cname VARCHAR(20),
	PRIMARY KEY(snum,cname),
	FOREIGN KEY(snum) REFERENCES Student,
	FOREIGN KEY (cname) REFERENCES Class,
);