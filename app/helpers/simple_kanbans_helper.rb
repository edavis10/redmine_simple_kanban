module SimpleKanbansHelper
  def next_issue_title
    if @filtered_user
      content_tag(:h2, l(:simple_kanban_text_next_issue_for, :user => h(@filtered_user.name)))
    else
      content_tag(:h2, l(:simple_kanban_text_next_issue))
    end
  end

  def swimlane_label(content, grouped_count_of_issues)
    label = l(content)
    count = grouped_count_of_issues.inject(0) do |counter, key_value_pair|
      counter += key_value_pair[1].length
    end
    content_tag(:h3, "#{label} (#{count})")
  end
end
