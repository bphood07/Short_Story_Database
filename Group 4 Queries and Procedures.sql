--1) "Who Wrote a Story?": Finds the author of a story and their agent if they have one.
SELECT s.Author_ID, p.Last_Name, p.First_Name, Person_Phone, b.Agent_ID, Agent_Name, Agent_Phone, Agency_Name, Agency_Phone
FROM Author a
LEFT JOIN Person p ON a.Author_ID = p.Person_ID
LEFT JOIN Story s ON a.Author_ID = s.Author_ID
LEFT JOIN Represented_By rb ON a.Author_ID = rb.Author_ID
LEFT JOIN (
SELECT Agent_ID, CONCAT(First_Name, Last_Name) Agent_Name, Agency_Name, Agency_Phone, Person_Phone AS Agent_Phone
FROM Agents a
JOIN Person p ON a.Agent_ID = p.Person_ID) b ON rb.Agent_ID = b.Agent_ID
WHERE End_Date IS NULL AND Title = 'The Winged Thing';

--2) "Publication History": Shows everywhere a story has been published.
SELECT Story_ID, Title, Publication_Name, Publisher_Name, Publication_Year, Fee, Publication_Type
FROM Story
JOIN Published_In  USING (Story_ID)
JOIN Publication  USING (Publication_ID)
JOIN Publisher  USING (Publisher_ID)
WHERE Title = 'Hills Like White Elephants'
ORDER BY Publication_Year;

--3) "Table of Contents": Shows all stories in a single publication
SELECT Title, Page_Number, First_Name || ' ' || Last_Name AS Author_Name 
FROM Story s
JOIN Author a ON s.Author_ID = a.Author_ID
JOIN Person p ON a.Author_ID = p.Person_ID
JOIN Published_In pi ON s.Story_ID = pi.Story_ID
JOIN Publication pb ON pi.Publication_ID = pb.Publication_ID
WHERE Publication_Name = 'Best American Short Fiction'
ORDER BY Page_Number;

--4) "Stories with Common Theme": Searches stories by theme
SELECT Theme_Name, Title, First_Name || ' ' || Last_Name AS Author_Name
FROM Theme t
JOIN Story_Theme st ON t.Theme_ID = st.Theme_ID
JOIN Story s ON st.Story_ID = s.Story_ID
JOIN Author a ON s.Author_ID = a.Author_ID
JOIN Person p ON a.Author_ID = p.Person_ID
WHERE Theme_Name = 'Horror';

--5) "Author's Most Popular Themes": Ranks themes an author has written on
SELECT Theme_Name, COUNT(*) "Total", RANK() OVER (ORDER BY Theme_Name, COUNT(*)) "Rank"
FROM Theme t
JOIN Story_Theme st ON t.Theme_ID = st.Theme_ID
JOIN Story s ON st.Story_ID = s.Story_ID
JOIN Author a ON s.Author_ID = a.Author_ID
JOIN Person p ON a.Author_ID = p.Person_ID
WHERE First_Name = 'Edgar Allan' and Last_Name = 'Poe'
GROUP BY Theme_Name;

--6) "Story Lookup": Uses an incomplete title and wildcards to find story
SELECT Title, First_Name || ' ' || Last_Name AS Author_Name
FROM Story s
JOIN Author a ON s.Author_ID = a.Author_ID
JOIN Person p ON a.Author_ID = p.Person_ID
WHERE Title LIKE '%Capital%'
ORDER BY Title;

--7) "Public Domain Stories": Shows all stories that are in the public domain.
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYYMMDD';
SELECT Title, Public_Domain_Year, Summary
FROM Story
WHERE TO_NUMBER(TO_CHAR((SELECT SYSDATE FROM DUAL), 'YYYY')) > public_domain_year;

