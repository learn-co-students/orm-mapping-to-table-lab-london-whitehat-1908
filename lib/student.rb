require_relative '../config/environment.rb'

class Student
  attr_reader :id
  attr_accessor :name, :grade

  def initialize(name, grade, id = nil)
    @name  = name
    @grade = grade
    @id = id
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    );
    SQL

    DB[:conn].execute sql
  end

  def self.drop_table
    sql = <<-SQL
    DROP TABLE students;
    SQL

    DB[:conn].execute sql
  end

  def save
    sql = <<-SQL
    INSERT INTO students (name, grade)
    VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, name, grade)

    sql = <<-SQL
    SELECT id FROM students
    ORDER BY id DESC
    LIMIT 1
    SQL

    @id = DB[:conn].execute(sql).first.first
  end

  def self.create(name: name, grade: grade)
    student = new(name, grade)
    student.save
    student
  end
end
