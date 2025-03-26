CREATE DATABASE EmployeeManagement;
USE EmployeeManagement;

-- Bảng Nhân viên
CREATE TABLE Employees (
    EmpID VARCHAR(20) PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Gender ENUM('Nam', 'Nữ', 'Khác'),
    Birthdate DATE,
    Telephone VARCHAR(15),
    Email VARCHAR(255) UNIQUE,
    Address_loc TEXT,
    Department VARCHAR(100),
    ChucVu VARCHAR(100),
    CapBac VARCHAR(50),
    Photo VARCHAR(255),
    ChuKiLuong ENUM('Hàng tháng', 'Hàng quý', 'Hàng năm'),
    LuongCoBan DECIMAL(10,2),
    NgayThamGia DATETIME,
    Status ENUM('Hoạt động', 'Nghỉ việc', 'Tạm nghỉ')
);

CREATE TABLE Users (
    UserID INT PRIMARY KEY AUTO_INCREMENT,
    EmpID VARCHAR(20) UNIQUE, -- Liên kết với EmpID trong bảng Employees
    Email VARCHAR(255) UNIQUE NOT NULL,
    PasswordHash VARCHAR(255) NOT NULL, -- Lưu trữ mật khẩu đã băm
    Salt VARCHAR(255) NOT NULL, -- Lưu trữ salt để băm mật khẩu
    Role ENUM('Admin', 'Manager', 'Employee') DEFAULT 'Employee', -- Thêm cột Role
    FOREIGN KEY (EmpID) REFERENCES Employees(EmpID)
);

-- Bảng Phòng ban
CREATE TABLE Departments (
    DeptID INT PRIMARY KEY AUTO_INCREMENT,
    DeptName VARCHAR(100),
    ManagerID VARCHAR(20),
    FOREIGN KEY (ManagerID) REFERENCES Employees(EmpID)
);

-- Bảng Team
CREATE TABLE Teams (
    TeamID INT PRIMARY KEY AUTO_INCREMENT,
    TeamName VARCHAR(100),
    DeptID INT,
    FOREIGN KEY (DeptID) REFERENCES Departments(DeptID)
);

-- Bảng Bài viết
CREATE TABLE Posts (
    PostID INT PRIMARY KEY AUTO_INCREMENT,
    EmpID VARCHAR(20),
    Title VARCHAR(255),
    Content TEXT,
    PostedDate DATETIME,
    Views INT,
    Likes INT,
    Status ENUM('Công khai', 'Nháp', 'Ẩn'),
    FOREIGN KEY (EmpID) REFERENCES Employees(EmpID)
);

-- Bảng Bình luận
CREATE TABLE Comments (
    CommentID INT PRIMARY KEY AUTO_INCREMENT,
    PostID INT,
    EmpID VARCHAR(20),
    Content TEXT,
    CommentDate DATETIME,
    ParentCommentID INT NULL,
    FOREIGN KEY (PostID) REFERENCES Posts(PostID),
    FOREIGN KEY (EmpID) REFERENCES Employees(EmpID),
    FOREIGN KEY (ParentCommentID) REFERENCES Comments(CommentID)
);

-- Bảng Đơn từ
CREATE TABLE Requests (
    RequestID INT PRIMARY KEY AUTO_INCREMENT,
    EmpID VARCHAR(20),
    RequestType ENUM('Nghỉ phép', 'Công tác', 'Hỗ trợ', 'Tăng lương'),
    Content TEXT,
    RequestDate DATETIME,
    Status ENUM('Chờ duyệt', 'Đã duyệt', 'Từ chối'),
    ApprovedBy VARCHAR(20) NULL,
    ApprovedDate DATETIME NULL,
    FOREIGN KEY (EmpID) REFERENCES Employees(EmpID),
    FOREIGN KEY (ApprovedBy) REFERENCES Employees(EmpID)
);

-- Bảng Lịch họp
CREATE TABLE Meetings (
    MeetingID INT PRIMARY KEY AUTO_INCREMENT,
    Title VARCHAR(255),
    Content TEXT,
    StartTime DATETIME,
    EndTime DATETIME,
    Organizer VARCHAR(20),
    Participants TEXT,
    Location VARCHAR(255),
    FOREIGN KEY (Organizer) REFERENCES Employees(EmpID)
);

