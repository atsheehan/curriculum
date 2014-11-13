def paginate(current_page, results_count, results_per_page, max_pages)
  total_pages = (results_count / results_per_page.to_f).ceil
  pages = (current_page..total_pages).to_a
  pages.slice(0, max_pages - 1)
end
