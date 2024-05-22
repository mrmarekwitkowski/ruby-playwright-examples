# frozen_string_literal: true

RSpec.describe 'Mark as completed', todo_page: true, mark_completed: true do
  before(:example) do
    @todo_page.add_todos(@todos)
    assert_total_todos_amount(@todo_page.parsed_react_todos, 3)
  end

  after(:example) do
    assert_total_todos_amount(@todo_page.parsed_react_todos, 3)
  end

  context 'mark all as complete' do
    it 'mark all items as complete' do
      @todo_page.toggle_all_todos.check
      expect(@todo_page.todo_items).to have_class(%w[completed completed completed])
      assert_todos_by_type(@todo_page.parsed_react_todos, 'completed', 3)
    end

    it 'allows to clear state' do
      @todo_page.toggle_all_todos.check
      @todo_page.toggle_all_todos.uncheck
      expect(@todo_page.todo_items).to have_class(['', '', ''])
    end

    it 'complete all checkbox should update state when items are completed / cleared' do
      @todo_page.toggle_all_todos.check
      expect(@todo_page.toggle_all_todos).to be_checked

      assert_todos_by_type(@todo_page.parsed_react_todos, 'completed', 3)

      first_todo = @todo_page.todo_items.nth(0)
      first_todo.get_by_role('checkbox').uncheck

      # Following LocatorAssertion significantly slows down the test.
      # Uncomment for trying it out own your own.
      # expect(@todo_page.toggle_all_todos).not_to be_checked

      # As it is not a LocatorAssertion Playwright will not wait for the correct state,
      # but it works without any issues.
      expect(@todo_page.toggle_all_todos.checked?).to be false

      first_todo.get_by_role('checkbox').check
      expect(@todo_page.toggle_all_todos).to be_checked

      assert_todos_by_type(@todo_page.parsed_react_todos, 'completed', 3)
    end
  end
end
