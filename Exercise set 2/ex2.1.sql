Skill 2.1. Query data by using subqueries and APPLY.

-- 21.01
-- Identyfikatory i nazwy wykładów, na które nie został zapisany żaden student. Dane posortowane malejąco według nazw wykładów. 
-- Użyj składni podzapytania.
-- 4 rekordy, wykłady o identyfikatorach 26, 25, 24 i 23 (w podanej kolejności)

SELECT module_id, module_name 
FROM modules
WHERE module_id NOT IN
(SELECT module_id FROM students_modules)
 ORDER BY module_name DESC

-- 21.02
-- Identyfikatory studentów, którzy przystąpili do egzaminu zarówno 2018-03-22 jak i 2018 09 30. Dane posortowane malejąco według identyfikatorów. 
-- Napisz dwie wersje tego zapytania: raz używając składni podzapytania, drugi raz operatora INTERSECT.
-- Studenci o identyfikatorach 18 i 2 (w podanej kolejności)

-- Podzapytanie:

SELECT student_id
FROM student_grades 
WHERE exam_date='20180322' AND student_id IN
(SELECT student_id
 FROM student_grades
 WHERE exam_date='20180930')
ORDER BY student_id DESC

-- Z operatorem INTERSECT:

SELECT student_id
FROM student_grades
WHERE exam_date='20180322'
INTERSECT
SELECT student_id
FROM student_grades
WHERE exam_date='20180930'
ORDER BY student_id DESC

-- 21.03
-- Identyfikatory, nazwiska, imiona i numery grup studentów, którzy zapisali się zarówno na wykład o identyfikatorze 2 jak i 4. Dane posortowane malejąco według nazwisk.
-- Użyj składni podzapytania a w zapytaniu zewnętrznym także złączenia.
-- 3 rekordy, studenci o identyfikatorach 16, 3, 20 (w podanej kolejności)

SELECT s.student_id,surname, first_name, group_no
FROM students s INNER JOIN students_modules sm 
ON s.student_id=sm.student_id
WHERE sm.module_id=2 AND s.student_id IN 
(SELECT sm.student_id
 FROM students_modules sm
 WHERE sm.module_id=4)
ORDER BY surname DESC

-- 21.04
-- Identyfikatory, nazwiska i imiona studentów, którzy zapisali się na wykład z matematyki (Mathematics) ale nie zapisali się na wykład ze statystyki (Statistics). 
-- Zapytanie napisz korzystając ze składni podzapytania, według następującego algorytmu:
-- •	najbardziej wewnętrznym zapytaniem wybierz identyfikatory studentów, którzy zapisali się na wykład ze statystyki (tu potrzebne będzie złączenie),
-- •	kolejnym zapytaniem wybierz identyfikatory studentów, którzy zapisali się na wykład z matematyki (także potrzebne będzie złączenie) oraz nie zapisali sią na wykład ze statystyki (ich identyfikatory nie należą do zbioru zwróconego przez poprzednie zapytanie),
-- •	zewnętrznym zapytaniem wybierz dane o studentach, których identyfikatory należą do zbioru zwróconego przez zapytanie środkowe.
-- 5 rekordów, studenci o identyfikatorach 3, 6, 16, 20, 33

SELECT student_id, surname, first_name
FROM students
WHERE student_id IN
(SELECT student_id
 	 FROM students_modules sm INNER JOIN modules m 
ON sm.module_id=m.module_id
 WHERE module_name='Mathematics'
		AND student_id NOT IN
(SELECT student_id
  FROM students_modules sm INNER JOIN modules m 
ON sm.module_id=m.module_id
 WHERE module_name='Statistics'))

-- 21.05
-- Imiona, nazwiska i numery grup studentów z grup, których nazwa zaczyna się na DMIe i kończy cyfrą 1 i którzy nie są zapisani na wykład z „Ancient history”.
-- Użyj składni zapytania negatywnego a w zapytaniu wewnętrznym także złączenia.
-- 3 rekordy (studenci z grupy DMIe1011 o nazwiskach Hunt, Holmes i Lancaster)

SELECT first_name, surname, group_no
FROM students 
WHERE group_no LIKE 'DMIe%1' AND student_id NOT IN 
(SELECT student_id FROM students_modules sm 
INNER JOIN modules m ON sm.module_id=m.module_id
 WHERE module_name='Ancient history')

