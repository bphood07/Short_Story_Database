--Short Story Index - Group Project
DROP TABLE Anthology;
DROP TABLE Collection;
DROP TABLE Book;
DROP TABLE Website;
DROP TABLE Magazine;
DROP TABLE Recommendation;
DROP TABLE Published_In;
DROP TABLE Edited_By;
DROP TABLE Represented_By;
DROP TABLE Story_Theme;
DROP TABLE Story;
DROP TABLE Author;
DROP TABLE Editor;
DROP TABLE Agents;
DROP TABLE Publication;
DROP TABLE Publisher;
DROP TABLE Person;
DROP TABLE Genre;
DROP TABLE Theme;

--Create Commands
CREATE TABLE Person 
(
    Person_ID           INTEGER         PRIMARY KEY,

    Last_Name    VARCHAR2(30),
    
    First_Name   VARCHAR2(30),

    Person_Phone        NUMBER(10,0),
    
    Address_Street      VARCHAR(30),
    
    Address_City        VARCHAR(30),
    
    Address_State       VARCHAR(30),
    
    Address_Zip         INTEGER,
    
    Date_Deceased       DATE,
    
    Person_Type         VARCHAR(3)
);

CREATE TABLE Publisher 
(
    Publisher_ID        INTEGER             PRIMARY KEY, 

    Publisher_Name      VARCHAR2(30)    NOT NULL,
    
    Publisher_City      VARCHAR2(30),

    Publisher_State     VARCHAR(30)
);

CREATE TABLE Editor 
(
    Editor_ID           INTEGER            PRIMARY KEY,

    Date_Editor_Start   DATE,
    
    Freelance_Rate      INTEGER,

    Publisher_ID        INTEGER,
    
    CONSTRAINT Publisher_Editor_FK FOREIGN KEY(Publisher_ID)
        REFERENCES Publisher(Publisher_ID),
        
    CONSTRAINT Editor_FK FOREIGN KEY(Editor_ID)
        REFERENCES Person(Person_ID)
);

CREATE TABLE Agents
(
    Agent_ID            INTEGER             PRIMARY KEY,
    
    Agency_Name         VARCHAR2(30),
    
    Agency_Phone        NUMBER(10,0),
    
    Date_Agent_Start    DATE,

    CONSTRAINT Agent_FK FOREIGN KEY(Agent_ID)
        REFERENCES Person(Person_ID)
);

CREATE TABLE Author
(
    Author_ID           INTEGER             PRIMARY KEY,

    Pen_Name            VARCHAR2(30),
    
    Date_Author_Start   DATE,
    
    CONSTRAINT Author_FK FOREIGN KEY(Author_ID)
        REFERENCES Person(Person_ID)
);

CREATE TABLE Represented_By
(
    Author_ID           INTEGER,
    
    Agent_ID            INTEGER,
    
    Start_Date          DATE,
    
    End_Date            DATE,
    
    Commission          INTEGER,
    
    PRIMARY KEY (Author_ID, Agent_ID),
    CONSTRAINT Author_Representation_FK FOREIGN KEY(Author_ID)
        REFERENCES Author(Author_ID),
    CONSTRAINT Agent_Representation_FK FOREIGN KEY(Agent_ID)
        REFERENCES Agents(Agent_ID)
);

CREATE TABLE Genre
(
    Genre_ID            INTEGER         PRIMARY KEY,

    Genre_Name          VARCHAR2(30)    NOT NULL
    
);

CREATE TABLE Theme
(
    Theme_ID            INTEGER         PRIMARY KEY,

    Theme_Name          VARCHAR2(30)    NOT NULL
    
);

CREATE TABLE Story
(
    Story_ID            INTEGER         PRIMARY KEY,

    Author_ID           INTEGER         NOT NULL,
    
    Editor_ID           INTEGER,

    Title               VARCHAR2(50)    NOT NULL,
    
    Date_Written        DATE,
    
    Summary             VARCHAR(200),
    
    Public_Domain_Year  INTEGER,
    
    Genre_ID            INTEGER,
    
    CONSTRAINT Author_Story_FK FOREIGN KEY(Author_ID)
        REFERENCES Author(Author_ID),
    CONSTRAINT Editor_Story_FK FOREIGN KEY(Editor_ID)
        REFERENCES Editor(Editor_ID),
    CONSTRAINT Genre_Story_FK FOREIGN KEY(Genre_ID)
        REFERENCES Genre(Genre_ID)
);

