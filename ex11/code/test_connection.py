"""
实验十一：测试数据库连接和查询（非交互版本）
"""
import pymysql


def main():
    try:
        conn = pymysql.connect(
            host='127.0.0.1', user='root', password='gy20060516',
            database='学生选课', port=3306, charset='utf8mb4')
        cursor = conn.cursor()
        print("连接数据库成功！\n")

        print("="*50)
        print("查询1：所有学生信息")
        cursor.execute("SELECT * FROM student")
        for row in cursor.fetchall():
            print(f"  {row[0]} {row[1]} {row[2]} {row[3]} {row[4]}")

        print("\n查询2：所有课程信息")
        cursor.execute("SELECT * FROM course")
        for row in cursor.fetchall():
            print(f"  {row[0]} {row[1]} 学分:{row[2]}")

        print("\n查询3：学生选课情况及成绩")
        cursor.execute("""
            SELECT s.Sname, c.Cname, sc.Grade
            FROM student s, course c, sc
            WHERE s.Sno = sc.Sno AND c.Cno = sc.Cno ORDER BY s.Sname""")
        for row in cursor.fetchall():
            print(f"  {row[0]} -> {row[1]}: {row[2]}")

        print("\n查询4：各院系学生人数")
        cursor.execute("SELECT Sdept, COUNT(*) FROM student GROUP BY Sdept")
        for row in cursor.fetchall():
            print(f"  {row[0]}: {row[1]}人")

        print("\n查询5：数据库系统概论成绩")
        cursor.execute("""
            SELECT s.Sname, sc.Grade FROM student s, sc, course c
            WHERE s.Sno = sc.Sno AND sc.Cno = c.Cno
            AND c.Cname = '数据库系统概论'""")
        for row in cursor.fetchall():
            print(f"  {row[0]}: {row[1]}")

        print("\n查询6：各课程平均成绩")
        cursor.execute("""
            SELECT c.Cname, AVG(sc.Grade)
            FROM course c, sc WHERE c.Cno = sc.Cno
            AND sc.Grade IS NOT NULL GROUP BY c.Cname""")
        for row in cursor.fetchall():
            print(f"  {row[0]}: {row[1]:.1f}")

        cursor.close()
        conn.close()
        print("\n数据库连接已关闭")
    except pymysql.Error as e:
        print(f"错误：{e}")


if __name__ == '__main__':
    main()
