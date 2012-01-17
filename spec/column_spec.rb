require 'spec_helper'

include TracksGrid

describe Column do
  it 'should have name and header' do
    g = PersonGrid.new
    col_spec = g.column_specs.detect_name :name
    col_spec.name.should == :name

    col= g.columns.detect_name :name
    col.name.should == :name
    col.header.should == 'Name'

    col_spec = g.column_specs.detect_name :full_name
    col_spec.name.should == :full_name

    g = PersonGrid.new
    col = g.columns.detect_name :full_name
    col.name.should == :full_name
    col.header.should == 'Full name'
  end

  it 'should have headers' do
    g = PersonGrid.new
    g.headers.size.should == 3
    g.headers.should == [ 'Name', 'Full name', 'Job Title' ]
  end

  it 'should have rows' do
    g = PersonGrid.new 
    g.rows.size.should == 7

    g = PersonGrid.new :order => :name
    g.rows.size.should == 7
    g.rows.should == [
       ["Dana", "Dana Twen", "teacher"],
       ["Dick", "Dick Teeny", "student"],
       ["Joe", "Joe Teen", "student"],
       ["John", "John Twen", "teacher"],
       ["Lisa", "Lisa Adult", "dentist"],
       ["Max", "Max Kid", "student"],
       ["Tina", "Tina Child", "student"]
    ]
  end

  it 'should order columns' do
    g = PersonGrid.new :order => :profession
    g.rows.size.should == 7
    g.rows.map{|r|r.last}.should == [
       "dentist",
       "student",
       "student",
       "student",
       "student",
       "teacher",
       "teacher"
    ]
  end

  it 'should order columns ascending' do
    g = PersonGrid.new :order => :profession, :desc => false
    g.rows.size.should == 7
    g.rows.map{|r|r.last}.should == [
       "dentist",
       "student",
       "student",
       "student",
       "student",
       "teacher",
       "teacher"
    ]
  end

  it 'should order columns descending' do
    g = PersonGrid.new :order => :profession, :desc => true
    g.rows.size.should == 7
    g.rows.map{|r|r.last}.should == [
       "teacher",
       "teacher",
       "student",
       "student",
       "student",
       "student",
       "dentist"
    ]
  end

  it 'should order columns descending with given descend' do
    g = PersonGrid.new :order => :profession, :desc => 'profession DESC'
    g.rows.size.should == 7
    g.rows.map{|r|r.last}.should == [
       "teacher",
       "teacher",
       "student",
       "student",
       "student",
       "student",
       "dentist"
    ]
  end

  it 'should order complex columns' do
    g = PersonGrid.new :order => :full_name
    g.rows.size.should == 7
    g.rows.should == [
       ["Dana", "Dana Twen",  "teacher"],
       ["Dick", "Dick Teeny", "student"],
       ["Joe",  "Joe Teen",   "student"],
       ["John", "John Twen",  "teacher"],
       ["Lisa", "Lisa Adult", "dentist"],
       ["Max",  "Max Kid",    "student"],
       ["Tina", "Tina Child", "student"]
    ]
  end

  it 'should order complex columns descending' do
    g = PersonGrid.new :order => :full_name, :desc => true
    g.rows.size.should == 7
    g.rows.should == [
       ["Tina", "Tina Child", "student"],
       ["Max",  "Max Kid",    "student"],
       ["Lisa", "Lisa Adult", "dentist"],
       ["John", "John Twen",  "teacher"],
       ["Joe",  "Joe Teen",   "student"],
       ["Dick", "Dick Teeny", "student"],
       ["Dana", "Dana Twen",  "teacher"]
    ]
  end

  it 'should raise error for unknown order column' do
    expect { 
      PersonGrid.new :order => :bla 
    }.to raise_error( 
      ArgumentError, /order/ 
    )
  end
end
