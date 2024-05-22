# frozen_string_literal: true

class TodoPage < GenericBasePage
  def new_todo
    page.get_by_placeholder('What needs to be done?')
  end

  def todo_count
    page.get_by_test_id('todo-count')
  end

  def todo_items
    page.get_by_test_id('todo-item')
  end

  def toggle_all_todos
    page.get_by_label('Mark all as complete')
  end

  def todo_filter(filter)
    page.get_by_role('link', name: filter)
  end

  def clear_completed_button
    page.get_by_role('button', name: 'Clear completed')
  end

  def add_todo(todo)
    new_todo = page.get_by_placeholder('What needs to be done?')
    new_todo.fill(todo)
    new_todo.press 'Enter'
  end

  def add_todos(todos = [])
    todos.each { |todo| add_todo(todo) }
  end

  def todo_items_class_attrs
    attrs = []
    todo_items.all.each { |todo| attrs.push(todo.get_attribute('class')) }
    attrs
  end

  def parsed_react_todos
    todos = local_storage.get_property('react-todos').json_value
    return [] if todos.nil?

    JSON.parse(todos)
  end
end
