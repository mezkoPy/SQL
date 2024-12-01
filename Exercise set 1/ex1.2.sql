--12.01
--Identyfikatory i nazwy wyk³adów na które nie zosta³ zapisany ¿aden student. Dane posortowane malej¹co wed³ug nazw wyk³adów.
--4 rekordy, wyk³ady o identyfikatorach 26, 25, 24, 23 (w podanej kolejnoœci)

SELECT m.module_id, m.module_name
FROM modules m
LEFT JOIN students_modules sm ON m.module_id = sm.module_id
WHERE sm.student_id IS NULL

--12.02
--Identyfikatory i nazwy wyk³adów oraz nazwiska wyk³adowców prowadz¹cych wyk³ady, na które nie zapisa³ siê ¿aden student.
--4 rekordy, wyk³ady o identyfikatorach 23, 24, 25, 26

SELECT m.module_id, module_name, surname
FROM (modules m LEFT JOIN students_modules sm 
ON m.module_id=sm.module_id) 
LEFT JOIN employees e ON m.lecturer_id=e.employee_id
WHERE sm.module_id IS NULL

--12.03
--Identyfikatory (pod nazw¹ lecturer_id) i nazwiska wszystkich wyk³adowców wraz z nazwami wyk³adów, które prowadz¹. Dane posortowane rosn¹co wed³ug nazwisk.
--37 rekordów, w pierwszych dwóch rekordach s¹ wyk³adowcy o identyfikatorach 5 i 12

SELECT l.lecturer_id, e.surname
FROM modules m
FULL OUTER JOIN lecturers l ON m.lecturer_id=l.lecturer_id
INNER JOIN employees e ON l.lecturer_id=e.employee_id
ORDER BY surname ASC

--12.04
--Identyfikatory, nazwiska i imiona pracowników, którzy s¹ wyk³adowcami.
--28 rekordów

SELECT e.employee_id, e.surname, e.first_name
FROM employees e
RIGHT JOIN lecturers l ON e.employee_id=l.lecturer_id

--12.05
--Identyfikatory, nazwiska i imiona pracowników, którzy nie s¹ wyk³adowcami.
--14 rekordów

SELECT e.employee_id, e.surname, e.first_name
FROM employees e
FULL OUTER JOIN lecturers l ON e.employee_id=l.lecturer_id
WHERE lecturer_id IS NULL 

--12.06
--Identyfikatory, imiona, nazwiska i numery grup studentów, którzy nie s¹ zapisani na ¿aden wyk³ad. Dane posortowane rosn¹co wed³ug nazwisk i imion.
--9 rekordów, ostatni: 13 Layla Owen NULL

SELECT s.first_name, s.surname, s.group_no
FROM students s
FULL OUTER JOIN students_modules sm ON s.student_id=sm.student_id
WHERE module_id IS NULL
ORDER BY surname, first_name ASC

--12.07
--Nazwiska, imiona i identyfikatory studentów, którzy przyst¹pili do egzaminu co najmniej raz oraz daty egzaminów. Jeœli student danego dnia przyst¹pi³ do wielu egzaminów,
--jego dane maj¹ siê pojawiæ tylko raz. Dane posortowane rosn¹co wzglêdem dat.
--50 rekordów, ostatni: Cox Megan, 32, 2018-09-30

SELECT DISTINCT s.surname, s.first_name, s.student_id, sg.exam_date
FROM students s
INNER JOIN student_grades sg ON s.student_id=sg.student_id
WHERE exam_date IS NOT NULL
ORDER BY exam_date ASC

--12.08
--Nazwy wszystkich wyk³adów, liczby godzin przewidziane na ka¿dy z nich oraz identyfikatory, nazwiska i imiona prowadz¹cych. Dane posortowane rosn¹co wed³ug nazw wyk³adów a nastêpnie nazwisk i imion prowadz¹cych.
--26 rekordów, ostatni: Windows server services, 15, 8, Evans Thomas

