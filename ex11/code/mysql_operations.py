"""
实验十一：数据库设计 - Python数据库连接操作
使用 pymysql 连接 MySQL 数据库，执行查询和数据操作

功能：
1. 创建数据库和数据表
2. 插入数据
3. 查询操作
4. 关闭连接
"""
import pymysql


def connect_mysql():
    """连接MySQL服务器"""
    print("正在连接MySQL服务器......")
    connection = pymysql.connect(
        host='localhost',
        user='root',
        password='gy20060516',
        charset='utf8mb4'
    )
    print("连接MySQL服务器成功！")
    return connection


def create_database(cursor):
    """创建数据库"""
    database_name = '学生选课'
    cursor.execute(f"SHOW DATABASES LIKE '{database_name}'")
    results = cursor.fetchone()
    if results:
        print(f"数据库'{database_name}'已存在")
    else:
        create_sql = f"""CREATE DATABASE {database_name}
            CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci"""
        cursor.execute(create_sql)
        print(f"数据库'{database_name}'创建成功")


def create_tables(cursor):
    """创建数据表"""
    cursor.execute("USE `学生选课`")

    sql_create_student = """
        CREATE TABLE IF NOT EXISTS student (
            Sno      CHAR(8) PRIMARY KEY COMMENT '学号',
            Sname    VARCHAR(20) NOT NULL COMMENT '姓名',
            Ssex     CHAR(2) DEFAULT '男' COMMENT '性别',
            Sbirth   DATE COMMENT '出生日期',
            Sdept    VARCHAR(30) COMMENT '所在院系'
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='学生表'
    """
    sql_create_course = """
        CREATE TABLE IF NOT EXISTS course (
            Cno      CHAR(5) PRIMARY KEY COMMENT '课程号',
            Cname    VARCHAR(40) NOT NULL COMMENT '课程名',
            Credit   INT NOT NULL COMMENT '学分',
            Cpno     CHAR(5) COMMENT '先修课程号',
            FOREIGN KEY (Cpno) REFERENCES course(Cno) ON DELETE SET NULL
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='课程表'
    """
    sql_create_sc = """
        CREATE TABLE IF NOT EXISTS sc (
            Sno      CHAR(8) COMMENT '学号',
            Cno      CHAR(5) COMMENT '课程号',
            Grade    DECIMAL(4,1) DEFAULT NULL COMMENT '成绩',
            PRIMARY KEY (Sno, Cno),
            FOREIGN KEY (Sno) REFERENCES student(Sno) ON DELETE CASCADE,
            FOREIGN KEY (Cno) REFERENCES course(Cno) ON DELETE CASCADE
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='选课表'
    """

    tables = [
        ("student", sql_create_student),
        ("course", sql_create_course),
        ("sc", sql_create_sc)
    ]

    success_count = 0
    for table_name, sql in tables:
        try:
            cursor.execute(sql)
            print(f"数据表 '{table_name}' 创建成功")
            success_count += 1
        except pymysql.Error as e:
            print(f"数据表 '{table_name}' 创建失败: {e}")

    return success_count


def insert_data(cursor, connection):
    """向表中插入数据"""
    cursor.execute("USE `学生选课`")

    students = [
        ('20121512', '李勇', '男', '1999-01-23', '计算机系'),
        ('20121513', '刘晨', '女', '1999-06-01', '计算机系'),
        ('20121514', '王敏', '女', '2000-02-10', '计算机系'),
        ('20121515', '张立', '男', '1999-09-15', '信息系'),
        ('20121516', '刘强', '男', '1999-03-20', '信息系'),
        ('20121517', '赵丽', '女', '2000-07-08', '数学系'),
        ('20121518', '陈鹏', '男', '1999-12-01', '计算机系'),
    ]
    sql_insert_student = """
        INSERT IGNORE INTO student(Sno, Sname, Ssex, Sbirth, Sdept)
        VALUES (%s, %s, %s, %s, %s)
    """
    for s in students:
        try:
            cursor.execute(sql_insert_student, s)
        except pymysql.IntegrityError:
            print(f"学生{s[1]}已存在，跳过")
    connection.commit()
    print("学生数据插入完成")

    courses = [
        ('81001', '程序设计基础与C语言', 4, None),
        ('81002', '数据结构', 4, '81001'),
        ('81003', '数据库系统概论', 4, '81002'),
        ('81004', '信息系统概论', 4, '81003'),
        ('81005', '操作系统', 4, '81001'),
        ('81006', 'Python语言', 3, '81002'),
        ('81007', '离散数学', 4, None),
        ('81008', '大数据技术概论', 4, '81003'),
    ]
    sql_insert_course = """
        INSERT IGNORE INTO course(Cno, Cname, Credit, Cpno)
        VALUES (%s, %s, %s, %s)
    """
    for c in courses:
        try:
            cursor.execute(sql_insert_course, c)
        except pymysql.IntegrityError:
            print(f"课程{c[1]}已存在，跳过")
    connection.commit()
    print("课程数据插入完成")

    sc_data = [
        ('20121512', '81001', 92), ('20121512', '81002', 90),
        ('20121512', '81003', 88), ('20121513', '81001', 78),
        ('20121513', '81002', 85), ('20121513', '81003', 80),
        ('20121513', '81004', 75), ('20121514', '81001', 65),
        ('20121514', '81002', 72), ('20121514', '81007', 80),
        ('20121515', '81001', 88), ('20121515', '81005', 90),
        ('20121516', '81001', 70), ('20121516', '81006', 85),
        ('20121517', '81001', 95), ('20121517', '81007', 92),
    ]
    sql_insert_sc = """
        INSERT IGNORE INTO sc(Sno, Cno, Grade)
        VALUES (%s, %s, %s)
    """
    for sc_item in sc_data:
        try:
            cursor.execute(sql_insert_sc, sc_item)
        except pymysql.IntegrityError:
            print(f"选课记录({sc_item[0]},{sc_item[1]})已存在，跳过")
    connection.commit()
    print("选课数据插入完成")


