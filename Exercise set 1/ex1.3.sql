--Skill 1.4 – zapytania do bazy danych university.

--UWAGA: ponieważ poniższe instrukcje modyfikują dane w bazie danych, warto je wykonywać w transakcji. Przed wykonaniem instrukcji wykonaj polecenie
--BEGIN tran
--następnie uruchom instrukcję, sprawdź wynik i wykonaj instrukcję
--ROLLBACK
--Przykład:
--SELECT * FROM tuition_fees
--Została wyświetlona lista wszystkich wpłat studentów (73 rekordy).

BEGIN tran
DELETE FROM tuition_fees

--Pojawiła się informacja, że operacja dotyczyła 73 rekordów.

SELECT * FROM tuition_fees

--Tabela tuition_fees jest pusta.

ROLLBACK

--Wszystkie operacje wykonane na bazie danych od wydania instrukcji BEGIN tran zostały wycofane.

SELECT * FROM tuition_fees

--Tabele tuition_fees znów zawiera 73 rekordy.


--14.00
--1. 	Instrukcją SELECT wybierz identyfikatory, nazwiska, imiona i numery grup studentów zapisanych na wykład o identyfikatorze 2. Posortuj dane według group_no.
--SELECT s.student_id, surname, first_name, group_no

FROM students s INNER JOIN students_modules sm 
ON s.student_id=sm.student_id
WHERE module_id=2
ORDER BY group_no

--Siedmiu studentów o identyfikatorach 16, 20, 1, 3, 10, 18, 14. 
--Zwróć uwagę, że dwóch studentów zapisanych na wykład o identyfikatorze 2 należy do grupy DMIe1011 (studenci o identyfikatorach 1 i 3) oraz, że dwóch studentów nie jest przypisanych do żadnej grupy (studenci o identyfikatorach 16 i 20).

2. 	Usuń wszystkich studentów grupy DMIe1011 z wykładu o identyfikatorze 2 z jednoczesnym wyświetleniem identyfikatorów tych studentów.
Wskazówka: wykorzystaj składnię DELETE based on a join. Nie korzystaj z transakcji.
DELETE FROM sm
OUTPUT deleted.student_id
FROM students s INNER JOIN students_modules sm 
ON s.student_id=sm.student_id
WHERE group_no='DMIe1011' AND module_id=2

--Usunięte zostały dwa rekordy – studenci o identyfikatorach 1 i 3. 
--Sprawdź, wyświetlając dane o studentach zapisanych na wykład o identyfikatorze 2. 

--3.	Instrukcją MERGE dokonaj takiej modyfikacji w bazie danych, aby wszyscy studenci z grupy DMIe1011 byli zapisani na wykład nr 2 i tylko oni.
--Studentów przypisanych dotychczas na wykład nr 2 i nie należących do grupy DMIe1011 należy przepisać na wykład o identyfikatorze 26. Nie korzystaj z transakcji.

MERGE INTO students_modules AS tgt
USING students AS src
ON src.student_id = tgt.student_id AND module_id=2
WHEN MATCHED THEN
UPDATE SET tgt.module_id=26
WHEN NOT MATCHED AND src.group_no='DMIe1011' THEN 
INSERT VALUES (student_id, 2, NULL);

--Zmodyfikowanych zostało 11 rekordów. 

--4.	Wybierz identyfikatory, nazwiska, imiona i numery grup studentów zapisanych na wykład o identyfikatorze 2.

SELECT s.student_id, surname, first_name, group_no
FROM students s INNER JOIN students_modules sm 
ON s.student_id=sm.student_id
WHERE module_id=2

--Na wykład zapisani są jedynie studenci z grupy DMIe1011. Jest ich sześciu (o identyfikatorach 1, 3, 4, 6, 29 i 30). 

--5.	Sprawdź, czy wszyscy studenci z grupy DMIe1011 zostali zapisani na wykład o identyfikatorze 2 wyświetlając z tabeli studenci dane o studentach zapisanych do grupy DMIe1011.

SELECT *
FROM students
WHERE group_no='DMIe1011'
--Jeśli zadanie zostało wykonane poprawnie, zapytanie powinno zwrócić dane o sześciu studentach o identyfikatorach 1, 3, 4, 6, 29 i 30.

--6.	Wyświetl identyfikatory studentów zapisanych na wykład o identyfikatorze 26.

