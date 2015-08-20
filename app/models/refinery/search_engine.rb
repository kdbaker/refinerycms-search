module Refinery
  class SearchEngine

    # How many results should we show per page
    RESULTS_LIMIT = 10

    # Perform search over the specified models
    def self.search(query, page = 1, per = RESULTS_LIMIT)
      page = 1 if page.nil?
      results = []
      offset = page.to_i*per

      Rails.logger.info "offset #{offset},  page #{page}, per #{per}"

      Refinery.searchable_models.each do |model|
        # results << model.live.in_menu.with_query(query)
        if model.respond_to?(:refinery_search_scope)
          results << model.refinery_search_scope.with_query(query)
        else
          results << model.with_query(query)
        end
      end if query.present?
      

      count = results.flatten.count
      start = -per + offset
      finish = start + per-1
      results = results.flatten[start..(finish)]
      pages = (count.to_f/per.to_f).ceil

      Rails.logger.info "count #{count}, offset #{offset},  pages #{pages}, per #{per}"

      results = { results: results, count: count, pages: pages, per:  per }
    end

  end
end
