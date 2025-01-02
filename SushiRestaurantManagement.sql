-- CREATE DATABASE
IF EXISTS (SELECT * FROM sys.databases WHERE name = 'SushiRestaurantManagement')
BEGIN
    USE [master]; -- Switch to the master database before dropping
    ALTER DATABASE [SushiRestaurantManagement] SET SINGLE_USER WITH ROLLBACK IMMEDIATE; -- Force close connections
    DROP DATABASE [SushiRestaurantManagement];
    CREATE DATABASE [SushiRestaurantManagement];
    PRINT 'Database SushiRestaurantManagement has been created.';
END

-- USE DATABASE
GO
USE [SushiRestaurantManagement];

-- CREATE TABLES
CREATE TABLE [dbo].[Employee_Score] (
    employee_id INT,
    scored_time DATETIME,
    score INT NOT NULL,
    PRIMARY KEY (employee_id, scored_time)
);

CREATE TABLE [dbo].[Department] (
    department_id INT PRIMARY KEY,
    department_name NVARCHAR(50) NOT NULL
);

CREATE TABLE [dbo].[Working_History] (
    start_date DATETIME NOT NULL,
    employee_id INT NOT NULL,
    branch_id INT NOT NULL,
    end_date DATETIME,
    PRIMARY KEY (employee_id, branch_id, start_date)
);

CREATE TABLE [dbo].[Region] (
    region_id INT PRIMARY KEY,
    region_name NVARCHAR(50) NOT NULL
);

CREATE TABLE [dbo].[ParkingDetail] (
    branch_id INT NOT NULL,
    parking_id INT NOT NULL,
    max_capacity INT NOT NULL,
    description NVARCHAR(256),
    PRIMARY KEY (branch_id, parking_id)
);

CREATE TABLE [dbo].[Parking] (
    parking_id INT PRIMARY KEY,
    parking_type NVARCHAR(30) NOT NULL
);

CREATE TABLE [dbo].[Employee] (
    employee_id INT PRIMARY KEY,
    department_id INT NOT NULL,
    branch_id INT NOT NULL,
    full_name NVARCHAR(30) NOT NULL,
    birth_day DATE NOT NULL,
    gender NVARCHAR(10) NOT NULL,
    salary DECIMAL(18, 2) NOT NULL,
    join_date DATE NOT NULL,
    leave_date DATE,
    is_enable BIT NOT NULL, 
	CONSTRAINT CK_Employee_Gender CHECK (gender IN (N'Nam', N'Nữ'))
);

CREATE TABLE [dbo].[Branch] (
    branch_id INT PRIMARY KEY,
    manager_id INT NOT NULL,
    region_id INT NOT NULL,
    branch_name NVARCHAR(50) NOT NULL,
    address NVARCHAR(50) NOT NULL,
    open_time TIME NOT NULL,
    close_time TIME NOT NULL,
    phone_number NVARCHAR(12),
    is_open BIT NOT NULL
);

CREATE TABLE [dbo].[Branch_Dish_Status] (
    branch_id INT,
	dish_id INT, 
	is_served BIT NOT NULL,
	PRIMARY KEY (branch_id, dish_id)
);

CREATE TABLE [dbo].[Region_Dish_Status] (
    region_id INT,
	dish_id INT, 
	is_served BIT NOT NULL,
	PRIMARY KEY (region_id, dish_id)
);

CREATE TABLE [dbo].[Membership_Card] (
    card_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    created_by INT NOT NULL,
    tier NVARCHAR(15) NOT NULL,
    issue_date DATETIME NOT NULL,
    last_upgrade_date DATETIME,
    point INT NOT NULL,
    is_enable BIT NOT NULL
);

CREATE TABLE [dbo].[Invoice] (
    invoice_id INT PRIMARY KEY,
    branch_id INT NOT NULL,
    responsible_employee INT NOT NULL,
    order_id INT NOT NULL,
    rating_id INT,
    total_amount DECIMAL(18, 2) NOT NULL,
    discount_amount DECIMAL(18, 2) NOT NULL,
    final_amount DECIMAL(18, 2) NOT NULL,
    point_earned INT NOT NULL,
    status NVARCHAR(20)
);

CREATE TABLE [dbo].[Menu_Category] (
    category_id INT PRIMARY KEY,
    category_name NVARCHAR(50) NOT NULL,
    is_served BIT NOT NULL
);