SELECT m.module_name, m.no_of_hours, m.lecturer_id, e.surname, e.first_name
FROM modules m
LEFT JOIN employees e ON m.lecturer_id=e.employee_id
ORDER BY m.module_name ASC, e.surname ASC, e.first_name ASC

--12.09
--Identyfikatory, nazwiska i imiona studentów zapisanych na wyk³ad z Statistics, posortowane rosn¹co wed³ug nazwiska i imienia.
--4 studentów o identyfikatorach (w podanej kolejnoœci) 32, 10, 12, 2

SELECT s.student_id, s.surname, s.first_name
FROM students s
LEFT JOIN students_modules sm ON s.student_id=sm.student_id
INNER JOIN modules m ON sm.module_id=m.module_id
WHERE module_name = 'Statistics'
ORDER BY surname, first_name 

--12.10
--Nazwiska, imiona i stopnie/tytu³y naukowe pracowników Department of Informatics. Dane posortowane rosn¹co wed³ug nazwisk i imion.
--7 rekordów, pierwszy: Craven Lily doctor

SELECT e.surname, e.first_name, l.acad_position
FROM employees e
RIGHT JOIN lecturers l ON e.employee_id=l.lecturer_id
WHERE department = 'Department of Informatics'
ORDER BY surname, first_name

--12.11
--Nazwiska i imiona wszystkich pracowników, a dla tych, którzy s¹ wyk³adowcami tak¿e nazwy katedr. Dane posortowane rosn¹co wed³ug nazwisk oraz malej¹co wed³ug imion.
--42 rekordy, pierwszy: Brown John NULL
--Odpowiedz na pytanie: czy John Brown, dla którego nazwa katedry jest NULL jest wyk³adowc¹, czy na podstawie otrzymanych danych nie jesteœmy w stanie tego stwierdziæ?
--Czy w udzieleniu odpowiedzi na pytanie pomocny mo¿e byæ projekt logiczny (diagram) bazy danych?

SELECT e.surname, e.first_name, l.department
FROM employees e
FULL OUTER JOIN lecturers l ON e.employee_id=l.lecturer_id
ORDER BY surname ASC, first_name DESC

--12.12
--Nazwiska i imiona wszystkich wyk³adowców wraz z nazwami katedr, w których pracuj¹. Dane posortowane rosn¹co wed³ug nazwisk oraz malej¹co wed³ug imion.
--28 rekordów, pierwszy: Brown Jacob, Department of Economics

SELECT e.surname, e.first_name, l.department
FROM lecturers l
INNER JOIN employees e ON l.lecturer_id=e.employee_id
ORDER BY surname ASC, first_name DESC

--12.13
--Identyfikatory, nazwiska, imiona i stopnie/tytu³y naukowe wyk³adowców, którzy nie prowadz¹ ¿adnego wyk³adu. Dane posortowane malej¹co wed³ug stopni naukowych.
--17 rekordów, pierwszy: 35, Jones Lily, master

SELECT l.lecturer_id, e.surname, e.first_name, l.acad_position
FROM employees e
RIGHT JOIN lecturers l ON e.employee_id=l.lecturer_id
FULL OUTER JOIN modules m ON l.lecturer_id=m.lecturer_id
WHERE no_of_hours IS NULL
ORDER BY l.department DESC

--12.14
--Imiona i nazwiska wszystkich studentów, nazwy wyk³adów, na które s¹ zapisani, nazwiska prowadz¹cych te wyk³ady (pole ma mieæ nazwê lecturer_surname) oraz nazwy katedr,
--w których ka¿dy z wyk³adowców pracuje. Dane posortowane malej¹co wed³ug nazw wyk³adów a nastêpnie rosn¹co wed³ug nazwisk wyk³adowców.
--103 rekordy, pierwszy: Mason Ben, Web applications, Jones, Department of History

