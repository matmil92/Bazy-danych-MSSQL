CREATE Table UserTable
(
id int identity(1,1) primary key,
login varchar(50) not null,
password varchar(50)  not null,
firstName varchar(20) not null,
lastName varchar(30) not null,
Constraint CHECK_USER CHECK(LEN(login) > 5 AND login like '%@%.%' AND LEN(password) > 8)
)
CREATE TABLE Writer
(
id int identity(1,1) primary key,
nickName varchar(10) not null,
userId int not null
Constraint FK_WRITER_USER FOREIGN KEY (userId) REFERENCES UserTable(id)
)
CREATE TABLE Reader
(
id int identity(1,1) primary key,
nickName varchar(10) not null,
lastLoginDate datetime not null,
ip varchar(15) not null,
userId int not null
Constraint FK_READER_USER FOREIGN KEY (userId) REFERENCES UserTable(id)
)
CREATE TABLE Category
(
id int identity(1,1) primary key,
categoryName varchar(20),
visible bit default 0
)
CREATE TABLE News
(
id int identity(1,1) primary key,
mainTitle varchar(30) not null,
subtitle varchar(20),
content varchar(max) not null,
banner varbinary(max),
writerId int not null,
categoryId int not null
Constraint FK_WRITER_NEWS FOREIGN KEY (writerId) REFERENCES Writer(id),
CONSTRAINT FK_CATEGORY_NEWS FOREIGN KEY (categoryId) REFERENCES Category(id)
)
CREATE TABLE Rating
(
id int identity(1,1) primary key,
rating int CHECK(rating <=5) not null,
readerId int not null,
newsId int not null
Constraint FK_READER_RATING FOREIGN KEY (readerId) REFERENCES Reader(id),
CONSTRAINT FK_NEWS_RATING FOREIGN KEY (newsId) REFERENCES News(id)
)
CREATE TABLE Comment
(
id int identity(1,1) primary key,
content varchar(120) not null,
readerId int not null,
newsId int not null
Constraint FK_READER_COMMENT FOREIGN KEY (readerId) REFERENCES Reader(id),
CONSTRAINT FK_NEWS_COMMENT FOREIGN KEY (newsId) REFERENCES News(id)
)
CREATE TABLE ReaderRank
(
id int identity(1,1) primary key,
rank int check(rank <=5),
receivedDate date not null,
description varchar(20) not null,
readerId int not null
CONSTRAINT FK_READER_READERRANK FOREIGN KEY (readerId) REFERENCES Reader(id)
)

DECLARE @iterator INT = 0;

WHILE @iterator < 50
BEGIN
	insert into UserTable(login,password, firstName, lastName)  values ('user' + CONVERT(Varchar(2),@iterator) + '@gmail.com' ,'userPassword1234','user' + CONVERT(Varchar(2),@iterator),'lastname' + CONVERT(Varchar(2),@iterator));
   SET @iterator = @iterator + 1;
END;
SET @iterator = 0;
WHILE @iterator < 50
BEGIN
if @iterator < 25 
	BEGIN
	insert into ProjectX.dbo.Writer (nickName,userId) 
	values ('Writer' + CONVERT(Varchar(2),@iterator) ,(select ID from ProjectX.dbo.UserTable where login='user' + CONVERT(Varchar(2),@iterator) + '@gmail.com'));
	END
if @iterator > 24 AND @iterator <50
	BEGIN
	insert into ProjectX.dbo.Reader (nickName,lastLoginDate,ip,userId) 
	values ('Reader' + CONVERT(Varchar(2),@iterator),CURRENT_TIMESTAMP,'172.18.254.1',(select ID from ProjectX.dbo.UserTable where login='user' + CONVERT(Varchar(2),@iterator) + '@gmail.com'));
	insert into ProjectX.dbo.ReaderRank (rank,receivedDate,description,readerId)
	values (ABS(Checksum(NewID()) % 5) + 1,CURRENT_TIMESTAMP,'Zmiana rangi',(select ID from ProjectX.dbo.Reader where nickName='Reader' + CONVERT(Varchar(2),@iterator)));
	END;
   SET @iterator = @iterator + 1;
END;
SET @iterator = 0;
WHILE @iterator < 25
BEGIN
	insert into ProjectX.dbo.Category (categoryName,visible) 
	values ('Category' + CONVERT(Varchar(2),@iterator),1);
   SET @iterator = @iterator + 1;
END;
SET @iterator = 0;
WHILE @iterator < 500
BEGIN
	insert into ProjectX.dbo.News (mainTitle,subtitle,content,banner,writerId,categoryId)
	values ('MainTitle' + CONVERT(Varchar(3),@iterator),'SubTitle' + CONVERT(Varchar(3),@iterator),'Content' + CONVERT(Varchar(3),@iterator),1011,
	(select ID from ProjectX.dbo.Writer where nickName='Writer' + CONVERT(Varchar(10),ABS(Checksum(NewID()) % 23) + 1)),
	ABS(Checksum(NewID()) % 24) + 1);
	SET @iterator = @iterator + 1;
END;


use ProjectX;

----=======================================3 Zapytania============================================--

--select mainTitle,writerId from ProjectX.dbo.News 
--where writerId = (select ID from ProjectX.dbo.UserTable where login='Rafss@gmail.com')
--group by mainTitle, writerId
--having LEN(mainTitle)>1;

----==================================4 funckje i procedury=======================================--


----========================================5 indeksy=============================================--
----nieklastrowe
--create unique nonclustered index UserTable_I_1 on ProjectX.dbo.UserTable(login);
----========================================6 widoki==============================================--
--use ProjectX;
--CREATE VIEW UserNews AS
--SELECT ut.login, w.nickName, n.CONTENT FROM News n
--LEFT JOIN Writer w on w.userId = n.writerId
--LEFT JOIN UserTable ut ON ut.id = w.userId; 




