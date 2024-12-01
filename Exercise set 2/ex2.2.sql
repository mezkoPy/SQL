
-- 22.01a – Widok (view) i funkcja (function)
-- Nazwiska i imiona studentów zapisanych na wykład z matematyki (Mathematics). Dane posortowane według nazwisk. Użyj składni podzapytania.
-- 6 rekordów.
-- Studenci o nazwiskach (kolejno): Bowen, Foster, Holmes, Hunt, Palmer, Powell

SELECT surname, first_name
FROM students where student_id IN
(SELECT student_id
 FROM students_modules
 WHERE module_id IN
(SELECT module_id
 FROM modules
 WHERE module_name='Mathematics'))
ORDER BY surname

-- 22.01b – Widok (view) i funkcja (function)
-- Napisz funkcję o nazwie studmod_f, która zwróci nazwiska i imiona studentów zapisanych na wykład o nazwie przekazanej do funkcji przy pomocy parametru. Uruchom funkcję podając jako parametr nazwę wybranego wykładu.

SELECT * FROM studmod_f('Mathematics') zwraca 6 rekordów (jak powyższe zapytanie)
SELECT * FROM studmod_f('Statistics') zwraca 4 rekordy
SELECT * FROM studmod_f('Databases') zwraca 2 rekordy
CREATE OR ALTER FUNCTION studmod_f(@module AS VARCHAR(100)) 
RETURNS TABLE AS RETURN
SELECT surname, first_name
FROM students where student_id IN
(SELECT student_id
 FROM students_modules
 WHERE module_id IN
(SELECT module_id
 FROM modules
 WHERE module_name=@module))
ORDER BY surname

-- Modyfikacje, jakie należy wykonać w powyższym zapytaniu aby powstała funkcja  oznaczono kolorem zielonym. Zwróć uwagę, że w instrukcji SELECT nie może być użyta klauzula ORDER BY.

-- 22.01c – Widok (view) i funkcja (function)
-- Jedną z różnic między funkcją a widokiem jest to, że do funkcji można przekazać parametr a do widoku nie. Aby przekazać parametr do widoku, można jednak użyć context info lub session context.
-- Utwórz widok o nazwie studmod_v, który zwróci nazwiska i imiona studentów zapisanych na wykład o nazwie przekazanej do widoku przy pomocy session context. Wykorzystaj mechanizm session context do przekazania nazwy wykładu do widoku i uruchom widok.
-- Instrukcja tworząca widok:

CREATE OR ALTER VIEW studmod_v AS
SELECT surname, first_name
FROM students where student_id IN
(SELECT student_id
 FROM students_modules
 WHERE module_id IN
(SELECT module_id
 FROM modules
 WHERE module_name=session_context(N'module')))

-- Instrukcja tworząca parę @key-@value session context i uruchamiająca widok:

exec sp_set_session_context @key=N'module', @value='Statistics'
select * from studmod_v

-- 22.02 – Funkcja ROW_NUMBER()
-- Wszystkie dane z tabeli student_grades, w ramach każdego module_id (partition by) posortowane według daty egzaminu a następnie identyfikatora studenta oraz ponumerowane kolejnymi liczbami. Pole zawierające kolejny numer oceny w ramach każdego module_id ma mieć nazwę sequence_num.
-- 58 rekordów, 
-- pierwsze trzy dotyczą wykładu o id=1 (w kolumnie sequence_num są liczby 1, 2, 3)
-- kolejnych pięć dotyczy wykładu o id=2 (w kolumnie sequence_num są liczby 1-5), itd.

SELECT ROW_NUMBER() OVER 
	(PARTITION BY module_id
	 ORDER BY exam_date, student_id) AS sequence_num,
module_id, exam_date, student_id, grade
FROM student_grades;

-- 22.03 – Funkcja ROW_NUMBER()
-- Wszystkie dane z tabeli student_grades, w ramach każdego student_id posortowane według daty egzaminu oraz ponumerowane kolejnymi liczbami. Zapytanie ma zwrócić jedynie dane o ocenach pozytywnych (większych niż 2). Pole zawierające kolejny numer oceny w ramach każdego student_id ma mieć nazwę sequence_num.
-- 45 rekordów 
-- pierwsze cztery dotyczą studenta o id=1 (w kolumnie sequence_num są liczby 1-4)
-- kolejne cztery dotyczą studenta o id=2 (w kolumnie sequence_num są liczby 1-4), itd.

