
#Load Packages RSQLite, sqldf, DBI
#Create a database
FinalPracticedb <- dbConnect(RSQLite::SQLite(),"FinalPractice-db.sqlite")  #run this code every time you open 

#Import files into working directory 
employee <- read.csv("C:/Users/Jaime/Documents/EMPLOYEE.txt")
stock_total <- read.csv("C:/Users/Jaime/Documents/STOCK_TOTAL.txt")
employee_phone <- read.csv("C:/Users/Jaime/Documents/EMPLOYEE_PHONE.txt")
invoices <- read.csv("C:/Users/Jaime/Documents/INVOICES.txt")
sales_order_line <- read.csv("C:/Users/Jaime/Documents/SALES_ORDER_LINE.txt")
sales_order <- read.csv("C:/Users/Jaime/Documents/SALES_ORDER.txt")
product <- read.csv("C:/Users/Jaime/Documents/PRODUCT.txt")
customer <- read.csv("C:/Users/Jaime/Documents/CUSTOMER.txt")

dbExistsTable(Labdb, "PRODUCT")
dbGetQuery(Labdb, 'Select Prod_NO, Quantity, PROD_NO*QUANTITY FROM SalesOrderLine WHERE Order_NO = 1')
dbGetQuery(Labdb, 'SELECT AVG(AGE) FROM EMPLOYEE')
Final <- dbConnect(RSQLite::SQLite(), "FINAL-db.sqlite")
employee <- read.csv()
dbWriteTable(FINAl, "employee", employee)





#populate the database
dbWriteTable(FinalPracticedb, "employee",employee)
dbWriteTable(FinalPracticedb, "stock_total",stock_total)
dbWriteTable(FinalPracticedb, "employee_phone",employee_phone)
dbWriteTable(FinalPracticedb, "invoices", invoices)
dbWriteTable(FinalPracticedb, "sales_order_line",sales_order_line)
dbWriteTable(FinalPracticedb, "sales_order",sales_order)
dbWriteTable(FinalPracticedb, "product", product)
dbWriteTable(FinalPracticedb, "customer",customer)

#List the relations in the database
dbListTables(FinalPracticedb)

#SELECT vs. SELECT DISTINCT 
dbGetQuery(FinalPracticedb, 'SELECT NAME FROM employee')  #Note that there are 2 "SMITH"s
dbGetQuery(FinalPracticedb, 'SELECT DISTINCT NAME FROM employee')  #SELECT DISTINCT returns the names without repeats
#SELECT with a condition
dbGetQuery(FinalPracticedb, 'SELECT CUST_NO, NAME FROM customer WHERE (NAME = "ALEX")')

#Add the department relation
department <- read.csv("C:/Users/Jaime/Documents/DEPARTMENT.txt")
dbWriteTable(FinalPracticedb, "department",department)

#dbGetQuery practice questions
dbGetQuery(FinalPracticedb, 'SELECT DATE FROM sales_order WHERE CUST_NO = "C3"')
dbGetQuery(FinalPracticedb, 'SELECT EMP_NO FROM EMPLOYEE ')
dbGetQuery(FinalPracticedb, 'SELECT EMP_NO, NAME, AGE FROM EMPLOYEE ')
dbGetQuery(FinalPracticedb, 'SELECT * FROM product WHERE NOT(color = "BLUE") AND (NAME = "SOCKS" OR "NAME = SHIRTS")') #NOT is evaluated before AND/OR

#Testing for null values
dbGetQuery(FinalPracticedb, 'SELECT * FROM DEPARTMENT WHERE MANAGER IS "null"')

#To update an existing relation, first fix the text file, then
dbWriteTable(FinalPracticedb,"sales_order_line",sales_order_line, overwrite = TRUE)  #overwrite is all lowercase

#Computation
dbGetQuery(FinalPracticedb, 'SELECT PROD_NO, QUANTITY, PRICE*QUANTITY FROM invoices')