-- 21.06
-- Nazwy wykładów o najmniejszej liczbie godzin. Zapytanie, oprócz nazw wykładów, ma zwrócić także liczbę godzin.
-- Użyj operatora ALL.
-- Jeden wykład: Advanced Statistics, 9 godzin

SELECT module_name, no_of_hours
FROM modules
WHERE no_of_hours <= ALL
(SELECT no_of_hours FROM modules)

-- 21.07
-- Identyfikatory i nazwiska studentów, którzy otrzymali ocenę wyższą od najniższej. Dane każdego studenta mają się pojawić tyle razy, ile takich ocen otrzymał.
-- Użyj operatora ANY. W zapytaniu nie wolno posługiwać się liczbami oznaczającymi oceny 2, 3, itd.) ani funkcjami agregującymi (MIN, MAX).
-- 45 rekordów

SELECT s.student_id, surname
FROM students s INNER JOIN student_grades sg 
ON s.student_id=sg.student_id
WHERE grade > ANY
(SELECT grade FROM grades)

-- Sprawdź, czy liczba rekordów zwróconych przez zapytanie jest poprawna, wykonując odpowiednie zapytanie do tabeli student_grades (wybierające rekordy, w których ocena jest wyższa niż 2).

-- 21.08
-- Napisz jedno zapytanie, które zwróci dane o najmłodszym i najstarszym studencie (do połączenia tych danych użyj jednego z operatorów typu SET). 
-- W zapytaniu nie wolno używać funkcji agregujących (MIN, MAX).
-- Uwaga: należy uwzględnić fakt, że data urodzenia w tabeli students może być NULL, do porównania należy więc wybrać rekordy, które w polu date_of_birth mają wpisane daty.
-- Użyj operatora ALL.
-- Najstarszym studentem jest Melissa Hunt urodzona 1978-10-18
-- Najmłodszym studentem jest Layla Owen urodzona 2001-06-20

SELECT *
FROM students
WHERE date_of_birth <= ALL
(SELECT date_of_birth FROM students where date_of_birth is not null)
UNION
SELECT *
FROM students
WHERE date_of_birth >= ALL
(SELECT date_of_birth FROM students where date_of_birth is not null)
Napisz zapytanie do tabeli students i sprawdź, czy otrzymane dane o najmłodszych i najstarszych studentach są poprawne.

-- 21.09a
-- Identyfikatory, imiona i nazwiska studentów z grupy DMIe1011, którzy otrzymali oceny z egzaminu wcześniej, niż wszyscy pozostali studenci z innych grup (nie uwzględniamy studentów, którzy nie są zapisani do żadnej grupy). Dane każdego studenta mają się pojawić tylko raz.
-- Użyj złączenia i operatora ALL.
-- 3 rekordy, studenci o identyfikatorach 1, 3 i 6

SELECT DISTINCT s.student_id, first_name, surname
FROM students s INNER JOIN student_grades sg 
ON sg.student_id=s.student_id
WHERE group_no = 'DMIe1011' AND exam_date < ALL 
(SELECT exam_date FROM students s INNER JOIN
student_grades sg  ON sg.student_id=s.student_id
WHERE group_no <> 'DMIe1011')


-- 21.09b
-- Jak wyżej, ale tym razem należy uwzględnić studentów, którzy nie są zapisani do żadnej grupy.
-- Wynikiem jest tabela pusta

SELECT DISTINCT s.student_id, first_name, surname
FROM students s INNER JOIN student_grades sg 
ON sg.student_id=s.student_id
WHERE group_no = 'DMIe1011' AND exam_date < ALL 
(SELECT exam_date FROM students s INNER JOIN
student_grades sg  ON sg.student_id=s.student_id
WHERE group_no <> 'DMIe1011' OR group_no IS NULL)

-- Odpowiedz na pytanie, jaki jest identyfikator studenta, którego ocena spowodowała, że wynikiem jest tabela pusta?
-- Jest to student o identyfikatorze 2, który otrzymał ocenę 2018-02-21 i była to najwcześniej przyznana ocena (w tym dniu ocenę otrzymało jeszcze dwóch studentów o identyfikatorach 1 i 3 z grupy DMIe1011).

-- 21.10
-- Nazwy wykładów, którym przypisano największą liczbę godzin (wraz z liczbą godzin).
-- Wyko¬rzystaj składnię podzapytania z operatorem =. W zapytaniu wewnętrznym użyj funkcji MAX.
-- Jeden rekord: Econometrics, 45 godzin

