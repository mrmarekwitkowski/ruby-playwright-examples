# frozen_string_literal: true

require_relative 'examples_helper/playwright_exec_helper'

module ExamplesHelper
  def assert_total_todos_amount(todos, expected_amount)
    expect(todos.size).to eq expected_amount
  end

  def assert_todos_by_type(todos, type, expected_amount)
    todos_by_type = todos.select { |t| t[type] == true }
    expect(todos_by_type.size).to eq expected_amount
  end

  def assert_todo_by_title(todos, title)
    todo = todos.select { |t| t['title'] == title }
    expect(todo.any?).to be true
  end
end