CREATE TABLE Recommendation
(
    Start_Story         INTEGER,

    Recommended_Story   INTEGER,
    
    PRIMARY KEY (Start_Story, Recommended_Story),
    CONSTRAINT Start_Story_FK FOREIGN KEY(Start_Story)
        REFERENCES Story(Story_ID),
    CONSTRAINT Recommended_Story_FK FOREIGN KEY(Recommended_Story)
        REFERENCES Story(Story_ID)
    
);

CREATE TABLE Story_Theme
(
    Story_ID            INTEGER,
    
    Theme_ID            INTEGER,
    
    PRIMARY KEY (Story_ID, Theme_ID),
    CONSTRAINT Story_ID_FK FOREIGN KEY(Story_ID)
        REFERENCES Story(Story_ID),
    CONSTRAINT Theme_ID_FK FOREIGN KEY(Theme_ID)
        REFERENCES Theme(Theme_ID)
);

CREATE TABLE Publication
(
    Publication_ID      INTEGER         PRIMARY KEY,
    
    Publisher_ID        INTEGER,
    
    Publication_Name    VARCHAR2(30)    NOT NULL,
    
    Publication_Year    INTEGER,
    
    Genre_ID            INTEGER,
    
    Publication_Type    VARCHAR2(30),
    
     CONSTRAINT Publisher_ID_FK FOREIGN KEY(Publisher_ID)
        REFERENCES Publisher(Publisher_ID),
    CONSTRAINT Genre_ID_FK FOREIGN KEY(Genre_ID)
        REFERENCES Genre(Genre_ID)
    
);

CREATE TABLE Published_In
(
    Story_ID            INTEGER,
    
    Publication_ID      INTEGER,
    
    Page_Number         INTEGER,
    
    Fee                 INTEGER,
    
    PRIMARY KEY (Story_ID, Publication_ID),
    CONSTRAINT Story_Publication_FK FOREIGN KEY(Story_ID)
        REFERENCES Story(Story_ID),
    CONSTRAINT Publication_Story_FK FOREIGN KEY(Publication_ID)
        REFERENCES Publication(Publication_ID)
);

CREATE TABLE Edited_By
(
    Editor_ID           INTEGER,
   
    Publication_ID      INTEGER,
   
   PRIMARY KEY (Editor_ID, Publication_ID),
    CONSTRAINT Editor_ID_FK FOREIGN KEY(Editor_ID)
        REFERENCES Editor(Editor_ID),
    CONSTRAINT Publication_ID_FK FOREIGN KEY(Publication_ID)
        REFERENCES Publication(Publication_ID)
);

CREATE TABLE Magazine
(
    Magazine_ID         INTEGER   PRIMARY KEY,
   
    Volume_No           INTEGER,
    
    Issue               VARCHAR2(24),
    
    ISSN                NUMBER(8,0)   UNIQUE,
   
    CONSTRAINT Magazine_FK FOREIGN KEY(Magazine_ID)
        REFERENCES Publication(Publication_ID)
);

CREATE TABLE Website
(
    Website_ID          INTEGER   PRIMARY KEY,
   
    URL                 VARCHAR2(120),
   
    CONSTRAINT Website_FK FOREIGN KEY(Website_ID)
        REFERENCES Publication(Publication_ID)
);

CREATE TABLE Book
(
    Book_ID             INTEGER   PRIMARY KEY,
   
    Subtitle            VARCHAR(30),
    
    Book_Edition        VARCHAR(20),
    
    ISBN                NUMBER(13,0)  UNIQUE,
    
    Book_Type           CHAR(1),
   
    CONSTRAINT Book_FK FOREIGN KEY(Book_ID)
        REFERENCES Publication(Publication_ID)
);

CREATE TABLE Collection
(
    Collection_ID       INTEGER   PRIMARY KEY,
   
    Author_ID           INTEGER,
    
    CONSTRAINT Collection_FK FOREIGN KEY(Collection_ID)
        REFERENCES Book(Book_ID),
        
    CONSTRAINT Collection_Author_FK FOREIGN KEY(Author_ID)
        REFERENCES Author(Author_ID)
);

