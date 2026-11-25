CREATE DATABASE   `shopping_test`;
CREATE DATABASE   `shopping`;
SHOW DATABASES;
DROP DATABASE `shopping`;
USE `shopping_test`;

CREATE TABLE `user`(
	`user_id` INT PRIMARY KEY AUTO_INCREMENT, -- 使用者ID 
    `user_name` VARCHAR(20) NOT NULL, -- 使用者名稱
    `phone` VARCHAR(20) UNIQUE,    -- 電話
    `email` VARCHAR(30) UNIQUE,    -- email
    `create_time` DATE  -- 註冊時間
);

CREATE TABLE `group_buy`(
	`group_id` INT PRIMARY KEY AUTO_INCREMENT,  -- 團購編號
    `organizer_id` INT NOT NULL,         -- 開團者ID 連結到user表格的user ID
    `product_name` VARCHAR(50) NOT NULL,  -- 產品名稱
    `price` DECIMAL(10,2) NOT NULL,      -- 單價
    `max_quantity` INT NOT NULL,         -- 單次限購 
    `create_time` DATETIME,    -- 開團時間
    `deadline` DATETIME NOT NULL,       -- 截止時間
    
    FOREIGN KEY(`organizer_id`)
    REFERENCES `user` (`user_id`)
);

CREATE TABLE `group_member`(
	`join_id` INT PRIMARY KEY AUTO_INCREMENT, -- 每一筆「使用者參加某個團購」紀錄的專屬編號，也就是這筆個人訂單的 ID
	`group_id` INT NOT NULL,   -- 參加的開團編號 連結到group_buy 的group ID
    `user_id` INT NOT NULL,    -- 參團者ID 連結到user ID
    `quantity` INT NOT NULL,   -- 購買數量
    `total_price` DECIMAL(10,2) NOT NULL, -- 總價(保留小數可能)
    `join_time` DATETIME,  -- 參團時間
    
	FOREIGN KEY(`user_id`)
    REFERENCES `user` (`user_id`),
    
	FOREIGN KEY(`group_id`)
    REFERENCES `group_buy` (`group_id`)

);

CREATE TABLE `payment`(
	`payment_id` INT PRIMARY KEY AUTO_INCREMENT, -- 付款編號
    `join_id` INT NOT NULL,  -- 依據個人訂單ID判斷為哪筆訂單
    `price` DECIMAL(10,2) NOT NULL, -- 要付款的價格
    `pay_method` VARCHAR(20), -- 付款方式
    `paid_time` DATETIME,  -- 付款時間

    
    FOREIGN KEY(`join_id`)
    REFERENCES `group_member` (`join_id`)
);


CREATE TABLE `deliver`(
	`deliver_id` INT PRIMARY KEY AUTO_INCREMENT, -- 取貨編號
    `join_id` INT NOT NULL,   -- 依據個人訂單ID判斷
    `deliver_method` VARCHAR(20) NOT NULL,  -- 取貨方式(面交 超商等)
	`deliver_status` VARCHAR(20),  -- 取貨狀態(是否完成)
    `deliver_time` DATETIME,  -- 完成取貨時間
    
    FOREIGN KEY(`join_id`)
    REFERENCES `group_member` (`join_id`)
);


DESCRIBE `user`;
DESCRIBE `group_buy`;
DESCRIBE `group_member`;
DESCRIBE `payment`;
DESCRIBE `deliver`;

DROP TABLE `user`;
DROP TABLE `group_buy`;
DROP TABLE `group_member`;
DROP TABLE `payment`;
DROP TABLE `deliver`;

ALTER TABLE `user` ADD password_ VARCHAR(20);
ALTER TABLE `user` DROP COLUMN password_;


USE `shopping_test`;
-- 1. 新增使用者
INSERT INTO `user` (`user_name`, `phone`, `email`, `create_time`)
VALUES
    ('Hank', '0900111111', 'hank@example.com', '2026-11-25'),
    ('Amy',  '0900222222', 'amy@example.com',  '2026-11-25');
-- 記下 Hank、Amy 自動產生的 user_id
SELECT * FROM `user`;

-- 2. 新增團購
-- 先假設 Hank 的 user_id 是 1；若 SELECT 顯示不同，請替換成實際 ID
INSERT INTO `group_buy`
    (`organizer_id`, `product_name`, `price`, `max_quantity`, `create_time`, `deadline`)
VALUES
    (1, '測試餅乾', 50.00, 10, NOW(), '2026-12-31 23:59:59');

SELECT * FROM `group_buy`;

-- 3. 新增參團紀錄
-- 先假設團購 group_id 是 1、Amy 的 user_id 是 2
-- 目前 join_id 沒有 AUTO_INCREMENT，所以這裡要手動給值
INSERT INTO `group_member`
    (`join_id`, `group_id`, `user_id`, `quantity`, `total_price`, `join_time`)
VALUES
    (1001, 1, 2, 3, 150.00, NOW());
    
SELECT * FROM `group_member`;

-- 4. 新增付款紀錄
INSERT INTO `payment`
    (`join_id`, `price`, `pay_method`, `paid_time`)
VALUES
    (1001, 150.00, '轉帳', NOW());
SELECT * FROM `payment`;

-- 5. 新增取貨紀錄
INSERT INTO `deliver`
    (`join_id`, `deliver_method`, `deliver_status`, `deliver_time`)
VALUES
    (1001, '面交', '待取貨', NULL);

SELECT * FROM `deliver`;


SELECT * FROM `user`;
SELECT * FROM `group_buy`;
SELECT * FROM `group_member`;
SELECT * FROM `payment`;
SELECT * FROM `deliver`;
    
SELECT * FROM `user`;
-- INT 整數
-- DECIMAL(m,n) 有小數點的數字 m表示幾位數 n表示小數點後面有幾位
-- VARCHAR(n) 字串 n代表最多能存放幾個字元
-- BLOB 圖片 影片 檔案 (Binary Large Object)
-- DATE 'YYYY-MM-DD` 日期
-- TIMESTAMP `YYYY-MM-DD HH:MM:SS` 紀錄時間

-- NOT NULL不能為空/ UNIQUE 只能有一個 /DEFAULT 設定預設 /AUTO_INCREMENT 自動+1




SELECT
    u.user_id,
    u.user_name,
    gb.group_id,
    gb.product_name,
    gm.join_id,
    gm.quantity,
    gm.total_price,
    p.payment_id,
    p.pay_method,
    p.paid_time,
    d.deliver_id,
    d.deliver_method,
    d.deliver_status,
    d.deliver_time
FROM `group_member` AS gm
JOIN `user` AS u
    ON gm.user_id = u.user_id
JOIN `group_buy` AS gb
    ON gm.group_id = gb.group_id
LEFT JOIN `payment` AS p
    ON gm.join_id = p.join_id
LEFT JOIN `deliver` AS d
    ON gm.join_id = d.join_id;
