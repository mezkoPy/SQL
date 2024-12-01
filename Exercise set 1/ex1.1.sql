--11.01 (NULL w wyrażeniach i funkcjach agregujących)
--a) 	Wykonaj zapytanie:

SELECT 34+NULL

-- wynik to null, ponieważ null=nic, a gdy dodamy liczbe do niczego/pustki to nadal nie pozanmy wyniku
--b) 	Wszystkie dane o tych pracownikach, dla których brakuje numeru PESEL lub daty zatrudnienia (warunek klauzuli WHERE napisz w taki sposób aby był SARG)
--	13 rekordów 

SELECT * FROM employees WHERE PESEL IS NULL
UNION
SELECT * FROM employees WHERE employment_date IS NULL

--c)	Zapytanie wybierające wszystkie dane z tabeli students_modules.
--Zauważ, że dla niektórych egzaminów nie wyznaczono planned_exam_date.

SELECT * FROM students_modules

--d)	Zapytanie, które dla każdego rekordu z tabeli students_modules zwróci informację, ile dni minęło od planowanego egzaminu (wykorzystaj funkcję DateDiff).
--Dane posortowane malejąco według daty.
--Zapamiętaj ile rekordów zwróciło zapytanie.
--94 rekordy, w pierwszych dwóch student_id jest 17 i 1

SELECT student_id, module_id, 
	DATEDIFF(day, planned_exam_date, GETDATE()) AS date_difference
FROM students_modules
ORDER BY planned_exam_date DESC

--e)	Zapytanie zwracające wynik działania funkcji agregującej COUNT na polu planned_exam_date tabeli students_modules. Zwrócona wartość oznaczająca liczbę takich rekordów jest mniejsza niż liczba rekordów w tabeli. Wyjaśnij dlaczego.
--16 rekordów

SELECT COUNT(planned_exam_date) AS no_of_records
FROM students_modules

--f)	Zapytanie zwracające wynik działania funkcji agregującej COUNT(*) dla tabeli students_modules. Wartość oznaczająca liczbę rekordów jest równa liczbie rekordów w tabeli. Wyjaśnij dlaczego.
--	Zapytanie zwróciło liczbę 94

SELECT COUNT(*) AS no_of_records
FROM students_modules

--11.02 (DISTINCT)
--a)	Zapytanie zwracające identyfikatory studentów wraz z datami przystąpienia do egzaminów. Jeśli student danego dnia przystąpił do wielu egzaminów, jego identyfikator ma się pojawić tylko raz.
--Dane posortowane malejąco względem dat.
--	50 rekordów

SELECT DISTINCT student_id, exam_date
FROM student_grades
ORDER BY exam_date DESC

--b)	Zapytanie zwracające identyfikatory studentów, którzy przystąpili do egzaminu w marcu 2018 roku. Identyfikator każdego studenta ma się pojawić tylko raz. Dane posortowane malejąco według identyfikatorów studentów
--10 rekordów

SELECT DISTINCT student_id
FROM student_grades
WHERE exam_date BETWEEN '20180301' AND '20180331'
ORDER BY student_id DESC

--11.03
--Spróbuj wykonać zapytanie:
--SELECT student_id, surname AS family_name
--FROM students
--WHERE family_name='Fisher'
--Wyjaśnij dlaczego jest ono niepoprawne a następnie je skoryguj.

--11.04 (SARG)
--Zapytanie zwracające module_name oraz lecturer_id z tabeli modules z tych rekordów, dla których lecturer_id jest równy 8 lub NULL.
--Zapytanie napisz dwoma sposobami – raz wykorzystując funkcję COALESCE (jako drugi parametr przyjmij 0) raz tak, aby predykat podany w warunku WHERE był SARG.
--9 rekordów

SELECT module_name, lecturer_id
FROM modules
WHERE lecturer_id IS NULL OR lecturer_id = 8

SELECT module_name, lecturer_id
FROM modules
WHERE lecturer_id=8 OR coalesce(lecturer_id, 0) = 0


--11.05
--Wykorzystaj funkcję CAST i TRY_CAST jako parametr instrukcji SELECT próbując zamienić tekst ABC na liczbę typu INT.
--Skomentuj otrzymane wyniki.

SELECT CAST('ABC' as INT);

SELECT TRY_CAST('ABC' AS INT);

--11.06
--Napisz trzy razy instrukcję SELECT wykorzystując funkcję CONVERT zamieniającą dzisiejszą datę na tekst. Jako ostatni parametr funkcji CONVERT podaj 101, 102 oraz 103. Skomentuj otrzymane wyniki.