CREATE TABLE Anthology
(
    Anthology_ID        INTEGER   PRIMARY KEY,
   
    Theme_ID            INTEGER,
    
    CONSTRAINT Anthology_FK FOREIGN KEY(Anthology_ID)
        REFERENCES Book(Book_ID),
        
    CONSTRAINT Anthology_Theme_FK FOREIGN KEY(Theme_ID)
        REFERENCES Theme(Theme_ID)
);

--Insert Commands--
INSERT INTO Person VALUES (1, 'Lockwood', 'Patrica', 2222222222, '12 Hummingbird Lane', 'New York City', 'NY', 11111, NULL, 'A');
INSERT INTO Person VALUES (2, 'Oliphant', 'Timothy', 123456888, '10 Lily Avenue', 'New York City', 'NY', 11111, NULL, 'EG');
INSERT INTO Person VALUES (3, 'Treisman', 'Deborah', 7305468888, '45 Treewood Avenue', 'New York City', 'NY', 11111, NULL, 'E');
INSERT INTO Person VALUES (4, 'Mainstay', 'Brooke', 4444444444, '11 Seventeenth Street', 'New York City', 'NY', 11111, NULL, 'G');
INSERT INTO Person VALUES (5, 'Hemingway', 'Ernest', 5764392231, '17 River Forest Circle', 'Oak Park', 'IL', 60301, TO_DATE('19610702', 'YYYYMMDD'), 'A');
INSERT INTO Person VALUES (6, 'Perkins', 'Maxwell', 8435529874, '24 Alabaster Road', 'Ketchum', 'ID', 83353, TO_DATE('19470619', 'YYYYMMDD'), 'E');
INSERT INTO Person VALUES (7, 'McDonald', 'Maria', 2917435566, '33 Ring Circle', 'Union City', 'NJ', 07087, TO_DATE('19870304', 'YYYYMMDD'), 'E');
INSERT INTO Person VALUES (8, 'Jolas', 'Eugene', 2917435565, '33 Ring Circle', 'Union City', 'NJ', 07087, TO_DATE('19620526', 'YYYYMMDD'), 'E');
INSERT INTO Person VALUES (9, 'Valente', 'Catherynne', 4728937472, '27 Washington Drive', 'Seattle', 'WA', 98101, NULL, 'A');
INSERT INTO Person VALUES (10, 'Thomas', 'Michael', 7473552649, '31 Phoenix Lane', 'Urbana', 'IL', 61802, NULL, 'E');
INSERT INTO Person VALUES (11, 'Maxwell', 'James', NULL, NULL, NULL, 'IL', 61802, NULL, 'E');
INSERT INTO Person VALUES (12, 'Coates', 'Ta-Nehisi',2345678945, '31 Trusel Lane', 'New York City', 'NY', 45678, NULL, 'A');
INSERT INTO Person VALUES (13, 'James', 'Thomas', 4567889053, '14 Whistel RD', 'New York City', 'NY', 5655, NULL, 'A');
INSERT INTO Person VALUES (14, 'Baldwin', 'James', 8765465465, '22 Rockwell Rd', 'Buffalo', 'NY', 66666, NULL, 'A');
INSERT INTO Person VALUES (15, 'Bronze', 'Jacob', 3953843948, '44 Jonel Lane', 'New Britian', 'CT', 88888, NULL, 'A');
INSERT INTO Person VALUES (16, 'Smith', 'Lilian', 8930987897, '67 Willow St', 'New Jersey ', 'NJ', 99999, NULL, 'A');
INSERT INTO Person VALUES (21, 'Poe', 'Edgar Allan', 9999887798, '15 Amazing Street', 'Boston', 'Massachusetts', 02101, To_DATE('18090119','YYYYMMDD'), 'A');
INSERT INTO Person VALUES (22, 'Lowell', 'James Russell', 9999347798, '25 Prospect Street', 'Cambridge', 'Massachusetts', 02114, NULL, 'E');
INSERT INTO Person VALUES (23, 'Carter', 'Robert', 9599347798, '32 North Parking Line', 'Albany', 'New York', 12084, NULL, 'E');
INSERT INTO Person VALUES (24, 'Harrap', 'George G.', 9596347798, '4 North city Road', 'London', 'United Kingdom', 83746, NULL, 'E');
INSERT INTO Person VALUES (25, 'Rowley', 'Steven', NULL, NULL, NULL, NULL, NULL, TO_DATE('18770809','YYYYMMDD'), 'G');
INSERT INTO Person VALUES (17, 'Editors of the Saturday Post', 'NULL', 7563490215, '16 Mapleleaf Drive', 'Indianapolis', 'IN', 46077, NULL, 'E');


