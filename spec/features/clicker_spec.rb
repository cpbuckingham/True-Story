require 'spec_helper'

feature "Tracking student responses" do

  scenario "Instructor sets up lesson and students click" do
    instructor_session = Capybara::Session.new(:rack_test, ClickerApp)
    student_session = Capybara::Session.new(:rack_test, ClickerApp)

    instructor_session.visit "/"
    instructor_session.click_on "I'm an Instructor"
    expect(instructor_session).to have_content("Lesson Overview")
    expect(instructor_session).to have_content("0 Students")

    student_session.visit "/"
    student_session.click_on "I'm a Student"
    expect(student_session).to have_content("Welcome, grasshopper!")
  end

end