SELECT ROW_NUMBER() OVER 
	(PARTITION BY student_id
	 ORDER BY exam_date) AS sequence_num,
student_id, exam_date, module_id, grade
FROM student_grades
WHERE grade>2;

-- 22.04 – Funkcja ROW_NUMBER()
-- Identyfikatory i nazwiska studentów oraz daty egzaminów, w ramach każdego student_id posortowane według daty egzaminu oraz ponumerowane kolejnymi liczbami. Zapytanie ma zwrócić jedynie dane o ocenach negatywnych (równych 2). Pole zawierające kolejny numer oceny w ramach każdego student_id ma mieć nazwę sequence_num.
-- 13 rekordów
-- studenci o identyfikatorach 2, 3 i 12 mają po dwie oceny 2,0
-- studenci o identyfikatorach 1, 6, 7, 8, 10, 20 i 33 po jednej

SELECT ROW_NUMBER() OVER 
	(PARTITION BY sg.student_id
	 ORDER BY exam_date) AS sequence_num,
	 s.student_id, exam_date
FROM student_grades sg INNER JOIN students s 
ON sg.student_id=s.student_id
WHERE grade=2;

-- 22.05 – Funkcja ROW_NUMBER()
-- Wszystkie dane z tabeli students, grupami. W ramach każdej grupy dane posortowane według daty urodzenia studenta. W ramach każdej grupy rekordy mają być ponumerowane.
-- 35 rekordów.
-- Zauważ, że w pierwszych 7 rekordach group_no jest NULL i rekordy te są traktowane jako jedna partycja.
-- W grupie DMIe1011 jest 6 studentów (data urodzenia pierwszego jest NULL).
-- W grupie DMIE1014 jest jeden student.
-- Data urodzenia pierwszego studenta w grupie ZMIe2011 to 1990-01-30 (Melissa Hunt).
-- W ostatnich dwóch rekordach w polu zawierającym kolejny numer w danej grupie są wartości 5 (w przedostatnim rekordzie) i 1 (w ostatnim).

SELECT ROW_NUMBER() OVER 
	(PARTITION BY group_no
	 ORDER BY date_of_birth) AS rownum,
	 group_no, student_id, surname, first_name, date_of_birth
FROM students;

 
-- 22.06a
-- Identyfikator, nazwisko i datę ostatniego egzaminu dla każdego studenta. Zapytanie ma zwrócić jedynie dane o studentach, którzy przystąpili co najmniej do jednego egzaminu.
-- Napisz zapytanie w dwóch wersjach: raz używając składni derived tables, raz CTE.
-- 21 rekordów
-- Trzeci: 3, Hunt, 2018-09-20
-- Ostatni: 33, Bowen, 2018-09-23
-- Derived tables:

SELECT dt.student_id, surname, exam_date
FROM
(SELECT ROW_NUMBER() OVER 
	 (PARTITION BY s.student_id
	  ORDER BY exam_date DESC) AS rownum,
	  s.student_id, surname, exam_date
 FROM students s INNER JOIN student_grades sg 
ON s.student_id=sg.student_id) AS dt
WHERE rownum=1;
CTE:
WITH CTE_table AS
(SELECT ROW_NUMBER() OVER 
	 (PARTITION BY s.student_id
	  ORDER BY exam_date DESC) AS rownum,
	  	s.student_id, surname, exam_date
 FROM students s INNER JOIN student_grades sg 
ON s.student_id=sg.student_id)
SELECT student_id, surname, exam_date
FROM CTE_table
WHERE rownum=1;

-- 22.06b
-- Korzystając z poprzedniego zapytania utwórz widok (VIEW) o nazwie last_exam zwracający identyfikator, nazwisko i datę ostatniego egzaminu dla każdego studenta.
-- Uruchom widok i sprawdź poprawność jego działania.
-- Wskazówka: Aby utworzyć widok, należy zapytanie poprzedzić instrukcją CREATE VIEW.
-- Uwaga: Widok nie może mieć takiej samej nazwy jak inny obiekt w bazie danych (tabela, funkcja).