INSERT INTO Author VALUES (1, NULL, TO_DATE('19960219', 'YYYYMMDD'));
INSERT INTO Author VALUES (5, NULL, TO_DATE('19210101', 'YYYYMMDD'));
INSERT INTO Author VALUES (9, 'CATHERYNNE M. VALENTE', TO_DATE('20000318', 'YYYYMMDD'));
INSERT INTO Author VALUES (12, NULL, TO_DATE('20170224', 'YYYYMMDD'));
INSERT INTO Author VALUES (14, NULL, TO_DATE('19650525', 'YYYYMMDD'));
INSERT INTO Author VALUES (21, NULL, TO_DATE('18260215', 'YYYYMMDD'));

INSERT INTO Agents VALUES (2, 'Oliphant and Co.', 2459638854, TO_DATE('20020819', 'YYYYMMDD'));
INSERT INTO Agents VALUES (4, NULL, NULL, TO_DATE('20041117', 'YYYYMMDD'));
INSERT INTO Agents VALUES (25, 'Steven Rowley Co.', 2459630954, TO_DATE('19920229', 'YYYYMMDD'));


INSERT INTO Represented_By VALUES (1, 2, TO_DATE('20191114', 'YYYYMMDD'), NULL, 12);
INSERT INTO Represented_By VALUES (1, 4, TO_DATE('20061114', 'YYYYMMDD'), TO_DATE('20191112', 'YYYYMMDD'), 12);
INSERT INTO Represented_By VALUES (21, 25, TO_DATE('18290203', 'YYYYMMDD'), NULL, 12);

INSERT INTO Publisher VALUES (1, 'Conde Nast', 'New York City', 'NY');
INSERT INTO Publisher VALUES (2, 'Charles Scribners Sons', 'New York City', 'NY');
INSERT INTO Publisher VALUES (3, 'Weber University', 'Amherst', 'MA');
INSERT INTO Publisher VALUES (4, 'Houghton Mifflin Harcourt', 'New York City', 'NY');
INSERT INTO Publisher VALUES (5, 'Michael Damian Thomas', 'Urbana', 'IL');
INSERT INTO Publisher VALUES (6, 'Emerson Collective', 'Palo Alto', 'CA');
INSERT INTO Publisher VALUES (7, 'Dial Press', 'New York City', 'NY');
INSERT INTO Publisher VALUES (21, 'Cybil Wallace', 'New York City', 'NY');
INSERT INTO Publisher VALUES (22, 'Sharon Hsu', 'New York City', 'NY');
INSERT INTO Publisher VALUES (23, 'James Rusell Lowell', 'New York City', 'NY');
INSERT INTO Publisher VALUES (8, 'Samuel D. Patterson and Co.', 'New York City', 'NY');
INSERT INTO Publisher VALUES (9, 'Carey and Hart', 'Philadelphia', 'PA');

INSERT INTO Editor VALUES (2, TO_DATE('20020819', 'YYYYMMDD'), 20, NULL);
INSERT INTO Editor VALUES (3, TO_DATE('19960319', 'YYYYMMDD'), NULL, 1);
INSERT INTO Editor VALUES (6, TO_DATE('19140615', 'YYYYMMDD'), NULL, 2);
INSERT INTO Editor VALUES (7, TO_DATE('19270912', 'YYYYMMDD'), NULL, 1);
INSERT INTO Editor VALUES (8, TO_DATE('19270912', 'YYYYMMDD'), NULL, 1);
INSERT INTO Editor VALUES (11, NULL, NULL, NULL);
INSERT INTO Editor VALUES (10, TO_DATE('20101029', 'YYYYMMDD'), NULL, 5);
INSERT INTO Editor VALUES (13, TO_DATE('20170112', 'YYYYMMDD'),NULL, NULL);
INSERT INTO Editor VALUES (15, TO_DATE('19650525', 'YYYYMMDD'), NULL, NULL);
INSERT INTO Editor VALUES (22, TO_DATE('19850323', 'YYYYMMDD'), NULL, NULL);
INSERT INTO Editor VALUES (23, TO_DATE('19960704', 'YYYYMMDD'), NULL, NULL);
INSERT INTO Editor VALUES (24, TO_DATE('19960704', 'YYYYMMDD'), NULL, NULL);
INSERT INTO Editor VALUES (17, TO_DATE('18210804', 'YYYYMMDD'), NULL, 8);

