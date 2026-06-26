-- ============================================================
-- 实验十一 数据库设计
-- 数据库：学生选课系统（student_course_db）
-- 内容：E-R图设计、关系模式转换、建表、数据插入、查询
-- ============================================================

-- 创建数据库
DROP DATABASE IF EXISTS `学生选课`;
CREATE DATABASE `学生选课` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `学生选课`;

-- ============================================================
-- 一、创建数据表
-- ============================================================

-- 1.1 学生表（Student）
CREATE TABLE student (
    Sno      CHAR(8) PRIMARY KEY COMMENT '学号',
    Sname    VARCHAR(20) NOT NULL COMMENT '姓名',
    Ssex     CHAR(2) DEFAULT '男' COMMENT '性别',
    Sbirth   DATE COMMENT '出生日期',
    Sdept    VARCHAR(30) COMMENT '所在院系',
    CONSTRAINT ck_student_ssex CHECK (Ssex IN ('男', '女'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='学生表';

-- 1.2 课程表（Course）
CREATE TABLE course (
    Cno      CHAR(5) PRIMARY KEY COMMENT '课程号',
    Cname    VARCHAR(40) NOT NULL COMMENT '课程名',
    Credit   INT NOT NULL COMMENT '学分',
    Cpno     CHAR(5) COMMENT '先修课程号',
    FOREIGN KEY (Cpno) REFERENCES course(Cno) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='课程表';

-- 1.3 选课表（SC）
CREATE TABLE sc (
    Sno      CHAR(8) COMMENT '学号',
    Cno      CHAR(5) COMMENT '课程号',
    Grade    DECIMAL(4,1) DEFAULT NULL COMMENT '成绩',
    PRIMARY KEY (Sno, Cno),
    FOREIGN KEY (Sno) REFERENCES student(Sno) ON DELETE CASCADE,
    FOREIGN KEY (Cno) REFERENCES course(Cno) ON DELETE CASCADE,
    CONSTRAINT ck_sc_grade CHECK (Grade >= 0 AND Grade <= 100)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='选课表';


-- ============================================================
-- 二、插入数据
-- ============================================================

-- 2.1 插入学生数据
INSERT INTO student VALUES ('20121512', '李勇', '男', '1999-01-23', '计算机系');
INSERT INTO student VALUES ('20121513', '刘晨', '女', '1999-06-01', '计算机系');
INSERT INTO student VALUES ('20121514', '王敏', '女', '2000-02-10', '计算机系');
INSERT INTO student VALUES ('20121515', '张立', '男', '1999-09-15', '信息系');
INSERT INTO student VALUES ('20121516', '刘强', '男', '1999-03-20', '信息系');
INSERT INTO student VALUES ('20121517', '赵丽', '女', '2000-07-08', '数学系');
INSERT INTO student VALUES ('20121518', '陈鹏', '男', '1999-12-01', '计算机系');

-- 2.2 插入课程数据（先插入无先修课的课程）
INSERT INTO course VALUES ('81001', '程序设计基础与C语言', 4, NULL);
INSERT INTO course VALUES ('81007', '离散数学', 4, NULL);
INSERT INTO course VALUES ('81002', '数据结构', 4, '81001');
INSERT INTO course VALUES ('81003', '数据库系统概论', 4, '81002');
INSERT INTO course VALUES ('81004', '信息系统概论', 4, '81003');
INSERT INTO course VALUES ('81005', '操作系统', 4, '81001');
INSERT INTO course VALUES ('81006', 'Python语言', 3, '81002');
INSERT INTO course VALUES ('81008', '大数据技术概论', 4, '81003');

-- 2.3 插入选课数据
INSERT INTO sc VALUES ('20121512', '81001', 92);
INSERT INTO sc VALUES ('20121512', '81002', 90);
INSERT INTO sc VALUES ('20121512', '81003', 88);
INSERT INTO sc VALUES ('20121513', '81001', 78);
INSERT INTO sc VALUES ('20121513', '81002', 85);
INSERT INTO sc VALUES ('20121513', '81003', 80);
INSERT INTO sc VALUES ('20121513', '81004', 75);
INSERT INTO sc VALUES ('20121514', '81001', 65);
INSERT INTO sc VALUES ('20121514', '81002', 72);
INSERT INTO sc VALUES ('20121514', '81007', 80);
INSERT INTO sc VALUES ('20121515', '81001', 88);
INSERT INTO sc VALUES ('20121515', '81005', 90);
INSERT INTO sc VALUES ('20121516', '81001', 70);
INSERT INTO sc VALUES ('20121516', '81006', 85);
INSERT INTO sc VALUES ('20121517', '81001', 95);
INSERT INTO sc VALUES ('20121517', '81007', 92);


-- ============================================================
-- 三、查询验证
-- ============================================================

-- 查看所有表数据
SELECT * FROM student;
SELECT * FROM course;
SELECT * FROM sc;

-- 查看表结构
DESCRIBE student;
DESCRIBE course;
DESCRIBE sc;

-- 查询学生选课情况
SELECT s.Sname, c.Cname, sc.Grade, c.Credit
FROM student s, course c, sc
WHERE s.Sno = sc.Sno AND c.Cno = sc.Cno
ORDER BY s.Sname, c.Cname;
