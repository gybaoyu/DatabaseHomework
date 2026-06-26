-- ============================================================
-- 实验十三 自主存取控制实验
-- 数据库：学生管理
-- 实验内容：用户管理、权限管理、角色管理
-- ============================================================

USE `学生管理`;

-- ============================================================
-- 一、用户管理
-- ============================================================

-- 1.1 创建用户 teas1，密码为 stu
CREATE USER 'teas1'@'localhost' IDENTIFIED BY 'stu';
CREATE USER 'teas1'@'%' IDENTIFIED BY 'stu';

-- 1.2 创建用户 t1，密码为 t1
CREATE USER 't1'@'localhost' IDENTIFIED BY 't1';
CREATE USER 't1'@'%' IDENTIFIED BY 't1';

-- 1.3 修改用户 t1 的密码为 hello
ALTER USER 't1'@'localhost' IDENTIFIED BY 'hello';
ALTER USER 't1'@'%' IDENTIFIED BY 'hello';

-- 1.4 删除用户 stu（如果存在）
DROP USER IF EXISTS 'stu'@'localhost';
DROP USER IF EXISTS 'stu'@'%';

-- 查看用户
SELECT User, Host FROM mysql.user WHERE User IN ('teas1', 't1', 'stu');


-- ============================================================
-- 二、权限管理
-- ============================================================

-- 2.1 授予 t1 对 student 表的查询(SELECT)权限
GRANT SELECT ON `学生管理`.student TO 't1'@'localhost';
GRANT SELECT ON `学生管理`.student TO 't1'@'%';

-- 2.2 授予 t1 对 score 表的插入(INSERT)权限
GRANT INSERT ON `学生管理`.score TO 't1'@'localhost';
GRANT INSERT ON `学生管理`.score TO 't1'@'%';

-- 2.3 授予 t1 对 score 表的更新(UPDATE)权限
GRANT UPDATE ON `学生管理`.score TO 't1'@'localhost';
GRANT UPDATE ON `学生管理`.score TO 't1'@'%';

-- 2.4 授予 t1 对 score 表的查询权限(s1列)和 student 表的查询权限(s1列)
--     注：列级权限——授予对特定列的访问权限
GRANT SELECT (student_id, course_id, score_grade, score_semester) ON `学生管理`.score TO 't1'@'localhost';
GRANT SELECT (student_id, course_id, score_grade, score_semester) ON `学生管理`.score TO 't1'@'%';
GRANT SELECT (student_id, student_name, student_sex) ON `学生管理`.student TO 't1'@'localhost';
GRANT SELECT (student_id, student_name, student_sex) ON `学生管理`.student TO 't1'@'%';

-- 查看 t1 的权限
SHOW GRANTS FOR 't1'@'localhost';

-- 2.5 root 收回 t1 对 score 表的查询权限
REVOKE SELECT ON `学生管理`.score FROM 't1'@'localhost';
REVOKE SELECT ON `学生管理`.score FROM 't1'@'%';

-- 查看收回后的权限
SHOW GRANTS FOR 't1'@'localhost';

-- 2.6 t1 创建 CS_Student 视图（基于student表，只包含计算机系学生）
--     注：需要先以root身份授予t1创建视图的权限
GRANT CREATE VIEW ON `学生管理`.* TO 't1'@'localhost';
GRANT CREATE VIEW ON `学生管理`.* TO 't1'@'%';

-- 重新授予t1对student表的SELECT权限（以便创建视图）
GRANT SELECT ON `学生管理`.student TO 't1'@'localhost';
GRANT SELECT ON `学生管理`.student TO 't1'@'%';

-- 创建 CS_Student 视图（需要以t1用户登录执行，这里先用root演示）
-- 实际执行时以t1身份登录：
-- CREATE VIEW CS_Student AS
-- SELECT * FROM student WHERE class_id IN (
--     SELECT class_id FROM class WHERE class_major LIKE '%计算机%'
-- );
-- 此处由root创建演示视图，然后授予t1权限
DROP VIEW IF EXISTS CS_Student;
CREATE VIEW CS_Student AS
SELECT * FROM student WHERE class_id IN (
    SELECT class_id FROM class WHERE class_major LIKE '%信息%'
);

-- 授予 t1 对视图 CS_Student 的查询权限
GRANT SELECT ON `学生管理`.CS_Student TO 't1'@'localhost';
GRANT SELECT ON `学生管理`.CS_Student TO 't1'@'%';

-- 查看最终 t1 的权限
SHOW GRANTS FOR 't1'@'localhost';


-- ============================================================
-- 三、角色管理
-- ============================================================

-- 3.1 创建角色 teacher
CREATE ROLE 'teacher';

-- 3.2 授予 teacher 角色对 course 表的查询权限
GRANT SELECT ON `学生管理`.course TO 'teacher';

-- 3.3 授予 teacher 角色对 course 表的插入、更新、删除权限
GRANT INSERT, UPDATE, DELETE ON `学生管理`.course TO 'teacher';

-- 查看 teacher 角色的权限
SHOW GRANTS FOR 'teacher';

-- 3.4 将 teacher 角色授予 t1 用户
GRANT 'teacher' TO 't1'@'localhost';
GRANT 'teacher' TO 't1'@'%';

-- 查看 t1 的权限（包含角色权限）
SHOW GRANTS FOR 't1'@'localhost';
SHOW GRANTS FOR 't1'@'localhost' USING 'teacher';

-- 3.5 收回 teacher 角色的删除(DELETE)权限
REVOKE DELETE ON `学生管理`.course FROM 'teacher';

-- 查看收回后 teacher 角色的权限
SHOW GRANTS FOR 'teacher';

-- 3.6 从 t1 用户收回 teacher 角色
REVOKE 'teacher' FROM 't1'@'localhost';
REVOKE 'teacher' FROM 't1'@'%';

-- 查看收回角色后 t1 的权限
SHOW GRANTS FOR 't1'@'localhost';

-- 3.7 验证第5步：teacher角色已无DELETE权限
-- 查看 teacher 角色当前权限
SHOW GRANTS FOR 'teacher';


-- ============================================================
-- 四、清理（可选，保留用于实验验证）
-- ============================================================

-- 如需清理实验环境，取消以下注释：
-- DROP VIEW IF EXISTS CS_Student;
-- DROP USER IF EXISTS 'teas1'@'localhost';
-- DROP USER IF EXISTS 'teas1'@'%';
-- DROP USER IF EXISTS 't1'@'localhost';
-- DROP USER IF EXISTS 't1'@'%';
-- DROP ROLE IF EXISTS 'teacher';
-- REVOKE ALL PRIVILEGES, GRANT OPTION FROM 't1'@'localhost';
-- REVOKE ALL PRIVILEGES, GRANT OPTION FROM 't1'@'%';
-- FLUSH PRIVILEGES;
