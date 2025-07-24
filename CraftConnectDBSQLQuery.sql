create table tblUsers
(
Uid int identity(1,1) primary key not null,
Username nvarchar(100)Null,
Password nvarchar(100)Null,
Email nvarchar(100)Null,
Name nvarchar(100)Null,
)
select * from tblUsers