CREATE TABLE [dbo].[Dish] (
    dish_id INT PRIMARY KEY,
    category_id INT NOT NULL,
    dish_name NVARCHAR(50) NOT NULL,
	quantity INT NOT NULL,
	allow_delivery_service BIT NOT NULL
);


CREATE TABLE [dbo].[MembershipDetail] (
    card_id INT PRIMARY KEY,
    password NVARCHAR(50) NOT NULL,
    email NVARCHAR(50) NOT NULL,
    personal_id CHAR(15) NOT NULL,
    gender NVARCHAR(10),
    is_enable BIT NOT NULL,
	CONSTRAINT CK_MembershipDetail_Gender CHECK (gender IN (N'Nam', N'Nữ'))
);

CREATE TABLE [dbo].[Criteria] (
    criteria_id INT PRIMARY KEY,
    criteria_name NVARCHAR(50) NOT NULL
);

CREATE TABLE [dbo].[Rating] (
    rating_id INT PRIMARY KEY,
    comment NVARCHAR(256)
);

CREATE TABLE [dbo].[Order] (
    order_id INT PRIMARY KEY,
    ordered_by INT NOT NULL,
    created_by INT NOT NULL,
    order_time DATETIME NOT NULL,
    table_number INT NOT NULL
);

CREATE TABLE [dbo].[Order_Detail] (
    order_id INT,
    dish_id INT,
    quantity INT NOT NULL,
    status NVARCHAR(15),
    PRIMARY KEY (order_id, dish_id)
);

CREATE TABLE [dbo].[Online_Aceess_Log] (
    access_id INT PRIMARY KEY,
	access_start_time DATETIME NOT NULL,
	access_end_time DATETIME NOT NULL,
	duration INT NOT NULL
);

CREATE TABLE [dbo].[Score] (
    criteria_id INT NOT NULL,
    rating_id INT NOT NULL,
    scored INT NOT NULL,
    PRIMARY KEY (criteria_id, rating_id)
);

CREATE TABLE [dbo].[Customer] (
    customer_id INT PRIMARY KEY,
    full_name NVARCHAR(50) NOT NULL,
    phone_number NVARCHAR(12) UNIQUE
);

CREATE TABLE [dbo].[Online_Reservation] (
    reservation_id INT PRIMARY KEY,
    phone_number NVARCHAR(12) NOT NULL,
    order_id INT NOT NULL,
    guest_count TINYINT NOT NULL,
    reservation_date DATETIME NOT NULL,
    reservation_time DATETIME NOT NULL,
    note NVARCHAR(256)
);


-- Insert data into Region
INSERT INTO Region (region_id, region_name) VALUES
(1, N'Hồ Chí Minh'),
(2, N'Hà Nội'),
(3, N'Đà Nẵng');

-- Insert data into Department
INSERT INTO Department (department_id, department_name) VALUES
(1, N'Bếp'),
(2, N'Lễ tân'),
(3, N'Phục vụ bàn'),
(4, N'Thu ngân'),
(5, N'Quản lý');

-- Insert data into Parking
INSERT INTO Parking (parking_id, parking_type) VALUES
(1, N'Xe máy'),
(2, N'Xe hơi');

-- Insert sample Employee data (including managers first)
-- First insert managers
-- Insert data into Branch
INSERT INTO Branch (branch_id, manager_id, region_id, branch_name, address, open_time, close_time, phone_number, is_open) VALUES
(1, 1, 1, N'SuShiX Quận 1', N'123 Nguyễn Huệ, Quận 1', '10:00', '22:00', '0901234567', 1),
(2, 2, 2, N'SuShiX Hoàn Kiếm', N'45 Hàng Bài, Hoàn Kiếm', '10:00', '22:00', '0901234568', 1),
(3, 3, 3, N'SuShiX Hải Châu', N'78 Lê Duẩn, Hải Châu', '10:00', '22:00', '0901234569', 1);

INSERT INTO Employee (employee_id, department_id, branch_id, full_name, birth_day, gender, salary, join_date, is_enable) VALUES
(1, 5, 1, N'Nguyễn Văn An', '1985-01-15', N'Nam', 15000000, '2020-01-01', 1),
(2, 5, 2, N'Trần Thị Bình', '1988-03-20', N'Nữ', 15000000, '2020-01-01', 1),
(3, 5, 3, N'Lê Văn Cường', '1987-06-25', N'Nam', 15000000, '2020-01-01', 1);


