# frozen_string_literal: true

RSpec.describe 'New Todo', todo_page: true, new_todo: true do
  context 'add new todos' do
    it 'add new todos' do
      @todo_page.add_todo(@todos.first)

      # Safe to use a String param as only a single todo was added
      expect(@page.get_by_test_id('todo-title')).to have_text(@todos.first)

      @todo_page.add_todo(@todos[1])
      # After adding another item the parameter for 'contain_text' and 'have_text'
      # must be an Array.
      expect(@page.get_by_test_id('todo-title')).to contain_text([@todos.first])
      expect(@page.get_by_test_id('todo-title')).to have_text([@todos.first, @todos[1]])

      assert_total_todos_amount(@todo_page.parsed_react_todos, 2)
    end

    it 'clears the input field' do
      @todo_page.add_todo(@todos.first)
      expect(@todo_page.new_todo).to be_empty
      assert_total_todos_amount(@todo_page.parsed_react_todos, 1)
    end

    it 'appends items at the bottom' do
      @todo_page.add_todos(@todos)

      todo_count = @todo_page.todo_count
      expect(todo_count).to have_text('3 items left')
      expect(todo_count).to have_text(/3/)
      expect(todo_count).to contain_text('3')

      expect(@page.get_by_text('3 items left')).to be_visible
      expect(@page.get_by_test_id('todo-title')).to have_text(@todos)
      assert_total_todos_amount(@todo_page.parsed_react_todos, 3)
    end
  end
end