INSERT INTO Genre VALUES (1, 'Science Fiction');
INSERT INTO Genre VALUES (14, 'Fiction');
INSERT INTO Genre VALUES (22, 'Romance');
INSERT INTO Genre VALUES (2, 'Horror Fiction');

INSERT INTO Publication VALUES (1, 1, 'The New Yorker', 2020, NULL, 'MW');
INSERT INTO Publication VALUES (2, 1, 'The New Yorker', 1927, NULL, 'M');
INSERT INTO Publication VALUES (3, 2, 'Men Without Women', 1927, NULL, 'B');
INSERT INTO Publication VALUES (4, 3, 'Weber University Archive', 2016, NULL, 'W');
INSERT INTO Publication VALUES (5, 4, 'Best American Short Fiction', 2011, NULL, 'B');
INSERT INTO Publication VALUES (6, 5, 'Uncanny Magazine', 2015, 1, 'W');
INSERT INTO Publication VALUES (7, 6, 'The Atlantic', 2017, NULL, 'MW');
INSERT INTO Publication VALUES (8, 7, 'Going to Meet the Man', 1965, NULL, 'B');
INSERT INTO Publication VALUES (21, 1, 'The New Yorker', 2020, NULL, 'MW');
INSERT INTO Publication VALUES (22, 1, 'Esquire', 1927, NULL, 'MW');
INSERT INTO Publication VALUES (9, 8, 'United States Saturday Post', 1843, NULL, 'M');
INSERT INTO Publication VALUES (10, 9, 'The Gift', 1842, NULL, 'M');

INSERT INTO Edited_By VALUES (3,1);
INSERT INTO Edited_By VALUES (7,2);
INSERT INTO Edited_By VALUES (8,2);
INSERT INTO Edited_By VALUES (6,3);
INSERT INTO Edited_By VALUES (11,5);
INSERT INTO Edited_By VALUES (10,6);
INSERT INTO Edited_By VALUES (13,7);
INSERT INTO Edited_By VALUES (15,8);
INSERT INTO Edited_By VALUES (23,21);
INSERT INTO Edited_By VALUES (24,22);
INSERT INTO Edited_By VALUES (17,9);

INSERT INTO Story VALUES (1, 1, 2,  'The Winged Thing', TO_DATE('20200102', 'YYYYMMDD'), 'A woman travels abroad for an abortion', 2080, NULL);
INSERT INTO Story VALUES (2, 5, 6,  'Hills Like White Elephants', TO_DATE('19270526', 'YYYYMMDD'), 'A conversation between an American man and a young woman at a Spanish train station', 2001, NULL);
INSERT INTO Story VALUES (3, 9, 10, 'Planet Lion', NULL, NULL, NULL, 1);
INSERT INTO Story VALUES (4, 12,13, 'My President Was Black', TO_DATE('20170122', 'YYYYMMDD'), NULL, NULL, NULL);
INSERT INTO Story VALUES (5, 14, 15,  'Going to Meet the Man', TO_DATE('19650525', 'YYYYMMDD'), NULL, NULL, NULL);
INSERT INTO Story VALUES (21, 21, NULL,  'The Tell-Tale Heart', TO_DATE('20170102', 'YYYYMMDD'), 'A horror story of mystery and imagination', 1956, NULL);
INSERT INTO Story VALUES (22, 5, NULL,  'The Capital of the World', TO_DATE('18290417', 'YYYYMMDD'), 'The Story around the city New York', 2009, NULL);
INSERT INTO Story VALUES (6, 21, 17,  'The Black Cat', TO_DATE('18430819', 'YYYYMMDD'), 'Horror story about a cat', 1913, 2);
INSERT INTO Story VALUES (7, 21, NULL,  'Eleonora', TO_DATE('18421002', 'YYYYMMDD'), 'A love story', 1912, 22);


