# frozen_string_literal: true

RSpec.describe 'Persistence', todo_page: true, persistence: true do
  it 'should persist its data' do
    @todo_page.add_todos([@todos.first, @todos.last])

    todo = @todo_page.todo_items.all.first
    todo.get_by_role('checkbox').check

    expect(@page.get_by_test_id('todo-title')).to have_text([@todos.first, @todos.last])
    expect(@todo_page.todo_items).to have_class(['completed', ''])

    assert_todos_by_type(@todo_page.parsed_react_todos, 'completed', 1)

    @page.reload
    expect(@page.get_by_test_id('todo-title')).to have_text([@todos.first, @todos.last])
    expect(@todo_page.todo_items).to have_class(['completed', ''])

    assert_todos_by_type(@todo_page.parsed_react_todos, 'completed', 1)
  end
end
