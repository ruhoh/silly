Feature: Query filter
  I want to filter a query so I can better arrange my content for optimized user experience.

  Scenario: Query with filter by metadata attribute
    Given some files with values:
      | file                | type  |
      | food/apple.html     | fruit |
      | food/banana.html    | fruit |
      | food/cranberry.html | fruit |
      | food/peanuts.html   | nuts  |
    When I query the path "food"
      And I filter the query with:
        """
        {"type" : "nuts"}
        """
    Then this query returns the ordered results "food/peanuts.html"

  Scenario: Query with filter by 2 different metadata attributes
    Given some files with values:
      | file                | type  | size  |
      | food/apple.html     | fruit | small |
      | food/banana.html    | fruit | small |
      | food/cranberry.html | fruit | small |
      | food/peanuts.html   | nuts  | small |
      | food/walnuts.html   | nuts  | med   |
    When I query the path "food"
      And I filter the query with:
        """
        { "type" : "nuts" }
        """
      And I filter the query with:
        """
        { "size" : "med" }
        """
    Then this query returns the ordered results "food/walnuts.html"

  Scenario: Query with filter by 2 of the same metadata attributes
    Given some files with values:
      | file                | type  | size  |
      | food/cranberry.html | fruit | med   |
      | food/peanuts.html   | nuts  | small |
      | food/walnuts.html   | nuts  | med   |
    When I query the path "food"
      And I filter the query with:
        """
        { "size" : "med" }
        """
      And I filter the query with:
        """
        { "type" : "nuts" }
        """
      And I filter the query with:
        """
        { "type" : {"$exists" : true } }
        """
    Then this query returns the ordered results "food/walnuts.html"
