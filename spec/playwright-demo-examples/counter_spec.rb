# frozen_string_literal: true

RSpec.describe 'Counter', todo_page: true, counter: true do
  context 'Todo counter' do
    it 'should display the current number of todo items' do
      @todo_page.add_todo(@todos.first)
      expect(@todo_page.todo_count).to contain_text('1')

      @todo_page.add_todo(@todos[1])
      expect(@todo_page.todo_count).to contain_text('2')

      assert_total_todos_amount(@todo_page.parsed_react_todos, 2)
    end
  end
end
