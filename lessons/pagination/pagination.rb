def paginate(current_page, results_count, results_per_page = 10, max_pages = 10)
  last_page = (results_count / results_per_page.to_f).ceil

  start_page = current_page - (max_pages / 2.0).floor + 1
  if start_page < 1
    start_page = 1
  end

  end_page = start_page
  while end_page < last_page && end_page - start_page + 1 < max_pages
    end_page += 1
  end

  (start_page..end_page).to_a
end