SELECT module_name, no_of_hours
FROM modules
WHERE no_of_hours =
(SELECT max(no_of_hours)
FROM modules)

-- 21.11
-- Nazwy wykładów, którym przypisano liczbę godzin większą od najmniejszej. 
-- Użyj funkcji MIN i składni podzapytania z operatorem >.
-- 25 rekordów

SELECT module_name
FROM modules
WHERE no_of_hours >
(SELECT min(no_of_hours)
 FROM modules)

-- 21.12a
-- Wszystkie dane o najstarszym studencie z każdej grupy. 
-- Użyj funkcji MIN i składni podzapytania skorelowanego z operatorem =.
-- 11 rekordów, np. w grupie DMIe1013 najstarszy jest Elliot Fisher, ur. 1998-07-19

SELECT *
FROM students s1
WHERE date_of_birth = 
(SELECT min(date_of_birth)
 FROM students s2
 WHERE s1.group_no=s2.group_no)

21.12b
Wszystkie numery grup z tabeli students posortowane według numerów grup. Każda grupa ma się pojawić jeden raz.

SELECT DISTINCT group_no FROM students

-- Zapytanie zwróciło 13 rekordów. Ponieważ jedną z wartości jest NULL, więc studenci są przypisani do 12 różnych grup. Poprzednie zapytanie, zwracające dane o najmłodszym studencie z każdej grupy, zwróciło 11 rekordów. Znajdź przyczynę tej różnicy.

-- Zapytanie:

SELECT * 
FROM students 
ORDER BY group_no

-- zwróciło dane, z których wynika, że do grupy ZMIe2012 został przypisany tylko jeden student (o identyfikatorze 18), który w dodatku nie ma wpisanej daty urodzenia. Zapytanie zwracające dane o najmłodszym studencie z każdej grupy pominęło więc tę grupę.

-- 21.13
-- Identyfikatory, nazwiska i imiona studentów, którzy otrzymali ocenę 5.0. Nazwisko każdego studenta ma się pojawić jeden raz. 
-- Użyj operatora EXISTS.
-- 6 studentów o identyfikatorach 1, 2, 14, 18, 19, 21

SELECT student_id, surname, first_name
FROM students s
WHERE EXISTS
(SELECT *
FROM student_grades sg
WHERE s.student_id=sg.student_id AND grade=5)

-- Napisz zapytanie:
-- SELECT * FROM student_grades where grade=5
-- i sprawdź otrzymany wynik.

-- 21.14a
-- Wszystkie dane o wykładach, w których uczestnictwo wymaga wcześniejszego uczestnictwa w wykładzie o identyfikatorze 3. 
-- Użyj operatora EXISTS.
-- Trzy wykłady o identyfikatorach 10, 16 i 25

SELECT *
FROM modules m1
WHERE EXISTS 
(SELECT *
FROM modules m2
WHERE m1.module_id=m2.module_id AND m2.preceding_module=3)
Aby sprawdzić otrzymany wynik napisz zapytanie:
SELECT module_id
FROM modules
WHERE preceding_module=3 

-- 21.14b
-- Nazwy wykładów, w których uczestnictwo wymaga wcześniejszego uczestnictwa w wykładzie z matematyki (Mathematics). 
-- Użyj operatora EXISTS.
-- Wskazówka: id. wykładu z matematyki znajdź przy pomocy odpowiedniego zapytania.
-- Dwa wykłady: Statistics i Mathematics II

SELECT module_name
FROM modules m1
WHERE EXISTS 
(SELECT *
 FROM modules m2
 WHERE m1.module_id=m2.module_id AND m2.preceding_module IN
(SELECT module_id FROM modules 
 WHERE module_name='Mathematics'))

-- 21.15a
-- Dane studentów z grupy DMIe1011 wraz z najwcześniejszą datą planowanego dla nich egzaminu (pole planned_exam_date w tabeli students_modules). Zapytanie nie zwraca danych o studentach, którzy nie mają wyznaczonej takiej daty. Sortowanie rosnące według planned_exam_date a następnie student_id.
-- Użyj operatora APPLY.
-- Uwaga: należy uwzględnić fakt, że data planowanego egzaminu może być NULL.
-- 3 rekordy, studenci o identyfikatorach 3, 29 i 1 (w takiej kolejności)
-- Najwcześniejsza planned_exam_date dla studenta o id=3 to 2018-03-21