INSERT INTO Theme VALUES (1, 'Abortion');
INSERT INTO Theme VALUES (2, 'Freedom');
INSERT INTO Theme VALUES (3, 'Relationships');
INSERT INTO Theme VALUES (4, 'Travel');
INSERT INTO Theme VALUES (5, 'American literature');
INSERT INTO Theme VALUES (6, 'Political');
INSERT INTO Theme VALUES (7, 'Race');
INSERT INTO Theme VALUES (21, 'Horror');
INSERT INTO Theme VALUES (22, 'Inspiration');
INSERT INTO Theme VALUES (8, 'Love');


INSERT INTO Story_Theme VALUES (1, 1);
INSERT INTO Story_Theme VALUES (2, 2);
INSERT INTO Story_Theme VALUES (2, 3);
INSERT INTO Story_Theme VALUES (2,1);
INSERT INTO Story_Theme VALUES (4, 6);
INSERT INTO Story_Theme VALUES (4, 7);
INSERT INTO Story_Theme VALUES (5, 5);
INSERT INTO Story_Theme VALUES (5, 7);
INSERT INTO Story_Theme VALUES (21, 21);
INSERT INTO Story_Theme VALUES (22, 22);
INSERT INTO Story_Theme VALUES (6, 21);
INSERT INTO Story_Theme VALUES (7, 8);

INSERT INTO Published_In Values (1, 1, 72, 1000);
INSERT INTO Published_In Values (2, 2, 53, 20);
INSERT INTO Published_In Values (2, 3, 26, NULL);
INSERT INTO Published_In Values (2, 4, 229, NULL);
INSERT INTO Published_In Values (2, 5, 35, NULL);
INSERT INTO Published_In Values (3, 6, NULL, 200);
INSERT INTO Published_In Values (4, 7, NULL, NULL);
INSERT INTO Published_In Values (5, 8, 49, NULL);
INSERT INTO Published_In Values (5, 5, 36, 1500);
INSERT INTO Published_In Values (21, 5, 98, 500);
INSERT INTO Published_In Values (22, 4, 47, 200);
INSERT INTO Published_In Values (22, 5, 64, NULL);
INSERT INTO Published_In Values (6, 9, NULL, NULL);
INSERT INTO Published_In Values (7, 10, NULL, NULL);

INSERT INTO Magazine VALUES (1, 2020, 'November 30', 123);
INSERT INTO Magazine VALUES (2, 1927, 'August', 345);
INSERT INTO Magazine VALUES (3, 2017, 'January/February', NULL);
INSERT INTO Magazine VALUES (4, 1965, 'April', NULL);
INSERT INTO Magazine VALUES (6, NULL, 'December', NULL);
INSERT INTO Magazine VALUES (21, 1896, 'September 03', 136);
INSERT INTO Magazine VALUES (22, 1927, 'August 09', 445);
INSERT INTO Magazine VALUES (5, NULL, 'August', NULL);

INSERT INTO Book VALUES (3, NULL, '2nd', 564429937, 'C');
INSERT INTO Book VALUES (5, NULL, 2011, 914567342, 'A');
INSERT INTO Book VALUES (8, NULL, NULL, 9780140184495, 'C');

INSERT INTO Collection VALUES (3,5);
INSERT INTO Collection VALUES (8,14);

INSERT INTO Anthology VALUES (5,5);


INSERT INTO Website VALUES (1, 'https://www.newyorker.com/magazine/2020/11/30/the-winged-thing');
INSERT INTO Website VALUES (4, 'https://faculty.weber.edu/jyoung/English%202500/Readings%20for%20English%202500/Hills%20Like%20White%20Elephants.pdf');
INSERT INTO Website VALUES (5,'https://uncannymagazine.com/article/planet-lion/');
INSERT INTO Website VALUES (6, 'https://www.theatlantic.com/magazine/archive/2017/01/my-president-was-black/508793/');
INSERT INTO Website VALUES (21, 'https://americanenglish.state.gov/files/ae/resource_files/the_tell-tale_heart_0.pdf');
INSERT INTO Website VALUES (22,' https://www.goodreads.com/pt/book/show/17898757-the-capital-of-the-world');

INSERT INTO Recommendation VALUES (4,5);

