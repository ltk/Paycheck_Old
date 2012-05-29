class Paycheck
  attr_reader :student, :starttime, :endtime, :comments, :value
  
  def initialize(student, starttime, endtime)
    @student = student
    @starttime = starttime
    @endtime = endtime
    
    #Add all of the student's comments to the Paycheck's comments array if they fall between the specified times
    @comments = []
    student.comments.each { |comment| @comments << comment if comment.timestamp > @starttime and comment.timestamp < @endtime }
    
    #Add up the values of all of this Paycheck's comments
    @value = 0;
    @comments.each { |comment| @value += comment.value }
  end
  
  def list_comments
    puts "Comments from #{@starttime} to #{@endtime}"
    puts "_______________________" 
    @comments.each { |comment| comment.summary }
    true #@comments
  end
  
  
end

class Student
  attr_reader :first_name, :last_name, :student_id, :comments
  
  def initialize(first_name, last_name)
    @first_name = first_name
    @last_name = last_name
    @comments = []
  end
  
  def add_comment(comment)
    @comments << comment
  end
  
  def list_comments
    @comments.each { |comment| comment.summary }
    true #@comments
  end
  
end

class Comment
  attr_reader :student, :value, :teacher, :categories, :message, :timestamp
  
  def initialize(student, value, teacher, categories, message, timestamp=Time.now.getutc)
    @student = student
    @value = value
    @teacher = teacher
    @categories = categories
    @message = message
    @timestamp = timestamp
    
    @student.add_comment(self)
    @teacher.add_comment(self)
  end
  
  def summary
    puts "Value: #{@value}"
    puts "Teacher: #{@teacher.to_str}"
    puts "Message: #{@message}"
    puts "Date: #{@timestamp}"
    cat_string = ''
    @categories.each { |category| cat_string += category.to_str + ' ' }
    puts "Categories: #{cat_string}"
    puts "_______________________"  
  end
  
end

class Teacher
  
  attr_reader :first_name, :last_name, :teacher_id, :comments
  
  def initialize(first_name, last_name)
    @first_name = first_name
    @last_name = last_name
    @comments = []
  end
  
  def to_str
    @first_name + ' ' + @last_name
  end
  
  def add_comment(comment)
    @comments << comment
  end
  
  def list_comments
    @comments.each { |comment| comment.summary }
    true #@comments
  end
  
  
end

class CommentCategory
  attr_reader :label
  
  def initialize(label)
    @label = label
  end
  
  def to_str
    @label
  end
  
end

class DemoSession
  attr_reader :student, :teacher1, :teacher2, :categories, :paycheck
  
  def initialize
    #Setup our student and teacher
    @student = Student.new('John', 'Smith')
    @teacher1 = Teacher.new('Lawson', 'Kurtz')
    @teacher2 = Teacher.new('Bob', 'Jones')
    
    #Setup the categories that our comments can fall under
    @category_labels = ['Academics', 'Character', 'Homework', 'Social Skills']
    @categories = []
    @category_labels.each { |category_label| @categories << CommentCategory.new(category_label) } 
  end
  
  def add_comments
    #This is a comment made by the teacher Lawson Kurtz
    @comment_1_categories = [@categories[0]]
    Comment.new(@student, 2, @teacher1, @comment_1_categories, 'Great work in class today!')
    
    #This is the second comment made by the teacher Lawson Kurtz
    @comment_2_categories = [@categories[1], @categories[0]]
    Comment.new(@student, 2, @teacher1, @comment_2_categories, 'Great work in class today!')

    #This is a comment made by the teacher Bob Jones
    @comment_3_categories = [@categories[2], @categories[1]]
    Comment.new(@student, 5, @teacher2, @comment_3_categories, 'Great work in class yesterday!', Time.utc(2012,"jan",1,1,1,1))
  end
  
  def create_paycheck
    #Create a paycheck
    @paycheck = Paycheck.new(@student, Time.utc(2011,"jan",1,1,1,1), Time.utc(2013,"jan",1,1,1,1))
  end
end