#Operators for comparing strings
dbGetQuery(FinalPracticedb, 'SELECT * FROM employee WHERE NAME = "BROWN"')
dbGetQuery(FinalPracticedb, 'SELECT * FROM employee WHERE NAME != "BROWN"')
dbGetQuery(Labdb, 'SELECT * FROM EMPLOYEE WHERE NAME != "BROWN"')
dbGetQuery(FinalPracticedb, 'SELECT * FROM employee WHERE NAME > "BROWN"')
dbGetQuery(FinalPracticedb, 'SELECT * FROM employee WHERE NAME < "BROWN"')
dbGetQuery(FinalPracticedb, 'SELECT * FROM employee WHERE NAME < "SMITH"')

#Summarizing functions
dbGetQuery(FinalPracticedb, 'SELECT AVG(QUANTITY) FROM invoices')
dbGetQuery(FinalPracticedb, 'SELECT AVG(QUANTITY), MIN(QUANTITY) FROM invoices')
dbGetQuery(FinalPracticedb, 'SELECT COUNT(*) FROM invoices')
dbGetQuery(FinalPracticedb, 'SELECT AVG(QUANTITY), MIN(QUANTITY) FROM invoices WHERE PROD_NO = "p2"')

#Group by
dbGetQuery(FinalPracticedb, 'SELECT PROD_NO, SUM(QUANTITY) FROM invoices GROUP BY PROD_NO')
#Group by having
dbGetQuery(FinalPracticedb, 'SELECT ORDER_NO, SUM(QUANTITY) FROM invoices GROUP BY ORDER_NO HAVING SUM(QUANTITY) > 20')

#Order by
dbGetQuery(FinalPracticedb, 'SELECT * FROM product ORDER BY NAME')  #orders by name alphabetically
dbGetQuery(FinalPracticedb, 'SELECT PROD_NO, NAME, COLOR FROM product ORDER BY 2 ASC')  #attributes are denoted by numbers too
dbGetQuery(FinalPracticedb, 'SELECT PROD_NO, NAME, COLOR FROM product ORDER BY 2 DESC') #DESC will order tuples in descending order
dbGetQuery(FinalPracticedb, 'SELECT * FROM employee ORDER BY 5 DESC')

