# frozen_string_literal: true

RSpec.describe 'Item', todo_page: true, item: true do
  context 'individual items' do
    it 'should allow me to mark items as complete' do
      @todo_page.add_todos([@todos.first, @todos.last])

      first_todo = @todo_page.todo_items.all.first
      first_todo.get_by_role('checkbox').check
      expect(first_todo).to have_class('completed')

      second_todo = @todo_page.todo_items.all[1]
      expect(second_todo).to have_class('')

      second_todo.get_by_role('checkbox').check
      expect(first_todo).to have_class('completed')
      expect(second_todo).to have_class('completed')
    end

    it 'should allow me to un-mark items as complete' do
      @todo_page.add_todos([@todos.first, @todos.last])

      first_todo = @todo_page.todo_items.all.first
      second_todo = @todo_page.todo_items.all[1]

      first_todo.get_by_role('checkbox').check
      expect(first_todo).to have_class('completed')
      expect(second_todo).to have_class('')

      assert_todos_by_type(@todo_page.parsed_react_todos, 'completed', 1)

      first_todo.get_by_role('checkbox').uncheck
      expect(first_todo).to have_class('')
      expect(second_todo).to have_class('')

      assert_todos_by_type(@todo_page.parsed_react_todos, 'completed', 0)
    end

    it 'should allow me to edit an item' do
      @todo_page.add_todos(@todos)

      second_todo = @todo_page.todo_items.all[1]
      second_todo.dblclick

      text_box = second_todo.get_by_role('textbox', name: 'Edit')
      expect(text_box).to have_value(@todos[1])

      text_box.fill('buy some sausages')
      text_box.press('Enter')

      expect(@todo_page.todo_items).to have_text([@todos.first, 'buy some sausages', @todos.last])

      assert_todo_by_title(@todo_page.parsed_react_todos, 'buy some sausages')
    end
  end
end
