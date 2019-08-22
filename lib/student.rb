# Remember, you can access your database connection anywhere in this class
#  with DB[:conn]
class Student
  attr_reader :id
  attr_accessor :name, :grade

  def initialize(name, grade, id = nil)
    @id = id
    @name = name
    @grade = grade
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS
      students (
        id INTEGER PRIMARY KEY,
        name TEXT, 
        grade TEXT
      )
      SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
      DROP TABLE students
      SQL
    DB[:conn].execute(sql)
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)

    res = DB[:conn].execute("SELECT id FROM students ORDER BY id DESC;")
    @id = res.first.first
  end

  def self.create(name:, grade:)
    student = Student.new(name, grade)
    student.save
    student
  end
end