SELECT student_id
FROM students_modules
WHERE module_id=26

--Jeśli zadanie zostało wykonane poprawnie, zapytanie powinno zwrócić identyfikatory pięciu studentów: 10, 14, 16, 18, 20.


--14.01
--1.	Spróbuj dodać do tabeli students dane o studencie (wykorzystaj transakcję):
--Andy Cooper, urodzony 1998-02-04, grupa MZa2020.
--Skomentuj reakcję systemu.

INSERT INTO students (surname, first_name, date_of_birth, group_no) 
VALUES ('Cooper', 'Andy', '19980204', 'MZa2020')

--Nie istnieje grupa MZa2020, a tabela walidacji (groups) pozwala na wpisanie do pola group_no tabeli students jedynie numeru grupy, który występuje w tabeli groups.

--2.	Spróbuj dodać do tabeli students dane o studencie (wykorzystaj transakcję) 
--	Andy Cooper, urodzony 1998-02-04, grupa DMZa3011

INSERT INTO students (surname, first_name, date_of_birth, group_no) 
VALUES ('Cooper', 'Andy', '19980204', 'DMZa3011')

--14.02
--Student o identyfikatorze 12 dokonał dwóch wpłat:
--12 czerwca 2019 roku 500 pln
--22 czerwca 2019 roku 650 pln
--Jedną instrukcją INSERT zarejestruj ten fakt w bazie danych.

INSERT INTO tuition_fees (student_id, fee_amount, date_of_payment) 
VALUES (12, 500, '20190612'), (12, 650, '20190622')

--14.03
--Pracownicy o identyfikatorach 23 i 40 zostali wykładowcami.
--Pracownik o identyfikatorze 23 ma tytuł master i został zatrudniony w Department of History, a pracownik o identyfikatorze 40 ma tytuł doctor i został zatrudniony w Department of Psychology.
--1. 	Jedną instrukcją INSERT wprowadź te dane do bazy danych. W instrukcji pomiń pierwszy nawias.
--Skomentuj reakcję systemu. Odpowiedz na pytanie, ile rekordów zostało dodanych do bazy danych.

INSERT INTO lecturers VALUES (23, 'master', 'Department of History'), (40, 'doctor', 'Department of Psychology')
--W tabeli departments, która jest tabelą słownikową, nie ma katedry Department of Psychology.

--Do tabeli nie został dodany żaden rekord, nawet ten dotyczący pracownika o identyfikatorze 23, mimo tego, że zawiera poprawne dane. Ponieważ rekordy są dodawane jedną instrukcję INSERT, cała operacja jest traktowana jako transakcja.

--2.	Dodaj do tabeli departments nazwę katedry Department of Psychology i ponów próbę wprowadzenia informacji o zatrudnieniu pracowników o identyfikatorach 23 i 40 na odpowiednich stanowiskach wykładowców. Tym razem zapytanie powinno zostać wykonane.

INSERT INTO departments VALUES ('Department of Psychology')

--14.04
--1.	Utwórz tabelę o nazwie payments o następującej strukturze (bez klucza podstawowego):

student (int)
fee (smallmoney)
date (date)
CREATE TABLE payments(
student int,
fee smallmoney,
date date)

--2.	Instrukcją INSERT…SELECT przepisz do tabeli payments wszystkie wpłaty dokonane w październiku 2018 roku.
	INSERT INTO payments
SELECT student_id, fee_amount, date_of_payment
FROM tuition_fees
WHERE date_of_payment BETWEEN '20181001' AND '20181031'

--25 rekordów

--3.	Sprawdź, czy operacja się wykonała wyświetlając zawartość tabeli payments.

	SELECT * FROM payments

--25 rekordów

--14.05
--1. 	Utwórz procedurę o nazwie usp_payments, która będzie wymagać podania dwóch parametrów typu date i będzie wykonywać następujące operacje (nie używaj transakcji):
--•	usunie zawartość tabeli payments
--•	do tabeli payments doda wszystkie rekordy z tabeli tuition_fees, które dotyczą wpłat dokonanych w okresie podanym jako parametry zapytania.

CREATE PROC usp_payments @sd AS date, @ed AS date
AS
TRUNCATE TABLE payments;
INSERT INTO payments
SELECT student_id, fee_amount, date_of_payment
FROM tuition_fees
WHERE date_of_payment BETWEEN @sd AND @ed
GO