#Join
dbGetQuery(FinalPracticedb, 'SELECT * FROM customer JOIN product')
#Natural join
dbGetQuery(FinalPracticedb, 'SELECT * FROM sales_order NATURAL JOIN customer')
dbGetQuery(FinalPracticedb, 'SELECT * FROM sales_order_line NATURAL JOIN product')
#Inner join
dbGetQuery(FinalPracticedb, 'SELECT * FROM sales_order_line 
           INNER JOIN product ON product.PROD_NO = sales_order_line.PROD_NO')
#Equivalent to inner join
dbGetQuery(FinalPracticedb, 'SELECT product.*, sales_order_line.* FROM product, 
           sales_order_line WHERE product.PROD_NO = sales_order_line.PROD_NO')
#Inner join vs. Left join
dbGetQuery(Labdb, 'SELECT * FROM department INNER JOIN employee WHERE employee.NAME = department.NAME')
dbGetQuery(FinalPracticedb, 'SELECT * FROM department LEFT JOIN employee ON employee.NAME = department.NAME')

#Selecting which attributes to order
dbGetQuery(FinalPracticedb, 'SELECT PROD_NO, NAME FROM product ORDER BY 2')  #the 2 represents the second attribute between the 2 specified by the SELECT command
dbReadTable(Labdb, "Product")
dbGetQuery(Labdb, 'SELECT PROD_NO, NAME FROM product ORDER BY 1 DESC')
#Returning temporarily renames attributes
dbGetQuery(FinalPracticedb, 'SELECT NAME AS FNAME FROM customer')

#Correlation names
dbGetQuery(FinalPracticedb, 'SELECT C.NAME AS FNAME FROM customer C')
dbGetQuery(FinalPracticedb, 'SELECT * FROM PRODUCT P, SALES_ORDER_LINE S 
           WHERE P.PROD_NO = S.PROD_NO')

#Which products will need to be re-stocked once the current orders have been filled?
dbGetQuery(FinalPracticedb, 'SELECT S.PROD_NO AS RESTOCK FROM stock_total S, 
                            sales_order_line O 
                            WHERE O.PROD_NO = RESTOCK AND O.QUANTITY >= S.QUANTITY')
dbGetQuery(Labdb, 'SELECT S.PROD_NO AS RESTOCK FROM Stock S, 
                  SalesOrderLine O WHERE O.PROD_NO = RESTOCK')
dbListTables(Labdb)
dbReadFields(Labdb, "SalesOrderLine")
dbReadTable(Labdb, "STOCK")
#Retrieve the product namesand product colors that have been ordered by ALEX
dbGetQuery(FinalPracticedb, 'SELECT DISTINCT C.NAME AS CustName, P.NAME AS ProductName, COLOR AS RequiredColor FROM customer C, sales_order_line O, sales_order S, product P WHERE C.NAME = "ALEX" AND C.CUST_NO = S.CUST_NO AND S.ORDER_NO = O.ORDER_NO AND O.PROD_NO = P.PROD_NO')

#Nested selects
##Check thet the relation product in your database is a data fram
is.data.frame(dbGetQuery(Labdb, 'SELECT * FROM PRODUCT'))
##what is the totdal quantity of Product p2 invoiced?
dbGetQuery(Labdb, 'SELECT PROD_NO, SUM(QUANTITY) FROM INVOICES WHERE PROD_NO = "p2"')
##write a query that returns the colors in product in descending order
dbGetQuery(Labdb, 'SELECT COLOR, PROD_NO FROM PRODUCT GROUP BY COLOR DESC')
dbGetQuery(Labdb, 'SELECT * FROM EMPLOYEE WHERE AGE BETWEEN 21 AND 31')

dbGetQuery(Labdb, 'SELECT * FROM PRODUCT')
dbGetQuery(Labdb, 'SELECT * FROM EMPLOYEE JOIN PRODUCT')
m <- matrix(nrow = 2, ncol = 3)
dim(m)
x <- c("a", "b", "c", "c", "d", "a")
as.factor(x)
x[1:4]
table(x)
x <- factor(c("yes", "yes", "no", "yes", "no"))
table(x)
x <- data.frame(foo = 1:4, bar = c(T, T, F, F))
x
x<- c(4,6,5,7,10,9,4,15)
y<- c(0,10,1,8,2,3,4,1)
x*y
x <- c(2,3,4,5,6)
x[1]
x<-seq(from =15, to =5, by = -.2)
x[3]
## SELECT FROM INNER JOIN ON
 #Find the product numbers corresponding to the order numbers
dbGetQuery(FinalPracticedb, 'SELECT PROD_NO FROM sales_order_line WHERE ORDER_NO = "01" OR ORDER_NO = "02"')
#Nested SELECT statements
dbGetQuery(FinalPracticedb, 'SELECT NAME, COLOR FROM product WHERE PROD_NO IN (SELECT PROD_NO FROM sales_order_line WHERE ORDER_NO = "01" OR ORDER_NO = "02")')  #The nested query does not have quotation marks
dbGetQuery(FinalPracticedb, 'SELECT NAME, COLOR, PROD_NO FROM PRODUCT WHERE PROD_NO IN
           (SELECT PROD_NO 
           FROM sales_order_line
           WHERE order_NO = "01" OR ORDER_NO = "02")')

#Creating new relations from Query results
dbGetQuery(FinalPracticedb, 'SELECT * FROM product')  
NEWTABLE <- dbGetQuery(FinalPracticedb, 'SELECT * FROM product')  #Create a new R object that contains all the entries in product
dbWriteTable(FinalPracticedb, "NEWTABLE",NEWTABLE)  #Add the NEWTABLE relation into the database
dbListTables(FinalPracticedb)  #verify that the relation was successfully added
is.data.frame(NEWTABLE)
NEWTABLE <- dbGetQuery(FinalPracticedb, 'SELECT CUST_NO, NAME FROM customer')  #overwrite NEWTABLE object
View(NEWTABLE)
dbWriteTable(Labdb, "NEWTABLE", NEWTABLE, overwrite = TRUE)  #overwrite the existing relation in the database
dbWriteTable(Labdb, "NEWTABLE", NEWTable, OVERWRITE = TRUE)
#Remove relations from database
#Must install dplyr package
dbRemoveTable(FinalPracticedb, 'NEWTABLE')
dbListTables(FinalPracticedb)  #Verify that NEWTABLE was removed

#To determine what datatype
dbDataType(FinalPracticedb, customer)
dbDataType(FinalPracticedb, sales_order)

#To determine attributes
dbListFields(Labdb, "product")  #THIS IS ON THE FINAL
dbListTables(Labdb)

Labdb#Adding tuples to existing relations
NEWTABLE <- dbSendQuery(FinalPracticedb, 'INSERT INTO product VALUES("p6","SOCKS","GREEN")')
dbSendQuery(FinalPracticedb, 'INSERT INTO product VALUES("p6","SOCKS","GREEN")')  #adds a tuple into product relation
dbGetQuery(FinalPracticedb, 'SELECT * FROM product')
ADD_KIM <- dbSendStatement(FinalPracticedb, 'INSERT INTO CUSTOMER (NAME)VALUES("KIM")')
dbGetRowsAffected(ADD_KIM)  #Verify that it worked
dbGetQuery(FinalPracticedb, 'SELECT * FROM customer')
dbSendQuery(Labdb, 'INSERT INTO PRODUCT VALUES ("p6", "p7", "p8")')
dbListTables(Labdb)
dbReadTable(Labdb, "PRODUCT")
#fetching


#Create relation
dbSendQuery(conn = FinalPracticedb, 'CREATE TABLE soft_toys 
            (Toy_ID INTEGER,
            Toy_Name TEXT,
            Color TEXT,
            Price REAL)')
dbSendQuery(conn = FinalPracticedb, 'INSERT INTO soft_toys VALUES(001, "BEAR", "BLUE", "5.99")')
dbGetQuery(FinalPracticedb, 'SELECT * FROM soft_toys')
dbSendQuery(conn=Labdb, 'CREATE TABLE NEW (TOY_ID INteger, ToyName REAL)')

#Views 
dbSendQuery(conn=Labdb, "CREATE VIEW FVIEW AS SELECT * FROM PRODUCT")
dbSendQuery(conn = FinalPracticedb, "CREATE VIEW FIRSTVIEW AS SELECT * FROM PRODUCT")
dbGetQuery(FinalPracticedb, 'SELECT * FROM FIRSTVIEW')
dbGetQuery(FinalPracticedb, 'SELECT COLOR FROM FIRSTVIEW')
dbSendQuery(conn = FinalPracticedb, 'CREATE VIEW SECONDVIEW AS SELECT EMPLOYEE.EMP_NO,
            EMPLOYEE.NAME, DEPARTMENT.MANAGER
            FROM EMPLOYEE LEFT JOIN DEPARTMENT WHERE EMPLOYEE.DEPT_NO = DEPARTMENT.DEPT_NO
            AND NOT (MANAGER = "null")')
dbGetQuery(FinalPracticedb, 'SELECT * FROM SECONDVIEW')

#Delete a view
dbSendQuery(conn = FinalPracticedb, 'DROP VIEW FIRSTVIEW')
dbGetQuery(FinalPracticedb, 'SELECT * FROM FIRSTVIEW')  #Verify that the view is gone

#Temporarily remove ALEX from all queries

DELALEX <- dbSendStatement(Labdb, 'DELETE FROM CUSTOMER WHERE NAME = "ALEX"')
dbGetRowsAffected(DELALEX)
dbGetQuery(Labdb, 'SELECT * FROM CUSTOMER')
dbWriteTable(Labdb, "CUSTOMER", CUSTOMER, OVERWRITE = TRUE)


DEL_BOB <- dbSendStatement(Labdb, 'DELETE FROM CUSTOMER WHERE NAME = "BOB"')
dbGetRowsAffected(DEL_BOB)
dbGetQuery(Labdb, 'SELECT NAME FROM CUSTOMER')[1,]


DEL_ALEX <- dbSendStatement(Labdb, 'DELETE FROM customer WHERE NAME = "ALEX"')
dbGetRowsAffected(DEL_ALEX)
dbGetQuery(FinalPracticedb, 'SELECT * FROM customer')
dbGetQuery(FinalPracticedb, 'SELECT NAME FROM customer')  #Note how ALEX is deleted here
customer  #Note how ALEX is still present in the R object customer
dbWriteTable(FinalPracticedb, "customer",customer, overwrite = TRUE)  #reset customer

#To end work in SQL
dbDisconnect(FinalPracticedb)