def query_data():
    """执行查询"""
    conn = pymysql.connect(
        host='127.0.0.1',
        user='root',
        password='gy20060516',
        database='学生选课',
        port=3306,
        charset='utf8mb4'
    )
    cursor = conn.cursor()

    print("\n" + "="*60)
    print("查询1：所有学生信息")
    print("="*60)
    cursor.execute("SELECT * FROM student")
    for row in cursor.fetchall():
        print(f"  学号:{row[0]}, 姓名:{row[1]}, 性别:{row[2]}, "
              f"生日:{row[3]}, 院系:{row[4]}")

    print("\n" + "="*60)
    print("查询2：所有课程信息")
    print("="*60)
    cursor.execute("SELECT * FROM course")
    for row in cursor.fetchall():
        print(f"  课程号:{row[0]}, 课程名:{row[1]}, "
              f"学分:{row[2]}, 先修课:{row[3]}")

    print("\n" + "="*60)
    print("查询3：学生选课情况及成绩")
    print("="*60)
    sql = """SELECT s.Sname, c.Cname, sc.Grade, c.Credit
             FROM student s, course c, sc
             WHERE s.Sno = sc.Sno AND c.Cno = sc.Cno
             ORDER BY s.Sname, c.Cname"""
    cursor.execute(sql)
    for row in cursor.fetchall():
        print(f"  学生:{row[0]}, 课程:{row[1]}, "
              f"成绩:{row[2]}, 学分:{row[3]}")

    print("\n" + "="*60)
    print("查询4：各院系学生人数统计")
    print("="*60)
    cursor.execute("SELECT Sdept, COUNT(*) FROM student GROUP BY Sdept")
    for row in cursor.fetchall():
        print(f"  院系:{row[0]}, 人数:{row[1]}")

    print("\n" + "="*60)
    print("查询5：查询选修了'数据库系统概论'的学生")
    print("="*60)
    cursor.execute("""
        SELECT s.Sname, sc.Grade
        FROM student s, sc, course c
        WHERE s.Sno = sc.Sno AND sc.Cno = c.Cno
          AND c.Cname = '数据库系统概论'
    """)
    for row in cursor.fetchall():
        print(f"  学生:{row[0]}, 成绩:{row[1]}")

    print("\n" + "="*60)
    print("查询6：交互式查询")
    print("="*60)
    student_id = input('请输入学生学号：')
    course_name = input('请输入课程名称：')
    sql = """SELECT sc.Sno, s.Sname, sc.Grade
             FROM sc, student s, course c
             WHERE sc.Sno = s.Sno AND sc.Cno = c.Cno
                   AND sc.Sno = %s AND c.Cname = %s
                   AND sc.Grade = (
                       SELECT MAX(sc2.Grade)
                       FROM sc sc2, course c2
                       WHERE sc2.Sno = %s AND c2.Cname = %s
                         AND sc2.Cno = c2.Cno
                   )"""
    try:
        cursor.execute(sql, (student_id, course_name, student_id, course_name))
        if cursor.rowcount == 0:
            print("没有符合条件的记录！")
        else:
            results = cursor.fetchall()
            print("取得最高成绩的学生有：")
            for row in results:
                print(f"  {row[0]}\t{row[1]}\t{row[2]}")
    except pymysql.Error as e:
        print(f"执行过程出现错误：{e}")

    cursor.close()
    conn.close()


def main():
    """主函数"""
    connection = None
    cursor = None
    try:
        connection = connect_mysql()
        cursor = connection.cursor()
        create_database(cursor)
        create_tables(cursor)
        insert_data(cursor, connection)
        print("\n数据库设计和建表完成，开始查询...")
        query_data()
    except pymysql.Error as e:
        print(f"数据库操作出错：{e}")
    finally:
        if cursor:
            cursor.close()
        if connection:
            connection.close()
        print("\n数据库连接已关闭")


if __name__ == '__main__':
    main()