-- Insert more employees
INSERT INTO Employee (employee_id, department_id, branch_id, full_name, birth_day, gender, salary, join_date, is_enable) VALUES
(4, 1, 1, N'Phạm Thị Dung', '1990-04-12', N'Nữ', 8000000, '2020-02-01', 1),
(5, 2, 1, N'Hoàng Văn Em', '1992-08-18', N'Nam', 7000000, '2020-02-01', 1),
(6, 3, 1, N'Nguyễn Thị Phương', '1995-11-23', N'Nữ', 6500000, '2020-02-01', 1);

-- Insert data into Menu_Category
INSERT INTO Menu_Category (category_id, category_name, is_served) VALUES
(1, N'Khai vị', 1),
(2, N'Sashimi combo', 1),
(3, N'Nigiri', 1),
(4, N'Tempura', 1),
(5, N'Udon', 1);

-- Insert data into Dish
INSERT INTO Dish (dish_id, category_id, dish_name, quantity, allow_delivery_service) VALUES
(1, 1, N'Trứng hấp', 100, 1),
(2, 1, N'Súp miso', 100, 1),
(3, 2, N'Sashimi tổng hợp', 50, 0),
(4, 2, N'Sashimi cá hồi đặc biệt', 50, 0),
(5, 3, N'Cá ngừ (2 miếng)', 80, 0),
(6, 3, N'Cá hồi (2 miếng)', 80, 0);

-- Insert data into Branch_Dish_Status
INSERT INTO Branch_Dish_Status (branch_id, dish_id, is_served) VALUES
(1, 1, 1),
(1, 2, 1),
(1, 3, 1),
(2, 1, 1),
(2, 2, 1),
(3, 1, 1);

-- Insert data into Region_Dish_Status
INSERT INTO Region_Dish_Status (region_id, dish_id, is_served) VALUES
(1, 1, 1),
(1, 2, 1),
(1, 3, 1),
(2, 1, 1),
(2, 2, 1),
(3, 1, 1);

-- Insert data into Customer
INSERT INTO Customer (customer_id, full_name, phone_number) VALUES
(1, N'Trần Văn Khách', '0912345678'),
(2, N'Lê Thị Khách', '0923456789'),
(3, N'Phạm Văn Khách', '0934567890');

-- Insert data into Membership_Card
INSERT INTO Membership_Card (card_id, customer_id, created_by, tier, issue_date, point, is_enable) VALUES
(1, 1, 5, 'MEMBER', '2023-01-01', 0, 1),
(2, 2, 5, 'SILVER', '2023-01-02', 100, 1),
(3, 3, 5, 'GOLD', '2023-01-03', 200, 1);

-- Insert data into MembershipDetail
INSERT INTO MembershipDetail (card_id, password, email, personal_id, gender, is_enable) VALUES
(1, 'password123', 'customer1@email.com', '079123456789', N'Nam', 1),
(2, 'password456', 'customer2@email.com', '079234567890', N'Nữ', 1),
(3, 'password789', 'customer3@email.com', '079345678901', N'Nam', 1);

-- Insert data into Order
INSERT INTO [Order] (order_id, ordered_by, created_by, order_time, table_number) VALUES
(1, 1, 6, '2024-01-01 12:00:00', 1),
(2, 2, 6, '2024-01-01 13:00:00', 2),
(3, 3, 6, '2024-01-01 14:00:00', 3);

-- Insert data into Order_Detail
INSERT INTO Order_Detail (order_id, dish_id, quantity, status) VALUES
(1, 1, 2, N'Hoàn thành'),
(1, 2, 1, N'Hoàn thành'),
(2, 3, 1, N'Hoàn thành'),
(3, 4, 2, N'Hoàn thành');

-- Insert data into Rating
INSERT INTO Rating (rating_id, comment) VALUES
(1, N'Món ăn ngon, phục vụ tốt'),
(2, N'Không gian đẹp'),
(3, N'Giá cả hợp lý');

-- Insert data into Criteria
INSERT INTO Criteria (criteria_id, criteria_name) VALUES
(1, N'Phục vụ'),
(2, N'Vị trí'),
(3, N'Chất lượng món ăn'),
(4, N'Giá cả'),
(5, N'Không gian');

-- Insert data into Score
INSERT INTO Score (criteria_id, rating_id, scored) VALUES
(1, 1, 5),
(2, 1, 4),
(3, 1, 5),
(1, 2, 4),
(2, 2, 5);

