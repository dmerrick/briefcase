#!/usr/bin/env ruby -wKU

class Briefcase

  attr_accessor :files

  def initialize()
    @files = parse_data_section
  end

  # Converts @files to a savable IO object.
  def save_to_file(filename)
    File.open(filename,"w") do |file|
      generate_data_section.each do |line_of_data|
        file.puts line_of_data
      end
    end
  end

  def save_all_files
    @files.each do |filename, contents|
      File.open(filename, "w") do |file|
        file.puts contents
      end
      puts "-- saved #{filename}"
      puts File.read(filename)
    end
  end

  private
  # Converts DATA section into the @files object.
  def parse_data_section()

    # if the DATA block doesn't start with a file boundary, we'll just send
    # everything to the following file
    current_file = "header.txt"

    # this hash will contain the files stored in the data section, keyed by
    # filename (as a string)
    files_hash = Hash.new("")

    DATA.readlines.each do |line|

      # create a new file if we hit the boundary
      if line =~ />>>>>(.*)<<<<</
        current_file = $1.strip
        next
      end

      # write the file data into the hash
      files_hash[current_file] += line

    end

    return files_hash

  end

  def generate_data_section
    data_section = []
    @files.each do |filename, contents|
      data_section << ">>>> #{filename} <<<<<"
      data_section << contents
    end

    data_section
  end

end

if $0 == __FILE__
  bc = Briefcase.new
  
  bc.save_all_files

  require 'pp'
  # print the file hash
  #pp bc.files

  #test_file_name = "trying.txt"
  #bc.save_to_file(test_file_name)
  #puts File.read(test_file_name)

end





















# this is down here to keep it out of view :)
__END__
>>>>> test1.txt <<<<<
This is a text file.
It is test file number one.

>>>>> test2.txt <<<<<
This is a text file.
It is test file number two.

