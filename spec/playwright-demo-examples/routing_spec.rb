# frozen_string_literal: true

RSpec.describe 'Routing', todo_page: true, routing: true do
  before(:example) do
    @todo_page.add_todos(@todos)
    assert_todo_by_title(@todo_page.parsed_react_todos, @todos.first)
  end

  it 'should allow me to display active items' do
    todo = @todo_page.todo_items.all[1]
    todo.locator('.toggle').check
    assert_todos_by_type(@todo_page.parsed_react_todos, 'completed', 1)

    @todo_page.todo_filter('Active').click
    expect(@todo_page.todo_items).to have_count(2)
    expect(@todo_page.todo_items).to have_text([@todos.first, @todos.last])
  end

  it 'should respect the back button' do
    todo = @todo_page.todo_items.all[1]
    todo.locator('.toggle').check
    assert_todos_by_type(@todo_page.parsed_react_todos, 'completed', 1)

    @todo_page.todo_filter('All').click
    expect(@todo_page.todo_items).to have_count(3)

    @todo_page.todo_filter('Active').click
    @todo_page.todo_filter('Completed').click

    expect(@todo_page.todo_items).to have_count(1)

    @page.go_back
    expect(@todo_page.todo_items).to have_count(2)

    @page.go_back
    expect(@todo_page.todo_items).to have_count(3)
  end

  it 'should allow me to display completed items' do
    todo = @todo_page.todo_items.all[1]
    todo.locator('.toggle').check
    assert_todos_by_type(@todo_page.parsed_react_todos, 'completed', 1)

    @todo_page.todo_filter('Completed').click
    expect(@todo_page.todo_items).to have_count(1)
  end

  it 'should allow me to display all items' do
    todo = @todo_page.todo_items.all[1]
    todo.locator('.toggle').check
    assert_todos_by_type(@todo_page.parsed_react_todos, 'completed', 1)

    @todo_page.todo_filter('Active').click
    @todo_page.todo_filter('Completed').click
    @todo_page.todo_filter('All').click

    expect(@todo_page.todo_items).to have_count(3)
  end

  it 'should highlight the currently applied filter' do
    expect(@todo_page.todo_filter('All')).to have_class('selected')

    @todo_page.todo_filter('Active').click
    expect(@todo_page.todo_filter('Active')).to have_class('selected')

    @todo_page.todo_filter('Completed').click
    expect(@todo_page.todo_filter('Completed')).to have_class('selected')
  end
end