--2.	Uruchom procedurę dla podanych dat. Za każdym razem sprawdzaj zawartość tabeli payments.

EXEC usp_payments ‘rrrrmmdd’,’rrrrmmdd’

--Dla dat 2018-10-01 oraz 2018-10-31 funkcja kopiuje do tabeli payments 25 rekordów
--Dla dat 2018-10-22 oraz 2018-10-31 funkcja kopiuje do tabeli payments 16 rekordów
--Dla dat 2018-09-20 oraz 2018-09-30 funkcja kopiuje do tabeli payments 4 rekordy

--14.06a
--Bez tworzenia tabeli instrukcją CREATE skopiuj do tabeli myStudents wszystkie dane z tabeli students dotyczące studentów z grupy DMIe1011. 
--Po wykonaniu instrukcji wyświetl zawartość tabeli myStudents. Nie używaj transakcji.
--W tabeli myStudents jest 6 rekordów. Są to studenci o identyfikatorach 1, 3, 4, 6, 29 i 30

SELECT *
INTO myStudents
FROM students
WHERE group_no=’DMIe1011’

--14.06b
--Utwórz procedurę o nazwie usp_myStudents, która wykona dwie operacje. Usunie tabelę myStudents, jeśli taka istnieje w bazie danych (użyj instrukcji DROP TABLE IF exists myStudents)
--oraz przepisze do niej wszystkie dane z tabeli students dotyczące studentów z grupy podanej jako parametr procedury.
--Za każdym razem po uruchomieniu procedury sprawdź zawartość tabeli myStudents.
--Dla grupy ZMIe2011 do tabeli myStudents kopiowane są 4 rekordy
--Dla grupy DMZa3012 do tabeli myStudents kopiowane są 2 rekordy

CREATE PROC usp_myStudents @group AS char(10)
AS
DROP TABLE IF exists myStudents
SELECT *
INTO myStudents
FROM students
WHERE group_no=@group

--14.07
--1.	Wyświetl zawartość tabeli acad_positions i zapamiętaj stawki dla stanowisk full professor i habilitated associate professor (odpowiednio 80 i 65).
--2.	Jedną instrukcją UPDATE zwiększ stawki godzinowe dla tych dwóch stanowisk o 20% (użyj transakcji).
--Po wykonaniu instrukcji full professor ma stawkę 96
--a habilitated associate professor 78

UPDATE acad_positions
SET overtime_rate*=1.2
WHERE acad_position in 
(‘full professor’, ‘habilitated associate professor’)

--14.08
--1.	Sprawdź identyfikator wykładowcy prowadzącego wykłady o identyfikatorze 1 i 3.
--Jest to wykładowca o identyfikatorze 4.
--2.	Wyświetl dane z tabeli students_modules dotyczące wykładów o identyfikatorach 1 i 3 i sprawdź na kiedy są zaplanowane egzaminy dla zapisanych studentów (pole planned_exam_date).
--Na ten wykład zapisanych jest 15 studentów. Część z nich ma ustaloną datę egzaminu na 21.03.2018 a część nie ma wpisanej daty.
--3.	Jedną instrukcją UPDATE zmień planowane daty egzaminów (planned_exam_date) prowadzonych przez wykładowcę o identyfikatorze 4 na 26.09.2019.
--Zmiana została wykonana w 15 rekordach.

UPDATE s
SET planned_exam_date=’20190926’
FROM modules m INNER JOIN students_modules s 
ON m.module_id=s.module_id
WHERE lecturer_id=4

--4.	Wyświetl dane dotyczące wykładów 1 i 3 z tabeli students_modules i sprawdź wynik. 
--14.09a
--Studentka Katie Lancaster z zajęć z przedmiotu Databases otrzymała dwie oceny (2 i 3,5). Okazało się, że ta druga ocena (3,5) oraz data jej wystawienia są błędne. Skoryguj ten błąd wpisując ocenę 4,0 z datą 30.09.2018.
--Wskazówka: w tabeli students odszukaj identyfikator tej studentki a w tabeli modules identyfikator przedmiotu. Posiadając te informacje sprawdź w tabeli student_grades, o który rekord chodzi i instrukcją UPDATE dokonaj odpowiedniej modyfikacji. Przed instrukcją UPDATE należy wykonać trzy instrukcje SELECT.

SELECT * 
FROM students
WHERE surname=’Lancaster’ AND first_name=’Katie’

