-- T1
CREATE DATABASE IF NOT EXISTS `学生管理`
DEFAULT CHARACTER SET utf8mb4
DEFAULT COLLATE utf8mb4_general_ci;

USE `学生管理`;
-- T2
CREATE TABLE IF NOT EXISTS `class` (
    `class_id` CHAR(6) NOT NULL COMMENT '班级编号',
    `class_name` VARCHAR(20) NULL COMMENT '班级名称',
    `class_major` VARCHAR(20) NULL COMMENT '所属专业',
    `class_size` INT NULL COMMENT '班级人数',
    PRIMARY KEY (`class_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


CREATE TABLE IF NOT EXISTS `student` (
    `student_id` CHAR(10) NOT NULL COMMENT '学号',
    `student_name` VARCHAR(8) NULL COMMENT '姓名',
    `student_sex` CHAR(2) NULL COMMENT '性别',
    `student_birthdate` DATE NULL COMMENT '出生日期',
    `student_entrancescore` DECIMAL(4, 1) NULL COMMENT '入学成绩',
    `student_partymember` BIT(1) NULL COMMENT '党员否',
    `student_resume` TEXT NULL COMMENT '简历',
    `student_photo` BLOB NULL COMMENT '照片',
    `class_id` CHAR(6) NOT NULL COMMENT '班级编号',
    PRIMARY KEY (`student_id`),
    INDEX `ix_student_entrancescore` (`student_entrancescore` ASC), -- 按入学成绩升序建立索引
    CONSTRAINT `fk_student_class` FOREIGN KEY (`class_id`) REFERENCES `class` (`class_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


CREATE TABLE IF NOT EXISTS `course` (
    `course_id` CHAR(8) NOT NULL COMMENT '课程编号',
    `course_name` VARCHAR(40) NULL COMMENT '课程名称',
    `course_assessmentmethod` CHAR(2) NULL COMMENT '考核方式',
    `course_hours` INT NULL COMMENT '学时',
    `course_credit` DECIMAL(2, 1) NULL COMMENT '学分',
    `course_prerequisite` CHAR(8) NULL COMMENT '先修课',
    PRIMARY KEY (`course_id`),
    INDEX `ix_course_name` (`course_name` DESC), -- 按课程名称降序建立索引
    CONSTRAINT `fk_course_course` FOREIGN KEY (`course_prerequisite`) REFERENCES `course` (`course_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


CREATE TABLE IF NOT EXISTS `score` (
    `student_id` CHAR(10) NOT NULL COMMENT '学号',
    `course_id` CHAR(8) NOT NULL COMMENT '课程编号',
    `score_grade` DECIMAL(4, 1) NULL COMMENT '成绩',
    `score_semester` CHAR(9) NULL COMMENT '学期',
    PRIMARY KEY (`student_id`, `course_id`),
    CONSTRAINT `fk_score_student` FOREIGN KEY (`student_id`) REFERENCES `student` (`student_id`),
    CONSTRAINT `fk_score_course` FOREIGN KEY (`course_id`) REFERENCES `course` (`course_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- T3
-- a)
ALTER TABLE `student`
ADD COLUMN `Sage` DECIMAL(3, 0) NULL COMMENT '学生的年龄';

-- b)
ALTER TABLE `student`
MODIFY COLUMN `Sage` INT NULL;

-- c)
ALTER TABLE `student`
DROP COLUMN `Sage`;

-- 2. 删除 student 表的索引 ix_student_entrancescore
DROP INDEX `ix_student_entrancescore` ON `student`;

-- 3. 删除 course 表的索引 ix_course_name
DROP INDEX `ix_course_name` ON `course`;
