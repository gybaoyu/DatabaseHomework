"""执行实验十三的SQL脚本"""
import pymysql
import sys

conn = pymysql.connect(
    host='localhost',
    user='root',
    password='gy20060516',
    charset='utf8mb4',
    autocommit=True
)
cursor = conn.cursor()

def execute_sql(sql, description=""):
    """执行一条SQL语句"""
    try:
        cursor.execute(sql)
        if cursor.description:
            result = cursor.fetchall()
            if result:
                print(f"[OK] {description}")
                for row in result:
                    print(f"  {row}")
            else:
                print(f"[OK] {description} (no result)")
        else:
            print(f"[OK] {description}")
    except pymysql.Error as e:
        print(f"[ERR] {description}: {e}")

# ===== 一、用户管理 =====
print("\n" + "="*60)
print("一、用户管理")
print("="*60)

execute_sql("CREATE USER 'teas1'@'localhost' IDENTIFIED BY 'stu'", "创建用户 teas1@localhost")
execute_sql("CREATE USER 'teas1'@'%' IDENTIFIED BY 'stu'", "创建用户 teas1@%")
execute_sql("CREATE USER 't1'@'localhost' IDENTIFIED BY 't1'", "创建用户 t1@localhost")
execute_sql("CREATE USER 't1'@'%' IDENTIFIED BY 't1'", "创建用户 t1@%")
execute_sql("ALTER USER 't1'@'localhost' IDENTIFIED BY 'hello'", "修改 t1@localhost 密码为 hello")
execute_sql("ALTER USER 't1'@'%' IDENTIFIED BY 'hello'", "修改 t1@% 密码为 hello")
execute_sql("DROP USER IF EXISTS 'stu'@'localhost'", "删除用户 stu@localhost")
execute_sql("DROP USER IF EXISTS 'stu'@'%'", "删除用户 stu@%")
execute_sql("SELECT User, Host FROM mysql.user WHERE User IN ('teas1', 't1', 'stu')", "查看创建的用户")

# ===== 二、权限管理 =====
print("\n" + "="*60)
print("二、权限管理")
print("="*60)

execute_sql("GRANT SELECT ON `学生管理`.student TO 't1'@'localhost'", "授予 t1 对 student 表的 SELECT 权限")
execute_sql("GRANT INSERT ON `学生管理`.score TO 't1'@'localhost'", "授予 t1 对 score 表的 INSERT 权限")
execute_sql("GRANT UPDATE ON `学生管理`.score TO 't1'@'localhost'", "授予 t1 对 score 表的 UPDATE 权限")
execute_sql("GRANT SELECT (student_id, course_id, score_grade, score_semester) ON `学生管理`.score TO 't1'@'localhost'", "授予 t1 对 score 表特定列的 SELECT 权限")
execute_sql("GRANT SELECT (student_id, student_name, student_sex) ON `学生管理`.student TO 't1'@'localhost'", "授予 t1 对 student 表特定列的 SELECT 权限")
execute_sql("SHOW GRANTS FOR 't1'@'localhost'", "查看 t1 权限")

execute_sql("REVOKE SELECT ON `学生管理`.score FROM 't1'@'localhost'", "收回 t1 对 score 表的 SELECT 权限")
execute_sql("SHOW GRANTS FOR 't1'@'localhost'", "查看收回后 t1 的权限")

# 视图操作
execute_sql("GRANT SELECT ON `学生管理`.student TO 't1'@'localhost'", "重新授予 t1 对 student 的 SELECT")
execute_sql("GRANT CREATE VIEW ON `学生管理`.* TO 't1'@'localhost'", "授予 t1 创建视图权限")
# 先用USE切换到目标数据库
execute_sql("USE `学生管理`", "切换到学生管理数据库")
execute_sql("DROP VIEW IF EXISTS CS_Student", "删除旧视图 CS_Student")
execute_sql("""
    CREATE VIEW CS_Student AS
    SELECT * FROM student WHERE class_id IN (
        SELECT class_id FROM class WHERE class_major LIKE '%信息%'
    )
""", "创建 CS_Student 视图（信息系学生）")
execute_sql("GRANT SELECT ON `学生管理`.CS_Student TO 't1'@'localhost'", "授予 t1 对 CS_Student 的查询权限")
execute_sql("SHOW GRANTS FOR 't1'@'localhost'", "查看最终 t1 的权限")

# ===== 三、角色管理 =====
print("\n" + "="*60)
print("三、角色管理")
print("="*60)

execute_sql("CREATE ROLE 'teacher'", "创建角色 teacher")
execute_sql("GRANT SELECT ON `学生管理`.course TO 'teacher'", "授予 teacher 角色对 course 的 SELECT 权限")
execute_sql("GRANT INSERT, UPDATE, DELETE ON `学生管理`.course TO 'teacher'", "授予 teacher 角色对 course 的 INSERT/UPDATE/DELETE 权限")
execute_sql("SHOW GRANTS FOR 'teacher'", "查看 teacher 角色的权限")

execute_sql("GRANT 'teacher' TO 't1'@'localhost'", "将 teacher 角色授予 t1")
execute_sql("SHOW GRANTS FOR 't1'@'localhost'", "查看 t1 的权限（含角色）")

execute_sql("REVOKE DELETE ON `学生管理`.course FROM 'teacher'", "收回 teacher 角色的 DELETE 权限")
execute_sql("SHOW GRANTS FOR 'teacher'", "查看收回后 teacher 角色的权限")

execute_sql("REVOKE 'teacher' FROM 't1'@'localhost'", "从 t1 收回 teacher 角色")
execute_sql("SHOW GRANTS FOR 't1'@'localhost'", "查看收回角色后 t1 的权限")

print("\n" + "="*60)
print("实验十三 SQL 脚本执行完毕！")
print("="*60)

cursor.close()
conn.close()
