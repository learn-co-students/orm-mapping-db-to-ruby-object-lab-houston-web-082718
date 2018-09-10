require 'pry'

class Student
  attr_accessor :id, :name, :grade

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class

    sql = <<-SQL
      SELECT * FROM students
    SQL

    all_students = DB[:conn].execute(sql)

    all_students.map do |stud|
      self.new_from_db(stud)
    end

  end

  def self.all_students_in_grade_9
    sql = <<-SQL
      SELECT * FROM students WHERE grade = ?
    SQL

    all_from_nine = DB[:conn].execute(sql,9)

    all_from_nine.map do |nines|
      self.new_from_db(nines)
    end

  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT * FROM students WHERE grade < 12
    SQL

    below_12 = DB[:conn].execute(sql)

    below_12.map do |twelve|
      self.new_from_db(twelve)
    end
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT * FROM students WHERE grade = 10 LIMIT 1
    SQL

    grade_10 = DB[:conn].execute(sql)

    self.new_from_db(grade_10.first)
  end

  def self.first_X_students_in_grade_10(n)
    sql = <<-SQL
      SELECT * FROM students WHERE grade = 10 LIMIT ?
    SQL

    grade_10 = DB[:conn].execute(sql, n)

    grade_10.map do |twelve|
      self.new_from_db(twelve)
    end
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
      SELECT * FROM students WHERE name = ?
    SQL

    info = DB[:conn].execute(sql, name)

    # binding.pry

    self.new_from_db(info.first)

  end

  def self.all_students_in_grade_X (n)
    sql = <<-SQL
      SELECT * FROM students WHERE grade = ?
    SQL

    info = DB[:conn].execute(sql, n)

    info.map do |grade|
      self.new_from_db(grade)
    end

  end
  
  def save
    sql = <<-SQL
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def self.new_from_db(row)
    new_student = Student.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end

end
