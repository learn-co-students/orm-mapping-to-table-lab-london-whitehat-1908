class Student
	attr_accessor :name, :grade
	attr_reader :id

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]  
	def initialize(name, grade, id=nil)
		@name = name
		@grade = grade
		@id = id
	end
	
	def self.create_table
		DB[:conn].execute("CREATE TABLE IF NOT EXISTS students(id INTEGER PRIMARY KEY, name TEXT, grade TEXT);")
	end

	def self.drop_table
		DB[:conn].execute("DROP TABLE IF EXISTS students;")
	end

	def self.create (name:, grade:)
		stud = Student.new(name,grade)
		stud.save
		stud
	end
  
	def save
		id_temp = (id_temp == nil) ? 1 : nil
		DB[:conn].execute("INSERT OR REPLACE INTO students VALUES ( COALESCE((SELECT id FROM students WHERE id=?),?),?,?);", id_temp, id_temp, @name, @grade)

		@id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
	end
end

