Feature: Query Sort
  I want to sort a query so I can better arrange my content for optimized user experience.

  Scenario: Query with sort
    Given some files with values:
      | file                |
      | food/apple.html     |
      | food/banana.html    |
      | food/cranberry.html |
    When I query the path "food"
      And I sort the query by "id" "desc"
    Then this query returns the ordered results "food/cranberry.html, food/banana.html, food/apple.html"

  Scenario: Query with sort by metadata attribute
    Given some files with values:
      | file                | order |
      | food/apple.html     | 2     |
      | food/banana.html    | 3     |
      | food/cranberry.html | 1     |
    When I query the path "food"
      And I sort the query by "order" "asc"
    Then this query returns the ordered results "food/cranberry.html, food/apple.html, food/banana.html"

  Scenario: Query with sort by date attribute ascending
    Given some files with values:
      | file            | date        |
      | essays/hello.md | 2013-12-01  |
      | essays/zebra.md | 2013-12-10  |
      | essays/apple.md | 2013-12-25  |
    When I query the path "essays"
      And I sort the query by "date" "asc"
    Then this query returns the ordered results "essays/hello.md, essays/zebra.md, essays/apple.md"

  Scenario: Query with sort by date attribute descending
    Given some files with values:
      | file            | date        |
      | essays/hello.md | 2013-12-01  |
      | essays/zebra.md | 2013-12-10  |
      | essays/apple.md | 2013-12-25  |
    When I query the path "essays"
      And I sort the query by "date" "desc"
    Then this query returns the ordered results "essays/apple.md, essays/zebra.md, essays/hello.md"
