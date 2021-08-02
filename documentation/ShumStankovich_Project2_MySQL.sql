-- STUDENT NAMES: Raymond Shum, Nicholas Stankovich
-- GROUP: Group 8
-- COURSE: CST 363
-- DUE DATE: February 2, 2021
-- INSTRUCTOR: Professor David Wisneski
-- TA: Brandon Lee
-- ASSIGNMENT: Project 2 / Module 4
-- ----------------------------------------------------

-- -------------------------------------
-- Section 1.0 - CREATE TABLE Statements
-- -------------------------------------

DROP DATABASE IF EXISTS `project1`;

CREATE DATABASE IF NOT EXISTS `project1`;

USE `project1`;

CREATE TABLE patient (
	patientid INT NOT NULL AUTO_INCREMENT,
    ssn CHAR(9) NOT NULL UNIQUE,
    firstname VARCHAR(45) NOT NULL,
    lastname VARCHAR(45) NOT NULL,
    dateofbirth DATE NOT NULL,
    street VARCHAR(45) NOT NULL,
    city VARCHAR(45) NOT NULL,
    state CHAR(2) NOT NULL,
    zipcode CHAR(5) NOT NULL,
    PRIMARY KEY (patientid)
);

CREATE TABLE doctor (
	doctorid INT NOT NULL AUTO_INCREMENT,
	ssn CHAR(9) NOT NULL UNIQUE,
	firstname VARCHAR(45) NOT NULL,
	lastname VARCHAR(45) NOT NULL,
	experienceathire INT NOT NULL,
    employmentstartdate DATE NOT NULL,
    specialty VARCHAR(45) NOT NULL,
	PRIMARY KEY (doctorid)
);
    