-- Bảng Chi tiết Lịch họp
CREATE TABLE MeetingDetails (
    DetailID INT PRIMARY KEY AUTO_INCREMENT,
    MeetingID INT,
    EmpID VARCHAR(20),
    Role ENUM('Người tổ chức', 'Người tham dự', 'Khách mời'),
    Notes TEXT,
    FOREIGN KEY (MeetingID) REFERENCES Meetings(MeetingID),
    FOREIGN KEY (EmpID) REFERENCES Employees(EmpID)
);

-- Bảng Thông báo
CREATE TABLE Notifications (
    NotificationID INT PRIMARY KEY AUTO_INCREMENT,
    EmpID VARCHAR(20),
    Type ENUM('Bài viết', 'Bình luận', 'Đơn từ', 'Lịch họp'),
    Message TEXT,
    TimeSent DATETIME,
    Status BOOLEAN,
    FOREIGN KEY (EmpID) REFERENCES Employees(EmpID)
);

-- Bảng Chi tiết Thông báo
CREATE TABLE NotificationDetails (
    DetailID INT PRIMARY KEY AUTO_INCREMENT,
    NotificationID INT,
    RelatedID INT,
    Description TEXT,
    FOREIGN KEY (NotificationID) REFERENCES Notifications(NotificationID)
);
-- Thêm dữ liệu vào bảng Nhân viên
INSERT INTO Employees VALUES ('E001', 'Nguyen', 'An', 'Nam', '1990-05-15', '0901234567', 'an.nguyen@example.com', 'Hà Nội', 'Kinh doanh', 'Trưởng phòng', 'A1', NULL, 'Hàng tháng', 15000000, '2020-06-01', 'Hoạt động');
INSERT INTO Employees VALUES ('E002', 'Tran', 'Binh', 'Nam', '1992-08-20', '0912345678', 'binh.tran@example.com', 'TP. HCM', 'CNTT', 'Nhân viên', 'B2', NULL, 'Hàng tháng', 12000000, '2021-03-15', 'Hoạt động');
--
INSERT INTO Users (EmpID, Email, PasswordHash, Salt, Role) VALUES
('E001', 'an.nguyen@example.com', 'your_hashed_password_1', 'your_salt_1', 'Manager'),
('E002', 'binh.tran@example.com', 'your_hashed_password_2', 'your_salt_2', 'Employee');
-- Thêm dữ liệu vào bảng Phòng ban
INSERT INTO Departments (DeptName, ManagerID) VALUES ('Kinh doanh', 'E001');
INSERT INTO Departments (DeptName, ManagerID) VALUES ('CNTT', 'E002');

-- Thêm dữ liệu vào bảng Team
INSERT INTO Teams (TeamName, DeptID) VALUES ('Marketing', 1);
INSERT INTO Teams (TeamName, DeptID) VALUES ('Phát triển phần mềm', 2);

-- Thêm dữ liệu vào bảng Bài viết
INSERT INTO Posts (EmpID, Title, Content, PostedDate, Views, Likes, Status) VALUES ('E001', 'Chương trình khuyến mãi', 'Chi tiết về chương trình khuyến mãi tháng 6.', NOW(), 100, 10, 'Công khai');

-- Thêm dữ liệu vào bảng Đơn từ
INSERT INTO Requests (EmpID, RequestType, Content, RequestDate, Status) VALUES ('E002', 'Nghỉ phép', 'Xin nghỉ phép 3 ngày.', NOW(), 'Chờ duyệt');

-- Thêm dữ liệu vào bảng Lịch họp
INSERT INTO Meetings (Title, Content, StartTime, EndTime, Organizer, Participants, Location) VALUES ('Họp kế hoạch', 'Thảo luận kế hoạch quý 3.', NOW(), DATE_ADD(NOW(), INTERVAL 2 HOUR), 'E001', 'E002', 'Phòng họp 101');
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '2280600798Hai';
FLUSH PRIVILEGES;