-- Insert data into Invoice
INSERT INTO Invoice (invoice_id, branch_id, responsible_employee, order_id, rating_id, total_amount, discount_amount, final_amount, point_earned, status) VALUES
(1, 1, 6, 1, 1, 500000, 50000, 450000, 4, N'Đã thanh toán'),
(2, 1, 6, 2, 2, 800000, 80000, 720000, 7, N'Đã thanh toán'),
(3, 1, 6, 3, 3, 1000000, 100000, 900000, 9, N'Đã thanh toán');

-- Insert data into ParkingDetail
INSERT INTO ParkingDetail (branch_id, parking_id, max_capacity, description) VALUES
(1, 1, 50, N'Bãi xe máy tầng hầm'),
(1, 2, 20, N'Bãi xe hơi tầng hầm'),
(2, 1, 40, N'Bãi xe máy'),
(3, 1, 30, N'Bãi xe máy');

-- Insert data into Working_History
INSERT INTO Working_History (employee_id, branch_id, start_date, end_date) VALUES
(1, 1, '2020-01-01', NULL),
(2, 2, '2020-01-01', NULL),
(3, 3, '2020-01-01', NULL),
(4, 1, '2020-02-01', NULL),
(5, 1, '2020-02-01', NULL),
(6, 1, '2020-02-01', NULL);

-- Insert data into Employee_Score
INSERT INTO Employee_Score (employee_id, scored_time, score) VALUES
(4, '2024-01-01 22:00:00', 9),
(5, '2024-01-01 22:00:00', 8),
(6, '2024-01-01 22:00:00', 9);

-- Insert data into Online_Aceess_Log
INSERT INTO Online_Aceess_Log (access_id, access_start_time, access_end_time, duration) VALUES
(1, '2024-01-01 10:00:00', '2024-01-01 10:15:00', 15),
(2, '2024-01-01 14:30:00', '2024-01-01 14:50:00', 20),
(3, '2024-01-01 19:00:00', '2024-01-01 19:20:00', 20);

-- Insert data into Online_Reservation
INSERT INTO Online_Reservation (reservation_id, phone_number, order_id, guest_count, reservation_date, reservation_time, note) VALUES
(1, '0912345678', 1, 4, '2024-01-01', '2024-01-01 12:00:00', N'Cần bàn gần cửa sổ'),
(2, '0923456789', 2, 2, '2024-01-01', '2024-01-01 13:00:00', NULL),
(3, '0934567890', 3, 6, '2024-01-01', '2024-01-01 14:00:00', N'Đặt thêm 1 ghế em bé');

GO
-- Tạo thêm nhân viên cho mỗi chi nhánh
DECLARE @i INT = 7;
WHILE @i <= 100
BEGIN
    -- Random branch_id từ 1-3
    DECLARE @branch_id INT = (SELECT TOP 1 ROUND(RAND() * 2, 0) + 1);
    -- Random department_id từ 1-4 (không tính department 5 là quản lý)
    DECLARE @department_id INT = (SELECT TOP 1 ROUND(RAND() * 3, 0) + 1);
    
    INSERT INTO Employee (
        employee_id, 
        department_id, 
        branch_id, 
        full_name, 
        birth_day, 
        gender, 
        salary, 
        join_date, 
        is_enable
    )
    VALUES (
        @i,
        @department_id,
        @branch_id,
        CASE 
            WHEN @i % 2 = 0 THEN N'Nguyễn Văn ' + CHAR((@i % 26) + 65)
            ELSE N'Trần Thị ' + CHAR((@i % 26) + 65)
        END,
        DATEADD(DAY, -(@i * 100), '2000-01-01'),
        CASE WHEN @i % 2 = 0 THEN N'Nam' ELSE N'Nữ' END,
        CASE 
            WHEN @department_id = 1 THEN 8000000  -- Bếp
            WHEN @department_id = 2 THEN 7000000  -- Lễ tân
            WHEN @department_id = 3 THEN 6500000  -- Phục vụ bàn
            ELSE 7500000  -- Thu ngân
        END,
        DATEADD(DAY, -(@i * 10), '2024-01-01'),
        1
    );

    -- Thêm lịch sử làm việc cho nhân viên mới
    INSERT INTO Working_History (employee_id, branch_id, start_date, end_date)
    VALUES (@i, @branch_id, DATEADD(DAY, -(@i * 10), '2024-01-01'), NULL);

    SET @i = @i + 1;
