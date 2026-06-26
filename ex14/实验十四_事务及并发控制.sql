-- ============================================================
-- 实验十四 事务及并发控制实验
-- 数据库：学生管理
-- 实验内容：COMMIT/ROLLBACK、事务隔离级别、并发控制
-- ============================================================

USE `学生管理`;

-- ============================================================
-- 一、事务基本操作：COMMIT 和 ROLLBACK
-- ============================================================

-- 1.1 查看当前course表中的数据（实验前状态）
SELECT * FROM course ORDER BY course_id;

-- 1.2 ROLLBACK 演示：插入3条课程记录后回滚
--     功能：插入课程，使用ROLLBACK撤销
START TRANSACTION;

INSERT INTO course VALUES ('04010107', 'Python程序设计', '考查', 36, 2.0, NULL);
INSERT INTO course VALUES ('04010108', '大数据技术', '考试', 40, 2.5, NULL);
INSERT INTO course VALUES ('04010109', '人工智能导论', '考查', 48, 3.0, NULL);

-- 查看事务内的插入结果
SELECT * FROM course ORDER BY course_id;

-- 回滚，撤销所有插入
ROLLBACK;

-- 验证：ROLLBACK后数据应恢复原状（3条新课程不存在）
SELECT * FROM course ORDER BY course_id;


-- 1.3 COMMIT 演示：插入3条课程记录后提交
--     功能：插入课程，使用COMMIT永久保存
START TRANSACTION;

INSERT INTO course VALUES ('04010107', 'Python程序设计', '考查', 36, 2.0, NULL);
INSERT INTO course VALUES ('04010108', '大数据技术', '考试', 40, 2.5, NULL);
INSERT INTO course VALUES ('04010109', '人工智能导论', '考查', 48, 3.0, NULL);

-- 查看事务内的插入结果
SELECT * FROM course ORDER BY course_id;

-- 提交，永久保存
COMMIT;

-- 验证：COMMIT后数据应包含新插入的3条课程
SELECT * FROM course ORDER BY course_id;


-- ============================================================
-- 二、事务隔离级别
-- ============================================================

-- 2.1 查看当前事务隔离级别
SELECT @@transaction_isolation AS '当前会话隔离级别';
SELECT @@global.transaction_isolation AS '全局隔离级别';
SELECT @@session.transaction_isolation AS '会话隔离级别';

-- 2.2 设置为 READ-COMMITTED（读已提交）隔离级别
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT @@session.transaction_isolation AS '修改后隔离级别';

-- 2.3 恢复为默认的 REPEATABLE-READ（可重复读）隔离级别
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SELECT @@session.transaction_isolation AS '恢复后隔离级别';


-- ============================================================
-- 三、并发控制实验（REPEATABLE READ 隔离级别）
-- ============================================================

-- 说明：以下实验需要开启两个MySQL会话（T1和T2）来模拟并发访问
-- 会话T1模拟用户1的操作，会话T2模拟用户2的操作
-- 以下SQL按时间顺序标注了T1和T2的执行步骤

-- ------------------------------------------------------------
-- 实验场景1：REPEATABLE READ下的并发更新
-- ------------------------------------------------------------

-- 【T1-步骤1】T1开始事务，查询学号为2021094001的学生的成绩
-- START TRANSACTION;
-- SELECT * FROM score WHERE student_id = '2021094001';
-- （此时T1看到原始数据）

-- 【T2-步骤1】T2开始事务，更新学号为2021094001的学生的成绩+2，提交
-- START TRANSACTION;
-- UPDATE score SET score_grade = score_grade + 2 WHERE student_id = '2021094001';
-- SELECT * FROM score WHERE student_id = '2021094001';
-- COMMIT;
-- （T2提交了修改）

-- 【T1-步骤2】T1再次查询学号为2021094001的学生的成绩
-- SELECT * FROM score WHERE student_id = '2021094001';
-- （REPEATABLE READ下T1看不到T2的修改，数据与步骤1相同）

-- 【T1-步骤3】T1提交
-- COMMIT;


-- ------------------------------------------------------------
-- 实验场景2：READ COMMITTED下的并发更新
-- ------------------------------------------------------------

-- 先在T1中设置READ COMMITTED隔离级别
-- SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- 【T1-步骤1】T1开始事务，查询学号为2021094001的学生的成绩
-- START TRANSACTION;
-- SELECT * FROM score WHERE student_id = '2021094001';

-- 【T2-步骤1】T2更新学号为2021094002的学生的成绩
-- START TRANSACTION;
-- SELECT * FROM score WHERE student_id = '2021094002';
-- UPDATE score SET score_grade = score_grade + 3 WHERE student_id = '2021094001';
-- SELECT * FROM score WHERE student_id = '2021094002';
-- COMMIT;
-- （T2提交了对T1查询的数据的修改）

-- 【T1-步骤2】T1再次查询（READ COMMITTED下能看到T2已提交的修改）
-- SELECT * FROM score WHERE student_id = '2021094001';
-- （此时T1看到的数据与步骤1不同，包含了T2的修改）

-- 【T1-步骤3】T1提交
-- COMMIT;


-- ------------------------------------------------------------
-- 实验场景3：REPEATABLE READ下的并发插入（幻读测试）
-- ------------------------------------------------------------

-- 【T1】在REPEATABLE READ隔离级别下：
-- START TRANSACTION;
-- SELECT * FROM score WHERE student_id = '2021094001';

-- 【T2】插入新记录并提交：
-- START TRANSACTION;
-- INSERT INTO score VALUES('2021094001', '04010107', 80, '202220231');
-- SELECT * FROM score WHERE student_id = '2021094001';
-- COMMIT;

-- 【T1】再次查询（REPEATABLE READ下看不到T2的插入——无幻读）：
-- SELECT * FROM score WHERE student_id = '2021094001';
-- COMMIT;
-- SELECT * FROM score WHERE student_id = '2021094001';
-- （提交后再次查询，可以看到T2插入的记录）


-- ============================================================
-- 四、清理实验数据
-- ============================================================

-- 删除实验插入的测试课程
-- DELETE FROM course WHERE course_id IN ('04010107', '04010108', '04010109');
