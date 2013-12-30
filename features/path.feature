Feature: Query Path
  I want to scope a query to a path so I can better arrange my content for optimized user experience.

  Scenario: Query with empty path (base path)
  Given some files with values:
    | file           |
    | apple.html     |
    | banana.html    |
    | cranberry.html |
  When I query the path ""
  Then this query returns the ordered results "apple.html, banana.html, cranberry.html"

  Scenario: Query with path
  Given some files with values:
    | file                |
    | food/apple.html     |
    | food/banana.html    |
    | food/cranberry.html |
  When I query the path "food"
  Then this query returns the ordered results "food/apple.html, food/banana.html, food/cranberry.html"

  Scenario: Query with path and nested files
  Given some files with values:
    | file                |
    | food/apple.html     |
    | food/cool/banana.html    |
    | food/cool/cranberry.html |
  When I query the path "food"
  Then this query returns the ordered results "food/apple.html"

  Scenario: Query with path_all and nested files
  Given some files with values:
    | file                |
    | food/apple.html     |
    | food/cool/banana.html    |
    | food/cool/cranberry.html |
  When I query the path_all "food"
  Then this query returns the ordered results "food/apple.html, food/cool/banana.html, food/cool/cranberry.html"
