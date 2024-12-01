--12.01
--Identyfikatory i nazwy wyk�ad�w na kt�re nie zosta� zapisany �aden student. Dane posortowane malej�co wed�ug nazw wyk�ad�w.
--4 rekordy, wyk�ady o identyfikatorach 26, 25, 24, 23 (w podanej kolejno�ci)

SELECT m.module_id, m.module_name
FROM modules m
LEFT JOIN students_modules sm ON m.module_id = sm.module_id
WHERE sm.student_id IS NULL

--12.02
--Identyfikatory i nazwy wyk�ad�w oraz nazwiska wyk�adowc�w prowadz�cych wyk�ady, na kt�re nie zapisa� si� �aden student.
--4 rekordy, wyk�ady o identyfikatorach 23, 24, 25, 26

SELECT m.module_id, module_name, surname
FROM (modules m LEFT JOIN students_modules sm 
ON m.module_id=sm.module_id) 
LEFT JOIN employees e ON m.lecturer_id=e.employee_id
WHERE sm.module_id IS NULL

--12.03
--Identyfikatory (pod nazw� lecturer_id) i nazwiska wszystkich wyk�adowc�w wraz z nazwami wyk�ad�w, kt�re prowadz�. Dane posortowane rosn�co wed�ug nazwisk.
--37 rekord�w, w pierwszych dw�ch rekordach s� wyk�adowcy o identyfikatorach 5 i 12

SELECT l.lecturer_id, e.surname
FROM modules m
FULL OUTER JOIN lecturers l ON m.lecturer_id=l.lecturer_id
INNER JOIN employees e ON l.lecturer_id=e.employee_id
ORDER BY surname ASC

--12.04
--Identyfikatory, nazwiska i imiona pracownik�w, kt�rzy s� wyk�adowcami.
--28 rekord�w

SELECT e.employee_id, e.surname, e.first_name
FROM employees e
RIGHT JOIN lecturers l ON e.employee_id=l.lecturer_id

--12.05
--Identyfikatory, nazwiska i imiona pracownik�w, kt�rzy nie s� wyk�adowcami.
--14 rekord�w

SELECT e.employee_id, e.surname, e.first_name
FROM employees e
FULL OUTER JOIN lecturers l ON e.employee_id=l.lecturer_id
WHERE lecturer_id IS NULL 

--12.06
--Identyfikatory, imiona, nazwiska i numery grup student�w, kt�rzy nie s� zapisani na �aden wyk�ad. Dane posortowane rosn�co wed�ug nazwisk i imion.
--9 rekord�w, ostatni: 13 Layla Owen NULL

SELECT s.first_name, s.surname, s.group_no
FROM students s
FULL OUTER JOIN students_modules sm ON s.student_id=sm.student_id
WHERE module_id IS NULL
ORDER BY surname, first_name ASC

--12.07
--Nazwiska, imiona i identyfikatory student�w, kt�rzy przyst�pili do egzaminu co najmniej raz oraz daty egzamin�w. Je�li student danego dnia przyst�pi� do wielu egzamin�w,
--jego dane maj� si� pojawi� tylko raz. Dane posortowane rosn�co wzgl�dem dat.
--50 rekord�w, ostatni: Cox Megan, 32, 2018-09-30

SELECT DISTINCT s.surname, s.first_name, s.student_id, sg.exam_date
FROM students s
INNER JOIN student_grades sg ON s.student_id=sg.student_id
WHERE exam_date IS NOT NULL
ORDER BY exam_date ASC

--12.08
--Nazwy wszystkich wyk�ad�w, liczby godzin przewidziane na ka�dy z nich oraz identyfikatory, nazwiska i imiona prowadz�cych. Dane posortowane rosn�co wed�ug nazw wyk�ad�w a nast�pnie nazwisk i imion prowadz�cych.
--26 rekord�w, ostatni: Windows server services, 15, 8, Evans Thomas

SELECT m.module_name, m.no_of_hours, m.lecturer_id, e.surname, e.first_name
FROM modules m
LEFT JOIN employees e ON m.lecturer_id=e.employee_id
ORDER BY m.module_name ASC, e.surname ASC, e.first_name ASC

--12.09
--Identyfikatory, nazwiska i imiona student�w zapisanych na wyk�ad z Statistics, posortowane rosn�co wed�ug nazwiska i imienia.
--4 student�w o identyfikatorach (w podanej kolejno�ci) 32, 10, 12, 2

SELECT s.student_id, s.surname, s.first_name
FROM students s
LEFT JOIN students_modules sm ON s.student_id=sm.student_id
INNER JOIN modules m ON sm.module_id=m.module_id
WHERE module_name = 'Statistics'
ORDER BY surname, first_name 

--12.10
--Nazwiska, imiona i stopnie/tytu�y naukowe pracownik�w Department of Informatics. Dane posortowane rosn�co wed�ug nazwisk i imion.
--7 rekord�w, pierwszy: Craven Lily doctor

