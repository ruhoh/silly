Feature: Query filter by file attributes
  I want to filter a query so I can better arrange my content for optimized user experience.

  Scenario: Query with filter by extension
    Given some files with values:
      | file                |
      | food/apple.html     |
      | food/banana.md      |
      | food/cranberry.html |
      | food/peanuts.md     |
    When I query the path "food"
      And I filter the query with:
        """
        { "$ext" : ".md" }
        """
    Then this query returns the ordered results "food/banana.md, food/peanuts.md"

  Scenario: Query with filter by extension $nin
    Given some files with values:
      | file                |
      | food/apple.html     |
      | food/banana.md      |
      | food/cranberry.html |
      | food/peanuts.md     |
      | food/carrots.txt     |
    When I query the path "food"
      And I filter the query with:
        """
        { "$ext" : { "$nin" : [".md", ".html"] } }
        """
    Then this query returns the ordered results "food/carrots.txt"

  Scenario: Query with filter by relative_shortname
    Given some files with values:
      | file                |
      | food/apple.html     |
      | food/banana.md      |
      | food/cranberry.html |
      | food/peanuts.md     |
    When I query the path "food"
      And I filter the query with:
        """
        { "$relative_shortname" : "food/peanuts" }
        """
    Then this query returns the ordered results "food/peanuts.md"

  Scenario: Query with filter by relative_shortname nested
    Given some files with values:
      | file                  |
      | food/fruit/apple.html |
      | food/fruit/banana.md  |
      | food/banana.html      |
      | food/peanuts.md       |
    When I query the path_all "food"
      And I filter the query with:
        """
        { "$relative_shortname" : "food/fruit/banana" }
        """
    Then this query returns the ordered results "food/fruit/banana.md"

  Scenario: Query with filter by filename
    Given some files with values:
      | file                |
      | food/apple.html     |
      | food/banana.md      |
      | food/cranberry.html |
      | food/peanuts.md     |
    When I query the path "food"
      And I filter the query with:
        """
        { "$filename" : "peanuts.md" }
        """
    Then this query returns the ordered results "food/peanuts.md"

  Scenario: Query with filter by directories
    Given some files with values:
      | file                  |
      | food/fruit/apple.html |
      | food/fruit/banana.md  |
      | food/cranberry.html   |
      | food/peanuts.md       |
    When I query the path_all "food"
      And I filter the query with:
        """
        { "$directories" : "fruit" }
        """
    Then this query returns the ordered results "food/fruit/apple.html, food/fruit/banana.md"

  Scenario: Query with filter by shortname
    Given some files with values:
      | file                  |
      | food/fruit/apple.html |
      | food/fruit/banana.md  |
      | food/banana.html      |
      | food/peanuts.md       |
    When I query the path_all "food"
      And I filter the query with:
        """
        { "$shortname" : "banana" }
        """
    Then this query returns the ordered results "food/banana.html food/fruit/banana.md"

  Scenario: Query with filter by binary?
    Given some files with values:
      | file                  |
      | food/banana.html      |
      | food/peanuts.jpg      |
    When I query the path_all "food"
      And I filter the query with:
        """
        { "$binary?" : true }
        """
    Then this query returns the ordered results "food/peanuts.jpg"

  Scenario: Query with filter by text?
    Given some files with values:
      | file                  |
      | food/banana.html      |
      | food/peanuts.jpg      |
    When I query the path_all "food"
      And I filter the query with:
        """
        { "$text?" : true }
        """
    Then this query returns the ordered results "food/banana.html"

  Scenario: Query with filter by data?
    Given some files with values:
      | file                  |
      | food/banana.html      |
      | food/strawberry.yaml  |
      | food/watermelon.json  |
    When I query the path_all "food"
      And I filter the query with:
        """
        { "$data?" : true }
        """
    Then this query returns the ordered results "food/strawberry.yaml food/watermelon.json"