CREATE TABLE primaryphysician (
	doctorid INT,
	patientid INT NOT NULL UNIQUE,
	PRIMARY KEY (patientid),
	FOREIGN KEY (doctorid) REFERENCES doctor(doctorid)
		ON DELETE SET NULL
        ON UPDATE CASCADE,
	FOREIGN KEY (patientid) REFERENCES patient(patientid)
		ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE pharmaceutical (
	pharmaceuticalid INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(45) NOT NULL,
    phonenumber CHAR(10) NOT NULL,
    PRIMARY KEY (pharmaceuticalid)
);
    
CREATE TABLE drug (
	drugid INT NOT NULL AUTO_INCREMENT,
    pharmaceuticalid INT NOT NULL,
    tradename VARCHAR(45) NOT NULL,
    PRIMARY KEY (drugid),
    FOREIGN KEY (pharmaceuticalid) REFERENCES pharmaceutical(pharmaceuticalid)
		ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE productdetails (
	drugid INT NOT NULL,
    formula VARCHAR(45) NOT NULL,
    price DECIMAL(8,2) NOT NULL,
    PRIMARY KEY (drugid),
    FOREIGN KEY (drugid) REFERENCES drug(drugid)
		ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE prescription (
	prescriptionid INT NOT NULL AUTO_INCREMENT,
    doctorid INT,
    patientid INT,
    drugid INT,
    prescribeddate DATE NOT NULL,
    quantity INT NOT NULL,
    PRIMARY KEY (prescriptionid),
    FOREIGN KEY (doctorid) REFERENCES doctor(doctorid)
		ON UPDATE CASCADE
        ON DELETE SET NULL,
    FOREIGN KEY (patientid) REFERENCES patient(patientid)
		ON UPDATE CASCADE
        ON DELETE SET NULL,
    FOREIGN KEY (drugid) REFERENCES drug(drugid)
		ON UPDATE CASCADE
        ON DELETE SET NULL
);

CREATE TABLE pharmacy (
	pharmacyid INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(45) NOT NULL,
	address VARCHAR(150) NOT NULL,
    phonenumber CHAR(10) NOT NULL,
    PRIMARY KEY (pharmacyid)
);

CREATE TABLE sells (
	pharmacyid INT NOT NULL,
    drugid INT NOT NULL,
    pharmacyprice DECIMAL(8,2) NOT NULL,
    PRIMARY KEY (pharmacyid, drugid),
    FOREIGN KEY (pharmacyid) REFERENCES pharmacy(pharmacyid)
		ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (drugid) REFERENCES drug(drugid)
		ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE fills (
	prescriptionid INT NOT NULL,
    pharmacyid INT NOT NULL,
    datefilled DATE NOT NULL,
    PRIMARY KEY (prescriptionid, pharmacyid),
    FOREIGN KEY (prescriptionid) REFERENCES prescription(prescriptionid)
		ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (pharmacyid) REFERENCES pharmacy(pharmacyid)
		ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE supervisor (
	supervisorid INT NOT NULL AUTO_INCREMENT,
    pharmacyid INT,
    firstname VARCHAR(45) NOT NULL,
    lastname VARCHAR(45) NOT NULL,
    PRIMARY KEY (supervisorid),
    FOREIGN KEY (pharmacyid) REFERENCES pharmacy(pharmacyid)
		ON DELETE SET NULL
        ON UPDATE CASCADE
);

CREATE TABLE contract (
	contractid INT NOT NULL AUTO_INCREMENT,
    pharmacyid INT,
    pharmaceuticalid INT,
    supervisorid INT,
    startdate DATE NOT NULL,
    enddate DATE NOT NULL,
    contracttext VARCHAR(45) NOT NULL,
    PRIMARY KEY (contractid),
    FOREIGN KEY (pharmacyid) REFERENCES pharmacy(pharmacyid)
		ON DELETE SET NULL
        ON UPDATE CASCADE,
    FOREIGN KEY (pharmaceuticalid) REFERENCES pharmaceutical(pharmaceuticalid)
		ON DELETE SET NULL
        ON UPDATE CASCADE,
    FOREIGN KEY (supervisorid) REFERENCES supervisor(supervisorid)
		ON DELETE SET NULL
        ON UPDATE CASCADE
);

-- ------------------------------------------------
-- Section 2.0 - Sample Data INSERT INTO Statements
-- ------------------------------------------------

INSERT INTO patient(ssn,firstname,lastname,dateofbirth,street,city,state,zipcode) VALUES
('260804895','Charles','Harmon','1951-06-01','2926 Harvest Lane', 'Bakersfield', 'CA', '93301'),
('379368888','Joseph','Rowland','1959-01-12','1914 Tecumsah Lane', 'Wishon', 'CA', '93664'),
('416148746','George','Brock','1977-04-30','1038 Corpening Drive', 'Austin', 'TX', '73301'),
('467128831','Florence','Eaton','1956-05-27','4124 Chapel Street', 'Spring', 'TX', '77386'),
('520870156','Elizabeth','Frazier','1965-11-10','4990 Crowfield Road', 'Phoenix', 'AZ', '85034');

INSERT INTO doctor(ssn,firstname,lastname,specialty,experienceathire,employmentstartdate) VALUES
('585869491','William','Alvarado','Anesthesiology',1,'2001-01-01'),
('797837092','Edward','Holland','Dermatology',2,'2002-02-02'),
('870845006','Ruth','Morrison','Ophthalmology',3,'2002-03-03');

INSERT INTO primaryphysician(patientid,doctorid) VALUES
(1,1),
(2,1),
(3,2),
(4,2),
(5,3);

INSERT INTO pharmaceutical(name,phonenumber) VALUES
('Pharmalyticals','4468005777'),
('Medway','5166697913'),
('Biolisted','7127002730');

INSERT INTO drug (pharmaceuticalid, tradename) VALUES
(1, 'Benzolevorin'),
(1, 'Romorphiphinol'),
(1, 'Obencetafen'),
(1, 'Paradacetaphinol'),
(2, 'Teproxodra'),
(3, 'Dydraproxazine'),
(3, 'Ephine'),
(3, 'Stecide'),
(3, 'Amphechlorolix'),
(3, 'Methaform');

INSERT INTO prescription (doctorid,patientid,drugid,prescribeddate,quantity) VALUES
(1,1,1,'2001-01-11',1),
(2,2,2,'2002-02-22',2),
(3,3,1,'2003-03-11',3),
(1,4,2,'2001-01-11',4),
(2,5,3,'2002-02-22',5),
(3,1,4,'2004-01-01',6),
(1,2,5,'2005-01-01',7),
(2,3,5,'2005-02-02',8),
(3,4,6,'2005-03-03',9);

INSERT INTO pharmacy(name,address,phonenumber) VALUES
('Lovelace Sandia Pharmacy','1953 Hamill Avenue, San Diego, CA 92105','1723146927'),
('Bayview Pharmacy Inc','4704 Hillhaven Drive, Irvine, CA 92614','2046217083'),
('Waukesha Pharmacy','2709 Colonial Drive, College Station, TX 77840','5509490877'),
('Haisten Rexall Drugs','2757 Emma Street, Happy Union,TX 79408','6158138761'),
('Allcare Pharmacy','4419 Elmwood Avenue, Mesa, AZ 85201','8257168692');

INSERT INTO fills(prescriptionid,pharmacyid,datefilled) VALUES
(1,1, '2001-01-01'),
(2,2, '2002-02-02'),
(3,3, '2003-03-03'),
(4,4, '2004-04-04'),
(5,5, '2005-05-05'),
(6,1, '2006-06-06'),
(7,2, '2007-07-07'),
(8,3, '2008-08-08');

INSERT INTO sells(pharmacyid,drugid,pharmacyprice) VALUES
(1,1,1100),
(1,2,2100),
(1,5,5100),
(1,10,10100),
(2,1,1200),
(2,3,3200),
(3,1,3100),
(3,5,5300),
(3,6,6300),
(3,7,7300),
(3,8,8300),
(4,1,1400),
(4,9,9400),
(4,10,10400),
(5,1,1500),
(5,2,2500),
(5,5,5500),
(5,6,6500),
(5,8,8500),
(5,9,9500),
(5,10,10500);

INSERT INTO productdetails(drugid,formula,price) VALUES
(1,'CH7N4O8P',10),
(2,'C5H4N3O8',20),
(3,'C11H8O2P2',30),
(4,'C12H2N4S',40),
(5,'HN11O3P',50),
(6,'NH4OH',60),
(7,'CHCl3',70),
(8,'C6H8O7',80),
(9,'CoSO4',90),
(10,'Cu2Cl2',100);

INSERT INTO supervisor(pharmacyid,firstname,lastname) VALUES
(1,'ph1_s1_fname','ph1_s1_lname'),
(1,'ph1_s2_fname','ph1_s2_lname'),
(1,'ph1_s3_fname','ph1_s3_lname'),
(2,'ph2_s1_fname','ph2_s1_lname'),
(2,'ph2_s2_fname','ph2_s2_lname'),
(3,'ph3_s1_fname','ph3_s1_lname'),
(4,'ph4_s1_fname','ph4_s1_lname'),
(4,'ph4_s2_fname','ph4_s2_lname'),
(5,'ph5_s1_fname','ph5_s1_lname'),
(5,'ph5_s2_fname','ph5_s2_lname'),
(5,'ph5_s3_fname','ph5_s3_lname'),
(5,'ph5_s4_fname','ph5_s4_lname');

INSERT INTO contract(pharmacyid, pharmaceuticalid,supervisorid,startdate,enddate,contracttext) VALUES
(1,1,1,'2001-01-01','2021-01-01','ct1'),
(1,1,2,'2001-02-02','2021-02-02','ct2'),
(1,2,3,'2001-03-03','2021-03-03','ct3'),
(2,1,4,'2001-04-04','2021-04-04','ct4'),
(2,2,5,'2001-05-05','2021-05-05','ct5'),
(3,3,6,'2001-06-06','2021-06-06','ct6'),
(3,3,6,'2001-07-07','2021-07-07','ct7'),
(4,2,7,'2001-08-08','2021-08-08','ct8'),
(5,2,9,'2001-09-09','2021-09-09','ct9'),
(5,2,9,'2001-10-10','2021-10-10','ct10'),
(5,2,10,'2001-11-11','2021-11-11','ct11'),
(5,3,11,'2001-12-12','2021-12-12','ct12'),
(5,3,12,'2002-01-01','2022-01-01','ct13');

-- ---------------------------------------
-- Section 3.0 - Sample Business Questions
-- ---------------------------------------

-- Which pharmaceutical company does each doctor prescribe from the most? (This could give insight into which drug reps are visiting which doctors.)
SELECT DoctorID, FirstName, LastName, Name as TopPharm, MAX(count) as NumScripts
FROM (SELECT d.DoctorID, d.FirstName, d.LastName, c.PharmaceuticalID, c.Name, COUNT(*) as count
      FROM doctor d, prescription p, drug g, pharmaceutical c
      WHERE d.doctorid=p.doctorid AND p.drugid=g.drugid AND g.pharmaceuticalid=c.pharmaceuticalid
      GROUP BY DoctorID, PharmaceuticalID) AS t
GROUP BY DoctorID;

-- What is the total revenue from drug sales for each pharmacy?
SELECT name, SUM(pr.quantity*s.pharmacyprice) as TotalSales
FROM pharmacy ph
INNER JOIN fills f ON f.pharmacyid = ph.pharmacyid
INNER JOIN sells s ON ph.pharmacyid = s.pharmacyid
INNER JOIN prescription pr ON pr.prescriptionid = f.prescriptionid
GROUP BY ph.name;          

-- Which prescriptions have been submitted but not yet filled?
SELECT p.PatientID, p.FirstName, p.LastName, n.PrescriptionID, n.DrugID, d.TradeName, n.PrescribedDate
FROM patient p INNER JOIN prescription n ON p.patientid=n.patientid
INNER JOIN drug d ON n.drugid=d.drugid
LEFT JOIN fills f ON n.prescriptionid=f.prescriptionid
WHERE f.datefilled IS NULL;

-- Which pharmacies and pharmaceutical companies have less than two months left on their contracts?
SELECT p.PharmacyID, p.name AS Pharmacy, l.name AS Pharmaceutical, c.ContractID, DATEDIFF(c.enddate, CURDATE()) AS DaysLeft
FROM pharmacy p INNER JOIN contract c ON p.pharmacyid=c.pharmacyid
INNER JOIN pharmaceutical l ON c.pharmaceuticalid=l.pharmaceuticalid
WHERE DATEDIFF(c.enddate, CURDATE()) <= 60;

-- Which pharmeceutical companies do not currently have active contracts with each pharmacy?
SELECT p.PharmacyID, p.Name AS Pharmacy, l.PharmaceuticalID, l.Name AS Pharmaceutical
FROM pharmacy p CROSS JOIN pharmaceutical l
LEFT JOIN contract c ON c.pharmacyid=p.pharmacyid AND c.pharmaceuticalid=l.pharmaceuticalid
WHERE c.contractid IS NULL OR DATEDIFF(c.enddate, CURDATE()) <= 0;