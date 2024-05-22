# frozen_string_literal: true

RSpec.describe 'Clear completed button', todo_page: true, clear_completed_button: true do
  before(:example) do
    @todo_page.add_todos(@todos)
    assert_total_todos_amount(@todo_page.parsed_react_todos, 3)
  end

  context 'Clear completed button' do
    it 'should display the correct text' do
      todo = @todo_page.todo_items.all[1]
      todo.locator('.toggle').check
      expect(@todo_page.clear_completed_button).to be_visible
    end

    it 'should remove completed items when clicked' do
      todo = @todo_page.todo_items.all[1]
      todo.locator('.toggle').check
      @todo_page.clear_completed_button.click

      expect(@todo_page.todo_items).to have_count(2)
      expect(@todo_page.todo_items).to have_text([@todos.first, @todos.last])
    end

    it 'should be hidden when there are no items that are completed' do
      todo = @todo_page.todo_items.all[1]
      todo.locator('.toggle').check

      @todo_page.clear_completed_button.click
      expect(@todo_page.clear_completed_button.visible?).to be false
    end
  end
end