--8) "Stories by Genre": Searches stories by genre
SELECT Title, First_Name || ' ' || Last_Name AS Author_Name
FROM Story s
JOIN Genre g ON g.Genre_ID = s.Genre_ID
JOIN Author a ON s.Author_ID = a.Author_ID
JOIN Person p ON a.Author_ID = p.Person_ID
WHERE Genre_Name = 'Science Fiction';

--9) "Story Recommendations": Shows story recommendations from the Recommendations entity
SELECT Title, First_Name || ' ' || Last_Name AS Author_Name, Summary
FROM Story s
JOIN Author a ON s.Author_ID = a.Author_ID
JOIN Person p ON a. Author_ID = p.Person_ID
JOIN Recommendation r ON s.Story_ID = r.Recommended_Story
WHERE Start_Story IN
(SELECT Story_ID
FROM Story
WHERE Title = 'My President Was Black');

--10) "Author Publication History": Shows the entire publication history of an author.
SELECT a.Author_ID, Title, Publication_Name, Publisher_Name, Publication_Year, Publication_Type, Fee
FROM Author a
JOIN Person p ON a.Author_ID = p.Person_ID
JOIN Story s ON a.Author_ID = s.Author_ID
JOIN Published_In pi ON s.Story_ID = pi.Story_ID
JOIN Publication pb ON pi.Publication_ID = pb.Publication_ID
JOIN Publisher pr ON pb.Publisher_ID = pr.Publisher_ID
WHERE Last_Name = 'Hemingway' and First_Name = 'Ernest'
ORDER BY Publication_Year;

--11) "Author Representation History": Shows what agents have represented an author and when
SELECT a.Agent_ID, p.Last_Name, p.First_Name, p.Person_Phone, Agency_Name, Agency_Phone, Start_Date, End_Date
FROM Agents a
JOIN Person p ON a.Agent_ID = p.Person_ID
JOIN Represented_By rb ON a.Agent_ID = rb.Agent_ID
WHERE rb.Author_ID IN (
SELECT Person_ID
FROM Person
WHERE Last_Name =  'Lockwood' AND First_Name = 'Patricia')
ORDER BY End_Date DESC; 

--12) "Unrepresented Authors": Shows all authors in the database that are not represented
SELECT Author_ID, Last_Name, First_Name, Pen_Name, Person_Phone 
FROM Author 
JOIN Person ON Author_ID = Person_ID 
WHERE Author_ID NOT IN (
SELECT Author_ID 
FROM Represented_By 
WHERE End_Date IS NULL) 
AND Date_Deceased IS NULL;

--13) "Calculate agent's cut": Find the portion of the publication fee that goes to the agent.
SELECT s.Story_ID, Title, Fee, Commission, Fee * Commission / 100 AS Agent_Cut
FROM Story s
JOIN Published_In pi ON s.Story_ID = pi.Story_ID
JOIN Author a ON s.Author_ID = a.Author_ID
JOIN Represented_By rb ON a.Author_ID = rb.Author_ID
JOIN Agents b ON rb.Agent_ID = b.Agent_ID
JOIN Person p ON b.Agent_ID = p.Person_ID
WHERE (Date_Written BETWEEN Start_Date AND End_Date
OR Date_Written > Start_Date AND End_Date IS NULL)
AND First_Name = 'Timothy' AND Last_Name = 'Oliphant';

--14) "Calculate Story Age": Shows how old a story is
SELECT s.Story_ID, Title, Date_Written, EXTRACT(YEAR FROM SYSDATE) -  EXTRACT(YEAR FROM Date_Written) AS Story_Age
FROM Story s
Where Title = 'Going to Meet the Man';

--15) "Show maximum freelance fee": Shows the editor(s) with the highest fee.
SELECT Editor_ID, Last_Name, First_Name, Freelance_Rate
FROM Editor e
JOIN Person p ON e.Editor_ID = p.Person_ID
WHERE Freelance_Rate IN (
SELECT MAX(Freelance_Rate)
FROM Editor);

--EXTRA CREDIT FOLLOWS--

