-- SELECT 4a. Grupowanie i funkcje agregujące

-- 4a.01
-- Liczba studentów zarejestrowanych w bazie danych.
-- 35 studentów

SELECT count(*)
FROM students

-- 4a.02
-- Liczba studentów, którzy są przypisani do jakiejś grupy.
-- 28 studentów

SELECT count(group_no)
FROM students

-- 4a.03
-- Liczba studentów, którzy nie są przypisani do żadnej grupy.
-- 7 studentów

SELECT count(*)
FROM students
WHERE group_no IS NULL

-- 4a.04
-- Liczba grup, do których jest przypisany co najmniej jeden student.
-- 12 grup

SELECT count(distinct group_no)
FROM students

-- 4a.05
-- Nazwy grup, do których zapisany jest przynajmniej jeden student wraz z liczbą studentów zapisanych do każdej grupy. Kolumna zwracająca liczbę studentów ma mieć nazwę no_of_students. Dane posortowane rosnąco według liczby studentów.
-- 12 rekordów
-- w pięciu grupach jest po jednym studencie, w czterech po dwóch,
-- w jednej czterech, w jednej pięciu, w jednej sześciu i w jednej siedmiu

SELECT group_no, COUNT(*) AS no_of_students 
FROM students
WHERE group_no IS NOT NULL
GROUP BY group_no
ORDER BY no_of_students

-- 4a.06
-- Nazwy grup, do których zapisanych jest przynajmniej trzech studentów wraz z liczbą tych studentów. Kolumna zwracająca liczbę studentów ma mieć nazwę no_of_students. Dane posortowane rosnąco według liczby studentów.
-- 3 rekordy

SELECT group_no, COUNT(*) AS no_of_students 
FROM students 
WHERE group_no IS NOT NULL
GROUP BY group_no
HAVING COUNT(*)>=3
ORDER BY no_of_students
 
-- 4a.07
-- Wszystkie możliwe oceny oraz ile razy każda z ocen została przyznana (kolumna ma mieć nazwę no_of_grades). Dane posortowane według ocen.
-- 8 rekordów.
-- Ocena 2.0 została przyznane 13 razy.
-- Ocena 5.5 4 razy.
-- Ocena 6.0 nie została przyznana ani raz.

SELECT g.grade, COUNT(sg.student_id) AS no_of_grades 
FROM grades g LEFT JOIN student_grades sg ON g.grade=sg.grade 
GROUP BY g.grade
ORDER BY g.grade

-- 4a.08
-- Nazwy wszystkich katedr oraz ile godzin wykładów w sumie mają pracownicy zatrudnieni w  tych katedrach. Kolumna zwracająca liczbę godzin ma mieć nazwę total_hours. Dane posortowane rosnąco według kolumny total_hours.
-- 11 rekordów
-- Dla pierwszych sześciu total_hours jest NULL
-- Ostatni rekord: Department of Informatics, 117 godzin

SELECT d.department, SUM(no_of_hours) AS total_hours 
FROM departments d LEFT JOIN lecturers l ON d.department=l.department
LEFT JOIN modules m ON l.lecturer_id=m.lecturer_id
GROUP BY d.department
ORDER BY total_hours

-- 4a.09
-- Nazwisko każdego wykładowcy wraz z liczbą prowadzonych przez niego wykładów. Kolumna zawierająca liczbę wykładów ma mieć nazwę no_of_modules. Dane posortowane malejąco według nazwiska.
-- 28 rekordów.
-- Pierwszy: Wright, nie prowadzi żadnego wykładu.
-- Trzeci: White, prowadzi jeden wykład.

SELECT surname, no_of_modules, COUNT(module_id) no_of_lectures
FROM (lecturers INNER JOIN employees ON lecturer_id=employee_id) 
LEFT JOIN modules ON modules.lecturer_id=lecturers.lecturer_id
GROUP BY surname, lecturers.lecturer_id
ORDER BY surname DESC

-- 4a.10
-- Nazwiska i imiona wykładowców prowadzących co najmniej dwa wykłady wraz z liczbą prowadzonych przez nich wykładów. Dane posortowane malejąco według liczby wykładów a następnie rosnąco według nazwiska.
-- 6 rekordów.
-- Pierwszy: Harry Jones, 4 wykłady
-- Ostatni: Lily Taylor, 2 wykłady

SELECT surname, first_name, count(*) AS no_of_modules
FROM modules INNER JOIN employees ON lecturer_id=employee_id
GROUP BY employee_id, surname, first_name
HAVING count(*)>=2
ORDER BY no_of_modules DESC, surname

 
-- 4a.11
-- Nazwiska i imiona wszystkich studentów o nazwisku Bowen, którzy otrzymali przynajmniej jedną ocenę wraz ze średnią ocen (każdego Bowena z osobna). Kolumna zwracająca średnią ma mieć nazwę avg_grade. Dane posortowane malejąco według nazwisk i malejąco według imion.
-- Dwa rekordy: 
-- Harry Bowen, średnia 3.7
-- Charlie Bowen, średnia 2.0

