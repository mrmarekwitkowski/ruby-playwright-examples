# frozen_string_literal: true

RSpec.describe 'Editing', todo_page: true, edit_item: true do
  before(:example) do
    @todo_page.add_todos(@todos)
    assert_total_todos_amount(@todo_page.parsed_react_todos, 3)
  end

  context 'edit Todos', edit_todos: true do
    it 'should hide other controls when editing' do
      todo = @todo_page.todo_items.all[1]
      todo.dblclick

      expect(todo.get_by_role('checkbox').visible?).to be false
      expect(todo.locator('label', hasText: @todos[1]).visible?).to be false

      # Using the 'not_to' matcher is slowing down the test.
      # expect(todo.get_by_role('checkbox')).not_to be_visible

      assert_total_todos_amount(@todo_page.parsed_react_todos, 3)
    end

    it 'should save edits on blur' do
      todo = @todo_page.todo_items.all[1]
      todo.dblclick

      text_box = todo.get_by_role('textbox', name: 'Edit')
      text_box.fill('buy some sausages')
      text_box.dispatch_event('blur')

      expect(@todo_page.todo_items).to have_text([@todos.first, 'buy some sausages', @todos.last])

      assert_todo_by_title(@todo_page.parsed_react_todos, 'buy some sausages')
    end

    it 'should trim entered text' do
      todo = @todo_page.todo_items.all[1]
      todo.dblclick

      text_box = todo.get_by_role('textbox', name: 'Edit')
      text_box.fill('     buy some sausages      ')
      text_box.press('Enter')

      expect(@todo_page.todo_items).to have_text([@todos.first, 'buy some sausages', @todos.last])
      assert_todo_by_title(@todo_page.parsed_react_todos, 'buy some sausages')
    end

    it 'should remove the item if an empty text string was entered' do
      todo = @todo_page.todo_items.all[1]
      todo.dblclick

      text_box = todo.get_by_role('textbox', name: 'Edit')
      text_box.fill('')
      text_box.press('Enter')

      expect(@todo_page.todo_items).to have_text([@todos.first, @todos.last])
    end

    it 'should cancel edits on escape' do
      todo = @todo_page.todo_items.all[1]
      todo.dblclick

      text_box = todo.get_by_role('textbox', name: 'Edit')
      text_box.fill('buy some sausages')
      text_box.press('Escape')

      expect(@todo_page.todo_items.all_text_contents).to eq(@todos)
    end
  end
end