--Zapytanie zwróci dane studentki. Należy zapamiętać jej identyfikator (10).

SELECT * 
FROM modules
WHERE module_name=’Databases’

--Zapytanie zwróci dane przedmiotu Databases. Należy zapamiętać jego identyfikator (11).

SELECT * 
FROM student_grades
WHERE student_id=10 AND module_id=11

--Zapytanie zwróci dwa rekordy. Wynika z nich, że należy skorygować ocenę wystawioną 28.09.2019:

UPDATE student_grades
SET exam_date=’20180930’, grade=4
WHERE student_id=10 AND module_id=11 AND grade=3.5 

--14.09b
--Student Oliver Webb z zajęć z przedmiotu Economics II otrzymał dwie oceny (2 i 4). Okazało się, że ta druga ocena (4) oraz data jej wystawienia są błędne. JEDNĄ INSTRUKCJĄ MERGE skoryguj ten błąd wpisując ocenę 3,0 z datą 15.10.2018.

MERGE INTO student_grades AS tgt
USING
(SELECT s.student_id, m.module_id
FROM students s INNER JOIN students_modules sm ON s.student_id=sm.student_id
INNER JOIN modules m ON sm.module_id=m.module_id
WHERE surname=’Webb’ AND first_name=’Oliver’ AND module_name=’Economics II’)
AS src
ON src.student_id=tgt.student_id AND src.module_id=tgt.module_id
WHEN MATCHED AND grade=4 THEN
UPDATE SET grade=3, exam_date=’20181015’;

--14.10
--Zwiększ overtime_rate dla stopnia master o 20 procent zapisując jednocześnie nową wartość w zmiennej o nazwie @newValue. Wyświetl zawartość zmiennej @newValue na ekranie.
--Nowa stawka to 48 pln.

DECLARE @newValue AS smallmoney=NULL
UPDATE acad_positions
SET @newValue=overtime_rate=overtime_rate*1.2
WHERE acad_position=’master’

SELECT @newValue 

--14.11
--Anulowany został egzamin z przedmiotu Mathematics. Usuń wszystkie oceny z tego przedmiotu.
--Wskazówka: wykorzystaj składnię DELETE based on a join
--Usuniętych zostało 6 rekordów.

DELETE FROM sg
FROM student_grades sg
INNER JOIN modules m ON sg.module_id=m.module_id
WHERE module_name=’Mathematics’

--14.12
--1.	Wyświetl te pary student_id, module_id z tabeli students_modules, dla których nie wpisano oceny do tabeli student_grades.

SELECT sm.student_id, sm.module_id
FROM students_modules sm left join student_grades sg on sm.student_id=sg.student_id and sm.module_id=sg.module_id
where sg.student_id is null

--49 rekordów

--2.	Instrukcją INSERT dodaj do tabeli grades ocenę 0.

INSERT INTO grades VALUES (0)

--3.	Instrukcją MERGE wszystkim studentom, którzy nie mają oceny z wykładu, na który uczęszczają przypisz ocenę 0 z datą dzisiejszą.

MERGE INTO student_grades as tgt
USING students_modules as src
ON src.student_id=tgt.student_id and src.module_id=tgt.module_id
WHEN not matched 
THEN INSERT VALUES (student_id, module_id, getdate(),0);

--Dodanych zostało 49 rekordów

--14.13
--Jedną instrukcją INSERT do tabeli employees dodaj dwóch pracowników i wyświetl nadane im identyfikatory:
--Jones Sylvia, employment_date: 20200403
--Edison George, PESEL 99062312345
--Pracownicy otrzymali identyfikatory 43 i 44.

INSERT INTO employees (surname, first_name, employment_date, PESEL)
OUTPUT inserted.employee_id
VALUES ('Jones', 'Sylvia', '202-303-44-55', NULL),
 ('Edison','George', NULL, '99062312345')

 
--14.14
--1.	Instrukcją CREATE TABLE utwórz tabelę #lastIncome o strukturze takiej jak tabela tuition_fees z jedną różnicą: pole payment_id ma nie być autonumerowane.
--2.	Student o identyfikatorze 6 dokonał dwóch wpłat: przedwczoraj 250 pln i dzisiaj 180 pln.
--Zarejestruj ten fakt w bazie danych z jednoczesnym zapisaniem wszystkich informacji o dokonanych wpłatach do tymczasowej tabeli #lastIncome.

