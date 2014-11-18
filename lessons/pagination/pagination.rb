def paginate(current_page, results_count, max_pages = 10, results_per_page = 10)
  result = []
  result << current_page

  total_pages = (results_count / results_per_page.to_f).ceil

  i = 1
  while result.length < total_pages && result.length < max_pages
    page = 0
    if i % 2 == 0
      page = result.first - 1
    else
      page = result.last + 1
    end

    if page > 0 && page <= total_pages
      if page < current_page
        result.unshift(page)
      else
        result.push(page)
      end
    end

    i += 1
  end

  return result
end