END

-- Thêm danh mục món ăn
INSERT INTO Menu_Category (category_id, category_name, is_served)
VALUES 
(6, N'Lunch Set', 1),
(7, N'Hot Pot', 1),
(8, N'Nước uống', 1);

-- Thêm món ăn
SET @i = 7;
WHILE @i <= 100
BEGIN
    DECLARE @category_id INT = (SELECT TOP 1 ROUND(RAND() * 7, 0) + 1);
    DECLARE @allow_delivery BIT = CASE WHEN @category_id IN (2, 3) THEN 0 ELSE 1 END;
    
    INSERT INTO Dish (
        dish_id,
        category_id,
        dish_name,
        quantity,
        allow_delivery_service
    )
    VALUES (
        @i,
        @category_id,
        CASE 
            WHEN @category_id = 1 THEN N'Khai vị ' + CAST(@i AS NVARCHAR(10))
            WHEN @category_id = 2 THEN N'Sashimi ' + CAST(@i AS NVARCHAR(10))
            WHEN @category_id = 3 THEN N'Nigiri ' + CAST(@i AS NVARCHAR(10))
            WHEN @category_id = 4 THEN N'Tempura ' + CAST(@i AS NVARCHAR(10))
            WHEN @category_id = 5 THEN N'Udon ' + CAST(@i AS NVARCHAR(10))
            WHEN @category_id = 6 THEN N'Lunch Set ' + CAST(@i AS NVARCHAR(10))
            WHEN @category_id = 7 THEN N'Hot Pot ' + CAST(@i AS NVARCHAR(10))
            ELSE N'Nước ' + CAST(@i AS NVARCHAR(10))
        END,
        100,
        @allow_delivery
    );

    -- Thêm trạng thái món ăn theo chi nhánh
    INSERT INTO Branch_Dish_Status (branch_id, dish_id, is_served)
    SELECT branch_id, @i, 1
    FROM Branch;

    -- Thêm trạng thái món ăn theo khu vực
    INSERT INTO Region_Dish_Status (region_id, dish_id, is_served)
    SELECT region_id, @i, 1
    FROM Region;

    SET @i = @i + 1;
END

-- Thêm lịch sử truy cập online
SET @i = 4;
WHILE @i <= 1000
BEGIN
    DECLARE @start_time DATETIME = DATEADD(MINUTE, -(@i % 1440), '2024-01-01');
    DECLARE @duration INT = (SELECT TOP 1 ROUND(RAND() * 30, 0) + 5);
    
    INSERT INTO Online_Aceess_Log (
        access_id,
        access_start_time,
        access_end_time,
        duration
    )
    VALUES (
        @i,
        @start_time,
        DATEADD(MINUTE, @duration, @start_time),
        @duration
    );
    
    SET @i = @i + 1;
END

