require 'spec_helper'

feature "Tracking student responses" do

  scenario "Instructor sees how many students are in the class" do
    instructor_session = Capybara::Session.new(:selenium, ClickerApp)
    student_session = Capybara::Session.new(:selenium, ClickerApp)
    other_student_session = Capybara::Session.new(:selenium, ClickerApp)

    instructor_session.visit "/"
    instructor_session.click_on "Boulder"
    instructor_session.click_on "I'm an Instructor"
    expect(instructor_session).to have_content("Lesson Overview")
    expect(instructor_session).to have_content("0 Students")

    student_session.visit "/"
    student_session.click_on "Boulder"
    student_session.click_on "I'm a Student"
    expect(student_session).to have_content("Welcome, grasshopper!")

    expect(instructor_session).to have_content("1")

    other_student_session.visit "/"
    other_student_session.click_on "Boulder"
    other_student_session.click_on "I'm a Student"

    instructor_session.visit instructor_session.current_path
    expect(instructor_session).to have_content("2")

    other_student_session.click_on "You lost me"
    expect(instructor_session).to have_css(".student-circle.is-behind")

    student_session.click_on "I'm caught-up"
    expect(instructor_session).to have_css(".student-circle.is-caught-up")

    instructor_session.click_on "Reset"
    expect(instructor_session).to have_no_css(".student-circle.is-caught-up")
    expect(instructor_session).to have_no_css(".student-circle.is-behind")
  end

  scenario "Asking questions in denver" do
    denver_instructor_session = Capybara::Session.new(:selenium, ClickerApp)
    student_session = Capybara::Session.new(:selenium, ClickerApp)

    denver_instructor_session.visit "/"
    denver_instructor_session.click_on "Denver"
    denver_instructor_session.click_on "I'm an Instructor"
    expect(denver_instructor_session).to have_content("Lesson Overview")
    expect(denver_instructor_session).to have_content("0 Students")

    student_session.visit "/"
    student_session.click_on "Denver"
    student_session.click_on "I'm a Student"

    expect(denver_instructor_session).to have_content("1")

    boulder_instructor_session = Capybara::Session.new(:selenium, ClickerApp)

    denver_instructor_session.visit "/"
    denver_instructor_session.click_on "Boulder"
    denver_instructor_session.click_on "I'm an Instructor"
    expect(denver_instructor_session).to have_content("Lesson Overview")
    expect(denver_instructor_session).to have_content("0 Students")
  end

end