SELECT e.surname, e.first_name, l.acad_position
FROM employees e
RIGHT JOIN lecturers l ON e.employee_id=l.lecturer_id
WHERE department = 'Department of Informatics'
ORDER BY surname, first_name

--12.11
--Nazwiska i imiona wszystkich pracownik�w, a dla tych, kt�rzy s� wyk�adowcami tak�e nazwy katedr. Dane posortowane rosn�co wed�ug nazwisk oraz malej�co wed�ug imion.
--42 rekordy, pierwszy: Brown John NULL
--Odpowiedz na pytanie: czy John Brown, dla kt�rego nazwa katedry jest NULL jest wyk�adowc�, czy na podstawie otrzymanych danych nie jeste�my w stanie tego stwierdzi�?
--Czy w udzieleniu odpowiedzi na pytanie pomocny mo�e by� projekt logiczny (diagram) bazy danych?

SELECT e.surname, e.first_name, l.department
FROM employees e
FULL OUTER JOIN lecturers l ON e.employee_id=l.lecturer_id
ORDER BY surname ASC, first_name DESC

--12.12
--Nazwiska i imiona wszystkich wyk�adowc�w wraz z nazwami katedr, w kt�rych pracuj�. Dane posortowane rosn�co wed�ug nazwisk oraz malej�co wed�ug imion.
--28 rekord�w, pierwszy: Brown Jacob, Department of Economics

SELECT e.surname, e.first_name, l.department
FROM lecturers l
INNER JOIN employees e ON l.lecturer_id=e.employee_id
ORDER BY surname ASC, first_name DESC

--12.13
--Identyfikatory, nazwiska, imiona i stopnie/tytu�y naukowe wyk�adowc�w, kt�rzy nie prowadz� �adnego wyk�adu. Dane posortowane malej�co wed�ug stopni naukowych.
--17 rekord�w, pierwszy: 35, Jones Lily, master

SELECT l.lecturer_id, e.surname, e.first_name, l.acad_position
FROM employees e
RIGHT JOIN lecturers l ON e.employee_id=l.lecturer_id
FULL OUTER JOIN modules m ON l.lecturer_id=m.lecturer_id
WHERE no_of_hours IS NULL
ORDER BY l.department DESC

--12.14
--Imiona i nazwiska wszystkich student�w, nazwy wyk�ad�w, na kt�re s� zapisani, nazwiska prowadz�cych te wyk�ady (pole ma mie� nazw� lecturer_surname) oraz nazwy katedr,
--w kt�rych ka�dy z wyk�adowc�w pracuje. Dane posortowane malej�co wed�ug nazw wyk�ad�w a nast�pnie rosn�co wed�ug nazwisk wyk�adowc�w.
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
--Liczba godzin wyk�ad�w, dla kt�rych nie da si� ustali� kwoty, jak� trzeba zap�aci� za ich przeprowadzenie.
--Wskaz�wka: we� pod uwag� fakt, �e nie jeste�my w stanie ustali�, ile uczelnia musi zap�aci� za danych wyk�ad w dw�ch przypadkach:
--1. 	Gdy w tabeli modules warto�� w polu lecturer_id jest Null
--2. 	Gdy w tabeli modules warto�� w polu lecturer_id istnieje, ale w tabeli lecturers wyk�adowca prowadz�cy ten wyk�ad nie ma wpisanego acad_position.
--Wynikiem jest liczba 165

SELECT SUM(no_of_hours)
FROM modules m LEFT JOIN
lecturers l ON m.lecturer_id=l.lecturer_id
WHERE m.lecturer_id IS NULL OR l.acad_position IS NULL;

--12.16
--Identyfikatory, nazwy wyk�ad�w oraz nazwy katedr odpowiedzialnych za prowadzenie wyk�ad�w, dla kt�rych nie mo�na ustali� kwoty, jak� trzeba zap�aci� za ich przeprowadzenie.
--7 wyk�ad�w o identyfikatorach 4, 5, 7, 13, 15, 20, 22

SELECT m.module_id, m.module_name, m.department
FROM modules m
LEFT JOIN lecturers l ON m.lecturer_id=l.lecturer_id
WHERE m.lecturer_id IS NULL or l.acad_position IS NULL;

--12.17
--Nazwy wszystkich wyk�ad�w, kt�rych nazwa zaczyna si� od s�owa computer (z uwzgl�dnieniem wielko�ci liter � wszystkie litery ma�e)
--oraz liczb� godzin przewidzianych na ka�dy z tych wyk�ad�w, nazwiska prowadz�cych i nazwy katedr, w kt�rych pracuj�. Dane posortowane malej�co wed�ug nazwisk.
--Wynikiem jest tabela pusta

SELECT m.module_name, m.no_of_hours, e.surname, l.department
FROM modules m
LEFT JOIN lecturers l ON m.lecturer_id = l.lecturer_id
LEFT JOIN employees e ON l.lecturer_id = e.employee_id
WHERE module_name collate polish_cs_as LIKE 'computer%'
ORDER BY e.surname DESC;