--"Creating Recommendations": Creates rows in the Recommendation entity based on a common theme.
--Note that since the last row is created twice for unknown reasons, this procedure will not work as written.
DECLARE
  start_story       Recommendation.Start_Story%TYPE;
  recommended_story   Recommendation.Recommended_Story%TYPE;
  CURSOR st_cursor_up IS SELECT Story_ID FROM Story_Theme st WHERE Theme_ID = 1 ORDER BY Story_ID ASC;
  CURSOR st_cursor_down IS SELECT Story_ID FROM Story_Theme st WHERE Theme_ID = 1 ORDER BY Story_ID DESC;
BEGIN
OPEN st_cursor_up;
OPEN st_cursor_down;
LOOP
  FETCH st_cursor_up INTO start_story; 
  FETCH st_cursor_down INTO recommended_story;
  IF (recommended_story != start_story) THEN
  INSERT INTO Recommendation VALUES (
    start_story,
    recommended_story);
    ELSE NULL;
     END IF;
      EXIT WHEN st_cursor_down%NOTFOUND;
      END LOOP;
 CLOSE st_cursor_up;
 CLOSE st_cursor_down;
END;

--"Denoting Writers' Career Experience": Gives a description of the author's experience
SET SERVEROUTPUT ON;
ALTER SESSION SET NLS_DATE_FORMAT = 'MM-DD-YYYY';

DECLARE
    total_writers NUMBER;
    total_people NUMBER;
    l_count NUMBER;
    current_writer NUMBER := 1;
    
    author_rec Author%ROWTYPE;
    person_rec Person%ROWTYPE;
    author_number INTEGER := 1;
    CURSOR c1 IS SELECT Author_ID, Pen_Name, Date_Author_Start FROM Author WHERE Author_ID = author_number;
    CURSOR c2 IS SELECT Person_ID, Last_Name, First_Name, Person_Phone, Address_Street, Address_City,
    Address_State, Address_Zip, Date_Deceased, Person_Type FROM Person WHERE Person_ID = author_number;

BEGIN
    SELECT COUNT(*) INTO total_writers FROM Author;
    SELECT COUNT(*) INTO total_people FROM Person;
    dbms_output.put_line('Number of Total Writers: ' || total_writers);
    dbms_output.new_line;
    FOR l_count IN 1..total_people
    LOOP
    author_number := l_count;
    OPEN c1;
    OPEN c2;
    FETCH c1 INTO author_rec;
    FETCH c2 INTO person_rec;
    CLOSE c1;
    CLOSE c2;
    IF ((EXTRACT(YEAR FROM SYSDATE) -  EXTRACT(YEAR FROM author_rec.Date_Author_Start)) > 30
    AND author_rec.Author_ID = author_number)
    THEN dbms_output.put_line(current_writer || ') ' || person_rec.First_Name || ' ' || person_rec.Last_Name ||
    ' is an Old Writer who started writing on ' || author_rec.Date_Author_Start || '.');
    dbms_output.new_line;
    current_writer := current_writer + 1;
    ELSIF ((EXTRACT(YEAR FROM SYSDATE) -  EXTRACT(YEAR FROM author_rec.Date_Author_Start)) > 10
    AND author_rec.Author_ID = author_number)
    THEN dbms_output.put_line(current_writer || ') ' || person_rec.First_Name || ' ' || person_rec.Last_Name ||
    ' is an Experienced Writer who started writing on ' || author_rec.Date_Author_Start || '.');
    dbms_output.new_line;
    current_writer := current_writer + 1;
    ELSIF (author_rec.Author_ID = author_number)
    THEN dbms_output.put_line(current_writer || ') ' || person_rec.First_Name || ' ' || person_rec.Last_Name ||
    ' is a New Writer who started writing on ' || author_rec.Date_Author_Start || '.');
    dbms_output.new_line;
    current_writer := current_writer + 1;
    END IF;
    END LOOP;
END;