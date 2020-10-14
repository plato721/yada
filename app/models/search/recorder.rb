class Search::Recorder
  def record(user, search_criteria)
    search = Search.where(criteria: search_criteria)
              .first_or_create
    user.searches << search
  end
end
