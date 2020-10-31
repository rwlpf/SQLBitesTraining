USE SQL_AdventureWork_SB;
GO

/****** Object:  Table [dbo].[Orders]    Script Date: 20/04/2018 14:33:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('dbo.Orders', 'U') IS NOT NULL 
  DROP TABLE dbo.Orders; 

CREATE TABLE [dbo].[Orders](
	[ID] [int] NULL,
	[Item] [nvarchar](50) NULL,
	[UserID] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 20/04/2018 14:33:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('dbo.Users', 'U') IS NOT NULL 
  DROP TABLE dbo.Users; 

CREATE TABLE [dbo].[Users](
	[ID] [int] NULL,
	[Name] [nvarchar](50) NULL
) ON [PRIMARY]
GO

INSERT [dbo].[Orders] ([ID], [Item], [UserID]) VALUES (1, N'Pizza', 1)
INSERT [dbo].[Orders] ([ID], [Item], [UserID]) VALUES (2, N'soda', 1)
INSERT [dbo].[Orders] ([ID], [Item], [UserID]) VALUES (3, N'french fries', 1)
INSERT [dbo].[Orders] ([ID], [Item], [UserID]) VALUES (4, N'french fries', 2)
INSERT [dbo].[Orders] ([ID], [Item], [UserID]) VALUES (5, N'burger', 4)
INSERT [dbo].[Orders] ([ID], [Item], [UserID]) VALUES (6, N'soda', 4)
INSERT [dbo].[Orders] ([ID], [Item], [UserID]) VALUES (7, N'Pizza', 5)
INSERT [dbo].[Orders] ([ID], [Item], [UserID]) VALUES (8, N'burger', 99)
INSERT [dbo].[Users] ([ID], [Name]) VALUES (1, N'Dave')
INSERT [dbo].[Users] ([ID], [Name]) VALUES (2, N'Jennifer')
INSERT [dbo].[Users] ([ID], [Name]) VALUES (3, N'Ben')
INSERT [dbo].[Users] ([ID], [Name]) VALUES (4, N'Tara')
INSERT [dbo].[Users] ([ID], [Name]) VALUES (5, N'Justin')
INSERT [dbo].[Users] ([ID], [Name]) VALUES (6, N'Praveen')
