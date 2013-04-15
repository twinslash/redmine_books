require 'factory_girl'

Given /^I am in the system$/ do
  @me = FactoryGirl.create(:active_user)
end

Given /^I logged in$/ do
  visit '/login'
  fill_in 'username', :with => @me.login
  fill_in 'password', :with => @me.password
  find('input[name="login"]').click
  page.should have_content 'My page'
end

Given /^I have one own book$/ do
  @me.own_books << @my_book = FactoryGirl.create(:free_book)
end

Given /^there is some others books$/ do
  @other_books = FactoryGirl.create_list(:free_book, 2)
end

Given /^I made my book (in)?visible$/ do |is_visible|
  @my_book.visibility = is_visible.nil?
  @my_book.save
end

Given /^my own book is (\w+)$/ do |status|
  @my_book.status = status.to_sym
  @my_book.save
end

When /^I on my own book page$/ do
  visit "/books/#{@my_book.id}"
end

When /^I make my book (in)?visible$/ do |is_visible|
  click_link "Make #{is_visible}visible"
end

When /^I go on books page$/ do
  visit '/books'
end


Then /^I (should|should not) see make book (in)?visible link$/ do |is_should, is_visible|
  is_should.gsub! /\s/, '_'
  page.send is_should, have_content("Make #{is_visible}visible")
end

Then /^I (should|should not) see my own book on books page$/ do |is_should|
  is_should.gsub! /\s/, '_'
  page.send is_should, have_content(@my_book.title)
end

Before do
  DatabaseCleaner.clean
end

After do
  click_link "Sign out"
end