-- Tạo Order và các bảng liên quan (100,000 records)
SET @i = 4;
WHILE @i <= 100000
BEGIN
    BEGIN TRY
        DECLARE @customer_id INT = (SELECT TOP 1 customer_id FROM Customer ORDER BY NEWID());
        DECLARE @employee_id INT = (SELECT TOP 1 employee_id FROM Employee WHERE department_id = 3 ORDER BY NEWID());
        DECLARE @order_date DATETIME = DATEADD(MINUTE, -((@i * 7) % 525600), '2024-01-01 12:00:00'); -- Random trong 1 năm
        
        -- Insert Order
        INSERT INTO [Order] (
            order_id,
            ordered_by,
            created_by,
            order_time,
            table_number
        )
        VALUES (
            @i,
            @customer_id,
            @employee_id,
            @order_date,
            (@i % 20) + 1
        );

        -- Insert Order_Detail (2-5 món cho mỗi đơn)
        DECLARE @num_items INT = (SELECT TOP 1 ROUND(RAND() * 3, 0) + 2);
        DECLARE @total_amount DECIMAL(18,2) = 0;
        
        DECLARE @j INT = 1;
        WHILE @j <= @num_items
        BEGIN
            DECLARE @dish_id INT = (SELECT TOP 1 dish_id FROM Dish ORDER BY NEWID());
            DECLARE @quantity INT = (SELECT TOP 1 ROUND(RAND() * 3, 0) + 1);
            DECLARE @dish_price DECIMAL(18,2) = (SELECT TOP 1 ROUND(RAND() * (300000 - 50000) + 50000, -3)); -- Random giá từ 50,000 đến 300,000
            
            INSERT INTO Order_Detail (
                order_id,
                dish_id,
                quantity,
                status
            )
            VALUES (
                @i,
                @dish_id,
                @quantity,
                N'Hoàn thành'
            );
            
            SET @total_amount = @total_amount + (@dish_price * @quantity);
            SET @j = @j + 1;
        END

        -- Insert Rating
        INSERT INTO Rating (
            rating_id,
            comment
        )
        VALUES (
            @i,
            CASE 
                WHEN @i % 5 = 0 THEN N'Rất hài lòng với dịch vụ'
                WHEN @i % 5 = 1 THEN N'Món ăn ngon, nhân viên thân thiện'
                WHEN @i % 5 = 2 THEN N'Không gian đẹp, giá cả hợp lý'
                WHEN @i % 5 = 3 THEN N'Sẽ quay lại lần sau'
                ELSE N'Chất lượng tốt'
            END
        );

        -- Insert Score cho mỗi tiêu chí
        INSERT INTO Score (criteria_id, rating_id, scored)
        SELECT 
            criteria_id,
            @i,
            CASE 
                WHEN @i % 10 = 0 THEN 5  -- 10% đánh giá 5 sao
                WHEN @i % 3 = 0 THEN 4   -- 30% đánh giá 4 sao
                ELSE 3                    -- Còn lại đánh giá 3 sao
            END
        FROM Criteria;

        -- Tính discount dựa vào tier của khách hàng
        DECLARE @discount_percent DECIMAL(4,2) = (
            SELECT 
                CASE tier
                    WHEN 'GOLD' THEN 0.15
                    WHEN 'SILVER' THEN 0.10
                    ELSE 0.05
                END
            FROM Membership_Card
            WHERE customer_id = @customer_id
        );

        DECLARE @discount_amount DECIMAL(18,2) = @total_amount * @discount_percent;
        DECLARE @final_amount DECIMAL(18,2) = @total_amount - @discount_amount;

        -- Insert Invoice
        INSERT INTO Invoice (
            invoice_id,
            branch_id,
            responsible_employee,
            order_id,
            rating_id,
            total_amount,
            discount_amount,
            final_amount,
            point_earned,
            status
        )
        VALUES (
            @i,
            (SELECT branch_id FROM Employee WHERE employee_id = @employee_id),
            @employee_id,
            @i,
            @i,
            @total_amount,
            @discount_amount,
            @final_amount,
            CAST(@final_amount / 100000 AS INT),
            N'Đã thanh toán'
        );

        SET @i = @i + 1;
        
        -- Print progress every 10000 records
        IF @i % 10000 = 0
            PRINT 'Processed ' + CAST(@i AS VARCHAR(10)) + ' order records';
    END TRY
    BEGIN CATCH
        PRINT 'Error at order_id: ' + CAST(@i AS VARCHAR(10));
        PRINT ERROR_MESSAGE();
        SET @i = @i + 1;
        CONTINUE;
    END CATCH
END