SELECT s.surname, s.first_name, module_name, 
e.surname AS lecturer_surname, l.department
FROM students s LEFT JOIN 
 (((students_modules sm INNER JOIN modules m 
ON sm.module_id=m.module_id)
 LEFT JOIN lecturers l ON l.lecturer_id=m.lecturer_id)
  LEFT JOIN employees e ON l.lecturer_id=employee_id) 
ON s.student_id=sm.student_id
ORDER BY module_name DESC, e.surname

--12.15
--Liczba godzin wyk³adów, dla których nie da siê ustaliæ kwoty, jak¹ trzeba zap³aciæ za ich przeprowadzenie.
--Wskazówka: weŸ pod uwagê fakt, ¿e nie jesteœmy w stanie ustaliæ, ile uczelnia musi zap³aciæ za danych wyk³ad w dwóch przypadkach:
--1. 	Gdy w tabeli modules wartoœæ w polu lecturer_id jest Null
--2. 	Gdy w tabeli modules wartoœæ w polu lecturer_id istnieje, ale w tabeli lecturers wyk³adowca prowadz¹cy ten wyk³ad nie ma wpisanego acad_position.
--Wynikiem jest liczba 165

SELECT SUM(no_of_hours)
FROM modules m LEFT JOIN
lecturers l ON m.lecturer_id=l.lecturer_id
WHERE m.lecturer_id IS NULL OR l.acad_position IS NULL;

--12.16
--Identyfikatory, nazwy wyk³adów oraz nazwy katedr odpowiedzialnych za prowadzenie wyk³adów, dla których nie mo¿na ustaliæ kwoty, jak¹ trzeba zap³aciæ za ich przeprowadzenie.
--7 wyk³adów o identyfikatorach 4, 5, 7, 13, 15, 20, 22

SELECT m.module_id, m.module_name, m.department
FROM modules m
LEFT JOIN lecturers l ON m.lecturer_id=l.lecturer_id
WHERE m.lecturer_id IS NULL or l.acad_position IS NULL;

--12.17
--Nazwy wszystkich wyk³adów, których nazwa zaczyna siê od s³owa computer (z uwzglêdnieniem wielkoœci liter – wszystkie litery ma³e)
--oraz liczbê godzin przewidzianych na ka¿dy z tych wyk³adów, nazwiska prowadz¹cych i nazwy katedr, w których pracuj¹. Dane posortowane malej¹co wed³ug nazwisk.
--Wynikiem jest tabela pusta

SELECT m.module_name, m.no_of_hours, e.surname, l.department
FROM modules m
LEFT JOIN lecturers l ON m.lecturer_id = l.lecturer_id
LEFT JOIN employees e ON l.lecturer_id = e.employee_id
WHERE module_name collate polish_cs_as LIKE 'computer%'
ORDER BY e.surname DESC;

--12.18
--Nazwy wszystkich wyk³adów, których nazwa zaczyna siê od s³owa Computer (z uwzglêdnieniem wielkoœci liter – pierwsza litera du¿a) oraz
--liczbê godzin przewidzianych na ka¿dy z tych wyk³adów,nazwiska prowadz¹cych i nazwy katedr, w których pracuj¹. 
--Dane posortowane malej¹co wed³ug nazwisk.
--4 rekordy: Computer networks, Computer network devices, Computer programming oraz Computer programming II 

SELECT m.module_name, m.no_of_hours, l.department, e.surname
FROM modules m
LEFT JOIN lecturers l ON m.lecturer_id=l.lecturer_id
LEFT JOIN employees e ON l.lecturer_id=e.employee_id
WHERE module_name collate polish_cs_as LIKE 'Computer%'
ORDER BY surname DESC