SELECT CONVERT(VARCHAR, GETDATE(), 101);
SELECT CONVERT(VARCHAR, GETDATE(), 102);
SELECT CONVERT(VARCHAR, GETDATE(), 103);


--11.07 (LIKE)
--Napisz zapytania z użyciem operatora LIKE wybierające nazwy grup (wielkość liter jest nieistotna):
--a)	zaczynające się na DM
--6 rekordów

SELECT group_no
FROM groups
WHERE group_no LIKE 'DM%';

--b)	niemające w nazwie ciągu '10'
--15 rekordów

SELECT group_no
FROM groups
WHERE group_no NOT LIKE '%10%';

--c)	których drugim znakiem jest M
--9 rekordów

SELECT group_no
FROM groups
WHERE group_no LIKE '_M%';

--d)	których przedostatnim znakiem jest 0 (zero)
--11 rekordów

SELECT group_no
FROM groups
WHERE group_no LIKE '%0_';

--e)	których ostatnim znakiem jest 1 lub 2
--12 rekordów

SELECT group_no
FROM groups
WHERE group_no LIKE '%1' OR group_no LIKE '%2';

--f)	których pierwszym znakiem nie jest litera D
--8 rekordów

SELECT group_no
FROM groups
WHERE group_no NOT LIKE 'D%';

--g)	których drugim znakiem jest dowolna litera z zakresu A-P
--10 rekordów

SELECT group_no
FROM groups
WHERE group_no LIKE '_[A-P]%';

--11.08 (LIKE i COLLATE)
--Napisz zapytania z użyciem operatora LIKE i/lub klauzuli COLLATE:
--a)	wybierające nazwy wykładów, które w nazwie mają literę o (wielkość liter nie ma znaczenia)
--19 rekordów

SELECT module_name
FROM modules
WHERE module_name LIKE '%O%'

--b)	wybierające nazwy wykładów, które w nazwie mają dużą literę O
--1 rekord, Operational systems

SELECT module_name
FROM modules
WHERE module_name COLLATE polish_cs_as LIKE '%O%'

--c)	wybierające nazwy grup, które w nazwie mają trzecią literę i (wielkość liter nie ma znaczenia)
--16 rekordów

SELECT group_no
FROM groups
WHERE group_no LIKE '__i%'

--d)	wybierające nazwy grup, które w nazwie mają trzecią literę małe i
--4 rekordy

SELECT group_no
FROM groups
WHERE group_no COLLATE polish_CS_as LIKE '__i%'

 
--11.09 (COLLATE)
--Instrukcją CREATE utwórz tabelę #tmp (jeśli stworzymy tabelę, której nazwa będzie poprzedzona znakiem #, tabela zostanie automatycznie usunięta po zamknięciu sesji) składającą się z pól:
--id int primary key
--nazwisko varchar(30) collate polish_cs_as
--Jedną instrukcją INSERT wprowadź do tabeli #tmp następujące rekordy (zwracając uwagę na wielkość liter):
--1	Kowalski
--2	kowalski
--3	KoWaLsKi
--4	KOWALSKI

CREATE TABLE #tmp (
	id int NOT NULL,
	nazwisko varchar(30) COLLATE polish_cs_as
);

INSERT INTO #tmp (id, nazwisko)
VALUES
(1, 'Kowalski'),
(2, 'kowalski'),
(3, 'KoWaLsKi'),
(4, 'KOWALSKI');

SELECT * FROM #tmp


--a)	Wybierz z tabeli #tmp rekordy, które w polu nazwisko mają (wielkość liter jest istotna):
--pierwszą literę duże K
--3 rekordy

SELECT nazwisko
FROM #tmp
WHERE nazwisko COLLATE polish_CS_as LIKE 'K%'

--napis Kowalski
--1 rekord


SELECT nazwisko
FROM #tmp
WHERE nazwisko COLLATE polish_CS_as = 'Kowalski'

--drugą literę od końca duże K
--2 rekordy

SELECT nazwisko
FROM #tmp
WHERE nazwisko COLLATE polish_CS_as LIKE '%K_'

--b)	Wyświetl rekordy, które w polu nazwisko mają (wielkość liter jest nieistotna):
--	napis kowalski
--4 rekordy

SELECT nazwisko
FROM #tmp
WHERE nazwisko COLLATE polish_ci_as = 'kowalski'

--	drugą literę o
--4 rekordy

SELECT nazwisko
FROM #tmp
WHERE nazwisko COLLATE polish_Ci_as LIKE '_o%'


--Odpowiedz na pytanie, w którym przypadku, a) czy b), użycie klauzuli COLLATE było konieczne i dlaczego.