INSERT INTO tuition_fees (student_id, fee_amount, date_of_payment)
OUTPUT inserted.*
INTO #lastIncome
VALUES (6, 250, getdate()-2),(6, 180, getdate())

--3.	Wyświetl zawartość tabeli #lastIncome.
--Zapytanie zwróciło dwa rekordy z wartościami payment_id 76 i 77.

--14.15
--Usuń wykład o identyfikatorze 24 z jednoczesnym wyświetleniem wszystkich danych o tym wykładzie.
--Na ekranie pojawiły się dane usuniętego wykładu:

24, Macroeconomics, 30, 26, 1, Department of Economics 
DELETE from modules
OUTPUT deleted.*
WHERE module_id=24

--14.16
--Zwiększ wszystkie stawki godzinowe o 10% z jednoczesnym wyświetleniem wszystkich tytułów naukowych, poprzednich stawek oraz stawek po zmianie. Kolumna zawierająca poprzednie stawki ma mieć nazwę old_rate a ta zawierająca nowe stawki new_rate.
--4 rekordy: Computer networks, Computer network devices, Computer programming oraz Computer programming II 

UPDATE acad_positions
SET overtime_rate*=1.1
OUTPUT inserted.acad_position,
 deleted.overtime_rate AS old_rate,
 inserted.overtime_rate AS new_rate

--14.17
--1.	Wyświetl dane o wszystkich wykładach, dla których liczba godzin jest mniejsza niż 15.
--Jest 6 takich wykładów.

SELECT * FROM modules WHERE no_of_hours<15

--2.	Zmień liczbę godzin dla wszystkich wykładów, dla których liczba ta jest mniejsza niż 15 na 15. Zwróć identyfikatory tych wykładów, ich nazwy oraz poprzednią i aktualną liczbę godzin.

		UPDATE modules
SET no_of_hours=15
OUTPUT inserted.module_id, deleted.module_name, deleted.no_of_hours AS old_hours, inserted.no_of_hours AS new_hours
WHERE no_of_hours<15

--6 rekordów: pierwszy module_id=6, old_hours=12, new_hours=15

 
--14.18a
--Podczas wprowadzania danych o ocenach pojawiły się błędy: część ocen nie zostało wprowadzonych, część zostało wprowadzonych błędnie. Poprawne dane o tych ocenach znajdują się w poniższej tabeli:
--student_id	module_id	exam_date	grade
--26	6	2018-09-26	5.0
--32	12	2018-03-02	4.5
--3	2	2018-09-15	3
--29	15	2018-10-15	4.5
--Napisz instrukcję MERGE wprowadzając poprawne dane do tabeli student_grades. Jeśli danemu studentowi z danego modułu podanego dnia ocena została wpisana, skoryguj ją, jeśli nie, wpisz ją. Wyświetl na ekranie nazwę akcji wykonanej na rekordzie (INSERT lub UPDATE), student_id, module_id oraz ocenę poprzednią (jeśli istniała) i nową.

BEGIN TRAN
MERGE INTO student_grades AS tgt
	USING (VALUES
(26, 6, '20180926', 5), 
(32, 12, '20180302', 4.5), 
(3, 2, '20180915', 3),
		(29, 15, '20181015', 4.5)
)
	AS src(student_id, module_id, exam_date, grade)
ON src.student_id = tgt.student_id 
AND src.module_id=tgt.module_id AND src.exam_date=tgt.exam_date
WHEN MATCHED THEN
UPDATE SET tgt.grade = src.grade
WHEN NOT MATCHED THEN
INSERT VALUES
(src.student_id, src.module_id, src.exam_date, src.grade)
OUTPUT
$action AS the_action,
inserted.student_id,
inserted.module_id,
deleted.grade AS old_grade,
inserted.grade AS new_grade;
ROLLBACK
 
--14.18b
--Zmodyfikuj poprzednie zapytanie tak, żeby zwracało jedynie dane o nowo wprowadzonych rekordach (INSERT).
--UWAGA: aby zobaczyć efekt, trzy instrukcje muszą być wykonane jednocześnie w transakcji:
--•	deklaracja zmiennej tablicowej o strukturze takiej, jak tabela student_grades,
--•	instrukcja MERGE 
--(a właściwie Nested DML, czyli INSERT SELECT…MERGE),
--•	instrukcja wyświetlająca zawartość zmiennej tablicowej.
--Wynikiem są ostatnie dwa rekordy z tabeli z poprzedniego zadania.