SELECT * FROM last_exam
zwraca te same dane, co powyższe zapytanie.
CREATE OR ALTER VIEW last_exam AS
WITH CTE_table AS
(SELECT ROW_NUMBER() OVER 
	 (PARTITION BY s.student_id
	  ORDER BY exam_date DESC) AS rownum,
	 	s.student_id, surname, exam_date
  FROM students s INNER JOIN student_grades sg 
ON s.student_id=sg.student_id)
SELECT student_id, surname, exam_date
FROM CTE_table
WHERE rownum=1;

-- 22.06c
-- Zmodyfikuj utworzony widok o nazwie last_exam, aby wywołując go instrukcją SELECT można było podać liczbę oznaczającą, ile rekordów z danymi o ostatnich egzaminach ma zostać zwróconych dla każdego studenta.
-- Wskazówka: widok powinien zwracać dane o wszystkich egzaminach dla każdego studenta, dzięki czemu zapytanie uruchamiające widok może zawierać klauzulę WHERE zawierającą warunek wskazujący, ile ostatnich egzaminów dla każdego studenta ma zostać zwróconych.

SELECT * FROM last_exam
WHERE rownum=1
zwraca 21 rekordów
SELECT * FROM last_exam
WHERE rownum<=3
zwraca 46 rekordów
CREATE OR ALTER VIEW last_exam AS
WITH CTE_table AS
(SELECT ROW_NUMBER() OVER 
	 (PARTITION BY s.student_id
	  ORDER BY exam_date DESC) AS rownum,
	 	s.student_id, surname, exam_date
  FROM students s INNER JOIN student_grades sg 
ON s.student_id=sg.student_id)
SELECT student_id, surname, exam_date, rownum
FROM CTE_table
WHERE rownum=1;

-- W widoku należy usunąć ostatnią klauzulę WHERE oraz w ostatniej instrukcji SELECT umieścić na liście pole rownum.

-- 22.06d
-- Korzystając z poprzedniego zapytania utwórz funkcję o nazwie last_exams zwracającą identyfikator, nazwisko i datę tylu ostatnich egzaminów każdego studenta, ile wynosi wartość parametru funkcji (np. jeśli jako parametr funkcji podana zostanie liczba 4, to funkcja ma zwrócić daty ostatnich 4 egzaminów każdego studenta).
-- Uruchom funkcję i sprawdź poprawność jej działania.

SELECT * FROM last_exams(1)
zwraca 21 rekordów
SELECT * FROM last_exams(2)
zwraca 37 rekordów
SELECT * FROM last_exams(4)
zwraca 52 rekordy
CREATE OR ALTER FUNCTION last_exams(@exam_no AS int) RETURNS TABLE AS RETURN
WITH CTE_table AS
(SELECT ROW_NUMBER() OVER 
	 (PARTITION BY s.student_id
	  ORDER BY exam_date DESC) AS rownum,
	 	s.student_id, surname, exam_date
  FROM students s INNER JOIN student_grades sg 
ON s.student_id=sg.student_id)
SELECT student_id, surname, exam_date
FROM CTE_table
WHERE rownum<=@exam_no;

-- 22.07a
-- Wszystkie dane o dwóch najmłodszych studentach w każdej grupie. W zapytaniu pomiń dane o studentach, którzy nie są przypisani do żadnej grupy oraz o tych, którzy nie mają przypisanej daty urodzenia.
-- Napisz zapytanie w dwóch wersjach: raz używając składni derived tables, raz CTE.
-- 17 rekordów.
-- W grupach DMIe1014, DMZa3013, DZZa3001, ZMIe2014 oraz ZZIe2003 tylko jeden student ma wpisaną datę urodzenia.
-- 6 rekord: Rebecca Mason z grupy DMZa3012, ur. 1988-12-10
-- 15 rekord: Katie Powell z grupy ZZIe2012, ur. 2001-01-20
-- Derived tables:

SELECT rownum, group_no, student_id, surname, first_name,
 date_of_birth
FROM
(SELECT ROW_NUMBER() OVER 
	 (PARTITION BY group_no
	  ORDER BY date_of_birth DESC) AS rownum,
	 group_no, student_id, surname, first_name, date_of_birth
 FROM students
 WHERE group_no IS NOT NULL and date_of_birth IS NOT NULL) AS s
