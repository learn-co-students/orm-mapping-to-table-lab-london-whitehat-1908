class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]  
  
  attr_reader :id
  attr_accessor :name, :grade
  DB = {:conn => SQLite3::Database.new("db/students.db")}

  def initialize(name, grade)
    @id = id
    @name = name
    @grade = grade
  end

  def self.create_table 
    sql =  <<-SQL 
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY, 
      name TEXT,
      grade TEXT
      );
      SQL
    DB[:conn].execute(sql) 
  end 

  def self.drop_table
    sql =  <<-SQL 
    DROP TABLE students;
      SQL
    DB[:conn].execute(sql) 
  end

  def save
    sql =  <<-SQL 
    INSERT INTO students (name, grade) 
    VAlUES (?, ?);
      SQL
    DB[:conn].execute(sql, @name, @grade) 

    sql =  <<-SQL 
    SELECT id 
    FROM students
    ORDER BY id DESC
    LIMIT 1;
      SQL
    arr = DB[:conn].execute(sql)
    @id = arr[0][0]
  end

  def self.create(name:, grade:)
    student = Student.new(name, grade)
    student.save
    return student
  end

end