--11.10
--Napisz zapytanie:
--SELECT surname
--FROM students
--ORDER BY group_no
--Wyjaśnij na czym polega błąd i skoryguj zapytanie tak, aby zwracało nazwiska studentów z tabeli students posortowane według numeru grupy.
--35 rekordów

--11.11 (TOP)
--a)	Napisz zapytanie wybierające 5 pierwszych rekordów z tabeli student_grades, które w polu exam_date mają najdawniejsze daty
--5 rekordów

SELECT TOP(5) student_id, module_id, exam_date, grade
FROM student_grades
ORDER BY exam_date


--b)	Skoryguj zapytanie z punktu a) dodając klauzulę WITH TIES. Skomentuj otrzymany wynik.
--	6 rekordów

SELECT TOP(5) WITH TIES student_id, module_id, exam_date, grade
FROM student_grades
ORDER BY exam_date

--11.12 (TOP, OFFSET)
--a)	Sprawdź, ile rekordów jest w tabeli student_grades

SELECT *
FROM student_grades

--b)	Wybierz 20% początkowych rekordów z tabeli student_grades. Posortuj wynik według exam_date. Sprawdź, ile rekordów zostało zwróconych i wyjaśnij dlaczego.
--12 rekordów

SELECT TOP(20) PERCENT *
FROM student_grades
ORDER BY exam_date

--c)	Pomiń pierwszych 6 rekordów i wybierz kolejnych 10 rekordów z tabeli student_grades. Posortuj wynik według exam_date.
--pierwszy rekord: student_id=6 i module_id=4

SELECT *
FROM student_grades
ORDER BY exam_date
OFFSET 6 ROWS FETCH NEXT 10 ROWS ONLY;

--d)	Wybierz wszystkie rekordy z tabeli student_grades z pominięciem pierwszych 20 (sortowanie według exam_date).
--38 rekordów

SELECT *
FROM student_grades
ORDER BY exam_date
OFFSET 20 ROWS;

--11.13 (INTERSECT, UNION, EXCEPT)
--a)	Wszystkie nazwiska z tabel students i employees (każde ma się pojawić tylko raz) posortowane według nazwisk
--40 rekordów

SELECT DISTINCT surname
FROM students
UNION
SELECT DISTINCT surname
FROM employees

--b)	Wszystkie nazwiska z tabel students i employees (każde ma się pojawić tyle razy ile razy występuje w tabelach) posortowane według nazwisk
--77 rekordów

SELECT surname
FROM students
UNION ALL
SELECT surname
FROM employees

--c)	Te nazwiska z tabeli students, które nie występują w tabeli employees
--21 rekordów

SELECT surname
FROM students
EXCEPT
SELECT surname
FROM employees

--d)	Te nazwiska z tabeli students, które występują także w tabeli employees
--1 rekord – nazwisko Craven

SELECT surname
FROM students
INTERSECT
SELECT surname
FROM employees

--e)	Nazwy katedr, których pracownicy nie są przypisani jako potencjalni prowadzący do żadnego wykładu (użyj operatora EXCEPT)
--3 rekordy: Department of Foreign Affairs, Department of Physics, 
--Institute of Teaching Methods

SELECT department
FROM departments
EXCEPT
SELECT department
FROM lecturers

--f)	Identyfikatory wykładów, które nie występują jako wykłady poprzedzające 
--14 rekordów

SELECT module_id
FROM modules
EXCEPT
SELECT module_id
FROM students_modules

--g)	Te pary id_studenta, id_wykladu z tabeli students_modules, którym nie została przyznana dotychczas żadna ocena
--45 rekordów

SELECT student_id, module_id
FROM students_modules
EXCEPT
SELECT student_id, module_id
FROM student_grades


--h)	Identyfikatory studentów, którzy zapisali się zarówno na wykład o identyfikatorze 3 jak i 12
--Trzech studentów o identyfikatorach 9, 14 i 18

SELECT student_id
FROM students_modules
WHERE module_id=3
INTERSECT
SELECT student_id
FROM students_modules
WHERE module_id=12


--i)	Nazwiska i imiona studentów wraz z numerami grup, zapisanych do grup o nazwach zaczynających się na DMIe oraz nazwiska i imiona wykładowców wraz z nazwami katedr, w których pracują. Ostatnia kolumna ma mieć nazwę group_department. Dane posortowane rosnąco według ostatniej kolumny.
--Wskazówka: W zapytaniu wybierającym dane o wykładowcach należy użyć złączenia
--37 rekordów

SELECT surname, first_name, group_no AS group_department
FROM students
WHERE group_no LIKE 'DMIe%'
UNION
SELECT surname, first_name, department
FROM lecturers INNER JOIN employees ON lecturer_id=employee_id
ORDER BY group_department
