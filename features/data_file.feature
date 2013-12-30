Feature: Data File
  I want to natively access the data in data files so I can use the data in my content

  Scenario: Query data file
    Given the file "person.yml" with body:
      """
      ---
      name: "jade"
      address:
        city: "alhambra"
      fruits:
        - mango
        - kiwi
      """
    When I query the path ""
      Then this query's first result should have the data:
      """
      {
          "name": "jade",
          "address": {
              "city": "alhambra"
          },
          "fruits": [
              "mango",
              "kiwi"
          ]
      }
      """

  Scenario: Query a merged data file
    Given the file "person.yml" with body:
      """
      ---
      name: "jade"
      address:
        city: "alhambra"
      fruits:
        - mango
        - kiwi
      """
      And the file "cascade/person.yml" with body:
        """
        ---
        name: "Bob"
        greeting: "Hai!"
        """
      And I append the path "cascade" to the query
    When I query the path ""
    Then this query's first result should have the data:
      """
      {
          "name": "Bob",
          "greeting" : "Hai!",
          "address": {
              "city": "alhambra"
          },
          "fruits": [
              "mango",
              "kiwi"
          ]
      }
      """

  Scenario: Query a merged data file with different formats
    Given the file "person.json" with body:
      """
        { "name" : "Bob" }
      """
      And the file "cascade/person.yml" with body:
        """
        ---
        greeting: "Hai!"
        """
      And I append the path "cascade" to the query
    When I query the path ""
    Then this query's first result should have the data:
      """
      {
          "name": "Bob",
          "greeting" : "Hai!"
      }
      """