WHERE rownum<=2;
-- CTE:
WITH CTE_table AS
(SELECT ROW_NUMBER() OVER 
	 (PARTITION BY group_no
	  ORDER BY date_of_birth DESC) AS rownum,
	 group_no, student_id, surname, first_name, date_of_birth
 	FROM students
 	WHERE group_no IS NOT NULL and date_of_birth IS NOT NULL)
SELECT rownum, group_no, student_id, surname, first_name,
date_of_birth
FROM CTE_table
WHERE rownum<=2;


-- 22.07b
-- Korzystając z poprzedniego zapytania napisz funkcję o nazwie youngest_students, która zwróci dane o tylu najmłodszych studentach, ile wskazuje pierwszy parametr funkcji, z grupy, której nazwa zostanie podana jako drugi parametr.
-- Uruchom funkcję (wykorzystaj instrukcję SELECT) i sprawdź poprawność jej działania.
-- Wywołanie funkcji:

SELECT * FROM youngest_students(4, 'DMIe1011')
-- Zwraca 4 rekordy, w kolejności studentów o id: 1, 29, 30, 6
-- Wywołanie funkcji:
SELECT * FROM youngest_students(3, 'ZMIe2012')
-- Zwraca tabele pustą
-- Wywołanie funkcji:
SELECT * FROM youngest_students(5, 'DZZa3001')
-- Zwraca jeden rekord, student o id=19
 	CREATE or ALTER FUNCTION youngest_students 
(@number AS tinyint, @group AS varchar(20)) RETURNS TABLE AS 
RETURN
WITH s AS
(SELECT ROW_NUMBER() OVER 
	 (PARTITION BY group_no
	  ORDER BY date_of_birth DESC) AS rownum,
	 group_no, student_id, surname, first_name, date_of_birth
 	 FROM students
 WHERE group_no=@group and date_of_birth IS NOT NULL)
SELECT rownum, group_no, student_id, surname, first_name,
date_of_birth
FROM s
WHERE rownum<=@number;

-- 22.08a – recursive CTE
-- Module_id, module_name and no_of_hours wykładu o identyfikatorze 9 wraz z łańcuchem poprzedzających wykładów. Kolumnę zawierającą kolejny poziom nazwij distance.
-- 4 rekordy, kolejno: 
-- 9 Econometrics 45 (distance 0)
-- 8 Advanced Statistics 9 (1)
-- 5 Statistics 30 (2)
-- 4 Mathematics 15 (3)

WITH modulesCTE AS
(
SELECT module_id, module_name, preceding_module, no_of_hours, 
0 AS distance
FROM modules
WHERE module_id = 9
	UNION ALL
SELECT m.module_id, m.module_name, m.preceding_module, m.no_of_hours,
e.distance + 1
FROM modulesCTE e INNER JOIN modules m
ON e.preceding_module = m.module_id
)
SELECT module_id, module_name, no_of_hours, distance
FROM modulesCTE;

-- 22.08b
-- Na podstawie powyższego zapytania napisz funkcję o nazwie preceding_modules zwracającą module_id, module_no oraz no_of_hours wykładu o identyfikatorze podanym jako parametr funkcji wraz z łańcuchem poprzedzających wykładów.
-- Dla parametru 9 funkcja zwraca 4 rekordy (takie same jak powyższe zapytanie)
-- Dla parametru 5 funkcja zwraca 2 rekordy (kolejno wykłady o identyfikatorach 5 i 4)
-- Dla parametru 8 funkcja zwraca 3 rekordy (kolejno wykłady o identyfikatorach 8, 5, 4)

CREATE or ALTER FUNCTION preceding_modules 
(@number AS tinyint) RETURNS TABLE AS 
RETURN
WITH modulesCTE AS
(
SELECT module_id, module_name, preceding_module, no_of_hours, 
0 AS distance
FROM modules
WHERE module_id = @number
	UNION ALL
SELECT m.module_id, m.module_name, m.preceding_module, m.no_of_hours,
e.distance + 1
FROM modulesCTE e INNER JOIN modules m
ON e.preceding_module = m.module_id
)
SELECT module_id, module_name, no_of_hours, distance
FROM modulesCTE;