BEGIN TRAN

DECLARE @InsertedGrades AS TABLE
(
student_id INT NOT NULL,
module_id INT NOT NULL,
exam_date DATE NOT NULL,
grade decimal(2,1)
);

INSERT INTO @insertedGrades (student_id, module_id, exam_date, grade)
SELECT student_id, module_id, exam_date, grade FROM 
(MERGE INTO student_grades AS tgt
	USING (VALUES
(26, 6, '20180926', 5),
(32, 12, '20180302', 4.5), 
(3, 2, '20180915', 3),
		(29, 15, '20181015', 4.5)
)
	AS src(student_id, module_id, exam_date, grade)
ON src.student_id = tgt.student_id 
AND src.module_id=tgt.module_id AND src.exam_date=tgt.exam_date
WHEN MATCHED THEN
UPDATE SET tgt.grade = src.grade
WHEN NOT MATCHED THEN
INSERT VALUES
(src.student_id, src.module_id, src.exam_date, src.grade)
OUTPUT
$action AS the_action, 
inserted.*) AS D
WHERE the_action='INSERT';

SELECT * FROM @InsertedGrades

ROLLBACK

 
--14.19a
--Do tabeli groups spróbuj dodać pole o nazwie field_of_study typu varchar(100) z atrybutem NULL bez wartości domyślnej i bez WITH VALUES. 
--Wyświetl zawartość tabeli groups i sprawdź, że składa się ona z dwóch pól oraz że pole field_of_study jest wypełnione wartością NULL.
--Skomentuj ten wynik.

ALTER TABLE groups ADD field_of_study varchar(100) NULL
SELECT * FROM groups

--14.19b
--Do tabeli groups spróbuj dodać pole o nazwie field_of_study typu varchar(100) z atrybutem NOT NULL bez wartości domyślnej i bez WITH VALUES. 
--Wynikiem jest informacja o błędzie. Skomentuj tę informację.

ALTER TABLE groups ADD field_of_study varchar(100) NOT NULL

--14.19c
--Do tabeli groups spróbuj dodać pole o nazwie field_of_study typu varchar(100) z atrybutem NULL i wartością domyślną ‘EMPTY’ bez klauzuli WITH VALUES. 
--Wyświetl zawartość tabeli groups i sprawdź, że składa się ona z dwóch pól oraz że pole field_of_study jest wypełnione wartością NULL.
--Skomentuj ten wynik.

ALTER TABLE groups ADD field_of_study varchar(100) NULL
CONSTRAINT fos_default DEFAULT('Empty')
SELECT * FROM groups

--14.19d
--Do tabeli groups spróbuj dodać pole o nazwie field_of_study typu varchar(100) z atrybutem NULL i wartością domyślną ‘EMPTY’ z klauzulą WITH VALUES. 
--Wyświetl zawartość tabeli groups i sprawdź, że składa się ona z dwóch pól oraz że pole field_of_study jest wypełnione wartością EMPTY.
--Skomentuj ten wynik.

ALTER TABLE groups ADD field_of_study varchar(100) NULL
CONSTRAINT fos_default DEFAULT('Empty') WITH VALUES
SELECT * FROM groups

--14.19e
--Do tabeli groups spróbuj dodać pole o nazwie field_of_study typu varchar(100) z atrybutem NOT NULL i wartością domyślną ‘EMPTY’ bez klauzuli WITH VALUES. 
--Wyświetl zawartość tabeli groups i sprawdź, że składa się ona z dwóch pól oraz że pole field_of_study jest wypełnione wartością EMPTY.
--Skomentuj ten wynik.

ALTER TABLE groups ADD field_of_study varchar(100) NOT NULL
CONSTRAINT fos_default DEFAULT('Empty')
SELECT * FROM groups
 
--14.20a
--Z tabeli students spróbuj usunąć pole surname. Wyświetl zawartość tabeli students i sprawdź, że usunięcie kolumny się powiodło. Skomentuj takie działanie systemu. 

ALTER TABLE students DROP COLUMN surname
SELECT * FROM students

--14.20b
--Z tabeli students spróbuj usunąć pole group_no. Odpowiedz, dlaczego operacja nie mogła zostać wykonana. 

ALTER TABLE students DROP COLUMN group_no
SELECT * FROM students