--12.18
--Nazwy wszystkich wyk�ad�w, kt�rych nazwa zaczyna si� od s�owa Computer (z uwzgl�dnieniem wielko�ci liter � pierwsza litera du�a) oraz
--liczb� godzin przewidzianych na ka�dy z tych wyk�ad�w,nazwiska prowadz�cych i nazwy katedr, w kt�rych pracuj�. 
--Dane posortowane malej�co wed�ug nazwisk.
--4 rekordy: Computer networks, Computer network devices, Computer programming oraz Computer programming II 

SELECT m.module_name, m.no_of_hours, l.department, e.surname
FROM modules m
LEFT JOIN lecturers l ON m.lecturer_id=l.lecturer_id
LEFT JOIN employees e ON l.lecturer_id=e.employee_id
WHERE module_name collate polish_cs_as LIKE 'Computer%'
ORDER BY surname DESC

--12.19
--Identyfikatory i nazwiska student�w, kt�rzy nie otrzymali dotychczas oceny z wyk�ad�w, na kt�re si� zapisali wraz z nazwami tych wyk�ad�w
--(dane ka�dego studenta maj� si� pojawi� tyle razy z ilu wyk�ad�w nie otrzymali oceny). Dane posortowane rosn�co wed�ug identyfikator�w student�w.
--45 rekord�w, np. student o identyfikatorze 2 nie ma ocen z 3 wyk�ad�w

SELECT s.student_id, surname, module_name
FROM ((students s INNER JOIN students_modules sm 
ON s.student_id=sm.student_id) 
LEFT JOIN student_grades sg ON sg.student_id=sm.student_id AND sg.module_id=sm.module_id) 
INNER JOIN modules m ON m.module_id=sm.module_id
WHERE sg.student_id IS NULL
ORDER BY s.student_id

--12.20
--Identyfikatory i nazwiska student�w, kt�rzy otrzymali oceny z wyk�ad�w, na kt�re si� zapisali wraz z nazwami tych wyk�ad�w i otrzymanymi ocenami
--(dane ka�dego studenta maj� si� pojawi� tyle razy z ilu wyk�ad�w nie otrzymali oceny). Dane posortowane rosn�co wed�ug identyfikator�w student�w i nazw wyk�ad�w a nast�pnie malej�co wed�ug otrzymanych ocen.
--58 rekord�w, pierwszy rekord: 1, Bowen, Computer network devices, 4.5
--student o identyfikatorze 2 (Palmer) ma 6 ocen,

SELECT s.student_id, surname, module_name, grade
FROM ((students s INNER JOIN students_modules sm 
ON s.student_id=sm.student_id) 
LEFT JOIN student_grades sg ON sg.student_id=sm.student_id AND sg.module_id=sm.module_id) 
INNER JOIN modules m ON m.module_id=sm.module_id
WHERE sg.student_id IS NOT NULL
ORDER BY s.student_id, module_name, grade DESC


--12.21
--W polu department tabeli modules przechowywana jest informacja, kt�ra katedra jest odpowiedzialna za prowadzenie ka�dego z wyk�ad�w.
--Napisz zapytanie, kt�re zwr�ci nazwy wyk�ad�w, kt�re s� prowadzone przez wyk�adowc�, kt�ry nie jest pracownikiem katedry odpowiedzialnej za dany wyk�ad.
--11 rekord�w, np.:
--Wyk�ad z Web applications jest przypisany do Department of Informatics a prowadzi go pracownik Department of History.
--Wyk�ad z Management jest przypisany do Department of Management a prowadzi go pracownik Department of Informatics.

SELECT module_name, m.department AS dep_responsible, 
l.department AS dpt_lecturer
FROM modules m inner join lecturers l on m.lecturer_id=l.lecturer_id
WHERE m.department<>l.department


--12.22
--Nazwiska, imiona i PESELe wyk�adowc�w, kt�rzy prowadz� przynajmniej jeden wyk�ad wraz z nazwami prowadzonych przez nich wyk�ad�w i napisem �wykladowca� w ostatniej kolumnie 
--oraz 
--nazwiska, imiona, numery grup wszystkich student�w wraz z nazwami wyk�ad�w na kt�re si� zapisali i napisem �student� w ostatniej kolumnie. 
--Trzecia kolumna ma mie� nazw� pesel/grupa a ostatnia student/wykladowca.
--Dane posortowane rosn�co wed�ug nazw wyk�ad�w a nast�pnie wed�ug kolumny student/wykladowca.
--119 rekord�w. Rekord nr 11: Chapman Grace DMZa3012 Advanced Statistics student

SELECT surname, first_name, PESEL AS "pesel/grupa", 
module_name, 'wykladowca' AS [student/wykladowca]
FROM employees INNER JOIN modules m 
ON employee_id=lecturer_id
UNION
SELECT surname, first_name, group_no, module_name, 'student'
FROM students s LEFT JOIN (modules m INNER JOIN students_modules sm 
ON m.module_id=sm.module_id) ON s.student_id=sm.student_id
ORDER BY module_name, [student/wykladowca]