--12.19
--Identyfikatory i nazwiska studentów, którzy nie otrzymali dotychczas oceny z wyk³adów, na które siê zapisali wraz z nazwami tych wyk³adów
--(dane ka¿dego studenta maj¹ siê pojawiæ tyle razy z ilu wyk³adów nie otrzymali oceny). Dane posortowane rosn¹co wed³ug identyfikatorów studentów.
--45 rekordów, np. student o identyfikatorze 2 nie ma ocen z 3 wyk³adów

SELECT s.student_id, surname, module_name
FROM ((students s INNER JOIN students_modules sm 
ON s.student_id=sm.student_id) 
LEFT JOIN student_grades sg ON sg.student_id=sm.student_id AND sg.module_id=sm.module_id) 
INNER JOIN modules m ON m.module_id=sm.module_id
WHERE sg.student_id IS NULL
ORDER BY s.student_id

--12.20
--Identyfikatory i nazwiska studentów, którzy otrzymali oceny z wyk³adów, na które siê zapisali wraz z nazwami tych wyk³adów i otrzymanymi ocenami
--(dane ka¿dego studenta maj¹ siê pojawiæ tyle razy z ilu wyk³adów nie otrzymali oceny). Dane posortowane rosn¹co wed³ug identyfikatorów studentów i nazw wyk³adów a nastêpnie malej¹co wed³ug otrzymanych ocen.
--58 rekordów, pierwszy rekord: 1, Bowen, Computer network devices, 4.5
--student o identyfikatorze 2 (Palmer) ma 6 ocen,

SELECT s.student_id, surname, module_name, grade
FROM ((students s INNER JOIN students_modules sm 
ON s.student_id=sm.student_id) 
LEFT JOIN student_grades sg ON sg.student_id=sm.student_id AND sg.module_id=sm.module_id) 
INNER JOIN modules m ON m.module_id=sm.module_id
WHERE sg.student_id IS NOT NULL
ORDER BY s.student_id, module_name, grade DESC


--12.21
--W polu department tabeli modules przechowywana jest informacja, która katedra jest odpowiedzialna za prowadzenie ka¿dego z wyk³adów.
--Napisz zapytanie, które zwróci nazwy wyk³adów, które s¹ prowadzone przez wyk³adowcê, który nie jest pracownikiem katedry odpowiedzialnej za dany wyk³ad.
--11 rekordów, np.:
--Wyk³ad z Web applications jest przypisany do Department of Informatics a prowadzi go pracownik Department of History.
--Wyk³ad z Management jest przypisany do Department of Management a prowadzi go pracownik Department of Informatics.

SELECT module_name, m.department AS dep_responsible, 
l.department AS dpt_lecturer
FROM modules m inner join lecturers l on m.lecturer_id=l.lecturer_id
WHERE m.department<>l.department


--12.22
--Nazwiska, imiona i PESELe wyk³adowców, którzy prowadz¹ przynajmniej jeden wyk³ad wraz z nazwami prowadzonych przez nich wyk³adów i napisem „wykladowca” w ostatniej kolumnie 
--oraz 
--nazwiska, imiona, numery grup wszystkich studentów wraz z nazwami wyk³adów na które siê zapisali i napisem „student” w ostatniej kolumnie. 
--Trzecia kolumna ma mieæ nazwê pesel/grupa a ostatnia student/wykladowca.
--Dane posortowane rosn¹co wed³ug nazw wyk³adów a nastêpnie wed³ug kolumny student/wykladowca.
--119 rekordów. Rekord nr 11: Chapman Grace DMZa3012 Advanced Statistics student

SELECT surname, first_name, PESEL AS "pesel/grupa", 
module_name, 'wykladowca' AS [student/wykladowca]
FROM employees INNER JOIN modules m 
ON employee_id=lecturer_id
UNION
SELECT surname, first_name, group_no, module_name, 'student'
FROM students s LEFT JOIN (modules m INNER JOIN students_modules sm 
ON m.module_id=sm.module_id) ON s.student_id=sm.student_id
ORDER BY module_name, [student/wykladowca]