-- Tạo Customer (100,000 records)
SET @i = 4;
WHILE @i <= 100000
BEGIN
    BEGIN TRY
        -- Insert Customer
        INSERT INTO Customer (
            customer_id,
            full_name,
            phone_number
        )
        VALUES (
            @i,
            CASE 
                WHEN @i % 2 = 0 THEN N'Khách ' + CHAR((@i % 26) + 65) + N' ' + CAST(@i AS NVARCHAR(10))
                ELSE N'Khách ' + CHAR((@i % 26) + 65) + N' ' + CAST(@i AS NVARCHAR(10))
            END,
            '09' + RIGHT('00000000' + CAST(@i AS VARCHAR(8)), 8)
        );

        -- Insert Membership_Card
        INSERT INTO Membership_Card (
            card_id,
            customer_id,
            created_by,
            tier,
            issue_date,
            point,
            is_enable
        )
        VALUES (
            @i,
            @i,
            (SELECT TOP 1 employee_id FROM Employee WHERE department_id = 2 ORDER BY NEWID()),
            CASE 
                WHEN @i % 100 = 0 THEN 'GOLD'
                WHEN @i % 20 = 0 THEN 'SILVER'
                ELSE 'MEMBER'
            END,
            DATEADD(DAY, -(@i % 365), '2024-01-01'),
            CASE 
                WHEN @i % 100 = 0 THEN FLOOR(RAND() * (300 - 200 + 1) + 200)
                WHEN @i % 20 = 0 THEN FLOOR(RAND() * (199 - 100 + 1) + 100)
                ELSE FLOOR(RAND() * 99)
            END,
            1
        );

        -- Insert MembershipDetail
        INSERT INTO MembershipDetail (
            card_id,
            password,
            email,
            personal_id,
            gender,
            is_enable
        )
        VALUES (
            @i,
            'password' + CAST(@i AS VARCHAR(10)),
            'customer' + CAST(@i AS VARCHAR(10)) + '@email.com',
            '0791234' + RIGHT('00000' + CAST(@i AS VARCHAR(5)), 5),
            CASE WHEN @i % 2 = 0 THEN N'Nam' ELSE N'Nữ' END,
            1
        );

        SET @i = @i + 1;
        
        -- Print progress every 10000 records
        IF @i % 10000 = 0
            PRINT 'Processed ' + CAST(@i AS VARCHAR(10)) + ' customer records';
    END TRY
    BEGIN CATCH
        PRINT 'Error at customer_id: ' + CAST(@i AS VARCHAR(10));
        PRINT ERROR_MESSAGE();
        SET @i = @i + 1;
        CONTINUE;
    END CATCH
END

-- Thêm đặt bàn online
SET @i = 4;
WHILE @i <= 1000
BEGIN
    DECLARE @reservation_date DATETIME = DATEADD(DAY, (@i % 30), '2024-01-01');
    
    INSERT INTO Online_Reservation (
        reservation_id,
        phone_number,
        order_id,
        guest_count,
        reservation_date,
        reservation_time,
        note
    )
    VALUES (
        @i,
        (SELECT TOP 1 phone_number FROM Customer WHERE customer_id = @i),
        @i,
        (SELECT TOP 1 ROUND(RAND() * 6, 0) + 2),
        @reservation_date,
        DATEADD(HOUR, (@i % 12) + 8, @reservation_date),
        CASE 
            WHEN @i % 3 = 0 THEN N'Cần bàn yên tĩnh'
            WHEN @i % 3 = 1 THEN N'Đặt thêm ghế em bé'
            ELSE NULL
        END
    );
    
    SET @i = @i + 1;
END

-- Thêm điểm đánh giá nhân viên
SET @i = 1;
WHILE @i <= 1000
BEGIN
    DECLARE @scored_employee INT = (SELECT TOP 1 employee_id FROM Employee ORDER BY NEWID());
    DECLARE @scored_date DATETIME = DATEADD(HOUR, -(@i % 24), '2024-01-01 22:00:00');
    
    INSERT INTO Employee_Score (
        employee_id,
        scored_time,
        score
    )
    VALUES (
        @scored_employee,
        @scored_date,
        (SELECT TOP 1 ROUND(RAND() * 2, 0) + 7)
    );
    
    SET @i = @i + 1;
END


-- (FOREIGN KEY)
-- Employee_Score
ALTER TABLE [dbo].[Employee_Score]
ADD CONSTRAINT FK_Employee_Score_Employee
		FOREIGN KEY (employee_id) REFERENCES [dbo].[Employee](employee_id);

-- Working_History
ALTER TABLE [dbo].[Working_History]
ADD CONSTRAINT FK_Working_History_Employee
		FOREIGN KEY (employee_id) REFERENCES [dbo].[Employee](employee_id),
	CONSTRAINT FK_Working_History_Branch
		FOREIGN KEY (branch_id) REFERENCES [dbo].[Branch](branch_id);

-- ParkingDetail
ALTER TABLE [dbo].[ParkingDetail]
ADD CONSTRAINT FK_ParkingDetail_Branch
		FOREIGN KEY (branch_id) REFERENCES [dbo].[Branch](branch_id),
	CONSTRAINT FK_ParkingDetail_Parking
		FOREIGN KEY (parking_id) REFERENCES [dbo].[Parking](parking_id);

-- Employee
ALTER TABLE [dbo].[Employee]
ADD CONSTRAINT FK_Employee_Department
		FOREIGN KEY (department_id) REFERENCES [dbo].[Department](department_id),
	CONSTRAINT FK_Employee_Branch
		FOREIGN KEY (branch_id) REFERENCES [dbo].[Branch](branch_id);

