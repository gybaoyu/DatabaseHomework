CREATE DATABASE IF NOT EXISTS `学生选课`
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `student` (
    `Sno` CHAR(8) NOT NULL COMMENT '学号',
    `Sname` VARCHAR(20) NULL,
    `Ssex` CHAR(1) NULL,
    `Sbirthdate` DATE NULL,
    `Smajor` VARCHAR(40) NULL,
    PRIMARY KEY (`Sno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `course` (
    `Cno` CHAR(5) NOT NULL,
    `Cname` VARCHAR(40) NOT NULL,
    `Ccredit` SMALLINT NULL,
    `Cpno` CHAR(5) NULL,
    PRIMARY KEY (`Cno`),
    CONSTRAINT `fk_course_cpno` FOREIGN KEY (`Cpno`) REFERENCES `course` (`Cno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `sc` (
    `Sno` CHAR(8) NOT NULL,
    `Cno` CHAR(5) NOT NULL,
    `Grade` SMALLINT NULL,
    `Semester` CHAR(5) NULL,
    `Teachingclass` CHAR(8) NULL,
    PRIMARY KEY (`Sno`, `Cno`),
    CONSTRAINT `fk_sc_sno` FOREIGN KEY (`Sno`) REFERENCES `student` (`Sno`),
    CONSTRAINT `fk_sc_cno` FOREIGN KEY (`Cno`) REFERENCES `course` (`Cno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- a) 增加新列 Sage
ALTER TABLE `student`
ADD COLUMN `Sage` FLOAT NULL;
-- b) 修改 Sage 列的数据类型
ALTER TABLE `student`
MODIFY COLUMN `Sage` INT NULL;
-- c) 删除 Sage 列
ALTER TABLE `student`
DROP COLUMN `Sage`;