SELECT surname, first_name, AVG(grade) AS avg_grade
FROM students s INNER JOIN student_grades sg 
ON s.student_id=sg.student_id
WHERE surname='Bowen'
GROUP BY s.student_id, surname, first_name
ORDER BY surname DESC, first_name DESC

-- 4a.12
-- Nazwiska i imiona wykładowców, którzy prowadzą co najmniej jeden wykład wraz ze średnią ocen jakie dali studentom (jeśli wykładowca nie dał do tej pory żadnej oceny, także ma się pojawić na liście). Kolumna zwracająca średnią ma mieć nazwę avg_grade. Dane posortowane malejąco według średniej.
-- 11 rekordów. Pierwszy rekord: James Robinson, średnia 5.0.
-- Jeden wykładowca nie wystawił żadnej oceny.

SELECT surname, first_name, AVG(grade) AS avg_grade
FROM employees e INNER JOIN modules m ON employee_id=m.lecturer_id 
LEFT JOIN student_grades sg ON m.module_id=sg.module_id
GROUP BY employee_id, surname, first_name
ORDER BY avg_grade DESC

-- 4a.13a
-- Nazwy wykładów oraz kwotę, jaką uczelnia musi przygotować na wypłaty pracownikom prowadzącym wykłady ze Statistics i Economics (osobno). Jeśli jest wiele wykładów o nazwie Statistics lub Economics, suma dla nich ma być obliczona łącznie. Zapytanie ma więc zwrócić dwa rekordy (jeden dla wykładów ze Statistics, drugi dla Economics).
-- Kwotę za jeden wykład należy obliczyć jako iloczyn stawki godzinowej prowadzącego wykładowcy oraz liczby godzin przeznaczonych na wykład.
-- Zapytanie zwraca jeden rekord: Economics 1200.00

SELECT module_name, SUM(overtime_rate*no_of_hours) sum_of_money
FROM (acad_positions ap INNER JOIN lecturers l 
ON ap.acad_position=l.acad_position)
INNER JOIN modules m ON m.lecturer_id=l.lecturer_id
WHERE module_name in ('Statistics','Economics')
GROUP BY module_name
-- Odpowiedz na pytanie, dlaczego zapytanie nie zwróciło danych o wykładzie Statistics.
-- Odpowiedź:
-- W bazie danych jest jeden taki wykład (o id=5) i ma przypisaną liczbę godzin oraz wykładowcę (id=30). Jednak wykładowca o id=30 nie ma przypisanego stopnia naukowego a od stopnia zależy stawka za godzinę, której w takiej sytuacji nie da się wyliczyć.

 
-- 4a.14a
-- Sumaryczną kwotę, jaką uczelnia musi wypłacić wykładowcom łącznie z tytułu prowadzenia przez nich wykładów.
-- 20265.00

SELECT sum(no_of_hours*overtime_rate) wages
FROM modules m INNER JOIN lecturers l 
ON m.lecturer_id=l.lecturer_id INNER JOIN acad_positions ap 
ON l.acad_position=ap.acad_position
-- Czy zapytanie zwróciło pełną kwotę, jaką uczelnia musi wypłacić z tytułu prowadzenia wykładów?
-- Nie, gdyż w bazie danych mogą być (i są) wykłady, którym nie są przypisani wykładowcy, nie wiadomo więc, ile będą te wykłady kosztować.

 
-- 4a.13d
-- Kwotę, jaką uczelnia musi przygotować na wypłaty z tytułu prowadzenia wszystkich wykładów, za które nie można ustalić stawki godzinowej. Przyjmij założenie, że za godzinę takiego wykładu należy zapłacić maksymalną wartość z pola overtime_rate w tabeli acad_positions.
-- UWAGA:
-- Nie można ustalić kwoty wynagrodzenia za wykłady, które nie mają przypisanego wykładowcy (lecturer_id w tabeli modules jest Null) oraz takie, które mają ustalonego wykładowcę, ale wykładowca ten nie ma przypisanego stopnia/tytułu naukowego (acad_position w tabeli lecturers jest Null).
-- 13200

SELECT
((SELECT sum(no_of_hours) FROM modules WHERE lecturer_id is null)
+
(SELECT sum(no_of_hours)
 FROM modules m inner join lecturers l ON m.lecturer_id=l.lecturer_id
 WHERE acad_position is null))
*
(SELECT max(overtime_rate) FROM acad_positions)
lub
	SELECT
(SELECT sum(no_of_hours)
 FROM modules m left join lecturers l ON m.lecturer_id=l.lecturer_id
 WHERE acad_position is null)
*
(SELECT max(overtime_rate) FROM acad_positions)