-- Branch
ALTER TABLE [dbo].[Branch]
ADD CONSTRAINT FK_Branch_Manager
		FOREIGN KEY (manager_id) REFERENCES [dbo].[Employee](employee_id),
	CONSTRAINT FK_Branch_Region
		FOREIGN KEY (region_id) REFERENCES [dbo].[Region](region_id);

-- Branch_Dish_Status
ALTER TABLE [dbo].[Branch_Dish_Status]
ADD CONSTRAINT FK_Branch_Dish_Status_Branch
		FOREIGN KEY (branch_id) REFERENCES [dbo].[Branch](branch_id),
	CONSTRAINT FK_Branch_Dish_Status_Dish
		FOREIGN KEY (dish_id) REFERENCES [dbo].[Dish](dish_id);

-- Region_Dish_Status
ALTER TABLE [dbo].[Region_Dish_Status]
ADD CONSTRAINT FK_Region_Dish_Status_Region
		FOREIGN KEY (region_id) REFERENCES [dbo].[Region](region_id),
	CONSTRAINT FK_Region_Dish_Status_Dish
		FOREIGN KEY (dish_id) REFERENCES [dbo].[Dish](dish_id);

-- Membership_Card
ALTER TABLE [dbo].[Membership_Card]
ADD CONSTRAINT FK_Membership_Card_Customer
		FOREIGN KEY (customer_id) REFERENCES [dbo].[Customer](customer_id),
	CONSTRAINT FK_Membership_Card_Employee
		FOREIGN KEY (created_by) REFERENCES [dbo].[Employee](employee_id);

-- Invoice
ALTER TABLE [dbo].[Invoice]
ADD CONSTRAINT FK_Invoice_Branch
		FOREIGN KEY (branch_id) REFERENCES [dbo].[Branch](branch_id),
	CONSTRAINT FK_Invoice_Employee
		FOREIGN KEY (responsible_employee) REFERENCES [dbo].[Employee](employee_id),
	CONSTRAINT FK_Invoice_Order
		FOREIGN KEY (order_id) REFERENCES [dbo].[Order](order_id),
	CONSTRAINT FK_Invoice_Rating
		FOREIGN KEY (rating_id) REFERENCES [dbo].[Rating](rating_id);

-- Dish
ALTER TABLE [dbo].[Dish]
ADD CONSTRAINT FK_Dish_Category
		FOREIGN KEY (category_id) REFERENCES [dbo].[Menu_Category](category_id);

-- MembershipDetail
ALTER TABLE [dbo].[MembershipDetail]
ADD CONSTRAINT FK_MembershipDetail_Card
		FOREIGN KEY (card_id) REFERENCES [dbo].[Membership_Card](card_id);

-- Score
ALTER TABLE [dbo].[Score]
ADD CONSTRAINT FK_Score_Criteria
		FOREIGN KEY (criteria_id) REFERENCES [dbo].[Criteria](criteria_id),
	CONSTRAINT FK_Score_Rating
		FOREIGN KEY (rating_id) REFERENCES [dbo].[Rating](rating_id);

-- Order
ALTER TABLE [dbo].[Order]
ADD CONSTRAINT FK_Order_Customer
		FOREIGN KEY (ordered_by) REFERENCES [dbo].[Customer](customer_id),
	CONSTRAINT FK_Order_Employee
		FOREIGN KEY (created_by) REFERENCES [dbo].[Employee](employee_id);

-- Order_Detail
ALTER TABLE [dbo].[Order_Detail]
ADD CONSTRAINT FK_Order_Detail_Order
		FOREIGN KEY (order_id) REFERENCES [dbo].[Order](order_id),
	CONSTRAINT FK_Order_Detail_Dish
		FOREIGN KEY (dish_id) REFERENCES [dbo].[Dish](dish_id);

-- Online_Reservation
ALTER TABLE [dbo].[Online_Reservation]
ADD CONSTRAINT FK_Online_Reservation_Customer
		FOREIGN KEY (phone_number) REFERENCES [dbo].[Customer](phone_number),
	CONSTRAINT FK_Online_Reservation_Order
		FOREIGN KEY (order_id) REFERENCES [dbo].[Order](order_id);


SELECT * FROM [Order]
SELECT * FROM [Order_Detail]

SELECT * FROM [Customer]
select * from [Invoice]