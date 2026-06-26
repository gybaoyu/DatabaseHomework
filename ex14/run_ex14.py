"""
实验十四：事务及并发控制 - 执行脚本
"""
import pymysql


def get_connection(autocommit=True):
    return pymysql.connect(
        host='localhost', user='root', password='gy20060516',
        database='学生管理', charset='utf8mb4', autocommit=autocommit)


def run_sql(cursor, sql, desc="", fetch=True):
    try:
        cursor.execute(sql)
        print(f"\n[SQL] {desc}")
        if fetch and cursor.description:
            for row in cursor.fetchall():
                print(f"  {row}")
        else:
            print("  OK")
    except pymysql.Error as e:
        print(f"  ERROR: {e}")


def main():
    print("="*60)
    print("一、COMMIT 和 ROLLBACK")
    print("="*60)

    conn = get_connection(autocommit=False)
    cur = conn.cursor()

    run_sql(cur, "SELECT * FROM course ORDER BY course_id", "实验前course表")

    print("\n>>> ROLLBACK演示")
    run_sql(cur, "START TRANSACTION", "开始事务")
    run_sql(cur, "INSERT INTO course VALUES ('04010107','Python程序设计','考查',36,2.0,NULL)", "插入1", fetch=False)
    run_sql(cur, "INSERT INTO course VALUES ('04010108','大数据技术','考试',40,2.5,NULL)", "插入2", fetch=False)
    run_sql(cur, "INSERT INTO course VALUES ('04010109','人工智能导论','考查',48,3.0,NULL)", "插入3", fetch=False)
    run_sql(cur, "SELECT * FROM course ORDER BY course_id", "ROLLBACK前")
    run_sql(cur, "ROLLBACK", "回滚", fetch=False)
    run_sql(cur, "SELECT * FROM course ORDER BY course_id", "ROLLBACK后(3条消失)")

    print("\n>>> COMMIT演示")
    run_sql(cur, "START TRANSACTION", "开始事务")
    run_sql(cur, "INSERT INTO course VALUES ('04010107','Python程序设计','考查',36,2.0,NULL)", "插入1", fetch=False)
    run_sql(cur, "INSERT INTO course VALUES ('04010108','大数据技术','考试',40,2.5,NULL)", "插入2", fetch=False)
    run_sql(cur, "INSERT INTO course VALUES ('04010109','人工智能导论','考查',48,3.0,NULL)", "插入3", fetch=False)
    run_sql(cur, "SELECT * FROM course ORDER BY course_id", "COMMIT前")
    run_sql(cur, "COMMIT", "提交", fetch=False)
    run_sql(cur, "SELECT * FROM course ORDER BY course_id", "COMMIT后(3条保留)")

    cur.close()
    conn.close()

    print("\n" + "="*60)
    print("二、事务隔离级别")
    print("="*60)

    conn2 = get_connection()
    cur2 = conn2.cursor()
    run_sql(cur2, "SELECT @@transaction_isolation", "当前隔离级别")
    run_sql(cur2, "SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED", "改为READ-COMMITTED", fetch=False)
    run_sql(cur2, "SELECT @@session.transaction_isolation", "修改后")
    run_sql(cur2, "SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ", "恢复REPEATABLE-READ", fetch=False)
    run_sql(cur2, "SELECT @@session.transaction_isolation", "恢复后")
    cur2.close()
    conn2.close()

    print("\n" + "="*60)
    print("三、清理")
    print("="*60)
    conn3 = get_connection()
    cur3 = conn3.cursor()
    run_sql(cur3, "DELETE FROM course WHERE course_id IN ('04010107','04010108','04010109')", "删除测试课程", fetch=False)
    cur3.close()
    conn3.close()
    print("\n实验十四完成！")


if __name__ == '__main__':
    main()