SELECT *
FROM students s
CROSS APPLY
(SELECT Top(1) planned_exam_date
 FROM students_modules sm
 WHERE s.student_id=sm.student_id 
and planned_exam_date IS NOT NULL
 ORDER BY planned_exam_date) AS t
WHERE group_no='DMIe1011'
ORDER BY planned_exam_date, student_id

-- 21.15b
-- Jak wyżej, tylko zapytanie ma zwrócić najpóźniejszą datę planowanego egzaminu. Ponadto zapytanie ma także zwrócić dane o studentach, którzy nie mają wyznaczonej takiej daty. Sortowanie rosnące według planned_exam_date.
-- Użyj operatora APPLY.
-- 6 rekordów, studenci o identyfikatorach 4, 6, 30 (dla których planned_exam_date jest NULL)
-- 	oraz 29, 3 i 1 (z istniejącą planned_exam_date).
-- Najwcześniejsza planned_exam_date dla studenta o id=3 to 2018-10-13

SELECT *
FROM students s
OUTER APPLY
(SELECT Top(1) planned_exam_date
 FROM students_modules sm
 WHERE s.student_id=sm.student_id 
and planned_exam_date IS NOT NULL
 ORDER BY planned_exam_date DESC) AS t
WHERE group_no='DMIe1011'
ORDER BY planned_exam_date, student_id

-- Zapytanie różni się od poprzedniego tym, że należy użyć operatora OUTER APPLY 
-- (zamiast CROSS APPLY) oraz w podzapytaniu sortowanie według planned_exam_date ma być malejące (DESC).

-- 21.16a
-- Identyfikatory i nazwiska studentów oraz dwie najlepsze oceny dla każdego studenta wraz z datami ich przyznania. Zapytanie uwzględnia tylko studentów, którym została przyznana co najmniej jedna ocena.
-- Użyj operatora APPLY.
-- 37 rekordów.
-- Ostatni rekord: 33, Bowen, 2.0, 2018-09-23
-- Np. w przypadku studentów o id=1, 2 i 3 zwrócone zostały po dwie oceny.
-- W przypadku studenta o id=4 jedna ocena.
-- Student o id=5 nie otrzymał żadnej oceny.

SELECT student_id, surname, grade, exam_date
FROM students s
CROSS APPLY
(SELECT Top(2) grade, exam_date
 FROM student_grades sg
 WHERE s.student_id=sg.student_id 
 ORDER BY grade DESC) AS t

-- 21.16b
-- Identyfikatory i nazwiska studentów oraz dwie najgorsze oceny dla każdego studenta wraz z datami ich przyznania. Zapytanie uwzględnia także studentów, którym nie została przyznana żadna ocena.
-- Użyj operatora APPLY.
-- 51 rekordów.
-- Pierwszy: 1, Bowen, 2.0, 2018-03-22
-- Ostatni: 35, Fisher, NULL, NULL
-- W kilku przypadkach (np. studenci o id: 5, 11, 13, 16) studenci nie otrzymali żadnej oceny.

SELECT student_id, surname, grade, exam_date
FROM students s
OUTER APPLY
(SELECT Top(2) grade, exam_date
 FROM student_grades sg
 WHERE s.student_id=sg.student_id 
 ORDER BY grade) AS t

-- Zapytanie różni się od poprzedniego tym, że należy użyć operatora OUTER APPLY 
-- (zamiast CROSS APPLY) oraz w podzapytaniu sortowanie według grade ma być rosnące.

-- 21.17
-- Identyfikatory i nazwiska studentów oraz kwoty dwóch ostatnich wpłat za studia wraz z datami tych wpłat. Zapytanie uwzględnia także studentów, którzy nie dokonali żadnej wpłaty.
-- Użyj operatora APPLY.
-- 54 rekordy.
-- Trzeci: 2, Palmer, 450.00, 2018-10-30
-- W kilku przypadkach (np. studenci o id: 9, 10, 20) studenci nie dokonali żadnej wpłaty.

SELECT student_id, surname, fee_amount, date_of_payment
FROM students s
OUTER APPLY
(SELECT Top(2) fee_amount, date_of_payment
 FROM tuition_fees tf
 WHERE s.student_id=tf.student_id 
 ORDER BY date_of_payment DESC) AS t

-- 21.18
-- Nazwę modułu poprzedzającego dla modułu Databases.
-- Information technology

select module_name
from modules
where module_id in
(select preceding_module
from modules
where module_name='databases')