-- 4a.14
-- Nazwiska i imiona wykładowców wraz z sumaryczną liczbą godzin wykładów prowadzonych przez każdego z nich z osobna ale tylko w przypadku, gdy suma godzin prowadzonych wykładów jest większa od 30. Kolumna zwracająca liczbę godzin ma mieć nazwę no_of_hours. Dane posortowane malejąco według liczby godzin.
-- 5 rekordów. 
-- Pierwszy: Jones Harry, 72 godziny.
-- Ostatni: Katie Davies 55 godzin.

SELECT surname, first_name, SUM(no_of_hours) AS no_of_hours 
FROM (employees INNER JOIN lecturers l ON employee_id=lecturer_id)
INNER JOIN modules m ON m.lecturer_id=l.lecturer_id
GROUP BY surname, first_name, m.lecturer_id
HAVING SUM(no_of_hours)>30
ORDER BY no_of_hours DESC

 
-- 4a.15
-- Nazwy wszystkich grup oraz liczbę studentów zapisanych do każdej grupy (kolumna ma mieć nazwę no_of_students). Dane posortowane rosnąco według liczby studentów a następnie numeru grupy.
-- 23 rekordy.
-- Do 11 grup nie został zapisany żaden student.
-- Ostatni rekord: grupa DMIe1011, 6 studentów

SELECT g.group_no, COUNT(student_id) AS no_of_students
FROM groups g LEFT JOIN students s ON g.group_no=s.group_no
GROUP BY g.group_no
ORDER BY no_of_students, g.group_no

-- 4a.16
-- Nazwy wszystkich wykładów, których nazwa zaczyna się literą A oraz średnią ocen ze wszystkich tych wykładów osobno (jeśli jest wiele takich wykładów, to średnia ma być obliczona dla każdego z nich oddzielnie). Jeśli z danego wykładu nie ma żadnej oceny, także powinien on pojawić się na liście. Kolumna ma mieć nazwę average.
-- 3 rekordy:
-- Advanced databases NULL
-- Advanced statistics 4.25
-- Ancient history 4.25

SELECT module_name, AVG(grade) AS average
FROM modules m LEFT JOIN student_grades sg 
ON m.module_id=sg.module_id
WHERE module_name LIKE 'A%'
GROUP BY m.module_id, module_name

-- 4a.17
-- Nazwy grup, do których jest zapisanych co najmniej dwóch studentów, liczba studentów zapisanych do tych grup (kolumna ma mieć nazwę no_of_students) oraz średnie ocen dla każdej grupy (kolumna ma mieć nazwę average_grade). Dane posortowane malejąco według średniej.
-- 8 rekordów.
-- Pierwszy: ZMIe2012, liczba studentów 5, średnia 6.6
-- Ostatni: DMIe1014, liczba studentów 2, średnia 3.25

SELECT group_no, COUNT(s.student_id) AS no_of_students, 
AVG(grade) AS average_grade
FROM students s INNER JOIN student_grades sg 
ON s.student_id=sg.student_id
GROUP BY group_no
HAVING COUNT(s.student_id) >= 2
ORDER BY average_grade DESC

 
-- 4a.18
-- Nazwy tych katedr (department), w których pracuje co najmniej 2 doktorów (doctor) wraz z liczbą doktorów pracujących w tych katedrach (ta ostatnia kolumna ma mieć nazwę no_of_doctors). Dane posortowane malejąco według liczby doktorów i rosnąco według nazw katedr.
-- 3 rekordy.
-- Department of Informatics – trzech doktorów.
-- Department of History i Departemt of Mathematics po dwóch doktorów.

SELECT department, count(*) AS no_of_doctors
FROM lecturers
WHERE acad_position='doctor'
GROUP BY department
HAVING count(*)>=2
ORDER BY no_of_doctors DESC, department

-- 4a.19
-- Identyfikatory, nazwy wykładów oraz nazwy katedr odpowiedzialnych za prowadzenie wykładów, dla których nie można ustalić kwoty, jaką trzeba zapłacić za ich przeprowadzenie wraz z nazwiskiem i imieniem dowolnego spośród pracowników tych katedr. 
-- Dane posortowane według module_id.
-- UWAGA: najpierw należy utworzyć pole wyliczane, które połączy nazwisko i imię w jedno pole. Pamiętaj, aby między nazwiskiem i imieniem wstawić spację. 
-- Wskazówka:
-- Użyj funkcji CONCAT
-- CONCAT(poleNazwisko, ‘ ‘ , poleImię)
-- lub operatora +. 
-- poleNazwisko + ‘ ‘ + poleImię
-- 6 rekordów. Wśród module_id są tylko identyfikatory 4, 7, 13, 15, 20, 22

SELECT module_id, module_name, m.department, 
min(concat(surname,' ',first_name)) as lecturer_name
FROM modules m INNER JOIN lecturers l 
ON m.department=l.department
INNER JOIN employees ON l.lecturer_id=employee_id
WHERE m.lecturer_id IS NULL
GROUP BY module_id, module_name, m.department
ORDER BY module_id

